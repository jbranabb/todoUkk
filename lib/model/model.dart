import 'package:intl/intl.dart';

class Todo{
  String title;
  String desc;
  String rty;
  bool? isCompleted;
  
  Todo({required this.title, required this.desc, required this.rty, this.isCompleted });

  //json ke aplikasi
  factory Todo.fromJson(Map<String, dynamic> json){
    return Todo(title: json['title'], desc: json['desc'], rty: json['rty']);
  }

  // aplikasi ke json
 Map<String,dynamic> toJson(){
  return {
    'title': title,
    'desc': desc,
    'priorty': rty,
    'isCompleted': false,
    'datetime': DateFormat('HH:mm').format(DateTime.now()).toString()
  };
}
}