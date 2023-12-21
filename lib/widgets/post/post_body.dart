import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:video_app/index.dart';

class PostBody extends StatefulWidget {
  final Post data;
  final bool bottomGap;
  final bool hideBody;

  const PostBody({
    super.key,
    required this.data,
    required this.bottomGap,
    required this.hideBody,
  });

  @override
  State<PostBody> createState() => _PostBody();
}

class _PostBody extends State<PostBody> {
  late UserAccount _user;
  late int _maxLines = 2;
  late int _likeCount = 0;
  late int _commentCount = 0;
  late int _viewCount = 0;

  @override
  void initState() {
    super.initState();

    if (widget.data.type == PostType.text) _maxLines = 7;

    _commentCount = widget.data.comment;

    try {
      FirebaseFirestore.instance
          .collection('/posts')
          .doc(widget.data.id)
          .snapshots()
          .listen(
        (event) {
          if (event.data() != null) {
            if (mounted) {
              setState(() {
                _likeCount = event.data()!['like'];
                _commentCount = event.data()!['comment'];
                _viewCount = event.data()!['view'];
              });
            }
          }
        },
        onError: (error) => log("Listen failed on post body: $error"),
      );
    } catch (_) {}
  }

  void _toggleFavorite() async {
    if (widget.data.isFavorite) {
      setState(() {
        widget.data.isFavorite = false;
      });
      try {
        await FirebaseFirestore.instance
            .collection('/posts')
            .doc(widget.data.id)
            .update({'like': FieldValue.increment(-1)});

        await FirebaseFirestore.instance
            .collection('/interactions')
            .where('userID', isEqualTo: _user.id)
            .where('postID', isEqualTo: widget.data.id)
            .get()
            .then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
        });
      } catch (_) {}
    } else {
      setState(() {
        widget.data.isFavorite = true;
      });
      try {
        await FirebaseFirestore.instance
            .collection('/posts')
            .doc(widget.data.id)
            .update({'like': FieldValue.increment(1)});

        String uuid = const Uuid().v4();
        await FirebaseFirestore.instance
            .collection('/interactions')
            .doc(uuid)
            .set(
                Interaction(
                  id: uuid,
                  userID: _user.id,
                  postID: widget.data.id,
                  type: InteractionType.likePost,
                ).toJson(),
                SetOptions(merge: true));
      } catch (_) {}
    }
  }

  void showBottomDetailSheet() {
    Participant participant =
        Provider.of<CommonProvider>(context, listen: false)
            .getParticipantNameById(widget.data.participantID);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 14),
            Container(
              width: 45,
              height: 4,
              decoration: const BoxDecoration(
                color: Color(0xFFE0E0E0),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE0E0E0),
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 14),
                      Text(
                        'Дэлгэрэнгүй мэдээлэл',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close, size: 28),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: ListView(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          widget.data.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: participant.photo,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                              placeholder: (context, url) =>
                              const CustomProgressIndicator(),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              participant.fullName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  widget.data.like.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.0,
                                  ),
                                ),
                                const Text(
                                  'Likes',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                    color: Color(0xFF606060),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  NumberFormat('###,###,###')
                                      .format(widget.data.view),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.0,
                                  ),
                                ),
                                const Text(
                                  'Views',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                    color: Color(0xFF606060),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  widget.data.date.year.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.0,
                                  ),
                                ),
                                Text(
                                  '${widget.data.date.day} ${getMonthName(widget.data.date.month)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                    color: Color(0xFF606060),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(
                      color: Color(0xFFE0E0E0),
                      height: 0,
                      thickness: 1.0,
                      indent: 2,
                      endIndent: 2,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.data.text,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _user = context.select((AuthBloc bloc) => bloc.state.user);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      margin: widget.bottomGap
          ? const EdgeInsets.only(bottom: 12)
          : EdgeInsets.zero,
      elevation: 2,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            if (!widget.hideBody) ...[
              // POST CONTENT
              if (widget.data.type == PostType.podcast ||
                  widget.data.type == PostType.video) ...[
                VideoPreview(data: widget.data)
              ],
              if (widget.data.type == PostType.image) ...[
                if (widget.data.images != null) ...[
                  ImageSlider(images: widget.data.images!)
                ]
              ],
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  // POST TEXT
                  GestureDetector(
                    onTap: () {
                      showBottomDetailSheet();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ExpandableText(
                        text: widget.data.text,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13.0,
                          letterSpacing: 0.2,
                          height: 1.25,
                          color: Color.fromRGBO(0, 0, 0, 1),
                        ),
                        maxLines: _maxLines,
                        expandIconColor: Colors.black,
                        isEnabled: false,
                        onTap: showBottomDetailSheet,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    color: Color(0xFFABABAB),
                    height: 0,
                    thickness: 0.3,
                    indent: 0,
                    endIndent: 0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        generatePostedDateTimeString(widget.data.date),
                        style: const TextStyle(
                          fontSize: 11.0,
                          color: Color.fromRGBO(0, 0, 0, 0.6),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // FAVORITE BUTTON
                          InteractButton(
                            onPressed: _toggleFavorite,
                            icon: widget.data.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            iconColor: widget.data.isFavorite
                                ? Colors.redAccent
                                : const Color.fromRGBO(0, 0, 0, 0.7),
                            count: _likeCount,
                          ),
                          // COMMENT BUTTON
                          InteractButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) =>
                                    CommentsScreen(postData: widget.data),
                              ));
                            },
                            icon: Icons.messenger_outline,
                            count: _commentCount,
                          ),
                          // VIEWS BUTTON
                          InteractButton(
                            onPressed: () {},
                            icon: Icons.remove_red_eye_outlined,
                            count: _viewCount,
                          ),
                        ],
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
