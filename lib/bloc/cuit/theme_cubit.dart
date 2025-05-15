import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:todo/bloc/todo/todo_bloc.dart';

class ThemeCubit extends Cubit<bool>{
  ThemeCubit(): super(false);

  void changeTheme(){
    emit(!state);
  } 
}

