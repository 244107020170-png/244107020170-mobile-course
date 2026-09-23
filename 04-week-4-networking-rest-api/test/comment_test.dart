import 'package:flutter_test/flutter_test.dart';

import 'package:week4_api/data/models/comment.dart';

void main() {
  group('Comment.fromJson', () {
    test('handles missing fields without throwing an exception', () {
      final comment = Comment.fromJson({
        'postId': 1,
        'id': 10,
      });

      expect(comment.postId, 1);
      expect(comment.id, 10);
      expect(comment.name, '');
      expect(comment.email, '');
      expect(comment.body, '');
    });

    test('handles null fields safely', () {
      final comment = Comment.fromJson({
        'postId': null,
        'id': null,
        'name': null,
        'email': null,
        'body': null,
      });

      expect(comment.postId, 0);
      expect(comment.id, 0);
      expect(comment.name, '');
      expect(comment.email, '');
      expect(comment.body, '');
    });
  });
}