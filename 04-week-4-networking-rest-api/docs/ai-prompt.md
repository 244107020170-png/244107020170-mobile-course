# AI Challenge Prompt — Week 4

## Prompt Used

Create a Flutter repository layer for the GET /comments?postId={id} endpoint of JSONPlaceholder using Dio + flutter_riverpod.

Requirements:

* Comment model with null-safe fromJson (postId, id, name, email, body).
* CommentRepository with fetchComments(postId) + 10-second timeout.
* AsyncNotifierProvider with automatic error handling (AsyncError) and a user-friendly error-message function for timeout, connection error, 404, and 500.
* One unit test for fromJson with missing fields.
* Explain each part of the code with comments.

The generated implementation must follow the existing Week 4 architecture, where the UI does not call Dio directly and all networking goes through the repository layer.
