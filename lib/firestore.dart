import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firbase/productmodel.dart';
class Informationdevelopper extends StatefulWidget {
  @override
  _InformationdevelopperState createState() => _InformationdevelopperState();
}
class _InformationdevelopperState extends State<Informationdevelopper> {
  List<ProductModel> productModels = List();
  @override
  void initState() {
    super.initState();
    //readDataAll();
  }
 /* Future<void> readDataAll() async {
    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference = firestore.collection('Products');
    await collectionReference.snapshots().listen((response) {
      // ແມ່ນການປະກາດຕົວແປແບບອາເລ
      print("snapshot = == ");
      List<DocumentSnapshot> snapshots = response.documents;
      for (var snapshot in snapshots) {
        print("snapshot = $snapshot");
        print("Name = ${snapshot.data["name"]}");
        ProductModel productModel = ProductModel.fromMap(snapshot.data);
        setState(() {
          productModels.add(productModel);
        });
      }
    });
  }*/
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('products')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Loading...');
                  default:
                    return new ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return new ListTile(
                          title:Text("${document['name']}")

                        );
                      }).toList(),
                    );
                }
              },
            )),
      ),
    );
  }
}
