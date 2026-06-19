import 'dart:async';
import 'dart:developer';

import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  static const String appId = '951833e3-da86-4219-80bf-bbb32917158f';
  static Completer<String?>? _playerIdCompleter;
  static String? _cachedPlayerId;
  static bool _initialized = false;

  static void initialize() {
    if (_initialized) {
      return;
    }

    try {
      _initialized = true;
      _playerIdCompleter = Completer<String?>();
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      OneSignal.User.pushSubscription.addObserver((state) {
        final playerId = state.current.id;
        final token = state.current.token;
        log('OneSignal subscription changed. id: $playerId, token: $token, optedIn: ${state.current.optedIn}');
        _savePlayerId(playerId);
      });

      OneSignal.initialize(appId);
      _preparePushSubscription();
      log('OneSignal initialized');
    } catch (e) {
      _initialized = false;
      log('OneSignal initialize error: $e');
    }
  }

  static Future<void> _preparePushSubscription() async {
    try {
      await OneSignal.Notifications.requestPermission(false)
          .timeout(const Duration(seconds: 3));
      await OneSignal.User.pushSubscription.optIn()
          .timeout(const Duration(seconds: 3));
      await _refreshPushSubscription();
    } catch (e) {
      log('OneSignal push permission setup error: $e');
    }
  }

  static Future<String?> getPlayerId() async {
    initialize();

    if (_cachedPlayerId != null && _cachedPlayerId!.isNotEmpty) {
      log('OneSignal Player ID: $_cachedPlayerId');
      return _cachedPlayerId;
    }

    await _refreshPushSubscription();
    final currentPlayerId = OneSignal.User.pushSubscription.id;
    if (currentPlayerId != null && currentPlayerId.isNotEmpty) {
      _savePlayerId(currentPlayerId);
      log('OneSignal Player ID: $currentPlayerId');
      return currentPlayerId;
    }

    final playerId = await _playerIdCompleter?.future
        .timeout(const Duration(seconds: 15), onTimeout: () => null);
    if (playerId != null && playerId.isNotEmpty) {
      log('OneSignal Player ID: $playerId');
      return playerId;
    }

    log('OneSignal permission: ${OneSignal.Notifications.permission}');
    log('OneSignal push token: ${OneSignal.User.pushSubscription.token}');
    log('OneSignal Player ID is not available yet');
    return null;
  }

  static Future<void> loginUser(String userId) async {
    try {
      await OneSignal.login(userId);
    } catch (e) {
      log('OneSignal login error: $e');
    }
  }

  static Future<void> logoutUser() async {
    try {
      await OneSignal.logout();
    } catch (e) {
      log('OneSignal logout error: $e');
    }
  }

  static Future<void> _refreshPushSubscription() async {
    try {
      await OneSignal.User.pushSubscription.lifecycleInit()
          .timeout(const Duration(seconds: 5));
      _savePlayerId(OneSignal.User.pushSubscription.id);
    } catch (e) {
      log('OneSignal push subscription refresh error: $e');
    }
  }

  static void _savePlayerId(String? playerId) {
    if (playerId == null || playerId.isEmpty) {
      return;
    }

    _cachedPlayerId = playerId;
    if (_playerIdCompleter != null && !_playerIdCompleter!.isCompleted) {
      _playerIdCompleter!.complete(playerId);
    }
  }
}
