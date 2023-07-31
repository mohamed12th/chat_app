import 'package:chat_app_flutter/helper/function.dart';
import 'package:chat_app_flutter/service/data_base.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

Future loginUserwithEmailandPassword( String email, String password) async
{
  try {
    User user =(await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password)).user!;
    if(user!=null){
    return true;

    }

  }  on FirebaseAuthException catch (e) {
    return e.message;
  }
}
Future registerUserWithEmailandPassword(
    String fullName, String email, String password) async {
  try {
    User user = (await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password))
        .user!;

    if (user != null) {
      // call our database service to update the user data.
      await DataBaseService( uid :user.uid).savingUserData(fullName, email);
      return true;
    }
  } on FirebaseAuthException catch (e) {
    return e.message;
  }
}


Future signOut()async{
  try{
    await HelperFunction.saveUserLoggInStatus(false);
    await HelperFunction.saveUserEmailKeyprefs("");
    await HelperFunction.saveUserNameKeyprefs("");
    await firebaseAuth.signOut();
  }catch(e){
    return null;
  }
}

}