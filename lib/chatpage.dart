import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'message.dart';

class ChatPage extends StatefulWidget{
const ChatPage({@required this.myid,@required  this.uid,@required this.myName,@required this.uName,@required this.myImg,@required this.uImg});
      final String myid;
      final String uid;
      final String myName;
     final String uName;
     final String myImg;
     final String uImg;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChatPageState(myid,uid,myName,uName,myImg,uImg);
  }
}

class ChatPageState extends State{
  final String myid;
  final String uid;
  final String myName;
  final String uName;
  final String myImg;
  final String uImg;
  TextEditingController _txtCtrl=new TextEditingController();
  FirebaseDatabase fireDB=FirebaseDatabase.instance;

  ChatPageState( this.myid,  this.uid,this.myName, this.uName,this.myImg,this.uImg);
  List<Messages>list;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list=new List();
    fetchMessages();
    /*FirebaseDatabase().reference()
        .child("messages")
        .child(myid+"_"+uid)
    .limitToLast(1)
    .orderByChild("created_at")
    .onChildAdded
    .listen((event) {
      Map<dynamic,dynamic>hm=event.snapshot.value;
      print("Event ${hm.length}");
      int k=0;

      hm.forEach((key, value) {

        print("Fetching Msgs ");
        print(key);
        if(k==hm.length)
          {
            setState(() {
              Map map=hm[key];
              list.add(Messages.fromMap(value,key));
            });
          }
         k++;


      });
    });*/
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: Material(child: Image.network(uImg,width: 10,height: 10,),borderRadius: BorderRadius.all(
          Radius.circular(32.0),
        ),
          clipBehavior: Clip.hardEdge,),
        title: Text(uName),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: (list.length>0)?ListView.separated(
                separatorBuilder: (
                    context, index) => Divider(color: Colors.grey,),
                            itemCount: list.length,
                            reverse: false,
                            itemBuilder: (context, index) {
                  return buildItem(index,list[index]);
            }
            ,):Center(child: CircularProgressIndicator(),
            ),
            ),
            Container(
                margin: EdgeInsets.all(8),
                child: Row(children: <Widget>[
                  Expanded(child: TextField(

                    controller: _txtCtrl,decoration: InputDecoration(
                    hintText: "Write your Message",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.pink)
                      )),)),
                  SizedBox(
                      width: 80,
                      child: FloatingActionButton(
                        onPressed: () => sendMessage(),
                        child: Icon(Icons.send), ))
                ]))
          ],
        ),
      ),
    );
  }
  sendMessage() {

    fireDB
        .reference()
        .child("messages")
        .child(getUniqueId(myid,uid))
    .child(DateTime.now().toUtc().millisecondsSinceEpoch.toString())
         .push().set({
    "from_id": myid,
    "to_id": uid,
    "from_name": myName,
    "to_name": uName,
    "msg": _txtCtrl.text
    }).then((value) => {
    _txtCtrl.text = ''
    });

  }



  fetchMessages()
  {

    fireDB
        .reference()
        .child("messages")
        .child(getUniqueId(myid,uid))

        .onValue
        .listen((Event event) {
      print("Fetching datad");
      print( event.snapshot.value);
      Map<dynamic,dynamic>hm=event.snapshot.value;
      if(hm!=null)
        {
          list.clear();
          hm.forEach((key, value) {

            print("Fetching Msgs $value");
            print(key);
            Map m=value;
            m.forEach((key, value) {
              setState(() {

                list.add(Messages.fromMap(value,key));
              });
            });



          });
        }

    });
   //StreamSubscription<Event> subscription =
  }



  Widget buildItem(int index, Messages msg) {
    if (msg.from_id == myid) {
      // Right (my message)
      return Column(
        children: [
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  msg.msg,
                  style: TextStyle(color: Colors.black),
                ),
                /*SizedBox(height: 10,),
                (msg.created_at!=null)?
                Text(
                  "${readTimestamp(msg.created_at )}",
                  style: TextStyle(color: Colors.black,fontSize: 8),
                ):Text("")*/
              ],
            ),
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          width: 200.0,
            decoration: ShapeDecoration(shape: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: BorderSide(color: Colors.pink))),
          margin: EdgeInsets.only(bottom:  10.0, right: 10.0),
        )
        ],
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    msg.msg,
                    style: TextStyle(color: Colors.black),
                  ),
                  /*SizedBox(height: 10,),
                  (msg.created_at!=null)?
                  Text(
                    ("${readTimestamp(msg.created_at )}"),
                    style: TextStyle(color: Colors.black,fontSize: 8),
                  ):Text("")*/
                ],
              ),
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              width: 200.0,
              decoration: ShapeDecoration(shape: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
              margin: EdgeInsets.only(left: 10.0),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  static String getUniqueId(String i1,String i2){
    if(i1.compareTo(i2)<=-1){
      return i1+i2;
    }
    else{
      return i2+i1;
    }
  }

  String readTimestamp(DateTime timestamp) {
    var now = DateTime.now();

    return now.difference(timestamp).inHours.toString();
   /* var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {

        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;*/
  }
}