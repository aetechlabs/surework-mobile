class AppConfig {
  static const String appName = 'SureWork';

  // ── Environment detection ───────────────────────────────────────────────────
  // Build with --dart-define=ENV=prod or --dart-define=ENV=staging
  // Defaults to 'dev' for local development
  static const String _env = String.fromEnvironment('ENV', defaultValue: 'dev');

  static bool get isDev => _env == 'dev';
  static bool get isStaging => _env == 'staging';
  static bool get isProd => _env == 'prod';

  // ── API URLs ────────────────────────────────────────────────────────────────
  // dev: 10.0.2.2 = Android emulator alias for host machine localhost
  //      Use --dart-define=API_HOST=192.168.x.x for physical device on same WiFi
  static const String _devHost =
      String.fromEnvironment('API_HOST', defaultValue: '10.0.2.2');

  static String get apiBaseUrl {
    if (isProd) return 'https://api.surework.app/api';
    if (isStaging) return 'https://staging-api.surework.app/api';
    return 'http://$_devHost:3000/api';
  }

  static String get socketUrl {
    if (isProd) return 'https://api.surework.app';
    if (isStaging) return 'https://staging-api.surework.app';
    return 'http://$_devHost:3000';
  }

  // ── Blockchain ──────────────────────────────────────────────────────────────
  static String get rpcUrl {
    if (isProd) return 'https://polygon-mainnet.g.alchemy.com/v2/YOUR_PROD_KEY';
    if (isStaging) return 'https://polygon-amoy.g.alchemy.com/v2/YOUR_STAGING_KEY';
    return 'http://$_devHost:8545';
  }

  static int get chainId {
    if (isProd) return 137;     // Polygon Mainnet
    if (isStaging) return 80002; // Polygon Amoy testnet
    return 31337;                // Local Hardhat
  }

  static String get escrowContractAddress {
    if (isProd) return 'DEPLOY_AND_FILL_PROD_ADDRESS';
    if (isStaging) return 'DEPLOY_AND_FILL_AMOY_ADDRESS';
    return '0x5FbDB2315678afecb367f032d93F642f64180aa3'; // local Hardhat
  }

  static String get usdcContractAddress {
    if (isProd) return '0x3c499c542cEF5E3811e1192ce70d8cC03d5c3359'; // Polygon USDC
    if (isStaging) return '0x41E94Eb019C0762f9Bfcf9Fb1E58725BfB0e7582'; // Amoy USDC
    return '0x0000000000000000000000000000000000000000';
  }

  static const int usdcDecimals = 6;

  // ── App Settings ───────────────────────────────────────────────────────────
  static const int messagePageSize = 50;
  static const int gigPageSize = 20;
  static const Duration apiTimeout = Duration(seconds: 30);

  // ── Feature Flags ──────────────────────────────────────────────────────────
  static const bool enablePushNotifications = true;
  static const bool enableBiometricAuth = false;

  // ── External Links ─────────────────────────────────────────────────────────
  static const String termsOfServiceUrl = 'https://surework.app/terms';
  static const String privacyPolicyUrl = 'https://surework.app/privacy';
  static const String supportEmail = 'support@surework.app';
}
