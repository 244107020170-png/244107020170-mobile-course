# AI Challenge - Prompt

## Prompt yang Digunakan

Create a Flutter page named `StatsPage` using `flutter_riverpod`.

Requirements:

* Use a `ConsumerWidget`.
* Use one `AsyncNotifierProvider`.
* Simulate fetching statistics with a 2-second delay.
* Add approximately a 30% chance of failure.
* Show a loading indicator while fetching data.
* Show an error message and Retry button when the request fails.
* Show a `ListView` containing 3 statistics when the request succeeds.
* Provide a unit test for the notifier.
* Explain the important parts of the implementation with comments.

The implementation should use the current Riverpod API, including `AsyncNotifier`, `AsyncNotifierProvider`, `ConsumerWidget`, `ref.watch`, and provider invalidation for retry.
