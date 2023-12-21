import 'package:video_app/index.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {});
  }

  List<Post> newsPosts = <Post>[
    Post(
      id: '086a1f74-dafd-497d-a637-26d8c40aa9a5',
      type: PostType.image,
      date: DateTime.parse('2020-09-02 10:00:00'),
      like: 1200,
      comment: 300,
      view: 5800000,
      share: 58,
      title: postTitles[2],
      images: imageContents,
      text: textContent[1],
      isFavorite: false,
    ),
    Post(
      id: '086a1f74-dafd-497d-a637-26d8c40aa9a5',
      type: PostType.text,
      date: DateTime.parse('2020-09-02 10:00:00'),
      like: 1200,
      comment: 300,
      view: 5800000,
      share: 58,
      title: textContent[0],
      text: textContent[1],
      isFavorite: false,
    ),
    Post(
      id: '086a1f74-dafd-497d-a637-26d8c40aa9a5',
      type: PostType.image,
      date: DateTime.parse('2020-09-02 10:00:00'),
      like: 1200,
      comment: 300,
      view: 5800000,
      share: 58,
      title: postTitles[2],
      text: textContent[1],
      images: <String>[imageContents[0]],
      isFavorite: false,
    ),
    Post(
      id: '086a1f74-dafd-497d-a637-26d8c40aa9a5',
      type: PostType.text,
      date: DateTime.parse('2020-09-02 10:00:00'),
      like: 1200,
      comment: 300,
      view: 5800000,
      share: 58,
      title: textContent[1],
      text: textContent[1],
      isFavorite: false,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      strokeWidth: 3,
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            return PostBody(
              data: newsPosts[index],
              bottomGap: index + 1 < 4,
              hideBody: false,
            );
          },
        ),
      ),
    );
  }
}
