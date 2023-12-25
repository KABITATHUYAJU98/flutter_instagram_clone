import 'package:flutter/foundation.dart' show immutable;
import 'package:insta_gram_clone/state/auth/models/auth_result.dart';
import 'package:insta_gram_clone/state/posts/typedefs/user_id.dart';
//we don't need entire foundation so..use show immutable to use only that

@immutable
class AuthState {
  final AuthResult? result;
  final bool isLoading;
  final UserId? userId;

  const AuthState({required this.result, required this.isLoading, required this.userId});

  //create constant constructor for  our auth state called unknown which sets up these three props accordingly to an unknown state 
  const AuthState.unknown() : result = null, isLoading = false, userId = null;

  AuthState copiedWithIsLoading(bool isLoading) => AuthState(result: result, isLoading: isLoading, userId: userId);
  
//any model objects for a riverpod and u need to ensure that you're implementing identical or equality and hash values on your model objects 
// checks equal and not equal if equal then.not gives new value if not then..it gives new value

  @override
  bool operator == (covariant AuthState other) => identical(this, other) || 
  (result == other.result && isLoading == other.isLoading && userId == other.userId);

  @override
  int get hashCode => Object.hash(result, isLoading, userId);
}

//even if the authentication state is unknown, it's loading property can be set to true, using copiedwithIsloading..func

//start implementing the authenticator
