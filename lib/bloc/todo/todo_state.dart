part of 'todo_bloc.dart';

@immutable
abstract class TodoState {}

class TodoInitial extends TodoState {}
class TodoLoading extends TodoState{}
class Todoloaded extends TodoState{}
class TodoErorr extends TodoState{
  String e;
  TodoErorr(this.e);
}