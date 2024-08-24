part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatActionState extends ChatState {}

final class ChatInitial extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatLoadedSuccessState extends ChatState {
  final List<ChatMessageModel> chatMessages;

  ChatLoadedSuccessState({required this.chatMessages});
}

class ChatErrorState extends ChatState {}

class ChatEmptyState extends ChatState {}

class ChatSendingState extends ChatState {}

class ChatReceivedNewMessageState extends ChatState {
  final ChatMessageModel newMessage;

  ChatReceivedNewMessageState({required this.newMessage});
}

class ChatLogoutState extends ChatActionState {}

class AuthenticatedState extends ChatState {}

class UnauthenticatedState extends ChatState {}

class AuthLoadingState extends ChatState {}

//
class ChatAddContactSuccessState extends ChatState {}

// class NavigateToContactsState extends ChatState {}
