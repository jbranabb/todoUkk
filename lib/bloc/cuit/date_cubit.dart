import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:todo/bloc/todo/todo_bloc.dart';

class DateCubit extends Cubit<List<String>> {
  DateCubit() : super([]) {}

  final DatabaseReference dbref = FirebaseDatabase.instance.ref();

  Future<void> getDate() async {
    try {
      await dbref.child('todos/$uid').onValue.listen(
        (event) {
          if (event.snapshot.exists) {
            final dates = (event.snapshot.value as Map<dynamic, dynamic>)
                .keys
                .cast<String>()
                .toList()
              ..sort((a, b) => a.compareTo(b)
                 );
            emit(dates);
          } else {
            emit([]);
          }
        },
      );
    } catch (e) {
      print('Failed to load data $e');
      emit([]);
    }
  }
}
