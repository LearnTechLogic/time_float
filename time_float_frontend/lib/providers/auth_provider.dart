import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  User? _user;
  String? _token;
  bool _isLoading = false;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null && _user != null;

  ApiService get apiService => ApiService(token: _token);

  Future<void> loadStoredAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _storage.read(key: 'token');
      final userId = await _storage.read(key: 'userId');
      final username = await _storage.read(key: 'username');

      if (token != null && userId != null && username != null) {
        _token = token;
        _user = User(id: int.parse(userId), username: username);
      }
    } catch (e) {
      if (kDebugMode) {
        print('加载认证信息失败: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final api = ApiService();
      await api.post('/auth/register', {
        'username': username,
        'password': password,
      });
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final api = ApiService();
      final response = await api.post('/auth/login', {
        'username': username,
        'password': password,
      });

      final data = response['data'];
      _token = data['token'];
      _user = User(id: data['userId'], username: data['username']);

      await _storage.write(key: 'token', value: _token);
      await _storage.write(key: 'userId', value: _user!.id.toString());
      await _storage.write(key: 'username', value: _user!.username);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    await _storage.deleteAll();
    notifyListeners();
  }
}
