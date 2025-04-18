// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        if(state is AuthLoaded){
          print('authloaded');
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(),));
        }else if(state is AuthErorr ){
          print('autherror');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Durations.extralong3,
            backgroundColor: Colors.red,
            content: Text(state.e)));
        }

      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade400,
        body: Center(
          child: Card(
            shadowColor: Colors.blue,
            child: SizedBox(
              height: 380,
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'TodoAPP',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.w500),
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
                        const Text(
                          'Belum Punya Akun?  ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => RegisterPage(),
                              ));
                              print('im working here');
                            },
                            child: const Text(
                              'Sign Up       ',
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.w700),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        context
                            .read<AuthBloc>()
                            .add(Login(email: email.text, password: pass.text));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey),
                      child:const Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ))
                ],
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
      padding:const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
            hintText: hint,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
      ),
    );
  }
}
