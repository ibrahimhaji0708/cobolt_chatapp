part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class ChatInitialEvent extends ChatEvent {}

class LoginEvent extends ChatEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class LogoutEvent extends ChatEvent {}

class CreateAccountButtonClickedEvent extends ChatEvent {
  final String email;
  final String password;

  CreateAccountButtonClickedEvent(
      {required this.email, required this.password});
}
class NavigateToCreateAccountEvent extends ChatEvent {}

class NavigateToLoginPageEvent extends ChatEvent {}

class NavigateToSignUpPageEvent extends ChatEvent {}

class LoginButtonClickedEvent extends ChatEvent {}

class SignUpButtonClickedEvent extends ChatEvent {}
