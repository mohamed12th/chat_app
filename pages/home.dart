import 'package:chat_app_flutter/helper/function.dart';
import 'package:chat_app_flutter/pages/login.dart';
import 'package:chat_app_flutter/pages/profile_page.dart';
import 'package:chat_app_flutter/pages/search_page.dart';
import 'package:chat_app_flutter/service/auth_services.dart';
import 'package:chat_app_flutter/service/data_base.dart';
import 'package:chat_app_flutter/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/groups_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String userName = "";
  String email = "";
  Stream? groups ;
  bool _isLoading = false;
  String groupName = "";
  AuthServices authService = AuthServices();

  @override
  void initState() {

    super.initState();
    gettingUserData();

  }
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }
  gettingUserData()async{
    await HelperFunction.getUserEmailKeyprefs().then((value) {
      setState(() {
        email = value! ;
      });
    });
    await HelperFunction.getUserEmailKeyprefs().then((value) {
      setState(() {
        userName = value! ;
      });
    });
    await DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       actions: [
         IconButton(onPressed: (){
           nextScreen(context, const SearchPage());
         }, icon:const Icon(Icons.search) )
       ],
       centerTitle: true,
       elevation: 0,
       backgroundColor: const Color(0xffee7b64),
       title: const Text("Groups",style: TextStyle(fontSize: 27,color: Colors.white,fontWeight: FontWeight.bold),),
     ),
      drawer: Drawer(
         child: ListView(
           padding: const EdgeInsets.symmetric(vertical: 50),
           children:  <Widget> [
             const Icon(Icons.account_circle,size: 150,color: Colors.grey,),
             const SizedBox(height: 15,),
             Text(userName ,
               textAlign: TextAlign.center,
               style: const TextStyle(fontWeight: FontWeight.bold),),
             const SizedBox(height: 30,),
             const Divider(height: 2,),
              ListTile(
               onTap: (){},
               selectedColor: Color(0xffee7b64),
               selected: true,
               leading: Icon(Icons.group),
               title: Text("Groups",style: TextStyle(color: Colors.black),),
               contentPadding: EdgeInsets.symmetric(vertical:5 ,horizontal:20 ),
             ),
            ListTile(
               onTap: (){
                 nextScreenReplace(context, ProfilePage(email: email,userName: userName,));
               },
               selectedColor: Color(0xffee7b64),
               selected: true,
               leading: Icon(Icons.group),
               title: Text("Profile",style: TextStyle(color: Colors.black),),
               contentPadding: EdgeInsets.symmetric(vertical:5 ,horizontal:20 ),
             ),
              ListTile(
               onTap: ()async{
                 showDialog(
                     barrierDismissible: false,
                     context: context, builder: (context){
                   return AlertDialog(
                     title: Text("Logout"),
                     content: Text("Are you sure you want to logout"),
                     actions: [
                       IconButton(onPressed: (){
                         Navigator.pop(context);
                       }, icon:Icon(Icons.cancel),color: Colors.red,),
                       IconButton(onPressed: ()async{
                         await authService.signOut();
                         Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginScreen()),
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
               leading: Icon(Icons.exit_to_app),
               title: Text("LogOut",style: TextStyle(color: Colors.black),),
               contentPadding: EdgeInsets.symmetric(vertical:5 ,horizontal:20 ),
             ),

           ],
         ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: const Color(0xffee7b64),
        child: const Icon(Icons.add,size: 30,color: Colors.white,),
      ),
    );
  }
  popUpDialog(BuildContext context){
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: ((context, setState){
            return AlertDialog(
          title: const Text("Create a group", textAlign: TextAlign.left,),
          content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          _isLoading == true ? Center(child: CircularProgressIndicator(color: Color(0xffee7b64),),)
              :TextField(
          onChanged: (val){
          setState(() {
          groupName = val ;
          });
          },
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide( color: Color(0xffee7b64),),
          borderRadius: BorderRadius.circular(20),
          ),
          errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(20),
          )
          ),
          ),


          ],),
          actions: [
          ElevatedButton(onPressed: (){
          Navigator.of(context).pop();
          }, style: ElevatedButton.styleFrom(backgroundColor: Color(0xffee7b64)),
          child: Text("Cancel")),
          ElevatedButton(onPressed: () async {
          if (groupName != "") {
          setState(() {
          _isLoading = true;
          });
          DataBaseService(
          uid: FirebaseAuth.instance.currentUser!.uid)
              .createGroup(userName,
          FirebaseAuth.instance.currentUser!.uid, groupName)
              .whenComplete(() {
          _isLoading = false;
          });
          Navigator.of(context).pop();
          showSnackBar(context, Colors.green, "Group created successfully.");
          }
          }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffee7b64)),
          child: Text("Create")
          ),
          ],
          );
        }));
        });

  }

  groupList(){
    StreamBuilder(
      stream: groups,
      builder: (context ,AsyncSnapshot snapshot){
        if(snapshot.hasData){
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                  return GroupsTile(
                      groupId: getId(snapshot.data['groups'][reverseIndex]),
                      groupName: getName(snapshot.data['groups'][reverseIndex]),
                      userName: snapshot.data['fullName']);
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        }
        else{
          return Center(child: CircularProgressIndicator(color: Color(0xffee7b64),),);
        }

      },
    );

  }
  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
