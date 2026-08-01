import '../services/auth_api_service.dart';
import '../services/local_storage_service.dart';

/// Repository for Authentication business logic & session persistence abstraction.
class AuthRepository {
  final AuthApiService apiService;
  final LocalStorageService localStorage;

  AuthRepository({
    AuthApiService? apiService,
    LocalStorageService? localStorage,
  })  : apiService = apiService ?? AuthApiService(),
        localStorage = localStorage ?? LocalStorageService();

  Future<String> login(String username, String password) async {
    final response = await apiService.loginApi(username, password);
    final token = response['token'] as String;
    final name = response['username'] as String;
    await localStorage.saveAuthToken(token, name);
    return name;
  }

  Future<String> register(String fullName, String email, String password) async {
    final response = await apiService.registerApi(fullName, email, password);
    final token = response['token'] as String;
    final name = response['username'] as String;
    await localStorage.saveAuthToken(token, name);
    return name;
  }

  Future<bool> isAuthenticated() async {
    final token = await localStorage.getAuthToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await localStorage.clearSession();
  }
}
