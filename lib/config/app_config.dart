class AppConfig {
  static const String appName = 'SureWork';
  static const String apiBaseUrl = 'http://localhost:3000/api';
  static const String socketUrl = 'http://localhost:3000';
  
  // Blockchain Configuration
  static const String network = 'polygon-mumbai';
  static const int chainId = 80001;
  static const String rpcUrl = 'https://rpc-mumbai.maticvigil.com';
  static const String escrowContractAddress = '0x...'; // Update after deployment
  
  // USDC Contract (Mumbai Testnet)
  static const String usdcContractAddress = '0x...';
  static const int usdcDecimals = 6;
  
  // App Settings
  static const int messagePageSize = 50;
  static const int gigPageSize = 20;
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Feature Flags
  static const bool enablePushNotifications = true;
  static const bool enableBiometricAuth = false;
  
  // External Links
  static const String termsOfServiceUrl = 'https://surework.app/terms';
  static const String privacyPolicyUrl = 'https://surework.app/privacy';
  static const String supportEmail = 'support@surework.app';
}
