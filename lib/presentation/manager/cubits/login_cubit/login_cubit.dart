
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../../../data/repository/task_repository.dart';
part 'login_state.dart'; // your state file

class LoginCubit extends Cubit<LoginState> {
  final TaskRepository repository;

  LoginCubit(this.repository) : super(LoginInitial());

  // Google login
  Future<void> loginWithGoogle() async {
    emit(LoginLoading());

    final Either<Failure, UserCredential> result = await repository.signInWithGoogle();

    result.fold(
          (failure) => emit(LoginFailure(failure.errMessage)),
          (userCredential) => emit(LoginSuccess(userCredential)),
    );
  }


// Facebook login
  Future<void> loginWithFacebook() async {
    emit(LoginLoading());
    final result = await repository.signInWithFacebook();
    result.fold(
          (failure) => emit(LoginFailure(failure.errMessage)),
          (userData) => emit(LoginSuccess(userData)),
    );
  }
}
