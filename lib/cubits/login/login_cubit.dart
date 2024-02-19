import 'dart:developer';
import 'package:video_app/index.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  LoginCubit(this._authRepository) : super(LoginState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: LoginStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: LoginStatus.initial));
  }

  Future<void> loginWithCredentials(AccountType accountType) async {
    if (state.status == LoginStatus.submitting) return;
    emit(state.copyWith(status: LoginStatus.submitting));

    try {
      switch (accountType) {
        case AccountType.emailAndPassword:
          // TODO: Handle this case.
          break;
        case AccountType.facebook:
          await _authRepository.loginWithFacebook();
          break;
        case AccountType.google:
          await _authRepository.loginWithGoogle();
          break;
        case AccountType.anonymous:
          await _authRepository.loginWithAnonymous();
          break;
        case AccountType.none:
          // TODO: Handle this case.
          break;
        case AccountType.phone:
          // TODO: Handle this case.
          break;
      }
      emit(state.copyWith(status: LoginStatus.success));
    } catch (_) {
      log('Error occurred while login in ...');
    }
  }
}
