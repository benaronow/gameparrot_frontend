class Config {
  // Use your computer's IP address when running on a physical device
  static const String apiHost = '10.0.0.85:8080';
  static const bool useSSL = false;

  static String get wsUrl => '${useSSL ? 'wss' : 'ws'}://$apiHost/ws';
  static String get httpUrl => '${useSSL ? 'https' : 'http'}://$apiHost';
}
