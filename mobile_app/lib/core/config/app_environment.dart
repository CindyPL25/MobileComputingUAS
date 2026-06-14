enum DataSourceMode { mock, api }

class AppEnvironment {
  AppEnvironment({required this.dataSourceMode, required this.apiBaseUrl});

  final DataSourceMode dataSourceMode;
  final String apiBaseUrl;

  factory AppEnvironment.fromDartDefine() {
    const rawMode = String.fromEnvironment('APP_DATA_SOURCE', defaultValue: 'mock');
    const rawBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://10.0.2.2/mobilecomputinguas-api',
    );

    final mode = rawMode.toLowerCase() == 'api' ? DataSourceMode.api : DataSourceMode.mock;

    return AppEnvironment(dataSourceMode: mode, apiBaseUrl: rawBaseUrl);
  }
}
