// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'package:todo/bloc/todo/todo_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<Login>((event, emit) async {
      print('Login Ke triger');
      emit(AuthLoading());
      try {
        if(event.password.length <=6 ){
          emit(AuthErorr('Password Harus 6 Karakter'));
        }else{
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: event.email, password: event.password);
        print('masuk');
        emit(AuthLoaded());
        }
      } on FirebaseAuthException catch (e) {
        print('Error Code : ${e.code}');
        if (e.code == 'user-not-found') {
          print('user not found');
          emit(AuthErorr('Akun tidak ditemukan.'));
        } else if (e.code == 'wrong-password') {
          print('passwword salah');
          emit(AuthErorr('Password salah.'));
        } else if (e.code == 'invalid-email') {
          print('invalid email');
          emit(AuthErorr('Format email salah.'));
        } else if (e.code == 'too-many-requests') {
          print('too many request');
          emit(AuthErorr('Terlalu banyak percobaan. Coba beberapa saat lagi.'));
        }else if(e.code == 'invalid-credential'){
          print('credential invalid');
          emit(AuthErorr('Passwords Salah'));
        } 
        else {
          emit(AuthErorr('Something Went Wrong: ${e.message ?? "Unknown"}'));
        }
      }
    });
    on<Register>((event, emit) async {
      try {
        emit(AuthLoading());
        if(event.email.isNotEmpty || event.password.isNotEmpty || event.confirPassword.isNotEmpty){
          if(event.password == event.confirPassword){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: event.email, password: event.password); 
        emit(AuthLoaded());
          }else{
          emit(AuthErorr('Passwords Tidak Sama'));
          }
        }else{
          emit(AuthErorr('Mohon Isi Semua Field Yang Kosong'));
        }
      } on FirebaseAuthException catch (e) {
        print('Erorr code :${e.code}');
        if (e.code == 'email-already-in-use') {
          print('👉 masuk ke email-already-in-use');
          emit(AuthErorr('Email sudah terdaftar.'));
        } else if (e.code == 'invalid-email') {
          emit(AuthErorr('Email tidak valid.'));
        } else if (e.code == 'weak-password') {
          emit(AuthErorr('Password terlalu lemah, Setidak nya 6 karakter'));
        } else {
          print('else error : ${e.message}');
          emit(AuthErorr('Terjadi error: ${e.message}'));
        }
      }
    });
  }
}
