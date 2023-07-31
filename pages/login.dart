import 'package:chat_app_flutter/pages/register.dart';
import 'package:chat_app_flutter/service/data_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../helper/function.dart';
import '../service/auth_services.dart';
import '../widgets/widget.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName ="";
  bool _isLoading = false;
  AuthServices authService = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffee7b64),
      ),
      body: _isLoading?Center(child: CircularProgressIndicator(color: Color(0xffee7b64)),):SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Form(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Groupie",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
                const SizedBox(height: 10,),
                const Text("Login now to see what they are talking!",
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w400)),
                Image.asset("assets/login.png"),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email, color: Color(0xffee7b64),),

                  ),
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                  validator: (val) {
                    return RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val!)
                        ? null
                        : "Please enter a valid email";
                  },
                ),

                const SizedBox(height: 15,),

                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock, color: Color(0xffee7b64),),
                  ),
                  validator: (val) {
                    if (val!.length < 8) {
                      return "Password must be at least 6 characters";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ),
                const SizedBox(height: 15,),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Color(0xffee7b64),
                        elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),

                        onPressed: (){
                          login();
                        }, child: const Text("Sign In",
                      style: TextStyle(fontSize: 16,color: Colors.white),),
                    )
                ),
                const SizedBox(
                  height: 10,
                ),
                Text.rich(TextSpan(
                  text: "Don't have an account? ",
                  style: const TextStyle(
                      color: Colors.black, fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                        text: "Register here",
                        style: const TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {nextScreen(context, const RegisterScreen());
                          }),
                  ],
                )),

              ],
            ),
          ),
        ),
      ),

    );
  }
  login()async{
    if(_formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      await authService.loginUserwithEmailandPassword( email , password)
          .then((value) async{
        if(value == true){
         QuerySnapshot snapshot = await DataBaseService(uid : FirebaseAuth.instance.currentUser!.uid).
          gettingUserData(email);
         await HelperFunction.saveUserLoggInStatus(true);
         await HelperFunction.saveUserNameKeyprefs(email);
         await HelperFunction.saveUserNameKeyprefs(snapshot.docs[0]['fullName']);

          nextScreen(context, const HomeScreen());

        }else{
          showSnackBar(context ,Colors.red ,value);
          setState(() {
            _isLoading = false;
          });
        }
      });

    }

  }


    }
