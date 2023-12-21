import 'package:video_app/index.dart';

class InteractButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final int count;
  final VoidCallback onPressed;

  const InteractButton({
    super.key,
    required this.icon,
    required this.count,
    required this.onPressed,
    this.iconColor = const Color.fromRGBO(0, 0, 0, 0.7),
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16.0, color: iconColor, opticalSize: 0.2),
      label: Text(
        summarizeNumber(count),
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 10.5,
          color: Color.fromRGBO(0, 0, 0, 0.8),
          letterSpacing: 0.3,
        ),
      ),
      style: ButtonStyle(
        overlayColor:
            MaterialStateColor.resolveWith((states) => const Color(0xFFD7E3F6)),
      ),
    );
  }
}
