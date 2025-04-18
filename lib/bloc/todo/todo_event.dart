part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent {}
class PostTodo  extends TodoEvent{
  String title;
  String desc;
  String rty;
  PostTodo({required this.title, required this.desc, required this.rty});
}
class  UpdateTodo extends TodoEvent{
  String title;
  String desc;
  String rty;
  String key;
  UpdateTodo({required this.title, required this.desc, required this.key,required this.rty});
}
class DeleteTodo extends TodoEvent{
  String key;
  DeleteTodo(this.key);
}
