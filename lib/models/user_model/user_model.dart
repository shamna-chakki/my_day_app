import 'dart:developer';
import 'package:hive_ce/hive.dart';

part 'user_model.g.dart';
@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String userName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String phone;



  UserModel({
    required this.uid,
    required this.userName,
    required this.email,
    required this.phone,

  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'userName': userName,
      'phone': phone,
    };
  }

  factory UserModel.fromJson({ required Map<String, dynamic> data}) {

    log('datayyyyy:$data');
    return UserModel(
      email: data['email'] ?? '' ,
      userName: data['userName'] ?? '',
      uid: data['uid']?? '',
      phone:data['phone'] ?? '',
    );
  }
}
