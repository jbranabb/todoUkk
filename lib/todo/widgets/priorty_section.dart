import 'package:flutter/material.dart';

class ContainerPriorty extends StatelessWidget {
  String label;
  String time;
  bool status;
  ContainerPriorty({
    super.key,
    required this.label,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          time,
          style: TextStyle(
              color: status != false
                  ? Theme.of(context).colorScheme.onSecondary
                  : Theme.of(context).colorScheme.onPrimary,
              fontSize: 12,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          height: 20,
          width: 40,
          decoration: BoxDecoration(
              border: Border.all(
                  color: status != false
                      ? Colors.transparent
                      : Theme.of(context).colorScheme.onSurface),
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                  color: status != false
                      ? Theme.of(context).colorScheme.onSecondary
                      : Theme.of(context).colorScheme.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
Widget buildPriorityWidget(String priority, String date, bool status) {
  switch (priority.toLowerCase()) {
    case 'c':
      return ContainerPriorty(status: status, time: date, label: 'Low');
    case 'b':
      return ContainerPriorty(status: status, time: date, label: 'Mid');
    case 'a':
      return ContainerPriorty(status: status, time: date, label: 'High');
    default:
      return ContainerPriorty(status: status, time: '', label: '');
  }
}
class MyText extends StatelessWidget {
  String text;
  MyText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
    );
  }
}

String fromPrty(String text){
 switch(text){
    case == 'a':
    return text = 'High';
    case  == 'b':
    return text = 'Mid';  
    case  == 'c':
    return text = 'Low';
    default:
    return text = 'Select The Priorty';  
  }
}
String toPrty(String text){
 switch(text.toLowerCase()){
    case == 'high':
    return text = 'a';
    case  == 'mid':
   return text = 'b';  
    case  == 'low':
   return text = 'c';
    default:
    return text = 'Select The Priorty';  
  }
}
