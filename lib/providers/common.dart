import 'package:video_app/index.dart';

class CommonProvider with ChangeNotifier {
  List<Participant> participants = [];
  List<Post> podcasts = [];
  List<Post> watchLaterList = [];
  List<Comment> comments = [];

  List<Participant> get topParticipant =>
      participants.length > 3 ? participants.sublist(0, 3) : participants;

  void setParticipants(List<Participant> list) {
    participants = list;
  }

  void setWatchLaterList(List<Post> list) {
    watchLaterList = list;
  }

  Post specialPodcast() {
    return podcasts.isNotEmpty
        ? podcasts[0]
        : Post(
            id: '',
            title: '',
            text: '',
            type: PostType.podcast,
            date: DateTime.now(),
            like: 0,
            comment: 0,
            view: 0,
            share: 0,
            isFavorite: false,
          );
  }

  void setPodcasts(List<Post> list) {
    podcasts = list;
  }

  void setComments(List<Comment> list) {
    list.sort((a, b) => b.commentedOn.compareTo(a.commentedOn));
    comments = list;
  }

  void addComment(Comment comment) {
    comments.insert(0, comment);
    notifyListeners();
  }

  Future<void> addWatchLaterList(Post post) async {
    if (!watchLaterList.any((element) => element.id == post.id)) {
      watchLaterList.add(post);
      notifyListeners();
    }
  }

  Future<void> removeWatchLaterListItem(Post post) async {
    watchLaterList.remove(post);
    notifyListeners();
  }

  Participant getParticipantNameById(String? id) {
    return participants.singleWhere((element) => element.id == id,
        orElse: () => Participant(
              id: '',
              fullName: 'participant not found!',
              photo: '',
              intro: '',
              isFavorite: false,
            ));
  }
}
