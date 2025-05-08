import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:todo/model/model.dart';

part 'todo_event.dart';
part 'todo_state.dart';
String date = DateFormat.yMMMd().format(DateTime.now());

late DatabaseReference dbref;
FirebaseAuth auth = FirebaseAuth.instance;
var uid =  auth.currentUser?.uid;
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    dbref = FirebaseDatabase.instance.ref().child('todos/$uid/$date');
    on<PostTodo>((event, emit) async {
      try {
        if (event.title.isNotEmpty && event.desc.isNotEmpty && event.rty.isNotEmpty) {
          var tod = Todo(title: event.title, desc: event.desc, rty: event.rty)
              .toJson();
          dbref.push().set(tod);
          emit(Todoloaded());
        } else {
          emit(TodoErorr('Harus Isi Semua field'));
        }
      } catch (e) {
        emit(TodoErorr(e.toString()));
      }
    });
    on<UpdateTodo>((event, emit) {
      try {
        var tod =
            Todo(title: event.title, desc: event.desc, rty: event.rty).toJson();
        dbref.child(event.key).update(tod);
      } catch (e) {
        emit(TodoErorr(e.toString()));
      }
    });
    on<DeleteTodo>((event, emit) {
     dbref.child(event.key).remove(); 
    });
    on<Filter>((event, emit) {
      emit(FilterState(
        fileterPriorty: event.fileterPriorty,
        iscompledfilter: event.isCompleted
      ));
    });
    on<DayTime>((event, emit){
      DateTime now = DateTime.now();
      var hour = now.hour;
      if(hour >= 05 && hour <= 11 ){
        emit(DayTim(e: "Morning"));
      }else if(hour >=12 && hour <= 15){
        emit(DayTim(e: "Afternoon"));
      }else if(hour >= 16 && hour <= 18 ){
        emit(DayTim(e: "Evening"));
      }else{
        emit(DayTim(e: "Night"));
      }
    });
  }
}
