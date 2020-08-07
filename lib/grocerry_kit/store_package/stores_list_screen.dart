import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/grocerry_kit/home_page.dart';
import 'package:groceryapp/providers/collection_names.dart';
import 'package:groceryapp/providers/store.dart';
import 'package:provider/provider.dart';

import 'add_store_screen.dart';

class StoresListPage extends StatefulWidget {
  static const routeName = "/StoresList";

  @override
  _StoresListPageState createState() => _StoresListPageState();
}

class _StoresListPageState extends State<StoresListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Stores",
        ),
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(AddStorePage.routeName);
              },
              child: Row(
                children: <Widget>[Text("Add"), Icon(Icons.add)],
              ))
        ],
      ),
      //bottomNavigationBar: BottomBar(),
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
              stream:
                  Firestore.instance.collection(stores_collection).snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                    break;
                  default:
                    if (snapshot.data.documents.length > 0) {
                      return ListView.builder(
                        itemBuilder: (context, index) {

                          var data = snapshot.data.documents[index];
                          return _vehicleCard(data);
                        },
                        itemCount: snapshot.data.documents.length,
                      );
                    }
                    return Center(
                      child: Text("No Stores Added"),
                    );
                }
              }),
        ),
      ),
    );
  }

  Widget _vehicleCard(DocumentSnapshot storeSnapshot) {
    StoreModel store = Provider.of<Store>(context).convertToStoreModel(storeSnapshot);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: new FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Color(0x802196F3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: myDetailsContainer1(store),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){

                     // print("Store DocID" + store.storeDocId);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage(store.storeDocId,store.storeName)),
                      );
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      child: store.storeImageRef!=null?ClipRRect(
                        borderRadius: new BorderRadius.circular(24.0),
                        child: Image(
                          fit: BoxFit.contain,
                          alignment: Alignment.topRight,
                          image: NetworkImage(
                              store.storeImageRef),
                        ),
                      ):Container(
                        margin: EdgeInsets.only(right: 25),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.all(16.0),
                        child:Icon(Icons.navigate_next,size: 50,),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget myDetailsContainer1(StoreModel docu) {
    StoreModel doc = docu;
    return LimitedBox(
      //maxHeight: 200,
      child: Container(
        height: 250,
        width: MediaQuery.of(context).size.width * .8,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
//            Container(
//                alignment: Alignment.centerRight,
//                child: IconButton(
//                  icon: Icon(Icons.edit),
//                  onPressed: () {},
//                  iconSize: 30,
//                )),
            Container(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                doc.storeName,
                maxLines: 3,
                style: TextStyle(
                    color: Color(0xffe6020a),
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold),
              ),
            ),

            Container(
              padding: EdgeInsets.all(6),
              child: Text(
                doc.storeAddress ,
                maxLines: 3,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 24.0,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(6),
              child: GestureDetector(
                onTap: (){
                  Firestore.instance.collection(stores_collection).document(docu.storeDocId).delete();
                },
                child: Text(
                  "delete" ,
                  maxLines: 1,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 24.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
