part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}
class Login extends AuthEvent{
  String email;
  String password;
  Login({required this.email, required  this.password});
}
class Register extends AuthEvent{
  String email;
  String password;
  String confirPassword;
  Register({required this.email, required  this.password, required this.confirPassword});
}
class Logout extends AuthEvent{}