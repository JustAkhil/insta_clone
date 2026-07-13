import 'package:flutter/widgets.dart';
import 'package:insta_clone/model/user_model.dart';
import 'package:insta_clone/repository/auth_method.dart';

class UserProvider extends ChangeNotifier{
  UserModel? _userModel;
  UserModel? get getUser => _userModel;
  final AuthMethod _authMethod=AuthMethod();
  Future<void> refreshUser()async{
    UserModel user=await _authMethod.getUserDetail();
    _userModel=user;
    notifyListeners();
  }
}