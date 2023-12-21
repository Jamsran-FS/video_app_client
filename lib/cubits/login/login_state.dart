part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, success, error }

class LoginState extends Equatable {
  final LoginStatus status;

  const LoginState({required this.status});

  factory LoginState.initial() {
    return const LoginState(status: LoginStatus.initial);
  }

  @override
  List<Object> get props => [status];

  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
  }) {
    return LoginState(status: status ?? this.status);
  }
}
