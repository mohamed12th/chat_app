import 'package:chat_app_flutter/helper/function.dart';
import 'package:chat_app_flutter/pages/login.dart';
import 'package:chat_app_flutter/service/auth_services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../widgets/widget.dart';
import 'home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
      body: _isLoading?const Center(child: CircularProgressIndicator(color: Color(0xffee7b64)),)
          :SingleChildScrollView(
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
                const Text("Create your account now to chat and explore",
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w400)),
                Image.asset("assets/register.png"),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "Full Name",
                    prefixIcon: const Icon(Icons.person ,color: Color(0xffee7b64),)
                  ),
                  onChanged: (val){
                    setState(() {
                      fullName = val;
                    });
                  },
                  validator: (val){
                    if (val!.isNotEmpty) {
                      return null;
                    } else {
                      return "Name cannot be empty" ;
                    }
                  },
                ),
                const SizedBox(height: 15,),
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
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffee7b64),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),

                      onPressed: (){
                        register();
                      }, child: const Text("Register",
                      style: TextStyle(fontSize: 16,color: Colors.white),),
                    )
                ),
                const SizedBox(
                  height: 10,
                ),
                Text.rich(TextSpan(
                  text: "Already have an account?",
                  style: const TextStyle(
                      color: Colors.black, fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                        text: "Login now",
                        style: const TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {nextScreen(context, const LoginScreen());
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
  register()async{
    if(_formKey.currentState!.validate()){
     setState(() {
       _isLoading = true;
     });
     await authService.registerUserWithEmailandPassword( fullName , email , password)
         .then((value) async{
          if(value == true){
            await HelperFunction.saveUserLoggInStatus(true);
            await HelperFunction.saveUserNameKeyprefs(email);
            await HelperFunction.saveUserNameKeyprefs(fullName);
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
