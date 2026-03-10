import 'package:flutter/foundation.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import '../config/app_config.dart';

class WalletProvider with ChangeNotifier {
  Web3Client? _web3client;
  EthereumAddress? _walletAddress;
  EtherAmount? _balance;
  bool _isLoading = false;

  EthereumAddress? get walletAddress => _walletAddress;
  EtherAmount? get balance => _balance;
  bool get isLoading => _isLoading;

  void initialize(String walletAddress) {
    _web3client = Web3Client(AppConfig.rpcUrl, Client());
    _walletAddress = EthereumAddress.fromHex(walletAddress);
    fetchBalance();
  }

  Future<void> fetchBalance() async {
    if (_walletAddress == null || _web3client == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      _balance = await _web3client!.getBalance(_walletAddress!);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> sendTransaction({
    required String to,
    required BigInt amount,
  }) async {
    // Implement transaction signing and sending
    // This would integrate with WalletConnect or Account Abstraction provider
    return null;
  }

  @override
  void dispose() {
    _web3client?.dispose();
    super.dispose();
  }
}
