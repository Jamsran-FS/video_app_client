import 'package:video_app/index.dart';

class DurationIndicator extends StatelessWidget {
  final String duration;

  const DurationIndicator({super.key, required this.duration});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
        color: const Color.fromRGBO(0, 0, 0, 0.7),
        child: Text(
          duration,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
