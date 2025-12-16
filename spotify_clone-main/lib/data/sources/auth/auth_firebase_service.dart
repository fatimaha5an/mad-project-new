import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/data/models/auth/create_user_req.dart';
import 'package:spotify/data/models/auth/signin_user_req.dart';
import 'package:spotify/data/models/auth/user.dart';
import 'package:spotify/domain/entities/authentication/user.dart';

abstract class AuthFirebaseService {
  Future<Either> signin(SigninUserReq signinuserReq);
  Future<Either> signup(CreateUserReq createuserReq);
  Future<Either> getUser();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either> signin(SigninUserReq signinuserReq) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: signinuserReq.email, password: signinuserReq.password);
      return const Right('Login was Succesfull');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid_email') {
        message =
            'The Email you Provided Doesn\'t Exist. Please Try Signing Up';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong Password Entered. Please Try Again!';
      } else {
        message = 'FirebaseAuth Error:\nCode: ${e.code}\nMessage: ${e.message ?? 'No details'}';
      }
      print('SignIn Error: Code: ${e.code}\nMessage: ${e.message ?? 'No details'}');
      return Left(message);
    } catch (e) {
      print('SignIn Unknown Error: ' + e.toString());
      return Left('Unknown error: ' + e.toString());
    }
  }

  @override
  Future<Either> signup(CreateUserReq createuserReq) async {
    try {
      var data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: createuserReq.email, password: createuserReq.password);

      FirebaseFirestore.instance.collection('Users').doc(data.user?.uid).set({
        'name': createuserReq.fullname,
        'email': data.user?.email,
      });

      return const Right('Sign Up was Succesfull');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message =
            'The Password Provided is too Weak. Please Try again with a Stronger Password';
      } else if (e.code == 'email-already-in-use') {
        message =
            'An account already Exists with this Email. Please Try Logging in';
      } else {
        message = 'FirebaseAuth Error:\nCode: ${e.code}\nMessage: ${e.message ?? 'No details'}';
      }
      print('SignUp Error: Code: ${e.code}\nMessage: ${e.message ?? 'No details'}');
      return Left(message);
    } catch (e) {
      print('SignUp Unknown Error: ' + e.toString());
      return Left('Unknown error: ' + e.toString());
    }
  }

  @override
  Future<Either> getUser() async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      var user = await firebaseFirestore
          .collection('Users')
          .doc(firebaseAuth.currentUser?.uid)
          .get();

      UserModel userModel = UserModel.fromJson(user.data()!);
      userModel.imageUrl =
          firebaseAuth.currentUser?.photoURL ?? AppUrls.defaultImage;
      UserEntity userEntity = userModel.toEntity();
      return Right(userEntity);
    } catch (e) {
      return const Left('An Error Occured');
    }
  }
}
