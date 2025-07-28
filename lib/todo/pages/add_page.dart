import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/todo/todo_bloc.dart';
import 'package:todo/model/model.dart';

class AddPage extends StatelessWidget {
  AddPage({super.key});

  List<String> priorty = [
    'High',
    'Mid',
    'Low',
  ];
  @override
  Widget build(BuildContext context) {
    TextEditingController controllerTitle = TextEditingController();
    TextEditingController controllerDesc = TextEditingController();
    TextEditingController controllerRty = TextEditingController();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Adding Something?',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyTextField(
            controller: controllerTitle,
            input: 'Title',
            desc: 'buy donats?..',
            maxlines: 2,
          ),
          MyTextField(
            controller: controllerDesc,
            input: 'Description',
            desc: 'dont forget the chips!!!',
            maxlines: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              width: 200,
              child: DropdownButtonFormField(
                menuMaxHeight: 200,
                dropdownColor: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(20),
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline))),
                hint: const Text('Set The Priorty'),
                isExpanded: true,
                value: isSelected,
                items: priorty
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  controllerRty.text = value.toString();
                },
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
              child: BlocListener<TodoBloc, TodoState>(
            listener: (context, state) {
              if (state is TodoErorr) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Something Went Wrong'),
                    content: Text('${state.e}'),
                  ),
                );
              } else if (state is Todoloaded) {
                controllerTitle.clear();
                controllerDesc.clear();
                controllerRty.clear();
                Navigator.of(context).pop();
              }
            },
            child: ElevatedButton(
                onPressed: () {
                  if (controllerRty.text.isNotEmpty ||
                      controllerDesc.text.isNotEmpty ||
                      controllerTitle.text.isNotEmpty) {
                    context.read<TodoBloc>().add(PostTodo(
                        title: controllerTitle.text,
                        desc: controllerDesc.text,
                        rty: controllerRty.text));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        duration: Durations.long3,
                        content: Text('Please fill all Empty Fields')));
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Done',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                )),
          ))
        ],
      ),
    );
  }
}

String? isSelected;

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.controller,
    required this.input,
    required this.maxlines,
    required this.desc,
  });

  final TextEditingController controller;
  final String input;
  final String desc;
  final int maxlines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Container(
        child: TextField(
            controller: controller,
            minLines: 1,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            maxLines: maxlines,
            decoration: InputDecoration(
              labelText: input,
              hintText: desc,
              enabled: true,
              labelStyle: TextStyle(color: Colors.grey.shade500),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).colorScheme.secondary)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      width: 2, color: Theme.of(context).colorScheme.outline)),
            )),
      ),
    );
  }
}
