// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:todo/bloc/cuit/theme_cubit.dart';
import 'package:todo/bloc/login/auth_bloc.dart';
import 'package:todo/login/pages/login.dart';
import 'package:todo/todo/pages/home_page.dart';

class RegisterPage extends StatelessWidget {
  TextEditingController email = TextEditingController();
  TextEditingController displayname = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController passCon = TextEditingController();
  RegisterPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeState, bool>(
      builder: (context, state) =>
       Scaffold(
         backgroundColor: state ? Colors.grey.shade400 : Colors.grey.shade200, 
          body: Center(
            child: Card(
              // shadowColor: Colors.blue,
              
              color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
              child: SizedBox(
                height: 540,
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
                        fontSize: 23, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Register',
                            style: TextStyle(
                              
                        color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 23, fontWeight: FontWeight.w500),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextfieldlogin(
                      controller: displayname,
                      hint: 'Username',
                      obscure: false,
                    ),
                    const SizedBox(
                      height: 15,
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
                      height: 15,
                    ),
                    MyTextfieldlogin(
                      controller: passCon,
                      hint: 'Confirm Passwords',
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
                          const Text(
                            'Already have a Account?  ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                print('im working here');
                              },
                              child: Text(
                                'Sign In       ',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w700),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                
                                      
                      BlocBuilder<AuthBloc, AuthState  >(
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
                              child:Container(
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
                           context.read<AuthBloc>().add(Register(
                               displayname: displayname.text,
                               email: email.text,
                               password: pass.text,
                               confirPassword: passCon.text));
                         },
                         style: ElevatedButton.styleFrom(
                               backgroundColor:
                                   Theme.of(context).colorScheme.onPrimary,
                             ),
                         child: Text(
                           'Register',
                           style: TextStyle(
                               color: Theme.of(context).colorScheme.primary,
                               fontWeight: FontWeight.bold,
                               fontSize: 18),
                         ));
                        },
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
