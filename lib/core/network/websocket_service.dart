/// **Architecture Layer**: Core / Network
/// **Purpose**: Production-ready WebSocket Service for real-time bi-directional household stock updates.
/// **Features**: Connection lifecycle management, automatic exponential backoff reconnects, ping/pong heartbeats, stream broadcasting.

import 'dart:async';
import 'dart:convert';
import 'package:reestoko/core/utils/app_logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum WebSocketConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
}

class WebSocketService {
  final String serverUrl;
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _heartbeatTimer;

  WebSocketConnectionState _state = WebSocketConnectionState.disconnected;
  WebSocketConnectionState get state => _state;

  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  final _stateController = StreamController<WebSocketConnectionState>.broadcast();
  Stream<WebSocketConnectionState> get stateStream => _stateController.stream;

  int _reconnectAttempts = 0;
  static const int maxReconnectAttempts = 5;
  static const Duration initialReconnectDelay = Duration(seconds: 2);

  WebSocketService({this.serverUrl = 'wss://api.reestoko.app/ws'});

  /// Initialize WebSocket Connection
  Future<void> connect() async {
    if (_state == WebSocketConnectionState.connected || _state == WebSocketConnectionState.connecting) {
      return;
    }

    _updateState(WebSocketConnectionState.connecting);
    AppLogger.i('Connecting to WebSocket server at $serverUrl...');

    try {
      final uri = Uri.parse(serverUrl);
      _channel = WebSocketChannel.connect(uri);

      _subscription = _channel!.stream.listen(
        _onMessageReceived,
        onError: _onError,
        onDone: _onDisconnected,
      );

      _updateState(WebSocketConnectionState.connected);
      _reconnectAttempts = 0;
      _startHeartbeat();
      AppLogger.i('WebSocket connection established.');
    } catch (e) {
      AppLogger.e('WebSocket connection failed: $e');
      _scheduleReconnect();
    }
  }

  /// Incoming Message Handler
  void _onMessageReceived(dynamic rawData) {
    try {
      final Map<String, dynamic> json = jsonDecode(rawData as String);
      AppLogger.d('WebSocket message received: ${json['event'] ?? 'UNKNOWN'}');

      // Heartbeat Pong response
      if (json['event'] == 'PONG') {
        return;
      }

      _messageController.add(json);
    } catch (e) {
      AppLogger.e('Error parsing incoming WebSocket frame: $e');
    }
  }

  /// Send Message / Event Frame to Server
  void sendMessage(String event, Map<String, dynamic> payload) {
    if (_state != WebSocketConnectionState.connected || _channel == null) {
      AppLogger.w('Cannot send WebSocket message: Socket disconnected.');
      return;
    }

    final frame = jsonEncode({
      'event': event,
      'timestamp': DateTime.now().toIso8601String(),
      'payload': payload,
    });

    _channel!.sink.add(frame);
    AppLogger.d('WebSocket message sent: $event');
  }

  /// Start Ping / Pong Heartbeat to keep TCP socket active
  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_state == WebSocketConnectionState.connected) {
        sendMessage('PING', {});
      }
    });
  }

  /// Schedule Automatic Reconnect with Exponential Backoff
  void _scheduleReconnect() {
    _heartbeatTimer?.cancel();
    _subscription?.cancel();

    if (_reconnectAttempts >= maxReconnectAttempts) {
      AppLogger.w('Max WebSocket reconnect attempts reached. Stopping auto-reconnect.');
      _updateState(WebSocketConnectionState.disconnected);
      return;
    }

    _reconnectAttempts++;
    final delaySeconds = initialReconnectDelay.inSeconds * (1 << (_reconnectAttempts - 1));
    AppLogger.i('Scheduling WebSocket reconnect attempt $_reconnectAttempts in ${delaySeconds}s...');

    _updateState(WebSocketConnectionState.reconnecting);
    Timer(Duration(seconds: delaySeconds), () => connect());
  }

  void _onError(dynamic error) {
    AppLogger.e('WebSocket stream error: $error');
    _scheduleReconnect();
  }

  void _onDisconnected() {
    AppLogger.w('WebSocket connection closed by server.');
    _scheduleReconnect();
  }

  void _updateState(WebSocketConnectionState newState) {
    _state = newState;
    _stateController.add(_state);
  }

  /// Close connection and clean up resources
  Future<void> dispose() async {
    _heartbeatTimer?.cancel();
    await _subscription?.cancel();
    await _channel?.sink.close();
    await _messageController.close();
    await _stateController.close();
    _updateState(WebSocketConnectionState.disconnected);
    AppLogger.i('WebSocket service disposed.');
  }
}
