import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../global.dart';

class Sign{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<bool> signUp(String email, String password, String name, String birth, int sex, int group, String nickName) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      await db.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'name': name,
        'birth': birth,
        'sex' : sex,
        'group': group,
        'nickName': nickName,
        'createDate': DateTime.now(),
      });
      uid = userCredential.user!.uid;
      print('uid: $uid');
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      uid = userCredential.user!.uid;
      print('uid: $uid');
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}