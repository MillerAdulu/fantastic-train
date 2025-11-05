class FCValues {
  FCValues({
    required this.urlScheme,
    required this.baseDomain,
    required this.hiveBox,
    required this.socketDomain,
    required this.socketKey,
    required this.socketScheme,
    required this.socketPort,
  });

  final String urlScheme;
  final String baseDomain;
  final String hiveBox;
  final String socketDomain;
  final String socketKey;
  final String socketScheme;
  final int socketPort;

  String get baseUrl => '$urlScheme://$baseDomain';
  String get globalHiveAuthBox => 'fc-auth';
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
