

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'daytim_event.dart';
part 'daytim_state.dart';

class DaytimBloc extends Bloc<DaytimEvent, DaytimState> {
  DaytimBloc() : super(DaytimInitial()){
    on<ChangeDay>((event, emit) {
      DateTime now = DateTime.now();
      var hour = now.hour;
      if (hour >= 05 && hour <= 11) {
        emit(StateChanegeDay("Morning"));
      } else if (hour >= 12 && hour <= 15) {
        emit(StateChanegeDay("Afternoon"));
      } else if (hour >= 16 && hour <= 18) {
        emit(StateChanegeDay("Evening"));
      } else {
        emit(StateChanegeDay("Night"));
      }
    });
  }
  
}
