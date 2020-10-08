import 'package:chat_app/models/chatMessageModel.dart';
import 'package:get/get.dart';

class GetMessage extends GetxController{
  RxList messages = [].obs;
  clearAll () => messages.clear();
  add(MessageModel messageModel) => messages.add(messageModel);
}

class MessageModel{
  int id;
  List<ChatMessageModel> messages;
  MessageModel({this.id,this.messages});
}