import 'dart:developer';

import 'package:hive_ce/hive.dart';

import '../models/user_model/user_model.dart';

class UserHiveRepository {
  static const String _userBoxName = 'userBox'; // Name of your Hive box
  static const String _boxKeyName = 'user';

  Future<Box<UserModel>> _openUserBox() async {
    return await Hive.openBox<UserModel>(_userBoxName);
  }

  Future<void> saveUser(UserModel userModel) async {
    final box = await _openUserBox();
    await box.put(_boxKeyName, userModel);
    box.close();
  }

  Future<UserModel?> getUser() async {
    final box = await _openUserBox();
    final UserModel? userModel = box.get(_boxKeyName);
    box.close();
    return userModel;
  }

  Future<void> resetUser() async {
    final box = await _openUserBox();

    box.clear();
    box.close();
  }

  Future<void> checkHive() async {
    if (Hive.isBoxOpen('userBox')) {
      Box box = Hive.box('userBox');
      await box.close();
    }
    if(Hive.isBoxOpen('settings')){
      Box box = Hive.box('settings');
      await box.close();
    }
  }

  // Alternatively, to close all open boxes before your application exits:
  Future<void> disposeHive() async {
    Hive.close();
    log('All Hive boxes closed.');
  }
}
