//core of authenticator - getting the current user Id, get the display name and email
import 'package:insta_gram_clone/state/auth/constants/constants.dart';
import 'package:insta_gram_clone/state/auth/models/auth_result.dart';

import 'package:insta_gram_clone/state/posts/typedefs/user_id.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Authenticator {

  const Authenticator();

  // User? get currentUser => FirebaseAuth.instance.currentUser;
  UserId? get userId => FirebaseAuth.instance.currentUser?.uid;
  //we also have to check that already logged in or not - if we have the current User Id then..u're already logged in
  bool get isAlreadyLoggedIn => userId != null;

  String get displayName => FirebaseAuth.instance.currentUser?.displayName ?? '';
  String? get email => FirebaseAuth.instance.currentUser?.email;

  //Function for log out
  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  //Response the auth Result
  Future<AuthResult> loginWithFacebook() async {
    final loginResult = await FacebookAuth.instance.login();
    final token = loginResult.accessToken?.token;

    if(token == null){
      //user has aborted the logging in the process
      return AuthResult.aborted;
    }

    final oauthCredentials = FacebookAuthProvider.credential(token);

    try{
      await FirebaseAuth.instance.signInWithCredential(oauthCredentials);
      return AuthResult.success;
    } on FirebaseAuthException catch(e){
      //extract ur email
      final email = e.email;
      final credential = e.credential;

      if(e.code == Constants.accountExistsWithDifferentCredential && 
      email != null && 
      credential != null
      
      ){
        //get your provider
        final providers = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

        if(providers.contains(Constants.googleCom)){
          await loginWithGoogle();

          FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
        }
        return AuthResult.success;

      }
      return AuthResult.failure;
    }
  }

  Future<AuthResult> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [Constants.emailScope]
    );

    final signInAccount = await googleSignIn.signIn();

    if(signInAccount == null){
      return AuthResult.aborted;
    }
    
    final googleAuth = await signInAccount.authentication;
    final authCredentials = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken,idToken: googleAuth.idToken);

    try{
      await FirebaseAuth.instance.signInWithCredential(authCredentials);
      return AuthResult.success;
    } catch (e){
      return AuthResult.failure;
    }
  }

}

//if u have federated signing in like google | fb..
/*already logged in but again with the same credential if u log in again then u will get  an exception*/ 
