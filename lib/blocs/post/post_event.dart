part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();
}

class PodcastGetAll extends PostEvent {
  final String userID;

  const PodcastGetAll({required this.userID});

  @override
  List<Object> get props => [userID];
}

class TextPostGetAll extends PostEvent {
  final String userID;

  const TextPostGetAll({required this.userID});

  @override
  List<Object> get props => [userID];
}

class ImagePostGetAll extends PostEvent {
  final String userID;

  const ImagePostGetAll({required this.userID});

  @override
  List<Object> get props => [userID];
}

class VideoPostGetAll extends PostEvent {
  final String userID;

  const VideoPostGetAll({required this.userID});

  @override
  List<Object> get props => [userID];
}

class WatchLaterGetAll extends PostEvent {
  final String userID;

  const WatchLaterGetAll({required this.userID});

  @override
  List<Object> get props => [userID];
}
