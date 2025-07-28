import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:todo/bloc/todo/todo_bloc.dart';

class TodoCubit extends Cubit<bool>{
  TodoCubit() : super(true);
  late DatabaseReference dbref;
  FirebaseAuth auth = FirebaseAuth.instance;
  void changetod(String key)async{
    emit(!state);
  var uid = auth.currentUser?.uid;
  dbref = FirebaseDatabase.instance.ref().child('todos/$uid/$date');
    Map<String, dynamic> value ={
      'isCompleted': state
    };
    await dbref.child(key).update(value);
    print('im also work here');
  }
}