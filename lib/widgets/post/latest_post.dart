import 'package:video_app/index.dart';

class LatestPost extends StatelessWidget {
  final Post data;

  const LatestPost({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Navigator.canPop(context)) Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => VideoPlayerScreen(
                  data: data,
                )));
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: CachedNetworkImageProvider(
              data.thumbnail ??
                  'https://cdn.pixabay.com/photo/2018/01/12/10/19/fantasy-3077928__480.jpg',
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(0),
          width: MediaQuery.of(context).size.width,
          height: 220.0,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color.fromRGBO(0, 0, 0, 0.0),
                Color.fromRGBO(0, 0, 0, 1.0),
              ],
              tileMode: TileMode.mirror,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  maxRadius: 24,
                  backgroundColor: Color.fromRGBO(0, 0, 0, 0.6),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    size: 33,
                    color: Color.fromRGBO(255, 255, 255, 0.85),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Container(
                      margin: const EdgeInsets.only(left: 0),
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      color: const Color.fromRGBO(0, 0, 0, 0.7),
                      child: const Text(
                        'Онцлох',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(12, 8, 18, 14),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color.fromRGBO(0, 0, 0, 0.0),
                      Color.fromRGBO(0, 0, 0, 1.0),
                    ],
                    tileMode: TileMode.mirror,
                  ),
                ),
                child: Text(
                  data.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
