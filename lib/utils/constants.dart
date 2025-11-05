class FCValues {
  FCValues({
    required this.urlScheme,
    required this.baseDomain,
  });

  final String urlScheme;
  final String baseDomain;

  String get baseUrl => '$urlScheme://$baseDomain';
}

class FCConfig {
  factory FCConfig({required FCValues values}) {
    return _instance ??= FCConfig._internal(values);
  }

  FCConfig._internal(this.values);

  final FCValues values;
  static FCConfig? _instance;

  static FCConfig? get instance => _instance;
}
