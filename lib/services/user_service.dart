import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_day_app/models/user_model/user_model.dart';

class UserService {
  final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  UserModel? userModel;

  Future<UserModel?> addUser({
    required String email,
    required String password,
    required String userName,
    required String phone,
  }) async {
    log(email, name: 'email');
    log(password, name: 'password');
    log(phone, name: 'phone');
    log(userName, name: 'name');
    UserCredential credential = await _fireBaseAuth
        .createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
    final String uid = credential.user!.uid;

    await _db.collection("users").doc(uid).set({
      'uid': uid,
      'email': email.trim(),
      'userName': userName,
      'phone': phone,
    });
    final doc = await _db.collection("users").doc(uid).get();
    if (doc.exists) {
      log('user data Collected');
      final data = doc.data()!;
      log('userdata:$data');
      userModel = UserModel.fromJson(data: data);
    }
    return null;
  }

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    log(email, name: 'email');
    log(password, name: 'password');
    final result = await _fireBaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    log('UID:${result.user?.uid}');
    final doc = await _db.collection("users").doc(result.user?.uid).get();
    if (doc.exists) {
      final data = doc.data()!;

      log('data:$data');
      userModel = UserModel.fromJson(data: data);
      log('User Model: $userModel');

      return userModel;
    }
    return null;
  }

  Stream<List<Map<String, dynamic>>> usersStream() {
    return _db
        .collection('users')
        .snapshots()
        .map(
          (qSnap) => qSnap.docs.map((d) => {...d.data(), 'id': d.id}).toList(),
        );
  }
}
