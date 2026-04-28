import 'package:flutter/material.dart';

/// Pickers que respetan el acento de la app.
///
/// `showTimePicker` y `showDatePicker` traen su propio theme Material
/// que ignora `colorScheme.primary` cuando viene de un overlay. El
/// fix: envolver con un Theme local que copia el current colorScheme,
/// asegurando que el botón de hora seleccionada y el indicador del
/// reloj usen el acento del usuario en lugar del azul Material default.
Future<TimeOfDay?> showAccentTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
  String? helpText,
}) {
  final scheme = Theme.of(context).colorScheme;
  return showTimePicker(
    context: context,
    initialTime: initialTime,
    helpText: helpText,
    builder: (ctx, child) => Theme(
      data: Theme.of(ctx).copyWith(colorScheme: scheme),
      child: child!,
    ),
  );
}

Future<DateTime?> showAccentDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  Locale? locale,
}) {
  final scheme = Theme.of(context).colorScheme;
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    locale: locale,
    builder: (ctx, child) => Theme(
      data: Theme.of(ctx).copyWith(colorScheme: scheme),
      child: child!,
    ),
  );
}
