import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/storage_methods.dart';

class authMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
    await _firestore.collection('user').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  //sign up the user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Error occured";
    try{
      if(email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        print(cred.user!.uid);

        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

        model.User _user = model.User(
          username: username,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          email: email,
          bio: bio,
          followers: [],
          following: [],
        );

        //adding user to the database
        await _firestore
            .collection("user")
            .doc(cred.user!.uid)
            .set(_user.toJson());
        res = "success";
      }
    } catch(error) {
      res = error.toString();
    }
    return res;
  }

  //login the user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";

    try {
      if(email.isNotEmpty || password.isNotEmpty) {
        //login user
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      }
      else {
        res = "Please enter all the fields";
      }
    } catch(err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}