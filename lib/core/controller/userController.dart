

import 'package:get/get.dart';

import '../models/user.dart'as Model;
import '../services/auth_method.dart';

class UserController extends GetxController{

  Model.User? _user;
  
  final AuthMethods _authMethods = AuthMethods();

 Model.User? get getUser {
  refreshUser();
return _user;
 } 
  Future<void> refreshUser() async {
    Model.User user = await AuthMethods.getUserDetails();
    _user = user;
    update();
  }
}