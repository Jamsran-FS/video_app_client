import 'package:video_app/index.dart';

List<Page> onGenerateAppViewPages(AuthStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AuthStatus.authenticated:
      return [LoginScreen.page()];
    case AuthStatus.unauthenticated:
      return [HomeScreen.page()];
  }
}