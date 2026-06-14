class AppEnvironment {
  const AppEnvironment({required this.apiBaseUrl});

  final String apiBaseUrl;

  String get assetBaseUrl {
    final uri = Uri.parse(apiBaseUrl);
    return '${uri.scheme}://${uri.authority}';
  }

  String assetUrl(String path) => '$assetBaseUrl/assets/${path.replaceFirst(RegExp(r'^/+'), '')}';

  factory AppEnvironment.fromDartDefine() {
    const rawBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://127.0.0.1:8089/api/',
    );

    final normalizedBaseUrl = rawBaseUrl.endsWith('/') ? rawBaseUrl : '$rawBaseUrl/';
    return AppEnvironment(apiBaseUrl: normalizedBaseUrl);
  }
}
