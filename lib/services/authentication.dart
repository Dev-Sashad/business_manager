import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<UserCredential> signIn(String email, String password);

  Future<UserCredential> signUp(String email, String password);

  Future<User> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<void> sendPasswordResetMail(String email);
}


 class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  
   @override
  Future<UserCredential> signIn(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    
  }


   @override

  Future<UserCredential> signUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

   @override

  Future<User> getCurrentUser() async {
    User user = _firebaseAuth.currentUser;
    return user;
  }

   @override

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    return signOut();
  }

   @override
  Future<void> sendEmailVerification() async {
    User user =  _firebaseAuth.currentUser;
    await user.sendEmailVerification();
  }

   @override
 
  Future<bool> isEmailVerified() async {
    _firebaseAuth.currentUser.emailVerified;
   return true;
  }


  @override
  Future<void> sendPasswordResetMail(String email) async{
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }


}
