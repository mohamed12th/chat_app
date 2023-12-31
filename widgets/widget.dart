import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xffee7b64),width: 2 )
  ),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffee7b64),width: 2 )
  ),
  errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffee7b64),width: 2 )
  ),

);
void nextScreen (context ,page){
  Navigator.push(context, MaterialPageRoute(builder:(context) => page,));
}
void nextScreenReplace (context , page){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page,));

}
void showSnackBar( context , color , message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message , style: TextStyle(fontSize: 14),
  ),
      backgroundColor: color,
    duration: Duration(seconds: 3),
    action: SnackBarAction(label: "ok", onPressed: (){},textColor: Colors.white,),
  )

  );
}
