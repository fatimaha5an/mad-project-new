import 'package:spotify/domain/entities/authentication/user.dart';

class UserModel {
  String? fullname;
  String? email;
  String? imageUrl;
  UserModel({this.email, this.imageUrl, this.fullname});

  UserModel.fromJson(Map<String, dynamic> data) {
    fullname = data['name'];
    email = data['email'];
  }
}

extension UserModelX on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      email: email,
      fullname: fullname,
      imageUrl: imageUrl,
    );
  }
}
