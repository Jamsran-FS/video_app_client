import 'package:video_app/index.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Post data;
  const VideoPlayerScreen({super.key, required this.data});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  late UserAccount _user;
  late dynamic _provider;
  late bool _isUpdateWatchLaterList = true;

  @override
  void initState() {
    super.initState();

    updateViewCount();
    _controller = YoutubePlayerController(
      initialVideoId: widget.data.videoURL ?? '',
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: true,
        controlsVisibleAtStart: true,
      ),
    );
  }

  void updateViewCount() async {
    try {
      await FirebaseFirestore.instance
          .collection('/posts')
          .doc(widget.data.id)
          .update({'view': FieldValue.increment(1)});
    } catch (_) {}
  }

  @override
  void deactivate() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.pause();

    if (_isUpdateWatchLaterList) updateWatchLaterList();

    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  void updateWatchLaterList() async {
    String id = '${widget.data.id}${_user.id}';
    int position = _controller.value.position.inSeconds;

    Post post = widget.data;
    post.watchedSec = position;

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _provider.addWatchLaterList(post));

    try {
      await FirebaseFirestore.instance.collection('/watch_later').doc(id).set(
          WatchLater(
                  id: id,
                  userID: _user.id,
                  postID: widget.data.id,
                  watchedSec: position)
              .toJson(),
          SetOptions(merge: true));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<CommonProvider>(context);
    _user = context.select((AuthBloc bloc) => bloc.state.user);
    final podcasts = Provider.of<CommonProvider>(context).podcasts;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          YoutubePlayerBuilder(
            onExitFullScreen: () {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                  overlays: SystemUiOverlay.values);
            },
            player: YoutubePlayer(
              controller: _controller,
              onReady: () {
                _isUpdateWatchLaterList = true;
                if (widget.data.watchedSec != null) {
                  int reduction = 0;
                  if (widget.data.watchedSec! > 5) reduction = 5;
                  _controller.seekTo(
                      Duration(seconds: widget.data.watchedSec! - reduction),
                      allowSeekAhead: true);
                }
              },
              onEnded: (metaData) {
                _isUpdateWatchLaterList = false;

                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _provider.removeWatchLaterListItem(widget.data));

                try {
                  String id = '${widget.data.id}${_user.id}';
                  FirebaseFirestore.instance
                      .collection('/watch_later')
                      .doc(id)
                      .get()
                      .then((snapshot) {
                    if (snapshot.exists) {
                      snapshot.reference.delete();
                    }
                  });
                } catch (_) {}

                Navigator.pop(context);
              },
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,
              topActions: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 25.0,
                  ),
                  onPressed: () {
                    if (_controller.value.isFullScreen) {
                      _controller.toggleFullScreenMode();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                Text(
                  widget.data.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
              bottomActions: [
                const SizedBox(width: 5),
                CurrentPosition(),
                const SizedBox(width: 5),
                ProgressBar(
                  isExpanded: true,
                  colors: const ProgressBarColors(
                      playedColor: Colors.blue, handleColor: Colors.blueAccent),
                ),
                const SizedBox(width: 5),
                RemainingDuration(),
                FullScreenButton(),
              ],
            ),
            builder: (context, player) => Column(
              children: [
                player,
                PostBody(data: widget.data, bottomGap: false, hideBody: true),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.only(top: 18),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: podcasts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return VideoListItem(data: podcasts[index]);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
