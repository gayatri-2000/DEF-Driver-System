import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:def_driver_system/View/Constant/shared_prefs.dart';
import '../Apis/app_exception.dart';

enum APIType { aPost, aGet, aPut, aDelete }

class APIService {
  static Future<void> _lock = Future.value();

  Future<dynamic> getResponse({
    required String url,
    required APIType apiType,
    Map<String, dynamic>? body,
    Map<String, String>? header,
  }) async {
    final Future<void> previousLock = _lock;
    final Completer<void> completer = Completer<void>();
    _lock = completer.future;
    await previousLock;

    try {
      log("API Request URL: $url");
      
      // Construct default headers
      final Map<String, String> requestHeaders = header ?? {};
      if (!requestHeaders.containsKey('Content-Type')) {
        requestHeaders['Content-Type'] = 'application/json';
      }
  
      // Attach Odoo session ID cookie if saved
      final String savedSessionId = preferences.getString(SharedPreference.sessionId) ?? "";
      if (savedSessionId.isNotEmpty) {
        if (savedSessionId.contains('session_id=')) {
          requestHeaders['Cookie'] = savedSessionId;
        } else {
          requestHeaders['Cookie'] = 'session_id=$savedSessionId';
        }
      }
  
      dynamic responseJson;
      try {
        http.Response response;
        if (apiType == APIType.aGet) {
          response = await http.get(Uri.parse(url), headers: requestHeaders)
              .timeout(const Duration(seconds: 15));
        } else if (apiType == APIType.aPut) {
          response = await http.put(
            Uri.parse(url),
            headers: requestHeaders,
            body: jsonEncode(body),
          ).timeout(const Duration(seconds: 15));
        } else if (apiType == APIType.aDelete) {
          response = await http.delete(Uri.parse(url), headers: requestHeaders)
              .timeout(const Duration(seconds: 15));
        } else {
          log("Request Body: ${jsonEncode(body)}");
          response = await http.post(
            Uri.parse(url),
            headers: requestHeaders,
            body: jsonEncode(body),
          ).timeout(const Duration(seconds: 15));
        }
  
        log("Response Status Code: ${response.statusCode}");
        
        // Save Odoo session cookie if returned in response headers (e.g. Set-Cookie)
        final String? setCookie = response.headers['set-cookie'];
        if (setCookie != null && setCookie.isNotEmpty) {
          log("Set-Cookie: $setCookie");
          final parts = setCookie.split(';');
          for (var part in parts) {
            final trimmed = part.trim();
            if (trimmed.startsWith('session_id=')) {
              final sessionIdValue = trimmed.split('=').last;
              await preferences.putString(SharedPreference.sessionId, sessionIdValue);
              log("Saved Session ID from Set-Cookie: $sessionIdValue");
              break;
            }
          }
        }
  
        responseJson = _returnResponse(response.statusCode, response.body);
      } on TimeoutException {
        throw FetchDataException('Connection Timeout. Server is not responding.');
      } on SocketException {
        throw FetchDataException('No Internet access');
      }
  
      return responseJson;
    } finally {
      completer.complete();
    }
  }

  dynamic _returnResponse(int statusCode, String body) {
    log("Response Body: $body");
    
    final trimmedBody = body.trim();
    final isHtml = trimmedBody.startsWith('<!DOCTYPE html>') || 
                   trimmedBody.startsWith('<html') || 
                   trimmedBody.toLowerCase().startsWith('<!doctype html');
                   
    if (statusCode == 200 && isHtml) {
      throw UnauthorisedException('Session expired or unauthorized request. Please login again.');
    }

    switch (statusCode) {
      case 200:
      case 201:
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('error') && decoded['error'] is Map) {
            final errorMap = decoded['error'] as Map<String, dynamic>;
            final message = errorMap['message'] ?? 'Odoo JSON-RPC Error';
            throw FetchDataException(message.toString());
          }
          if (decoded.containsKey('result')) {
            return decoded['result'];
          }
        }
        return decoded;
      case 204:
        return {
          "status": "SUCCESS",
          "message": "Query completed successfully",
          "data": []
        };
      case 400:
        throw BadRequestException(body);
      case 401:
      case 403:
        throw UnauthorisedException(body);
      case 404:
        throw ServerException('Server Endpoint Not Found');
      case 500:
      default:
        String? serverMsg;
        try {
          final Map<String, dynamic> errorObj = jsonDecode(body);
          if (errorObj.containsKey('message')) {
            serverMsg = errorObj['message'];
          }
        } catch (_) {}
        if (serverMsg != null) {
          throw FetchDataException(serverMsg);
        }
        throw FetchDataException('Internal Server Error: Status $statusCode');
    }
  }
}
