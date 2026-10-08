import 'package:flutter_test/flutter_test.dart';

import 'package:campus_notify/data/auth_repository.dart';

void main() {
  group('AuthRepository', () {
    test('login returns an authenticated session', () async {
      final auth = AuthRepository();

      final session = await auth.login(
        email: 'student@campus.ac.id',
        password: '123456',
      );

      expect(
        session.access,
        'mock-access-for-student@campus.ac.id',
      );

      expect(
        session.refresh,
        'mock-refresh-for-student@campus.ac.id',
      );
    });

    test('login rejects invalid credentials', () async {
      final auth = AuthRepository();

      expect(
        () => auth.login(
          email: 'invalid-email',
          password: '123',
        ),
        throwsException,
      );
    });

    test('refresh generates a new access token', () async {
      final auth = AuthRepository();

      final renewed = await auth.refresh(
        'mock-refresh-token',
      );

      expect(
        renewed,
        startsWith('mock-access-renewed-'),
      );
    });

    test('refresh rejects an empty refresh token', () async {
      final auth = AuthRepository();

      expect(
        () => auth.refresh(''),
        throwsException,
      );
    });
  });
}