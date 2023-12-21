import 'dart:developer';
import 'package:video_app/index.dart';

class SmallVideoPreview extends StatefulWidget {
  final Post data;
  final UserAccount user;
  final bool hideTitle;

  const SmallVideoPreview({
    super.key,
    required this.data,
    required this.user,
    required this.hideTitle,
  });

  @override
  State<SmallVideoPreview> createState() => _SmallVideoPreview();
}

class _SmallVideoPreview extends State<SmallVideoPreview> {
  late int? watchedSec = widget.data.watchedSec;
  final double _cornerRadius = 0.0;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('/watch_later')
        .doc('${widget.data.id}${widget.user.id}')
        .snapshots()
        .listen(
      (event) {
        if (event.data() != null) {
          if (mounted) {
            setState(() {
              watchedSec = event.data()!['watchedSec'];
            });
          }
        }
      },
      onError: (error) => log("Listen failed: $error"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.38,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: const EdgeInsets.only(left: 10),
            color: const Color(0xFFD1D1D6),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_cornerRadius),
            ),
            child: GestureDetector(
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
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2.2,
                        height: 90,
                        padding: widget.hideTitle
                            ? EdgeInsets.zero
                            : const EdgeInsets.only(bottom: 5),
                        child: CachedNetworkImage(
                            imageUrl: widget.data.thumbnail!,
                            imageBuilder: (_, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: widget.hideTitle
                                        ? BorderRadius.all(
                                            Radius.circular(_cornerRadius))
                                        : BorderRadius.only(
                                            topLeft:
                                                Radius.circular(_cornerRadius),
                                            topRight:
                                                Radius.circular(_cornerRadius),
                                          ),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                            placeholder: (_, __) => const CustomProgressIndicator(),
                            errorWidget: (_, __, ___) =>
                                const Icon(Icons.error)),
                      ),
                      // VIDEO DURATION INDICATOR
                      Positioned(
                        right: 8,
                        bottom: 12,
                        child: DurationIndicator(
                            duration: generateVideoDurationFromSeconds(
                                widget.data.duration ?? 0)),
                      ),
                      if (!widget.hideTitle) ...[
                        Positioned(
                          right: 0,
                          left: 0,
                          bottom: 0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(_cornerRadius),
                                bottomRight: Radius.circular(_cornerRadius)),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 5,
                              color: const Color(0xFFD1D1D6),
                            ),
                          ),
                        ),
                        Positioned(
                          width: getWatchedWidth(
                              widget.data.duration!,
                              watchedSec!,
                              MediaQuery.of(context).size.width / 2.2),
                          left: 0,
                          bottom: 0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(_cornerRadius),
                            ),
                            child: Container(
                              height: 5,
                              color: const Color(0xFFF0A732),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (!widget.hideTitle) ...[
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 4, right: 0),
              child: Text(
                widget.data.text,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 10.5,
                  color: Color.fromRGBO(0, 0, 0, 1),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
