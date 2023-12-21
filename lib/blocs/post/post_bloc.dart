import 'dart:developer';
import 'package:video_app/index.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(const PostInitial()) {
    on<PodcastGetAll>((event, emit) async {
      emit(const PostLoading());
      try {
        final data = await PostRepository()
            .getAll('podcast', event.props.first.toString());
        emit(PostSuccess(data));
      } catch (e) {
        log(e.toString());
        emit(PostFailure(e.toString()));
      }
    });

    on<TextPostGetAll>((event, emit) async {
      emit(const PostLoading());
      try {
        final data =
            await PostRepository().getAll('text', event.props.first.toString());
        emit(PostSuccess(data));
      } catch (e) {
        log(e.toString());
        emit(PostFailure(e.toString()));
      }
    });

    on<ImagePostGetAll>((event, emit) async {
      emit(const PostLoading());
      try {
        final data = await PostRepository()
            .getAll('image', event.props.first.toString());
        emit(PostSuccess(data));
      } catch (e) {
        log(e.toString());
        emit(PostFailure(e.toString()));
      }
    });

    on<VideoPostGetAll>((event, emit) async {
      emit(const PostLoading());
      try {
        final data = await PostRepository()
            .getAll('video', event.props.first.toString());
        emit(PostSuccess(data));
      } catch (e) {
        log(e.toString());
        emit(PostFailure(e.toString()));
      }
    });

    on<WatchLaterGetAll>((event, emit) async {
      emit(const PostLoading());
      try {
        final data = await PostRepository()
            .getWatchLaterList(event.props.first.toString());
        emit(PostSuccess(data));
      } catch (e) {
        log(e.toString());
        emit(PostFailure(e.toString()));
      }
    });
  }
}
