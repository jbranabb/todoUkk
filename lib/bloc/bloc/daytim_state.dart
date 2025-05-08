part of 'daytim_bloc.dart';

abstract class DaytimState extends Equatable {
  const DaytimState();
  
  @override
  List<Object> get props => [];
}

class DaytimInitial extends DaytimState {}
class StateChanegeDay extends DaytimState {
  String e;
  StateChanegeDay(this.e);
  @override
  List<Object> get props => [e]; 
}
