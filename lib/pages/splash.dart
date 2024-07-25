import 'dart:async';
import 'package:chat_app/pages/signin/signin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../data/remote/firebase_repo.dart';
import '../utils/app_colors.dart';
import '../widgets/ui_helper.dart';
import 'home.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () async {
      ///check session
      var prefs = await SharedPreferences.getInstance();
      String? value = prefs.getString(FirebaseRepo.PREF_USER_ID_KEY);
      Widget nextPage =  SignInPage();

      if (value != null && value != '') {
        nextPage = const HomePage();
      }

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => nextPage));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                appLogo(),
                const SizedBox(height: 4),
                appName(
                    textStyle: GoogleFonts.aclonica(
                        color: AppColors.secondaryBlack, fontSize: 40)),
              ],
            ),
          ),
        ));
  }
}
