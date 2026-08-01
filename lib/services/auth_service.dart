/// Mock Authentication service with simulated API delays.
class AuthService {
  /// Simulates a login API request with a 600ms network delay.
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (email.isNotEmpty && password.isNotEmpty) {
      return true;
    }
    return false;
  }

  /// Simulates a user registration API request with a 600ms network delay.
  Future<bool> register(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (name.isNotEmpty && email.contains('@') && password.length >= 6) {
      return true;
    }
    return false;
  }
}
