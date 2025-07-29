import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:todo/bloc/todo/todo_bloc.dart';
import 'package:todo/main.dart';

class ThemeToggle extends Cubit<bool>{
  ThemeToggle(): super(false);

}

class ThemeState extends Cubit<bool>{
  ThemeState() : super(false);
void saveData() async{
  emit(!state);
  print('state :$state');
 await pref?.setBool('theme', state) ?? true;
 var themeState = pref?.getBool('theme');
  print('themestate :$themeState');
 emit(themeState!);
}
}

