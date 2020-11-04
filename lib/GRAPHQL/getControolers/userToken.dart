import 'package:get/get.dart';

class GetUserData extends GetxController{
  RxString token = ''.obs;
  RxString name = ''.obs;
  RxString id = ''.obs;
  setToken(value)=>token.value = value;
  setName(value)=>name.value = value;
  setId(value)=>id.value = value;
}