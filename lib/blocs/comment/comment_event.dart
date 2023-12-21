part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();
}

class CommentGetAll extends CommentEvent {
  const CommentGetAll();

  @override
  List<Object> get props => [];
}
