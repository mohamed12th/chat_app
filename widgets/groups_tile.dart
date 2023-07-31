import 'package:chat_app_flutter/pages/chat_page.dart';
import 'package:chat_app_flutter/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupsTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const GroupsTile({Key? key,
    required this.userName, required this.groupId, required this.groupName})
      : super(key: key);

  @override
  State<GroupsTile> createState() => _GroupsTileState();
}

class _GroupsTileState extends State<GroupsTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        nextScreen(context, ChatPage(
          groupId: widget.groupId,
          groupName: widget.groupName,
          userName: widget.userName,
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5) ,
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xffee764),
            child: Text(widget.groupName.substring(0 , 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),

          ),
          title: Text(widget.groupName,style: TextStyle(fontWeight: FontWeight.bold),),
          subtitle:  Text(
            "Join the conversation as ${widget.userName}",
            style: const TextStyle(fontSize: 13),
          )
        ),
      ),
    );
  }
}
