part of 'todo_bloc.dart';

@immutable
abstract class TodoState extends Equatable{
    const TodoState();
  
  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {}
class TodoLoading extends TodoState{}
class Todoloaded extends TodoState{}
class TodoErorr extends TodoState{
  String e;
  TodoErorr(this.e);
}
class FilterState extends TodoState{
  final String? fileterPriorty;
  final bool? iscompledfilter;
  FilterState({this.fileterPriorty, this.iscompledfilter});
  
  @override
  List<Object?> get props => [fileterPriorty, iscompledfilter];
}

class DayTim extends TodoState{
  String e;
  DayTim({required this.e});
}