import 'package:chat_app_flutter/service/data_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/widget.dart';
import 'home.dart';

class GroupInfo extends StatefulWidget {
  final String groupId ;
  final String groupName ;
  final String adminName ;
  const GroupInfo({Key? key,
    required this.groupId,
    required this.groupName,
    required this.adminName})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? member ;
  @override
  void initState() {
    getMember();
    // TODO: implement initState
    super.initState();
  }
  getMember()async{
    DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid).getGroupMembers(widget.groupId).then((val){
      setState(() {
        member = val ;
      });
    });
  }
  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xffee7b64),
        title: const Text("Group Info"),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Exit"),
                        content:
                        const Text("Are you sure you exit the group? "),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              DataBaseService(
                                  uid: FirebaseAuth
                                      .instance.currentUser!.uid)
                                  .toggleGroupJoin(
                                  widget.groupId,
                                  getName(widget.adminName),
                                  widget.groupName)
                                  .whenComplete(() {
                                nextScreenReplace(context, const HomeScreen());
                              });
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color(0xffee7b64),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xffee7b64),
                    child: Text(widget.groupName.substring(0 , 1).toUpperCase(),
                      style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),),
                  ),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Admin: ${getName(widget.adminName)}")
                    ],
                  )
                ],
              ),
            ),
            memberList(),
          ],
        ),
      ),
    );
  }
  memberList(){
    return StreamBuilder(
        stream: member,
        builder: (context , AsyncSnapshot snapshot){
          if(snapshot.hasData){
            if(snapshot.data['member']!=null){
              if(snapshot.data['member']!=null){
                return ListView.builder(itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xffee7b64),
                        child: Text(getName(snapshot.data['member'][index]).substring(0,1).toUpperCase(),
                          style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                      ),
                      title: Text(getName(snapshot.data['member'][index])),
                      subtitle: Text(getId(snapshot.data['member'][index])),
                    ),
                  );
                } ,
                    itemCount: snapshot.data['member'].lenght,
                    shrinkWrap: true,

                );

              }else{
                return Center(child: Text("No Member"),);
              }

            }else{
              return Center(child: Text("No Member"));
            }

          }else{
            return Center(child: CircularProgressIndicator(color: Color(0xffee7b64)),);
          }
        });
  }
}
