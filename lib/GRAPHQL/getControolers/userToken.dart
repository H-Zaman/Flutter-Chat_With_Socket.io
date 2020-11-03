import 'package:get/get.dart';

class GetUserToken extends GetxController{
  RxString token = ''.obs;
  setToken(value)=>token.value = value;
}