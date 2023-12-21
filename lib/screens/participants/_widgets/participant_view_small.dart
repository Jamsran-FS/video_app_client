import 'dart:developer';
import 'package:video_app/index.dart';

class ParticipantViewSmall extends StatefulWidget {
  final Participant data;

  const ParticipantViewSmall({super.key, required this.data});

  @override
  State<ParticipantViewSmall> createState() => _ParticipantViewSmall();
}

class _ParticipantViewSmall extends State<ParticipantViewSmall> {
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
            log("Listen failed on participant view small: $error"),
      );
    } catch (_) {}

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => VideoList(data: widget.data)));
      },
      child: Card(
        margin: const EdgeInsets.only(left: 10),
        color: const Color(0xFFF8F8F8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 6, 10, 6),
          width: MediaQuery.of(context).size.width / 1.8,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFBEBEBE), width: 0.3),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            color: const Color(0xFFF8F8F8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.data.photo,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 40,
                          height: 40,
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
                      const SizedBox(width: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: Container(
                          margin: const EdgeInsets.only(left: 0),
                          padding: const EdgeInsets.fromLTRB(6, 3, 6, 3),
                          color: const Color.fromRGBO(0, 0, 0, 0.7),
                          child: Text(
                            '${widget.data.videoCount} Бичлэг',
                            style: const TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // LIKE BUTTON
                  IconButton(
                    onPressed: _toggleFavorite,
                    icon: (widget.data.isFavorite
                        ? const Icon(Icons.favorite,
                            size: 24.0, color: Colors.redAccent)
                        : const Icon(Icons.favorite_border_rounded,
                            size: 24.0, color: Color.fromRGBO(0, 0, 0, 1))),
                    style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => const Color(0xFFD7E3F6)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                widget.data.fullName,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.0,
                  letterSpacing: 0.2,
                  color: Color.fromRGBO(0, 0, 0, 1),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                widget.data.intro,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                  fontSize: 13.0,
                  letterSpacing: 0.0,
                  color: Color.fromRGBO(0, 0, 0, 1),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
