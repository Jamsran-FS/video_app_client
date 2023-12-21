import 'package:video_app/index.dart';

class WatchLaterWidget extends StatelessWidget {
  final List<Post> data;
  final UserAccount user;

  const WatchLaterWidget({super.key, required this.data, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(left: 10, top: 12, bottom: 4),
              child: Text(
                "Үргэлжлүүлэн үзэх",
                style: TextStyle(
                  color: Color(0xFF1C1C1E),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 125,
              color: Colors.white,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                padding: const EdgeInsets.only(right: 10, top: 2),
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return SmallVideoPreview(
                    data: data[index],
                    user: user,
                    hideTitle: false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
