part of 'signup_cubit.dart';

@immutable
sealed class SignupState {}

final class SignupInitialState extends SignupState {}

final class SignupLoadingState extends SignupState {}

final class SignupSuccessState extends SignupState {}

final class SignupFailedState extends SignupState {
  String errorMsg;
  SignupFailedState({required this.errorMsg});
}
