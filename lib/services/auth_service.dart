/// Mock Authentication Service for Login & Register functionality.
class AuthService {
  bool _isAuthenticated = false;
  String? _currentUser;

  bool get isAuthenticated => _isAuthenticated;
  String? get currentUser => _currentUser;

  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (username.isNotEmpty && password.isNotEmpty) {
      _isAuthenticated = true;
      _currentUser = username;
      return true;
    }
    return false;
  }

  Future<bool> register(String fullName, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (email.isNotEmpty && password.isNotEmpty) {
      _isAuthenticated = true;
      _currentUser = fullName;
      return true;
    }
    return false;
  }

  void logout() {
    _isAuthenticated = false;
    _currentUser = null;
  }
}
