import 'package:get/get.dart';

class GetOnlineUsers extends GetxController{
  RxList onlineUserList = [].obs;
  addUser(value) => onlineUserList.add(value);
  clearList() => onlineUserList.clear();
}