import 'package:video_app/index.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final String postID;

  CommentBloc({required this.postID}) : super(CommentInitial()) {
    on<CommentGetAll>((event, emit) async {
      emit(const CommentLoading());
      try {
        final data = await CommentRepository().get(postID);
        emit(CommentSuccess(data));
      } catch (e) {
        emit(CommentFailure(e.toString()));
      }
    });
  }
}
