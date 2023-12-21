import 'dart:developer';
import 'package:video_app/index.dart';

class ParticipantViewLarge extends StatefulWidget {
  final Participant data;
  final bool bottomGap;

  const ParticipantViewLarge(
      {super.key, required this.data, required this.bottomGap});

  @override
  State<ParticipantViewLarge> createState() => _ParticipantViewLarge();
}

class _ParticipantViewLarge extends State<ParticipantViewLarge> {
  late UserAccount _user;
  void _toggleFavorite() async {
    if (widget.data.isFavorite) {
      try {
        setState(() {
          widget.data.isFavorite = false;
        });
        await FirebaseFirestore.instance
            .collection('/participants')
            .doc(widget.data.id)
            .update({'likeCount': FieldValue.increment(-1)});

        await FirebaseFirestore.instance
            .collection('/interactions')
            .where('userID', isEqualTo: _user.id)
            .where('participantID', isEqualTo: widget.data.id)
            .get()
            .then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
        });
      } catch (_) {}
    } else {
      try {
        setState(() {
          widget.data.isFavorite = true;
        });
        await FirebaseFirestore.instance
            .collection('/participants')
            .doc(widget.data.id)
            .update({'likeCount': FieldValue.increment(1)});

        String id = '${widget.data.id}${_user.id}';
        await FirebaseFirestore.instance
            .collection('/interactions')
            .doc(id)
            .set(
                Interaction(
                  id: id,
                  userID: _user.id,
                  participantID: widget.data.id,
                  type: InteractionType.likeParticipant,
                ).toJson(),
                SetOptions(merge: true));
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    _user = context.select((AuthBloc bloc) => bloc.state.user);
    //print(widget.data.toJson().toString());
    try {
      FirebaseFirestore.instance
          .collection('/interactions')
          .doc('${widget.data.id}${_user.id}')
          .snapshots()
          .listen(
        (event) {
          if (mounted) {
            if (event.data() != null) {
              setState(() {
                widget.data.isFavorite = true;
              });
            } else {
              setState(() {
                widget.data.isFavorite = false;
              });
            }
          }
        },
        onError: (error) =>
            log("Listen failed on participant view large: $error"),
      );
    } catch (_) {}

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => VideoList(data: widget.data)));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        margin: widget.bottomGap
            ? const EdgeInsets.only(bottom: 12)
            : EdgeInsets.zero,
        elevation: 2,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Stack(
                children: [
                  // FAMOUS VIDEO THUMBNAIL OF PARTICIPANT
                  AspectRatio(
                    aspectRatio: 2 / 1,
                    child: CachedNetworkImage(
                      imageUrl: widget.data.famousVideoThumb!,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Container(
                        margin: const EdgeInsets.only(left: 0),
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                        color: const Color.fromRGBO(0, 0, 0, 0.7),
                        child: Text(
                          '${widget.data.videoCount} Бичлэг',
                          style: const TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // LIKE BUTTON
                  Positioned(
                    top: 12,
                    right: 12,
                    child: CircleAvatar(
                      maxRadius: 20,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: _toggleFavorite,
                        icon: (widget.data.isFavorite
                            ? const Icon(
                                Icons.favorite,
                                size: 24.0,
                                color: Colors.redAccent,
                              )
                            : const Icon(Icons.favorite_border_rounded,
                                size: 24.0, color: Color.fromRGBO(0, 0, 0, 1))),
                        style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => const Color(0xFFD7E3F6)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // PARTICIPANT AVATAR IMAGE
                    CachedNetworkImage(
                      imageUrl: widget.data.photo,
                      imageBuilder: (_, imageProvider) => Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      placeholder: (_, __) => const CustomProgressIndicator(),
                      errorWidget: (_, __, ___) => const Icon(Icons.error),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // PARTICIPANT NAME
                            Text(
                              widget.data.fullName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                height: 1.6,
                                fontSize: 13.5,
                                letterSpacing: 0.2,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // PARTICIPANT DESCRIPTION
                            Text(
                              widget.data.intro,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  height: 1.2,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  color: Colors.black),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
