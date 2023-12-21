import 'dart:developer';
import 'package:video_app/index.dart';

class CommentsScreen extends StatefulWidget {
  final Post postData;

  const CommentsScreen({super.key, required this.postData});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentInputController = TextEditingController();
  late UserAccount _user;
  bool _loading = false;
  late CommentBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = CommentBloc(postID: widget.postData.id);
    _bloc.add(const CommentGetAll());
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    _user = context.select((AuthBloc bloc) => bloc.state.user);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Сэтгэгдэл',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        titleSpacing: 0,
        backgroundColor: const Color(0xFFFFFFFF),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CommentBloc, CommentState>(
            bloc: _bloc,
            listener: ((context, state) {
              if (state is CommentLoading) {
                setState(() {
                  _loading = true;
                });
              }
              if (state is CommentSuccess) {
                Provider.of<CommonProvider>(context, listen: false)
                    .setComments(state.data);
                setState(() {
                  _loading = false;
                });
              }
              if (state is CommentFailure) {
                setState(() {
                  _loading = false;
                });
              }
            }),
          ),
        ],
        child: Consumer<CommonProvider>(
          builder: ((context, provider, child) {
            return _loading
                ? const CustomProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: provider.comments.isEmpty
                            ? const Center(
                                child: Text('Сэтгэгдэл байхгүй байна . . .'),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(2),
                                itemCount: provider.comments.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: CommentComponent(
                                      data: provider.comments[index],
                                    ),
                                  );
                                },
                              ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _commentInputController,
                                minLines: 1,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  hintText: 'Сэтгэгдэл бичих...',
                                  filled: true,
                                  fillColor: const Color(0xFFF4F5F7),
                                  hintStyle: const TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2,
                                    color: Color(0xFF757575),
                                    wordSpacing: 1.2,
                                  ),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(14, 6, 14, 6),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFF4F5F7),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFF4F5F7),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                String comm =
                                    _commentInputController.value.text;
                                if (comm.isNotEmpty && comm.trim() != '') {
                                  _commentInputController.clear();
                                  try {
                                    var commentID = const Uuid().v4();
                                    Comment comment = Comment(
                                      id: commentID,
                                      postID: widget.postData.id,
                                      comment: comm,
                                      commentedOn: DateTime.now(),
                                      user: _user,
                                    );
                                    Provider.of<CommonProvider>(context,
                                            listen: false)
                                        .addComment(comment);
                                    await FirebaseFirestore.instance
                                        .collection('/comments')
                                        .doc(commentID)
                                        .set(comment.toJson());
                                    await FirebaseFirestore.instance
                                        .collection('/posts')
                                        .doc(comment.postID)
                                        .update({
                                      'comment': FieldValue.increment(1)
                                    });
                                  } catch (e) {
                                    log('ERROR ==================>${e.toString()}');
                                  }
                                }
                              },
                              icon: const Icon(
                                Icons.send_rounded,
                                size: 32,
                                color: Color(0xFFC4C5C7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
          }),
        ),
      ),
    );
  }
}
