import 'package:get/get.dart';

class GetUserValue extends GetxController{
  RxString token = ''.obs;
  RxString name = ''.obs;

  setToken(value)=>token.value = value;
  setName(value)=>name.value = value;
}
