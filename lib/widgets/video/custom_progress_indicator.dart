import 'package:video_app/index.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: Color(0xFF288DFE),
          strokeWidth: 3,
        ),
      ),
    );
  }
}
