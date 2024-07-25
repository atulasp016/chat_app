import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_style.dart';
import '../../widgets/ui_helper.dart';
import '../home.dart';
import '../signup/signup.dart';
import 'cubit/signin_cubit.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  static const String LOGIN_PREFS_KEY = 'isLogin';
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 51),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      appLogo(height: 80,width: 80),
                      const SizedBox(height: 11),
                      Text(
                        'Log in to Chatbox',
                        textAlign: TextAlign.center,
                        style: mTextStyle30(
                            mFontWeight: FontWeight.bold,
                            mColor: AppColors.mainBlack),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Welcome back! Sign in using your social account or email to continue us',
                          textAlign: TextAlign.center,
                          style: mTextStyle16(mColor: AppColors.mainBlack),
                        ),
                      ),
                    ],
                  ),
                ),
                appDivider(),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      appTextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          hintText: 'Enter your email',
                          title: 'Your email',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          }),
                      appTextField(
                          controller: passController,
                          hintText: 'Enter your password',
                          title: 'Password',
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          }),
                      const SizedBox(height: 31),
                      BlocConsumer<SigninCubit, SigninState>(
                          builder: (_, state) {
                        if (state is SigninLoadingState) {
                          return ElevatedButton(
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.all(5),
                                      child: CircularProgressIndicator()),
                                  const SizedBox(width: 11),
                                  Text('Authentication user..',
                                      style: mTextStyle16()),
                                ],
                              ));
                        }

                        return outlinedBTN(
                            onTap: () async {
                              /// firebase login
                              if (_formKey.currentState!.validate()) {
                                String email = emailController.text;
                                String pass = passController.text;

                                BlocProvider.of<SigninCubit>(context)
                                    .authenticateUser(email: email, pass: pass);
                              }
                            },
                            title: 'Log in',
                            bgColor: AppColors.primaryColor,
                            textColor: AppColors.whiteColor);
                      }, listener: (_, state) {
                        if (state is SigninFailedState) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: AppColors.secondaryBlack,
                              content: Text(
                                state.errorMsg.toString(),
                                style: mTextStyle18(
                                    mFontWeight: FontWeight.w500,
                                    mColor: AppColors.whiteColor),
                              )));
                        } else if (state is SigninSuccessState) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: AppColors.secondaryBlack,
                              content: Text(
                                'User login successfully..',
                                style: mTextStyle18(
                                    mFontWeight: FontWeight.w500,
                                    mColor: AppColors.whiteColor),
                              )));
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        }
                      }),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 21),
                        child: textBTN(
                            onTap: () {},
                            title: 'Forgot password?',
                            textColor: AppColors.primaryColor),
                      ),
                      outlinedBTN(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()));
                          },
                          bgColor: AppColors.greyColor,
                          title: 'Sign up within mail',
                          textColor: AppColors.secondaryBlack),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
