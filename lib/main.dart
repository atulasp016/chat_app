import 'package:chat_app/pages/signin/cubit/signin_cubit.dart';
import 'package:chat_app/pages/signup/cubit/signup_cubit.dart';
import 'package:chat_app/pages/splash.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/remote/firebase_repo.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(RepositoryProvider(
    create: (context) => FirebaseRepo(),
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => SignupCubit(
                firebaseRepo: RepositoryProvider.of<FirebaseRepo>(context))),
        BlocProvider(
            create: (context) => SigninCubit(
                firebaseRepo: RepositoryProvider.of<FirebaseRepo>(context)))
      ],
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chatbox App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
