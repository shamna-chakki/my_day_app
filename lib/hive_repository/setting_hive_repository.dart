import 'package:hive_ce/hive.dart';

import '../models/setting_model/setting_model.dart';

class SettingHiveRepository {
  static const String _settingBoxName = 'settingBox'; // Name of your Hive box
  static const String _userBoxName = 'userBox'; // Name of your Hive box
  static const String _boxKeyName = 'settings';

  Future<Box<SettingModel>> _openSettingBox() async {
    return await Hive.openBox<SettingModel>(_settingBoxName);
  }

  Future<void> _saveSetting(SettingModel settingModel) async {
    final box = await _openSettingBox();
    await box.put(_boxKeyName, settingModel);
  }

  Future<SettingModel?> getSetting() async {
    final box = await _openSettingBox();
    final SettingModel? settings = box.get(_boxKeyName);
    return settings ?? SettingModel();
  }

  Future<void> saveToken({required String token}) async {
    final SettingModel? setting = await getSetting();
    final updatedSettings = setting?.copyWith(token: token);
    await _saveSetting(updatedSettings!);
  }

  Future<void> checkHiveBox() async {
    if (_userBoxName.isEmpty) {
      _saveSetting(
        SettingModel(signInScreen: true, homeScreen: false, loginScreen: false),
      );
    } else {
      _saveSetting(
        SettingModel(signInScreen: false, homeScreen: true, loginScreen: false),
      );
    }
  }

  Future<void> reset() async {
    _saveSetting(SettingModel(signInScreen: false, homeScreen: false, loginScreen: true));
  }


}
