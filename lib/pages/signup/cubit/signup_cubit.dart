import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/models/user_model.dart';
import '../../../data/remote/firebase_repo.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  FirebaseRepo firebaseRepo;
  SignupCubit({required this.firebaseRepo}) : super(SignupInitialState());

  void signUpUser({required UserModel user, required String pass}) async {
    emit(SignupLoadingState());
    try {
      await firebaseRepo.createUser(user: user, pass: pass);
      emit(SignupSuccessState());
    } catch (e) {
      emit(SignupFailedState(errorMsg: e.toString()));
    }
  }
}
