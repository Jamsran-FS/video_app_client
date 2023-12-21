import 'package:video_app/index.dart';

class VideoList extends StatefulWidget {
  final Participant data;
  const VideoList({super.key, required this.data});

  @override
  State<StatefulWidget> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.initState();
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final podcasts = Provider.of<CommonProvider>(context)
        .podcasts
        .where((element) => element.participantID == widget.data.id)
        .toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.data.fullName,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18.0,
              color: Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      body: RefreshIndicator(
        strokeWidth: 3,
        onRefresh: _onRefresh,
        child: ListView.builder(
          shrinkWrap: false,
          padding: EdgeInsets.zero,
          itemCount: podcasts.length,
          itemBuilder: (BuildContext context, int index) {
            return VideoListItem(data: podcasts[index]);
          },
        ),
      ),
    );
  }
}
