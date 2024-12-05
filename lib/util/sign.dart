import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../global.dart';

class Sign{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<bool> signUp(BuildContext context, String email, String password, String name, String birth, String sex, int group, String nickName) async {
    try {
      saving(context);
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      await db.collection('users').doc(userCredential.user!.uid).set({
        'id': email,
        'name': name,
        'birthDate': birth,
        'sex' : sex,
        'mail': email,
        'randomGroup': group + 1,
        'diaryName': nickName,
        'createDate': DateTime.now(),
      });
      myName = nickName;
      uid = userCredential.user!.uid;
      return true;
    } catch (e) {
      print(e);
      Get.back();
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      DocumentSnapshot snapshot = await db.collection('users').doc(userCredential.user!.uid).get();
      myName = snapshot['diaryName'];
      uid = userCredential.user!.uid;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}