import 'package:bloc/bloc.dart';
import 'package:cobolt_chatapp/data/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<ChatInitialEvent>(_onChatInitialEvent);
    on<LoginEvent>(_loginEvent);
    on<LogoutEvent>(_logoutEvent);
    on<CreateAccountButtonClickedEvent>(_onCreateAccountButtonClickedEvent);
    on<NavigateToSignUpPageEvent>(_onNavigateToSignUpPageEvent);
    on<SignUpButtonClickedEvent>(_onSignUpButtonClickedEvent);
    // on<AddContactEvent>(_addContactEvent);
    on<NavigateToContactsEvent>(_navigateToContactsEvent);
  }

  FutureOr<void> _onChatInitialEvent(
      ChatInitialEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoadingState());
    await Future.delayed(const Duration(seconds: 2));
    emit(ChatLoadedSuccessState(chatMessages: const []));
  }

  FutureOr<void> _loginEvent(LoginEvent event, Emitter<ChatState> emit) async {
    emit(AuthLoadingState());

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: event.email, password: event.password);

      if (userCredential.user != null) {
        emit(AuthenticatedState());
        emit(ChatLoadedSuccessState(chatMessages: const []));
      } else {
        emit(UnauthenticatedState());
      }
    } catch (e) {
      emit(ChatErrorState());
    }
  }

  FutureOr<void> _logoutEvent(
      LogoutEvent event, Emitter<ChatState> emit) async {
    await FirebaseAuth.instance.signOut();
    emit(ChatLogoutState());
    emit(UnauthenticatedState());
  }

  FutureOr<void> _onCreateAccountButtonClickedEvent(
      CreateAccountButtonClickedEvent event, Emitter<ChatState> emit) async {
    emit(AuthLoadingState());
    emit(AuthenticatedState());
  }

  FutureOr<void> _onNavigateToSignUpPageEvent(
      NavigateToSignUpPageEvent event, Emitter<ChatState> emit) async {
    emit(ChatActionState());
  }

  FutureOr<void> _onSignUpButtonClickedEvent(
      SignUpButtonClickedEvent event, Emitter<ChatState> emit) async {
    emit(AuthLoadingState());
    emit(AuthenticatedState());
  }

  // FutureOr<void> _addContactEvent(
  //     AddContactEvent event, Emitter<ChatState> emit) async {
  //   emit(NavigateToContactsState());
  // }

  FutureOr<void> _navigateToContactsEvent(
      NavigateToContactsEvent event, Emitter<ChatState> emit) async {
    print("NavigateToContactsEvent triggered");
    emit(ChatAddContactSuccessState());
  }
}
