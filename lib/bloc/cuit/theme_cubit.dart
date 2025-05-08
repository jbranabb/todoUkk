import 'package:bloc/bloc.dart';

class ThemeCubit extends Cubit<bool>{
  ThemeCubit(): super(false);
  void changeTheme(){
    emit(!state);
    print(state);
  }
}