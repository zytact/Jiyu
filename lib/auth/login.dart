import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signInWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount account = await googleSignIn.signIn();
      if (account == null) {
        return false;
      }
      GoogleSignInAuthentication googleSignInAuthentication =
          await account.authentication;
      AuthResult res =
          await _auth.signInWithCredential(GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      ));
      if (res.user == null) {
        return false;
      }
      // final FirebaseUser user = await _auth.currentUser();
      // final uid = user.uid;
      // final CollectionReference collectionReference =
      //     Firestore.instance.collection(uid);
      return true;
    } catch (e) {
      print("Error logging in with google");
      return false;
    }
  }

  void signOut() {
    _auth.signOut();
  }

  Future<String> currentUserId() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    return uid;
  }
}
