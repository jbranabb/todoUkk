import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class TodoCubit extends Cubit<bool>{
  TodoCubit() : super(true);
  late DatabaseReference dbref;
  FirebaseAuth auth = FirebaseAuth.instance;
  void changetod(String key)async{
  var uid = auth.currentUser?.uid;
  dbref = FirebaseDatabase.instance.ref().child('todos/$uid');
    Map<String, dynamic>value ={
      'isCompleted': state
    };
    await dbref.child(key).update(value);
    emit(!state);
  }
}