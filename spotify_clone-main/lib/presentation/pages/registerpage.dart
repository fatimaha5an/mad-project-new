import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/common/widgets/button/my_button.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/data/models/auth/create_user_req.dart';
import 'package:spotify/domain/usecases/auth/signup.dart';
import 'package:spotify/presentation/pages/loginPage.dart';
import 'package:spotify/presentation/pages/home/pages/home.dart';
import 'package:spotify/service_locater.dart';

class Registerpage extends StatelessWidget {
  Registerpage({super.key});
  final TextEditingController _fullnametxtcontroller = TextEditingController();
  final TextEditingController _passwordtxtcontroller = TextEditingController();
  final TextEditingController _emailtxtcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
          width: 40,
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _registerText(),
                    const SizedBox(
                      height: 25,
                    ),
                    _fullName(context),
                    const SizedBox(
                      height: 25,
                    ),
                    _email(context),
                    const SizedBox(
                      height: 25,
                    ),
                    _password(context),
                    const SizedBox(
                      height: 25,
                    ),
                    MyButton(
                        onpressed: () async {
                          var result = await sl<SignupUseCase>().call(
                            params: CreateUserReq(
                              email: _emailtxtcontroller.text.toString(),
                              fullname: _fullnametxtcontroller.text.toString(),
                              password: _passwordtxtcontroller.text.toString(),
                            ),
                          );
                          result.fold(
                              //L is signup failed
                              (l) {
                            final errorMsg = (l == null || l.toString().trim().isEmpty)
                                ? 'An unknown error occurred. Please try again.'
                                : l.toString();
                            var snackbar = SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.error, color: Colors.red),
                                  SizedBox(width: 8),
                                  Expanded(child: Text(errorMsg)),
                                ],
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.white,
                              duration: Duration(seconds: 4),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          },
                              //R is signupp successfull
                              (r) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RootPage()),
                                (route) => false);
                          });
                        },
                        txt_title: 'C R E A T E    A C C O U N T'),
                  ],
                ),
                _signinText(context),
              ],
            ),
          )),
    );
  }

  Widget _registerText() {
    return const Text(
      'REGISTER',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _fullName(BuildContext context) {
    return TextField(
      controller: _fullnametxtcontroller,
      decoration: const InputDecoration(hintText: 'Full Name')
          .applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _email(BuildContext context) {
    return TextField(
      controller: _emailtxtcontroller,
      decoration: const InputDecoration(hintText: 'Enter Email')
          .applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _password(BuildContext context) {
    return TextField(
      controller: _passwordtxtcontroller,
      decoration: const InputDecoration(hintText: 'Enter Password')
          .applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _signinText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Loginpage()));
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Already Have an Account?'),
          SizedBox(
            width: 5,
          ),
          Text(
            'Login',
            style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 15),
          )
        ],
      ),
    );
  }
}
