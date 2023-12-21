part of 'comment_bloc.dart';

abstract class CommentState extends Equatable {
  const CommentState();
}

class CommentInitial extends CommentState {
  @override
  List<Object> get props => [];
}

class CommentLoading extends CommentState {
  const CommentLoading();

  @override
  List<Object?> get props => [];
}

class CommentSuccess extends CommentState {
  final List<Comment> data;

  const CommentSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class CommentFailure extends CommentState {
  final String message;

  const CommentFailure(this.message);

  @override
  List<Object?> get props => [message];
}
