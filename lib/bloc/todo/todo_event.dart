part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent extends Equatable{
  const TodoEvent();

  @override
  List<Object?> get props => [];
}
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

  @override
  List<Object> get props => [title, desc, rty, key];
}
class DeleteTodo extends TodoEvent{
  String key;
  DeleteTodo(this.key);
}
class Filter extends TodoEvent{
  final String? fileterPriorty;
  final bool? isCompleted;
  Filter({this.fileterPriorty, this.isCompleted});
  
  @override
  List<Object?> get props => [fileterPriorty, isCompleted];
}
class ListDate extends TodoEvent{
  
}
