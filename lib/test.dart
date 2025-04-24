import 'package:intl/intl.dart';

String date = DateFormat.yMMMd().format(DateTime.now());


void main(){
  print(date);
}