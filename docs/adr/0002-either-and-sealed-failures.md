# ADR 0002: `Either` results with sealed failures and states

## Status

Accepted, 2026-10-09.

## Context

Repositories and use cases return outcomes the UI must distinguish: wrong password versus network error, taken email versus weak password. The first version modelled these with `freezed` unions, which needed `build_runner`, generated `*.freezed.dart` files, and a code generation step before every build and in CI.

Dart 3 added `sealed` classes and exhaustive `switch` expressions, which cover the same need in the language.

## Decision

- Repository and use-case results are `Future<Either<F, T>>` from `dartz`. `F` is a `sealed class` per feature extending the `Failure` port. `T` is `Unit` when there is nothing to return.
- Cubit states are `sealed class` hierarchies too.
- Failures and states are plain `const` classes. Cubits map failures to states with a `switch` expression; widgets `switch` on states. The compiler rejects a missing case.
- Expected failures (invalid credentials, taken email, weak password) are mapped in the repository and not logged. Unexpected ones are logged with `Logger.recordError` and mapped to the feature's `UnexpectedError` failure.
- `freezed`, `freezed_annotation` and `build_runner` are removed. No code generation remains.

## Alternatives considered

- **Keep `freezed`.** Gives `copyWith` and equality for free, but costs a build step, generated files in review, and a dependency on the generator keeping up with Flutter releases. The few entities that need `copyWith` or `==` (`Tweet`, `User`) write them by hand.
- **Throw exceptions and catch in the cubit.** Outcomes are not visible in the signature and exhaustiveness is lost. Rejected.
- **Drop `dartz` and return a sealed `Result<F, T>` of our own.** Fewer dependencies, but `Either.fold` is already what the cubits use and `dartz` is stable. Kept; a later ADR may replace it.

## Consequences

- `flutter pub get` is the whole setup. CI has no generation step.
- Adding a failure or state subclass without handling it is a compile error in every `switch`.
- Entities that need value semantics implement `==`, `hashCode` and `copyWith` by hand.
- `Unit` and `right(unit)` appear in signatures where a method has nothing to return; readers new to `dartz` must learn that one idiom.
