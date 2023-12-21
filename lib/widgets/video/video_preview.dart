import 'package:video_app/index.dart';

class VideoPreview extends StatefulWidget {
  final Post data;

  const VideoPreview({super.key, required this.data});

  @override
  State<VideoPreview> createState() => _VideoPreview();
}

class _VideoPreview extends State<VideoPreview> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Navigator.canPop(context)) Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => VideoPlayerScreen(data: widget.data)));
      },
      child: Container(
        height: 200,
        color: Colors.white,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              progressIndicatorBuilder: (_, __, ___) => const CustomProgressIndicator(),
              imageUrl: widget.data.thumbnail ?? '',
              fit: BoxFit.fill,
            ),
            Positioned(
              right: 15,
              bottom: 15,
              child: DurationIndicator(
                duration:
                    generateVideoDurationFromSeconds(widget.data.duration ?? 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
