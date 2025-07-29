import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<bool>{
  SearchCubit() : super(false);
  void changeState(){
    emit(!state);
  }
}

class TextSearchCubit extends Cubit<String>{
  TextSearchCubit() : super('');
  void search(String text){ final lower = text.toLowerCase();
  if (state != lower) {
    emit(lower);
    print('state skng : $lower');
  }
  }
}