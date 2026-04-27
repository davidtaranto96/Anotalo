import 'dart:convert';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;

import 'auth_service.dart';
import 'backup_service.dart';

/// Backup/restore en el `appDataFolder` privado del Google Drive del
/// usuario. La carpeta es invisible en la UI de Drive y exclusiva de
/// esta app — no requiere reglas de seguridad ni billing.
///
/// Diseño:
/// - Un único archivo canónico `apunto-backup-latest.json` por usuario.
///   Cada upload sobrescribe (PATCH) o crea (POST) ese archivo, así no
///   acumulamos basura en la cuenta del user.
/// - El JSON es exactamente el mismo que `BackupService.exportToJson`
///   produce — total compatibilidad con el restore manual existente.
class DriveBackupService {
  DriveBackupService._(this._backupService);
  static DriveBackupService? _instance;
  static DriveBackupService instance(BackupService backup) {
    _instance ??= DriveBackupService._(backup);
    return _instance!;
  }

  final BackupService _backupService;

  static const String _fileName = 'apunto-backup-latest.json';

  /// Construye un cliente HTTP autenticado contra Drive. Si el usuario
  /// canceló el login o el token caducó, devuelve null.
  Future<drive.DriveApi?> _getDriveApi() async {
    try {
      final google = AuthService.instance.googleSignIn;
      // Si el user nunca otorgó el scope drive.appdata, signInSilently
      // re-pide el consentimiento. Si tampoco está logueado, falla.
      var account = google.currentUser;
      account ??= await google.signInSilently();
      if (account == null) return null;

      final http.Client? client = await google.authenticatedClient();
      if (client == null) return null;
      return drive.DriveApi(client);
    } catch (e) {
      debugPrint('DriveBackup: no se pudo crear DriveApi: $e');
      return null;
    }
  }

  /// Busca el archivo canónico en el appDataFolder. Devuelve null si no
  /// existe — el primer upload lo crea.
  Future<drive.File?> _findBackupFile(drive.DriveApi api) async {
    try {
      final list = await api.files.list(
        spaces: 'appDataFolder',
        q: "name='$_fileName' and trashed=false",
        $fields: 'files(id,name,modifiedTime,size)',
        pageSize: 1,
      );
      if (list.files == null || list.files!.isEmpty) return null;
      return list.files!.first;
    } catch (e) {
      debugPrint('DriveBackup _findBackupFile: $e');
      return null;
    }
  }

  /// Sube el snapshot actual de la app al Drive del usuario. Si ya
  /// existe, lo sobrescribe (mismo file id). Devuelve true si la
  /// operación tuvo éxito.
  Future<bool> uploadBackup() async {
    final api = await _getDriveApi();
    if (api == null) return false;

    try {
      final jsonStr = await _backupService.exportToJson();
      final bytes = utf8.encode(jsonStr);
      final media = drive.Media(
        Stream<List<int>>.value(bytes),
        bytes.length,
        contentType: 'application/json',
      );

      final existing = await _findBackupFile(api);
      if (existing == null) {
        final file = drive.File()
          ..name = _fileName
          ..parents = ['appDataFolder']
          ..mimeType = 'application/json';
        await api.files.create(file, uploadMedia: media);
      } else {
        // Update keeps el id estable; PATCH no permite cambiar parents.
        final patch = drive.File()..name = _fileName;
        await api.files.update(patch, existing.id!, uploadMedia: media);
      }
      return true;
    } catch (e) {
      debugPrint('DriveBackup uploadBackup error: $e');
      return false;
    }
  }

  /// Lee el último backup del Drive del user y devuelve el JSON crudo.
  /// Devuelve null si no hay backup, no hay sesión o falló la red.
  Future<String?> downloadBackupJson() async {
    final api = await _getDriveApi();
    if (api == null) return null;

    try {
      final file = await _findBackupFile(api);
      if (file == null || file.id == null) return null;

      final media = await api.files.get(
        file.id!,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final bytes = <int>[];
      await for (final chunk in media.stream) {
        bytes.addAll(chunk);
      }
      return utf8.decode(bytes);
    } catch (e) {
      debugPrint('DriveBackup downloadBackupJson error: $e');
      return null;
    }
  }

  /// Metadata útil para mostrar en Settings ("Última copia: hace 2 días").
  /// Devuelve null si no hay backup todavía.
  Future<DateTime?> getLastBackupTime() async {
    final api = await _getDriveApi();
    if (api == null) return null;
    try {
      final file = await _findBackupFile(api);
      return file?.modifiedTime?.toLocal();
    } catch (e) {
      debugPrint('DriveBackup getLastBackupTime error: $e');
      return null;
    }
  }
}
