import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/common/widgets/button/my_button.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/data/models/auth/signin_user_req.dart';
import 'package:spotify/domain/usecases/auth/signin.dart';
import 'package:spotify/presentation/pages/registerpage.dart';
import 'package:spotify/presentation/pages/home/pages/home.dart';
import 'package:spotify/service_locater.dart';

class Loginpage extends StatelessWidget {
  Loginpage({super.key});

  final TextEditingController _emailtxt = TextEditingController();
  final TextEditingController _passtxt = TextEditingController();

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
                    _loginText(),
                    const SizedBox(
                      height: 25,
                    ),
                    _email(context),
                    const SizedBox(
                      height: 25,
                    ),
                    _password(context),
                    _forgotpass(context),
                    const SizedBox(
                      height: 25,
                    ),
                    MyButton(
                        onpressed: () async {
                          var result = await sl<SigninUseCase>().call(
                            params: SigninUserReq(
                              email: _emailtxt.text.toString(),
                              password: _passtxt.text.toString(),
                            ),
                          );
                          result.fold(
                              //L is signin failed
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
                        txt_title: ' S I G N   I N  '),
                  ],
                ),
                _signinText(context),
              ],
            ),
          )),
    );
  }

  Widget _loginText() {
    return const Text(
      'LOGIN',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _email(BuildContext context) {
    return TextField(
      controller: _emailtxt,
      decoration: const InputDecoration(hintText: 'Enter Email')
          .applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _password(BuildContext context) {
    return TextField(
      controller: _passtxt,
      decoration: const InputDecoration(hintText: 'Enter Password')
          .applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _forgotpass(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child:
          GestureDetector(onTap: () {}, child: const Text('Forgot Password?')),
    );
  }

  Widget _signinText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Registerpage()));
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Dont\'t have an Account?'),
          SizedBox(
            width: 5,
          ),
          Text(
            'Register Now',
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
