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
  String? username;

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
        Uri.parse('https://$_serverUrl/api/admin/usuaris/login'),
        body: jsonEncode(body),
        headers: {
          "Content-Type": "application/json"
        }
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

  Future<dynamic> callValidateUser() async {
    setLoading(true);
    notifyListeners();

    try {
      final response = await _client!.get(
        Uri.parse('https://$_serverUrl/api/admin/usuaris/perfil'),
        headers: {
          "Authorization": "Bearer ${_sessionId.trim()}",
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
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

  Future<dynamic> callValidateToken({required String username}) async {
    setLoading(true);
    notifyListeners();

    final body = {
      "username": username,
    };

    try {
      final response = await _client!.post(
        Uri.parse('https://$_serverUrl/api/admin/usuaris/testtoken'),
        headers: {
          "Authorization": "Bearer $_sessionId",
          "Content-Type": "application/json"
        },
        body: jsonEncode(body)
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

  Future<dynamic> callLogOut() async {
    setLoading(true);
    notifyListeners();

    try {
      final response = await _client!.post(
        Uri.parse('https://$_serverUrl/api/admin/usuaris/logout'),
        headers: {
          "Authorization": "Bearer ${_sessionId.trim()}",
          "Content-Type": "application/json"
        },
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

  Future<dynamic> callFetchUsers() async {
    setLoading(true);
    notifyListeners();

    try {
      final response = await _client!.get(
        Uri.parse('https://$_serverUrl/api/admin/usuaris/listUsers'),
        headers: {
          "Authorization": "Bearer ${_sessionId.trim()}",
        }
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

  Future<dynamic> callAddUser({required String username, required String password, required String phone, required String email}) async {
    setLoading(true);
    notifyListeners();

    final body = {
      "username": username,
      "email": email,
      "password": password,
      "phone": phone
    };

    try {
      final response = await _client!.post(
        Uri.parse('https://$_serverUrl/api/admin/usuaris/addUser'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${_sessionId.trim()}",
        },
        body: jsonEncode(body)
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

  Future<dynamic> callDeleteUser({required String id}) async {
    setLoading(true);
    notifyListeners();

    final body = {
      "id": id
    };

    try {
      final response = await _client!.post(
        Uri.parse('https://$_serverUrl/api/admin/usuaris/deleteUser'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${_sessionId.trim()}",
        },
        body: jsonEncode(body)
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