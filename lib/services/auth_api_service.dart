/// Low-level authentication service simulating REST API auth calls.
class AuthApiService {
  Future<Map<String, dynamic>> loginApi(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (username.isNotEmpty && password.isNotEmpty) {
      return {
        'token': 'mock_jwt_token_12345',
        'username': username,
        'email': '$username@example.com',
      };
    } else {
      throw Exception('Invalid username or password');
    }
  }

  Future<Map<String, dynamic>> registerApi(String fullName, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (email.contains('@') && password.length >= 6) {
      return {
        'token': 'mock_jwt_token_registered_67890',
        'username': fullName,
        'email': email,
      };
    } else {
      throw Exception('Invalid registration data provided');
    }
  }
}
