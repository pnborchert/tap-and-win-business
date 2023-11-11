import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tw_business_app/models/user.dart';
import 'package:tw_business_app/services/database.dart';
import 'package:tw_business_app/services/auth_api.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<int> resetPassword(String email) async {
    _auth.sendPasswordResetEmail(email: email);
  }

  User currentUser() {
    return _auth.currentUser;
  }

  Future<int> reauthenticateUser(String email, String password) async {
    try {
      AuthCredential cred = EmailAuthProvider.credential(
          email: _auth.currentUser.email, password: password);
      await _auth.currentUser.reauthenticateWithCredential(cred);
      return 1;
    } catch (e) {
      return 0;
    }
  }

  // update Email Credentials
  Future<int> updateEmailCred(String newEmail) async {
    try {
      await _auth.currentUser.updateEmail(newEmail);
      return 1;
    } catch (e) {
      return 0;
    }
  }

  // create user object based on firebase user
  AppUser _userFromFirebase(User user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  Stream<User> get authUser {
    return _auth.userChanges();
  }

  // auth change user stream
  Stream<AppUser> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  // sign in email and password
  Future signInEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      // await DataBaseService(uid: user.uid).updateFCMToken();
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register email and password
  Future registerEmailPassword(
      String email, String password, String placeId) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      // create new document in firebase with uid
      // updateCustomerData(String email, int gender, int is_store, int points, String username)

      bool resAPI = await storeRegisterAPI(placeId, email, user.uid);
      if (!resAPI) {
        return null;
      }
      //await DataBaseService(uid: user.uid)
      //  .updateCustomerData(user.email, 3, 0, 0, 'New User');

      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }

      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> emailVerified() async {
    await FirebaseAuth.instance.currentUser.reload();
    return FirebaseAuth.instance.currentUser.emailVerified;
  }

  Future<void> sendEmailVerification() async {
    return FirebaseAuth.instance.currentUser.sendEmailVerification();
  }
}
