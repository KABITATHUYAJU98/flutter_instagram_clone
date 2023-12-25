import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_gram_clone/main.dart';
import 'package:insta_gram_clone/state/auth/backend/authenticator.dart';
import 'package:insta_gram_clone/state/auth/models/auth_result.dart';
import 'package:insta_gram_clone/state/auth/models/auth_state.dart';

import '../../posts/typedefs/user_id.dart';

class AuthStateNotifier extends StateNotifier<AuthState>{
  //lets keep instance of our authenticator | every state notifier has to have an initial state  -- it is saying if u don't have a initial states 
  //so u have to create a const. that contains an initial state and passes it to the super class 
  final _authenticator = const Authenticator();
  // final _userInfoStorage = const UserInfoStorage();

  AuthStateNotifier() : super(const AuthState.unknown()){ // 1st we start with the unknown state
  if(_authenticator.isAlreadyLoggedIn){
    state = AuthState(result: AuthResult.success,
     isLoading: false,
      userId: _authenticator.userId);
      //if already logged in then emit a new off state 
      //values are encompassed in the state ohject and if we change this state obj. and that new state 
      //isn't equal to the previous state then new value is going to be emitted inside ur state notifier 
   //so whoeevr is listening to changes that are happening inside State notifier are going to get notified about it

  }
  }
  
//already written this in authenticator but ..it is not the state | it doesn't contain results 
//AuthStateNotifier contains the atate 

  Future<void> logOut() async {
  state = state.copiedWithIsLoading(true);
  await _authenticator.logOut();
  state = const AuthState.unknown();
  //delegete task to authenticator and set our state to unknown
}

// Future<void> loginWithGoogle() async {
//   state = state.copiedWithIsLoading(true);
//   final result = await _authenticator.loginWithGoogle();
//   final userId = _authenticator.userId;
  
//   if(result == AuthResult.success && userId != null){
//     await saveUserInfo(userId: userId);

//   }
//   state = AuthState(result: result, isLoading: false, userId: userId);
}

//save user Info
//   Future<void> saveUserInfo({required UserId userId}) => _userInfoStorage.saveUserInfo(userId: userId,
//   displayName: _authenticator.displayName,
//   email: _authenticator.email);
// }


// rules_version = '2';
// service cloud.firestore {
//   match /databases{database}/documents {
//     match /{collectionName}/{document == **}{
//       allow read, update: if request.auth != null;
//       allow delete: if request.auth != null && ((collectionName == "likes" || collectionName == "comments") || request.auth.uid == resource.data.uid);
//     }
//   }
// }
