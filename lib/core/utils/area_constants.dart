enum AreaKey { trabajo, personal, salud, estudio, familia, viajes, proyectos }

const areaLabels = {
  AreaKey.trabajo:   'Trabajo',
  AreaKey.personal:  'Personal',
  AreaKey.salud:     'Salud',
  AreaKey.estudio:   'Estudio',
  AreaKey.familia:   'Familia',
  AreaKey.viajes:    'Viajes',
  AreaKey.proyectos: 'Proyectos',
};

AreaKey? areaFromString(String? s) {
  if (s == null) return null;
  return AreaKey.values.firstWhere((e) => e.name == s, orElse: () => AreaKey.personal);
}
