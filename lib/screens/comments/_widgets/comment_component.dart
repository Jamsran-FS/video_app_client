import 'package:video_app/index.dart';

class CommentComponent extends StatelessWidget {
  final Comment data;

  const CommentComponent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38.0,
            height: 38.0,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFF2F2F7)),
              image: DecorationImage(
                filterQuality: FilterQuality.high,
                image: data.user.photo == null
                    ? const AssetImage('assets/images/user.png')
                    : CachedNetworkImageProvider(
                        data.user.photo!,
                      ) as ImageProvider,
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                    minWidth: 120,
                    maxWidth: MediaQuery.of(context).size.width - 64),
                padding: const EdgeInsets.fromLTRB(14, 8, 12, 10),
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F5F7),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.user.username ?? data.user.email ?? 'Anonymous',
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        wordSpacing: 1.2,
                      ),
                    ),
                    Text(
                      data.comment,
                      overflow: TextOverflow.clip,
                      maxLines: 8,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                        color: Colors.black,
                        wordSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 2),
                child: Text(
                  generatePostedDateTimeString(data.commentedOn),
                  style: const TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF808080),
                    wordSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
