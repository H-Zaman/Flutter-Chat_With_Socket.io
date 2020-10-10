import 'package:chat_app/models/chatMessageModel.dart';
import 'package:get/get.dart';

class GetMessage extends GetxController{
  RxList messages = [].obs;
  clearAll () => messages.clear();
  add(ChatMessageModel messageModel) => messages.add(messageModel);
}