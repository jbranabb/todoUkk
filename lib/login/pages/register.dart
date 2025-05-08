// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Scaffold(
        backgroundColor: Colors.grey.shade400,
        body: Center(
          child: Card(
            shadowColor: Colors.blue,
            child: SizedBox(
              height: 540,
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
                          'Register',
                          style: TextStyle(
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
                          'Sudah Punya Akun?  ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              print('im working here');
                            },
                            child: const Text(
                              'Sign In       ',
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
                        context.read<AuthBloc>().add(Register(
                            displayname: displayname.text,
                            email: email.text,
                            password: pass.text,
                            confirPassword: passCon.text));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey),
                      child: const Text(
                        'Register',
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
      );
  }
}
