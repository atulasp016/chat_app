import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/remote/firebase_repo.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  FirebaseRepo firebaseRepo;
  SigninCubit({required this.firebaseRepo}) : super(SigninInitialState());

  void authenticateUser({required String email, required String pass}) async{
    emit(SigninLoadingState());

try{
  await firebaseRepo.loginUser(email: email, pass: pass);
  emit(SigninSuccessState());
}catch(e){
  emit(SigninFailedState(errorMsg: e.toString()));

}

  }


}
