import 'dart:developer';
import 'package:video_app/index.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('/users');

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  var currentUser = UserAccount.empty;

  late AccountType _accountType = AccountType.none;

  Stream<UserAccount> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null
          ? UserAccount.empty
          : firebaseUser.toUserAccount(_accountType);
      currentUser = user;
      return user;
    });
  }

  Future<void> insertUserData() async {
    try {
      await _usersCollection.doc(currentUser.id).set(currentUser.toJson());
    } catch (error) {
      log(error.toString());
    }
  }

  Future<String> signupWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _accountType = AccountType.emailAndPassword;
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await insertUserData();
      return "Registration success!";
    } on FirebaseAuthException catch (e) {
      log('Email signup failed with error code: ${e.code}');
      log(e.message.toString());
      return e.message.toString();
    }
  }

  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _accountType = AccountType.emailAndPassword;
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      log('Email login failed with error code: ${e.code}');
      log(e.message.toString());
    }
  }

  Future<void> loginWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      //final userData = await FacebookAuth.instance.getUserData();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      _accountType = AccountType.facebook;
      await _firebaseAuth.signInWithCredential(facebookAuthCredential);
      await insertUserData();
    } on FirebaseAuthException catch (e) {
      log('Facebook login failed with error code: ${e.code}');
      log(e.message.toString());
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      _accountType = AccountType.google;
      await _firebaseAuth.signInWithCredential(credential);
      await insertUserData();
    } on FirebaseAuthException catch (e) {
      log('Google account login failed with error code: ${e.code}');
      log(e.message.toString());
    }
  }

  Future<void> loginWithAnonymous() async {
    try {
      _accountType = AccountType.anonymous;
      await _firebaseAuth.signInAnonymously();
      await insertUserData();
    } on FirebaseAuthException catch (e) {
      log('Anonymous login failed with error code: ${e.code}');
      log(e.message.toString());
    }
  }

  Future<void> logout() async {
    try {
      await Future.wait([_firebaseAuth.signOut()]);
    } catch (_) {}
  }
}

extension on User {
  UserAccount toUserAccount(AccountType accountType) {
    return UserAccount(
      id: uid,
      username: displayName,
      photo: photoURL,
      email: email,
      phone: phoneNumber,
      registeredDate: metadata.creationTime,
      accountType: accountType,
    );
  }
}
