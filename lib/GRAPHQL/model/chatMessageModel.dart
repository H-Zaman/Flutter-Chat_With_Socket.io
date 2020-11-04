// To parse this JSON data, do
//
//     final chatMessageModel = chatMessageModelFromJson(jsonString);

import 'dart:convert';

ChatMessageModel chatMessageModelFromJson(String str) => ChatMessageModel.fromJson(json.decode(str));

String chatMessageModelToJson(ChatMessageModel data) => json.encode(data.toJson());

class ChatMessageModel {
  ChatMessageModel({
    this.messageAdded,
  });

  MessageModel messageAdded;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => ChatMessageModel(
    messageAdded: MessageModel.fromJson(json["messageAdded"]),
  );

  Map<String, dynamic> toJson() => {
    "messageAdded": messageAdded.toJson(),
  };
}


SentChatModel sentChatModelFromJson(String str) => SentChatModel.fromJson(json.decode(str));

String sentChatModelToJson(SentChatModel data) => json.encode(data.toJson());

class SentChatModel {
  SentChatModel({
    this.addMessage,
  });

  MessageModel addMessage;

  factory SentChatModel.fromJson(Map<String, dynamic> json) => SentChatModel(
    addMessage: MessageModel.fromJson(json["addMessage"]),
  );

  Map<String, dynamic> toJson() => {
    "addMessage": addMessage.toJson(),
  };
}


class MessageModel {
  MessageModel({
    this.id,
    this.message,
    this.sender,
    this.receiver,
  });

  String id;
  String message;
  String sender;
  String receiver;

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json["_id"],
    message: json["message"],
    sender: json["sender"],
    receiver: json["receiver"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "message": message,
    "sender": sender,
    "receiver": receiver,
  };
}