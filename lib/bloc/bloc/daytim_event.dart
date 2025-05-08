part of 'daytim_bloc.dart';

abstract class DaytimEvent extends Equatable {
  const DaytimEvent();

  @override
  List<Object> get props => [];
}

class ChangeDay extends DaytimEvent{}