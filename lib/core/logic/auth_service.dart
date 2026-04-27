import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Servicio de autenticación con Google + Firebase.
///
/// Responsabilidades:
/// - Iniciar/cerrar sesión con Google (OAuth).
/// - Exponer el usuario actual como `Stream<User?>` para que el router
///   reaccione a logout.
/// - Wrapear errores conocidos con mensajes en español para el UI.
///
/// Mantiene los datos LOCALES intactos: el login es informativo / habilita
/// futura sincronización a Firestore. La DB Drift no toca el `uid`.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _google = GoogleSignIn();

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// Inicia el flujo de Google Sign-In, intercambia los tokens con Firebase
  /// y devuelve el `User` resultante. `null` si el usuario canceló el
  /// diálogo de Google.
  Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await _google.signIn();
      if (googleUser == null) return null; // cancelado por el user

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final result = await _auth.signInWithCredential(credential);
      return result.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuth signIn error: ${e.code} ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('signInWithGoogle error: $e');
      rethrow;
    }
  }

  /// Cierra sesión tanto en Firebase como en Google (para que el próximo
  /// signIn vuelva a pedir cuenta y no entre auto).
  Future<void> signOut() async {
    try {
      await _google.signOut();
    } catch (_) {}
    try {
      await _auth.signOut();
    } catch (_) {}
  }
}

/// Provider Riverpod del usuario actual — emite cuando cambia el estado
/// (login / logout / token refresh).
final authStateProvider = StreamProvider<User?>(
  (ref) => AuthService.instance.authStateChanges(),
);
