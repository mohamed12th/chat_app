
import 'package:shared_preferences/shared_preferences.dart';
class HelperFunction{
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmail = "USEREMAILKEY";

  static Future<bool> saveUserLoggInStatus(bool isUserLoggedIn) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(userLoggedInKey , isUserLoggedIn);

  }
  static Future<bool> saveUserNameKeyprefs(String userName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString( userNameKey ,userName);

  }
  static Future<bool> saveUserEmailKeyprefs(String userEmail) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString( userEmail , userEmail);

  }




  static Future<bool?> getUserLoggedInStatus()async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     return prefs.getBool(userLoggedInKey);

  }
  static Future<String?> getUserEmailKeyprefs()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmail);

  }
  static Future<String?> getUserNameKeyprefs()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);

  }


}