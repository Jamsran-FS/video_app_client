import 'dart:developer';
import 'package:video_app/index.dart';

class CommentRepository {
  Future<List<Comment>> get(String postID) async {
    List<Comment> list = [];
    try {
      final docs = await FirebaseFirestore.instance
          .collection('comments')
          .where('postID', isEqualTo: postID)
          .get();
      for (var element in docs.docs) {
        list.add(Comment.fromJson(element.data()));
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
