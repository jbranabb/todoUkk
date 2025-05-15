import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/bloc/daytim_bloc.dart';
import 'package:todo/bloc/cuit/date_cubit.dart';
import 'package:todo/bloc/cuit/theme_cubit.dart';
import 'package:todo/bloc/login/auth_bloc.dart';
import 'package:todo/bloc/todo/todo_bloc.dart';
import 'package:todo/bloc/todo/todo_cubit.dart';
import 'package:todo/firebase_options.dart';
import 'package:todo/login/pages/login.dart';
import 'package:todo/myobserver.dart';
import 'package:todo/theme.dart';
import 'package:todo/todo/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = Myobserver();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => TodoBloc(),),
      BlocProvider(create: (context) => TodoCubit(),),
      BlocProvider(create: (context) => AuthBloc(),),
      BlocProvider(create: (context) => DaytimBloc(),),
      BlocProvider(create: (context) => ThemeCubit(),),
      BlocProvider(create: (context) => DateCubit(),),
    ],
    child: const MyApp()));
}
FirebaseAuth auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
         return BlocBuilder<ThemeCubit, bool> (
          builder: (context, state) => 
            MaterialApp(
              debugShowCheckedModeBanner: false,
              theme:  state ? dark : light,
             home: auth.currentUser != null ? HomePage() : LoginPage()
                   ),
         );
        } 
  }
