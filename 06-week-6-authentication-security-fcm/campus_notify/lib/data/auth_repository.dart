class AuthSession {
  const AuthSession({
    required this.access,
    required this.refresh,
  });

  final String access;
  final String refresh;
}

class AuthRepository {
  // Mock authentication for this practicum.
  //
  // This can later be replaced with:
  // FirebaseAuth.instance.signInWithEmailAndPassword(...)
  //
  // or GoogleSignIn once the Firebase backend is ready.

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!email.contains('@') || password.length < 6) {
      throw Exception('Invalid email or password');
    }

    // Simulated authentication tokens.
    return AuthSession(
      access: 'mock-access-for-$email',
      refresh: 'mock-refresh-for-$email',
    );
  }

  Future<String> refresh(String refreshToken) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    if (refreshToken.isEmpty) {
      throw Exception('Refresh token missing');
    }

    return 'mock-access-renewed-${DateTime.now().millisecondsSinceEpoch}';
  }
}