import 'package:video_app/index.dart';

class VideoListItem extends StatefulWidget {
  final Post data;

  const VideoListItem({super.key, required this.data});

  @override
  State<VideoListItem> createState() => _VideoListItemState();
}

class _VideoListItemState extends State<VideoListItem> {
  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);
    return GestureDetector(
      onTap: () {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => VideoPlayerScreen(
              data: widget.data,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.only(top: 9, bottom: 9, right: 9),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SmallVideoPreview(data: widget.data, user: user, hideTitle: true),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data.text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.0,
                      letterSpacing: 0.0,
                      color: Colors.black,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        '${widget.data.view} үзэлт',
                        style: const TextStyle(
                          fontSize: 11.0,
                          color: Color.fromRGBO(0, 0, 0, 0.6),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Text(
                        ' · ',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Color.fromRGBO(0, 0, 0, 0.55),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        generatePostedDateTimeString(widget.data.date),
                        style: const TextStyle(
                          fontSize: 11.0,
                          color: Color.fromRGBO(0, 0, 0, 0.6),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
