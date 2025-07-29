import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:todo/bloc/todo/todo_bloc.dart';
import 'package:todo/todo/widgets/priorty_section.dart';

class FilterPage extends StatelessWidget {
  FilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    Query db = FirebaseDatabase.instance.ref().child('todos/$uid/$date');
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SizedBox(
        height: double.infinity,
        child: StreamBuilder(
          stream: db.onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
              final data = Map<String, dynamic>.from(
                  snapshot.data!.snapshot.value as Map);
              final list = data.entries.where((element) => element.value['isCompleted'] == true,).toList();
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final tod = Map<String, dynamic>.from(list[index].value);
                  final key = list[index].key;
                  tod['key'] = key;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Card(
                      child: ListTile(
                        title: Text(tod['title']),
                        subtitle: Text(tod['desc']),
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildPriorityWidget(tod['priorty'], tod['datetime'], tod['isCompleted']),
                            Text(tod['datetime']),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: Text('no data'),
            );
          },
        ),
      ),
    );
  }
}
