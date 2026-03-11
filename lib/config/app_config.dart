class AppConfig {
  static const String appName = 'SureWork';
  
  // For Android emulator, 10.0.2.2 maps to the host's localhost
  // For physical device on same network, use your machine's LAN IP (e.g. 192.168.x.x)
  static const String _host = String.fromEnvironment('API_HOST', defaultValue: '10.0.2.2');
  static const String apiBaseUrl = 'http://$_host:3000/api';
  static const String socketUrl = 'http://$_host:3000';
  
  // Blockchain Configuration (local Hardhat)
  static const String network = 'localhost';
  static const int chainId = 31337;
  static const String rpcUrl = 'http://$_host:8545';
  static const String escrowContractAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3';
  
  // USDC Contract (placeholder for local dev)
  static const String usdcContractAddress = '0x0000000000000000000000000000000000000000';
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
