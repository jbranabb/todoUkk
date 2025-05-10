part of 'auth_bloc.dart';

@immutable
abstract class AuthState  {}

class AuthInitial extends AuthState {}
class UnAuth extends AuthState {}
class AuthLoading extends AuthState {}
class AuthLoaded extends AuthState {}
class AuthErorr extends AuthState {
  final String e;
  AuthErorr(this.e);
}