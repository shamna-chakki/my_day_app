import 'package:hive_ce/hive.dart';

part 'setting_model.g.dart';
@HiveType(typeId: 2)
class SettingModel extends HiveObject {
  @HiveField(0)
  final bool signInScreen;
  @HiveField(1)
  final bool loginScreen;
  @HiveField(3)
  final bool homeScreen;
  @HiveField(4)
  final String? token;

  SettingModel({
    this.signInScreen=true,
    this.loginScreen=false,
    this.homeScreen=false,
    this.token,
  });

  SettingModel copyWith({
    bool? signInScreen,
    bool? loginScreen,
    bool? homeScreen,
    String? token,
  }) {
    return SettingModel(
      signInScreen: signInScreen ?? this.signInScreen,
      loginScreen: loginScreen ?? this.loginScreen,
      homeScreen: homeScreen ?? this.homeScreen,
      token: token ?? this.token,
    );
  }

}
