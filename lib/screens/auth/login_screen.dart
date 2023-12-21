import 'package:video_app/cubits/login/login_cubit.dart' as cubit;
import 'package:video_app/index.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static Page page() => const MaterialPage<void>(child: LoginScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocProvider(
          create: (_) => cubit.LoginCubit(context.read<AuthRepository>()),
          child: const LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<cubit.LoginCubit, cubit.LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == cubit.LoginStatus.submitting
            ? const CustomProgressIndicator()
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 120),
                    const Image(
                      image: AssetImage('assets/images/logo.png'),
                      height: 140,
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: 'Welcome '),
                              TextSpan(
                                text: 'to',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Brain Hacker',
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: Color(0xFFFF3F54),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _FacebookLoginButton(),
                  ],
                ),
              );
      },
    );
  }
}

class _FacebookLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext contextA) {
    return BlocBuilder<cubit.LoginCubit, cubit.LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return _Button(
          icon: const AssetImage('assets/images/facebook.png'),
          iconSize: 32,
          onPressed: state.status == cubit.LoginStatus.submitting
              ? () {}
              : () {
                  context
                      .read<cubit.LoginCubit>()
                      .loginWithCredentials(AccountType.facebook);
                },
        );
      },
    );
  }
}

/*class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return _Button(
          icon: const AssetImage('assets/images/google.png'),
          iconSize: 48,
          onPressed: state.status == LoginStatus.submitting
              ? () {}
              : () {
                  context
                      .read<LoginCubit>()
                      .loginWithCredentials(AccountType.google);
                },
        );
      },
    );
  }
}*/

/*class _AnonymousLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return _Button(
          icon: const AssetImage('assets/images/user.png'),
          iconSize: 32,
          onPressed: state.status == LoginStatus.submitting
              ? () {}
              : () {
                  context
                      .read<LoginCubit>()
                      .loginWithCredentials(AccountType.anonymous);
                },
        );
      },
    );
  }
}*/

class _Button extends StatelessWidget {
  final ImageProvider icon;
  final double iconSize;
  final VoidCallback onPressed;

  const _Button(
      {required this.icon, required this.iconSize, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: const Color(0xFF3A5794)),
          color: Colors.white,
        ),
        padding: const EdgeInsets.only(left: 12),
        width: MediaQuery.of(context).size.width / 1.4,
        child: ListTile(
          leading: Image(
            image: icon,
            height: iconSize,
            filterQuality: FilterQuality.high,
            isAntiAlias: true,
          ),
          title: const Text('Facebook-ээр нэвтрэх'),
          horizontalTitleGap: 10,
        ),
      ),
    );
  }
}
