import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../config/app_config.dart';

class ChatProvider with ChangeNotifier {
  IO.Socket? _socket;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  void connect(String userId) {
    _socket = IO.io(AppConfig.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket!.connect();

    _socket!.on('connect', (_) {
      _isConnected = true;
      notifyListeners();
    });

    _socket!.on('disconnect', (_) {
      _isConnected = false;
      notifyListeners();
    });
  }

  void joinGig(String gigId) {
    _socket?.emit('join-gig', gigId);
  }

  void leaveGig(String gigId) {
    _socket?.emit('leave-gig', gigId);
  }

  void sendMessage(String gigId, Map<String, dynamic> message) {
    _socket?.emit('message', {'gigId': gigId, 'message': message});
  }

  void onNewMessage(Function(Map<String, dynamic>) callback) {
    _socket?.on('new-message', (data) {
      callback(data as Map<String, dynamic>);
    });
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
  }
}
