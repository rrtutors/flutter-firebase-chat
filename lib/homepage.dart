
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firbase/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chatpage.dart';

class MyHomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyHomePageState();
  }

}

class MyHomePageState extends State<MyHomePage>
{
  FirebaseDatabase fireDB=FirebaseDatabase.instance;
  TextEditingController _txtCtrl = TextEditingController();
  FirebaseUser currentUser;
  String id;
  String nickname="";
  String photoUrl;
  List<User>listUsers=new List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }


  getUserInfo() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();

    setState(() {
      id=prefs.getString("id");
      nickname=prefs.getString("nickname");
      photoUrl=prefs.getString("photoUrl");
    });
    FirebaseDatabase.instance.reference().child('users/-M1ZPGcD23x7uAUew5fF')
    .orderByChild("created_at")
        .onValue
        .listen((event) {
      print("data user");
      Map<dynamic,dynamic>hm=event.snapshot.value;
      if(hm!=null)
        {
          hm.forEach((key, value) {
            print(hm[key]);
          });
        }

    });
    print("Fetching datad 0 ");
    StreamSubscription<Event> subscription =fireDB
        .reference()
        .child("users")
        .onValue
        .listen((Event event) {
      print("Fetching datad 1 ");
     print( event.snapshot.value);
     Map<dynamic,dynamic>hm=event.snapshot.value;
      hm.forEach((key, value) {
        Map<dynamic,dynamic>users=value;
        setState(() {
          if(users['id']!=id)
          listUsers.add(new User(users['name'],users['id'],users['photoUrl']));
        });


      });
    },onError: (errror){

          print("Error ${errror.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Chat $nickname"),),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            Expanded(
                child:(listUsers.length>0)?
                ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.black,
                    );
                  },
                  itemCount: listUsers.length,
                    itemBuilder: (context,index){
                  return ListTile(
                    title: Text(listUsers[index].name),
                    leading: Material(child: Image.network(listUsers[index].img,),borderRadius: BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                      clipBehavior: Clip.hardEdge,),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                      return  ChatPage(myid: id,uid:listUsers[index].id ,myImg: photoUrl,uImg: listUsers[index].img,myName: nickname,uName:listUsers[index].name ,);
                      }));
                    },
                  );
                }):Center(child: CircularProgressIndicator(),)
            ),
            Container(
                margin: EdgeInsets.all(8),
               )
          ]),
    );
  }

  String peerId="1";
  String peerAvatar;


  var listMessage;
  String groupChatId="1";
  SharedPreferences prefs;




}