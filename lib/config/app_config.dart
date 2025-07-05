class AppConfig {
  static const String environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'production');
  
  // Base URLs for different environments
  static const Map<String, Map<String, String>> _config = {
    'development': {
      'baseUrl': 'https://cardamombe-dev.magnussoftech.in',
      'webServiceReact': 'https://cardamombe-dev.magnussoftech.in/WebDataProcessingReact.aspx',
      'imageBaseUrl': 'https://cardamombe-dev.magnussoftech.in/PICS/stock',
      'catalogImageUrl': 'https://cardamombe-dev.magnussoftech.in/CatLog',
    },
    'staging': {
      'baseUrl': 'https://cardamombe-staging.magnussoftech.in',
      'webServiceReact': 'https://cardamombe-staging.magnussoftech.in/WebDataProcessingReact.aspx',
      'imageBaseUrl': 'https://cardamombe-staging.magnussoftech.in/PICS/stock',
      'catalogImageUrl': 'https://cardamombe-staging.magnussoftech.in/CatLog',
    },
    'production': {
      'baseUrl': 'https://cardamombe.magnussoftech.in',
      'webServiceReact': 'https://cardamombe.magnussoftech.in/WebDataProcessingReact.aspx',
      'imageBaseUrl': 'https://cardamombe.magnussoftech.in/PICS/stock',
      'catalogImageUrl': 'https://cardamombe.magnussoftech.in/CatLog',
    },
  };

  // Get current environment configuration
  static Map<String, String> get currentConfig => _config[environment] ?? _config['production']!;

  // Getters for easy access
  static String get baseUrl => currentConfig['baseUrl']!;
  static String get webServiceReact => currentConfig['webServiceReact']!;
  static String get imageBaseUrl => currentConfig['imageBaseUrl']!;
  static String get catalogImageUrl => currentConfig['catalogImageUrl']!;

  // API Configuration
  static const bool isEncrypted = bool.fromEnvironment('IS_ENCRYPTED', defaultValue: false);
  static const String encryptMode = String.fromEnvironment('ENCRYPT_MODE', defaultValue: 'B64');
  
  // Timeout configurations
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds

  // Session configuration
  static const int sessionTimeoutHours = 8;
  static const int partyCacheTimeoutHours = 1;

  // Debug configuration
  static const bool enableLogging = bool.fromEnvironment('ENABLE_LOGGING', defaultValue: true);
  static const bool enableDebugMode = bool.fromEnvironment('DEBUG_MODE', defaultValue: false);

  // App information
  static const String appName = 'Cardamom ERP';
  static const String appVersion = '1.0.0';
  static const String companyName = 'Magnus Softech';

  // Print current configuration (for debugging)
  static void printConfig() {
    if (enableLogging) {
      print('=== App Configuration ===');
      print('Environment: $environment');
      print('Base URL: $baseUrl');
      print('Web Service: $webServiceReact');
      print('Image Base URL: $imageBaseUrl');
      print('Catalog Image URL: $catalogImageUrl');
      print('Encryption Enabled: $isEncrypted');
      print('Encrypt Mode: $encryptMode');
      print('Debug Mode: $enableDebugMode');
      print('==========================');
    }
  }
}
