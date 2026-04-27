import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/logic/weekly_plan_service.dart';

/// Provider del servicio de plan semanal — antes vivía en `features/semana`,
/// movido acá cuando esa feature se borró (1.9.0 unificó Semana en
/// Calendario, así que el provider reside con sus consumidores).
final weeklyPlanServiceProvider = Provider((ref) =>
    WeeklyPlanService(ref.watch(databaseProvider)));
