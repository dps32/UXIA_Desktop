import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';


class AppData extends ChangeNotifier {
  bool _isLoading = false;
  http.Client? _client;
  IOClient? _ioClient;
  HttpClient? _httpClient;
  String _serverUrl = '';
  late String _sessionId;
  String? userRole;

  bool get isLoading => _isLoading;

  AppData() {
    _httpClient = HttpClient();
    _ioClient = IOClient(_httpClient!);
    _client = _ioClient;
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setServerUrl(String serverUrl) {
    _serverUrl = serverUrl;
    notifyListeners();
  }

  String getUrl() {
    return _serverUrl;
  }

  void setSessionId(String sessionId) {
    _sessionId = sessionId;
    notifyListeners();
  }


  Future<dynamic> callAuthenticateUser({required String email, required String password}) async {
    setLoading(true);
    notifyListeners();

    final body = {
      "email": email,
      "password": password
    };

    try {
      final response = await _client!.post(
        Uri.parse('$_serverUrl/api/admin/usuaris/login'),
        body: jsonEncode(body),
      );

      setLoading(false);
      notifyListeners();
      return jsonDecode(response.body);
    
    } catch (e) {
      print("Error during API call: $e");
      setLoading(false);
      notifyListeners();
      return null;
    }
  }

  void cancelRequests() {
    _httpClient?.close(force: true);
    _httpClient = HttpClient();
    _ioClient = IOClient(_httpClient!);
    _client = _ioClient;
    setLoading(false);
    notifyListeners();
  }
}