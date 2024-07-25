import 'package:chat_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_model.dart';
import '../../utils/app_colors.dart';
import '../../widgets/ui_helper.dart';
import 'cubit/signup_cubit.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 21),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back))),
              ),
              appLogo(height: 80, width: 80),
              const SizedBox(height: 11),
              Column(
                children: [
                  Text(
                    'Sign up with Email',
                    textAlign: TextAlign.center,
                    style: mTextStyle30(
                        mFontWeight: FontWeight.bold,
                        mColor: AppColors.mainBlack),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Get chatting with friends and family today by signing up for our chat app!',
                      textAlign: TextAlign.center,
                      style: mTextStyle16(mColor: AppColors.mainBlack),
                    ),
                  ),
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    appTextField(
                        controller: nameController,
                        hintText: 'Enter your nane',
                        title: 'Your name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        }),
                    appTextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      hintText: 'Enter your email',
                      title: 'Your email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
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
                      },
                    ),
                    appTextField(
                      controller: confirmPassController,
                      hintText: 'Enter your password',
                      title: 'Confirm Password',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != passController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 51),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 21.0),
                        child: BlocConsumer<SignupCubit, SignupState>(
                            builder: (_, state) {
                          if (state is SignupLoadingState) {
                            return ElevatedButton(
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Padding(
                                        padding: EdgeInsets.all(5),
                                        child: CircularProgressIndicator()),
                                    const SizedBox(width: 11),
                                    Text('Creating User..',
                                        style: mTextStyle20()),
                                  ],
                                ));
                          }
                          return outlinedBTN(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  String email = emailController.text;
                                  String pass = passController.text;

                                  if (emailController.text.isNotEmpty &&
                                      passController.text.isNotEmpty ==
                                          confirmPassController
                                              .text.isNotEmpty) {
                                    var newUser = UserModel(
                                        name: nameController.text,
                                        email: email,
                                        mobNo: 'XXXXX-XXXXX',
                                        gender: 'Male',
                                        createdAt: DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString(),
                                        isOnline: false,
                                        status: 1,
                                        profilePic: '',
                                        profileStatus: 1);

                                    BlocProvider.of<SignupCubit>(context)
                                        .signUpUser(user: newUser, pass: pass);
                                  }
                                }
                              },
                              title: 'Sign Up',
                              bgColor: AppColors.primaryColor,
                              textColor: AppColors.whiteColor);
                        }, listener: (_, state) {
                          if (state is SignupFailedState) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: AppColors.secondaryBlack,
                                content: Text(
                                  state.errorMsg,
                                  style: mTextStyle18(
                                      mFontWeight: FontWeight.w500,
                                      mColor: AppColors.whiteColor),
                                )));
                          } else if (state is SignupSuccessState) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: AppColors.secondaryBlack,
                                content: Text(
                                  'User created account successfully..',
                                  style: mTextStyle18(
                                      mFontWeight: FontWeight.w500,
                                      mColor: AppColors.whiteColor),
                                )));
                            Navigator.pop(context);
                            /*Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInPage()));*/
                          }
                        })),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
