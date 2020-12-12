import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_index_state.freezed.dart';

@freezed
abstract class AuthIndexState with _$AuthIndexState {
  const factory AuthIndexState.initial() = Initial;

  const factory AuthIndexState.authorized() = Authorized;

  const factory AuthIndexState.unauthorized() = Unauthorized;

  const factory AuthIndexState.unexpectedError() = UnexpectedError;

  const factory AuthIndexState.maintenance() = Maintenance;
}
