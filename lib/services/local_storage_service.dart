/// Local Storage service for managing tokens and cached user data.
class LocalStorageService {
  String? _authToken;
  String? _cachedUsername;

  Future<void> saveAuthToken(String token, String username) async {
    _authToken = token;
    _cachedUsername = username;
  }

  Future<String?> getAuthToken() async => _authToken;

  Future<String?> getUsername() async => _cachedUsername;

  Future<void> clearSession() async {
    _authToken = null;
    _cachedUsername = null;
  }
}
