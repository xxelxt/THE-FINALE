import 'package:dingtea/infrastructure/models/data/chat_message_data.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default(false) bool isLoading,
    @Default(false) bool isMoreLoading,
    @Default([]) List<ChatMessageData> chats,
    @Default('') String chatId,
    TextEditingController? textController,
  }) = _ChatState;

  const ChatState._();
}
