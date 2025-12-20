import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:my_day_app/services/user_service.dart';

import '../hive_repository/setting_hive_repository.dart';
import '../hive_repository/user_hive_repository.dart';
import '../models/user_model/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  final UserService _userService = UserService();
  final UserHiveRepository _userHiveRepository = UserHiveRepository();
  final SettingHiveRepository _settingHiveRepository = SettingHiveRepository();

  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;

  Future<bool> signUp({
    required String email,
    required String password,
    required String userName,
    required String phone,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      log('signUp function called', name: 'SignUp:');
      await Future.delayed(const Duration(milliseconds: 500));
      _userModel = await _userService.addUser(
        email: email,
        password: password,
        userName: userName,
        phone: phone,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      log(e.message ?? 'Firebase Error', name: 'FirebaseAuthException');
      _error = e.message;
      notifyListeners();
      return false;
    } catch (e, s) {
      log(
        'Auth provider error',
        name: 'FirebaseAuthException',
        error: e,
        stackTrace: s,
      );
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      _isLoading = true;
      notifyListeners();
      log('Called Login');
      await Future.delayed(const Duration(milliseconds: 500));

      final result = await _userService.login(email: email, password: password);

      //---- Need to remove after coder completion...
      _userHiveRepository.checkHive();

      //---------------

      if (result != null) {
        await _userHiveRepository.saveUser(result);
        await _settingHiveRepository.saveToken(token: result.uid);
        await _settingHiveRepository.checkHiveBox();
      } else {
        log('User Not Found...!!');
        return false;
      }

      return true;
    } on FirebaseAuthException catch (e) {
      log(e.message ?? 'Firebase Error', name: 'FirebaseAuthException');
      _error = e.message;
      notifyListeners();
      return false;
    } catch (e, s) {
      log(
        'Auth provider error',
        name: 'FirebaseAuthException',
        error: e,
        stackTrace: s,
      );

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updatePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      log('Function called');
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: oldPassword,
      );

      await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(
        credential,
      );

      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);

      log('Password updated successfully ✅', name: 'UpdatePassword');

      return true;
    } on FirebaseAuthException catch (e) {
      log(e.message ?? 'Firebase Error', name: 'FirebaseAuthException');
      _error = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();
      log('Called SignOut');
      await Future.delayed(const Duration(milliseconds: 500));
      await _fireBaseAuth.signOut();
      await _userHiveRepository.resetUser();
      await _settingHiveRepository.reset();
      return true;
    } on FirebaseAuthException catch (e) {
      log(e.message ?? 'Firebase Error', name: 'FirebaseAuthException');

      return false;
    } catch (e, s) {
      log(
        'Auth provider error',
        name: 'FirebaseAuthException',
        error: e,
        stackTrace: s,
      );
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
Future<bool> checkUserExists({required String email}) async {
  try {
    final querySnapshot = await _db
        .collection('users')
        .where('email', isEqualTo: email.trim())
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return true;
    }
    else{
      return false;
    }

  } on FirebaseAuthException catch (e) {
    throw _getErrorMessage(e);
  }
}
  Future<bool> sendEmail(String email) async {
    try {
      final result = await _fireBaseAuth.sendPasswordResetEmail(
        email: email.trim(),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e);

    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'invalid-email':
        return 'Invalid email address';
      default:
        return 'Something went wrong. Try again';
    }
  }
}
