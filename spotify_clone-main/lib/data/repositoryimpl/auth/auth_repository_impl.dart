import 'package:dartz/dartz.dart';
import 'package:spotify/data/models/auth/create_user_req.dart';
import 'package:spotify/data/models/auth/signin_user_req.dart';
import 'package:spotify/data/sources/auth/auth_firebase_service.dart';
import 'package:spotify/domain/repository/auth/auth.dart';
import 'package:spotify/service_locater.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signin(SigninUserReq signinuserReq) async {
    return await sl<AuthFirebaseService>().signin(signinuserReq);
  }

  @override
  Future<Either> signup(CreateUserReq createuserReq) async {
    return await sl<AuthFirebaseService>().signup(createuserReq);
  }
  
  @override
  Future<Either> getUser() async{
    return await sl<AuthFirebaseService>().getUser();
  }
}
