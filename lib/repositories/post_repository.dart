import 'dart:developer';
import 'package:video_app/index.dart';

class PostRepository {
  Future<List<Post>> getAll(String type, String userID) async {
    List<Post> list = [];
    try {
      final docs = await FirebaseFirestore.instance
          .collection('/posts')
          .where('type', isEqualTo: type)
          .get();
      for (var element in docs.docs) {
        Post post = Post.fromJson(element.data());
        await FirebaseFirestore.instance
            .collection('/interactions')
            .where('userID', isEqualTo: userID)
            .where('postID', isEqualTo: post.id)
            .get()
            .then((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            post.isFavorite = true;
          }
        });
        list.add(post);
      }
      return list;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        log('Failed with error ${e.code}: ${e.message}');
      }
      return list;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Post>> getWatchLaterList(String userID) async {
    List<Post> list = [];
    try {
      final watchLaterDocs = await FirebaseFirestore.instance
          .collection('/watch_later')
          .where('userID', isEqualTo: userID)
          .get();

      for (var element in watchLaterDocs.docs) {
        final postDoc = await FirebaseFirestore.instance
            .collection('/posts')
            .doc(element.data()['postID'])
            .get();

        if (postDoc.data() != null) {
          Post post = Post.fromJson(postDoc.data()!);
          post.watchedSec = element.data()['watchedSec'];
          list.add(post);
        }
      }
      return list;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        log('Failed with error ${e.code}: ${e.message}');
      }
      return list;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
