// ignore_for_file: avoid_print

// import 'package:flutter/';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:todo/bloc/cuit/theme_cubit.dart';
import 'package:todo/bloc/login/auth_bloc.dart';
import 'package:todo/login/pages/register.dart';
import 'package:todo/todo/pages/home_page.dart';

class LoginPage extends StatelessWidget {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController passCon = TextEditingController();
  LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoaded) {
          Future.delayed(Durations.extralong1, () => 
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage(),
          ))
          ,);
        } 
        if (state is AuthErorr) {
          print('autherror');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Durations.extralong3,
              backgroundColor: Colors.red,
              content: Text(state.e)));
        }
      },
      child: BlocBuilder<ThemeState, bool>(
        builder: (context, state) => Scaffold(
          backgroundColor: state ? Colors.grey.shade400 : Colors.grey.shade200,
          body: Center(
            child: Card(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              child: Container(
                height: 380,
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'TodoAPP',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 23,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 23,
                                fontWeight: FontWeight.w500),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextfieldlogin(
                      controller: email,
                      hint: 'Email',
                      obscure: false,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MyTextfieldlogin(
                      controller: pass,
                      hint: 'Passwords',
                      obscure: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Need an account? ',
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onTertiary),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RegisterPage(),
                                ));
                                print('im working here');
                              },
                              child: Text(
                                'Sign Up       ',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w700),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if(state is AuthLoading){
                          return ElevatedButton(onPressed: (){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Durations.extralong3,
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                content: Text('Loading Please Wait', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),)));
                          },style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                            ), 
                          
                          child:Container(
                                height: 10,
                                width: 45,
                                child: const CircularProgressIndicator(),)
                          
                          ); 
                        }
                        if(state is AuthLoaded){
                          return ElevatedButton(onPressed: (){},
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                            ), 
                          child: Container(
                                height: 40,
                                width: 45,
                            child: Center(
                              child: LottieBuilder.asset(
                                      'assets/lottie/darkmode.json'),
                            ),
                          ),
                          );
                        }
                        return ElevatedButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(Login(
                                  email: email.text, password: pass.text));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                            ),
                            
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child:
                          
                              
                              Text(
                                'Login',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              
                            ));

                      },
                    ),
                    // ElevatedButton(onPressed: (){
                    //   print(FirebaseAuth.instance.currentUser);
                    // }, child: Icon(Icons.percent))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyTextfieldlogin extends StatelessWidget {
  String hint;
  TextEditingController controller;
  bool obscure = false;
  MyTextfieldlogin(
      {required this.obscure,
      super.key,
      required this.controller,
      required this.hint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        cursorColor: Theme.of(context).colorScheme.onPrimary,
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.onInverseSurface),
                borderRadius: BorderRadius.circular(15)),
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.inverseSurface),
                borderRadius: BorderRadius.circular(15))),
      ),
    );
  }
}
