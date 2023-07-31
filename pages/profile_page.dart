import 'package:chat_app_flutter/pages/home.dart';
import 'package:flutter/material.dart';

import '../service/auth_services.dart';
import '../widgets/widget.dart';
import 'login.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  String userName;
  String email ;
   ProfilePage({Key? key,required this.userName,required this.email}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthServices authService = AuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: const Color(0xffee7b64),
        elevation: 0,
        title: const Text("Profile", style: TextStyle(fontSize: 27,color: Colors.white,fontWeight: FontWeight.bold),),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children:  <Widget> [
            const Icon(Icons.account_circle,size: 150,color: Colors.grey,),
            const SizedBox(height: 15,),
            Text(widget.userName ,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(height: 30,),
            const Divider(height: 2,),
            ListTile(
              onTap: () {
                nextScreen(context, const HomeScreen());
              },
              selectedColor: Color(0xffee7b64),
              leading: Icon(Icons.group),
              title: Text("Groups",style: TextStyle(color: Colors.black),),
              contentPadding: EdgeInsets.symmetric(vertical:5 ,horizontal:20 ),
            ),
            ListTile(
              onTap: (){
              },
              selectedColor: const Color(0xffee7b64),
              selected: true,
              leading: const Icon(Icons.group),
              title: const Text("Profile",style: TextStyle(color: Colors.black),),
              contentPadding: const EdgeInsets.symmetric(vertical:5 ,horizontal:20 ),
            ),
            ListTile(
              onTap: ()async{
                showDialog(
                    barrierDismissible: false,
                    context: context, builder: (context){
                  return AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Are you sure you want to logout"),
                    actions: [
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon:Icon(Icons.cancel),color: Colors.red,),
                      IconButton(onPressed: ()async{
                        await authService.signOut();
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>
                            LoginScreen()),
                                (route) => false);
                      }, icon:const Icon(Icons.done),color: Colors.green,),
                    ],

                  );
                });
                authService.signOut().whenComplete((){
                  nextScreenReplace(context, const LoginScreen());
                });
              },
              selectedColor: const Color(0xffee7b64),
              selected: true,
              leading: const Icon(Icons.exit_to_app),
              title: const Text("LogOut",style: TextStyle(color: Colors.black),),
              contentPadding: const EdgeInsets.symmetric(vertical:5 ,horizontal:20 ),
            ),

          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40,vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.account_circle,size: 200,color: Colors.grey,),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Full Name",style: TextStyle(fontSize: 17),),
                Text(widget.userName,style: TextStyle(fontSize: 17),),

              ],
            ),
            Divider(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Email",style: TextStyle(fontSize: 17),),
                Text(widget.email,style: TextStyle(fontSize: 17),),

              ],
            ),
          ],
        ),
      ),

    );
  }
}
