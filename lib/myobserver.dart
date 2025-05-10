import 'package:bloc/bloc.dart';

class Myobserver extends BlocObserver{
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(bloc);
    print(transition);
  }
}