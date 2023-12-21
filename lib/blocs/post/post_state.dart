part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();
}

class PostInitial extends PostState {
  const PostInitial();

  @override
  List<Object?> get props => [];
}

class PostLoading extends PostState {
  const PostLoading();

  @override
  List<Object?> get props => [];
}

class PostSuccess extends PostState {
  final List<Post> data;

  const PostSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class PostFailure extends PostState {
  final String message;

  const PostFailure(this.message);

  @override
  List<Object?> get props => [message];
}
