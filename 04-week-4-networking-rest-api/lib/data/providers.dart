import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';
import 'models/comment.dart';
import 'models/post.dart';
import 'repositories/comment_repository.dart';
import 'repositories/post_repository.dart';

/// Provides one centralized Dio client for the whole application.
final dioProvider = Provider<Dio>((ref) {
  return createDio();
});

/// Provides the repository used to fetch posts.
final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository(ref.watch(dioProvider));
});

/// Provides the repository used to fetch comments.
final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  return CommentRepository(ref.watch(dioProvider));
});

/// Handles loading the complete list of posts.
class PostListNotifier extends AsyncNotifier<List<Post>> {
  @override
  Future<List<Post>> build() async {
    final repository = ref.watch(postRepositoryProvider);
    return repository.fetchPosts();
  }

  /// Reloads the posts from the API.
  Future<void> refresh() async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(postRepositoryProvider);
      final posts = await repository.fetchPosts();

      state = AsyncData(posts);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

/// Provider for the complete posts list.
final postListProvider =
    AsyncNotifierProvider<PostListNotifier, List<Post>>(
  PostListNotifier.new,
  retry: (retryCount, error) => null,
);

/// Handles loading comments for a selected post.
class CommentListNotifier extends AsyncNotifier<List<Comment>> {
  @override
  Future<List<Comment>> build() async {
    // Comments are loaded when loadComments() is called
    // with a specific postId.
    return [];
  }

  /// Loads comments belonging to the given post ID.
  Future<void> loadComments(int postId) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(commentRepositoryProvider);

      final comments = await repository.fetchComments(postId);

      state = AsyncData(comments);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

/// Provider for the comment list.
final commentListProvider =
    AsyncNotifierProvider<CommentListNotifier, List<Comment>>(
  CommentListNotifier.new,
  retry: (retryCount, error) => null,
);

/// Converts Dio/network errors into user-friendly messages.
String friendlyErrorMessage(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Slow connection or timeout. Check your internet and retry.';

      case DioExceptionType.connectionError:
        return 'Cannot reach the server. Check your internet connection.';

      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;

        if (code == 404) {
          return 'Data not found (404).';
        }

        if (code == 401 || code == 403) {
          return 'Access denied ($code). Check your credentials.';
        }

        return 'Server problem ($code). Try again later.';

      default:
        return 'A network error occurred. Try again.';
    }
  }

  return 'An unexpected error occurred: $error';
}

/// Converts comment-specific API errors into user-friendly messages.
String friendlyCommentErrorMessage(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Request timed out. Please check your internet connection and try again.';

      case DioExceptionType.connectionError:
        return 'Cannot connect to the server. Please check your internet connection.';

      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;

        if (code == 404) {
          return 'Comments were not found (404).';
        }

        if (code == 500) {
          return 'The server is currently unavailable (500). Please try again later.';
        }

        return 'Server error ($code). Please try again later.';

      default:
        return 'A network error occurred. Please try again.';
    }
  }

  return 'An unexpected error occurred. Please try again.';
}