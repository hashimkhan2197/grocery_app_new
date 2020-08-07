import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/grocerry_kit/SignIn.dart';
import 'package:groceryapp/providers/collection_names.dart';
import 'package:groceryapp/widgets/custom_image_picker.dart';

class CouponDeliveryPage extends StatefulWidget {
  @override
  _CouponDeliveryPageState createState() => _CouponDeliveryPageState();
}

class _CouponDeliveryPageState extends State<CouponDeliveryPage> {

  final _formKey = GlobalKey<FormState>();
  String _couponCode = '';
  String _discPercentage = '';
  File _categoryImageFile;
  void _pickedImage(File image) {
    _categoryImageFile = image;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        brightness: Brightness.dark,
        automaticallyImplyLeading: false,
        title: Text(
          'Admin',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
                  return SignInPage();
                }),(Route<dynamic> route) => false);
              },
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text("Logout",style:TextStyle(color:Colors.white)),
                  )
                ],
              ))
        ],
      ),

      body: Container(height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: <Widget>[
          ///Splash image section
//          Column(
//            children: <Widget>[
//              Container(
//                alignment: Alignment.centerLeft,
//                padding: EdgeInsets.only(left: 16, top: 4),
//                child: Text(
//                  "Splash Screen Section",
//                  style: TextStyle(
//                    fontSize: 22,
//                    fontWeight: FontWeight.bold,
//                  ),
//                ),
//              ),
//
//              SizedBox(
//                height: 22,
//              ),
//
//              SizedBox(
//                height: 10,
//              ),
//              UserImagePicker(_pickedImage),
//
//
//              Align(
//                child: SizedBox(
//                  height: 50.0,
//                  width: 270.0,
//                  child: FlatButton(
//                    onPressed: ()async {
//                      if (_categoryImageFile == null) {
//                        Scaffold.of(context).showSnackBar(SnackBar(
//                          content: Text('Please pick an image'),
//                          backgroundColor: Theme
//                              .of(context)
//                              .errorColor,));
//                        return;
//                      }
//
//                      //TODO Check values and navigate to new page
//                      final ref =
//                      FirebaseStorage.instance.ref().child('images').child("fjijj" + ".jpg");
//                      await ref.putFile(_categoryImageFile).onComplete;
//
//                      final url = await ref.getDownloadURL();
//
//
//                      await Firestore.instance.collection('splashImage').document('splashImage')
//                          .updateData({
//                        'url': url
//                      })
//                          .then((value) => {
//                        showDialog(
//                          context: context,
//                          builder: (ctx) => AlertDialog(
//                            title: Text('Splash Screen'),
//                            content: Text(
//                                'The splash image has been updated'),
//                            actions: <Widget>[
//                              FlatButton(
//                                child: Text(
//                                  'Okay',
//                                  style: TextStyle(
//                                      color: Theme.of(context)
//                                          .primaryColor),
//                                ),
//                                onPressed: () {
//                                  Navigator.of(ctx).pop();
//                                },
//                              )
//                            ],
//                          ),
//                        )
//                      })
//                          .catchError((e) {
//                        print(e);
//                        showDialog(
//                          context: context,
//                          builder: (ctx) => AlertDialog(
//                            title: Text('An error occurred!'),
//                            content: Text(
//                                'Something went wrong. Please Try again later.'),
//                            actions: <Widget>[
//                              FlatButton(
//                                child: Text('Okay',
//                                    style: TextStyle(
//                                        color: Theme.of(context)
//                                            .primaryColor)),
//                                onPressed: () {
//                                  Navigator.of(ctx).pop();
//                                },
//                              )
//                            ],
//                          ),
//                        );
//                      });
//
//                    },
//                    color: Theme.of(context).primaryColor,
//                    //Color.fromRGBO(58, 66, 86, 1.0),
//                    shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(30.0)),
//                    child: Text(
//                      'Add splash',
//                      style: Theme.of(context).primaryTextTheme.button,
//                    ),
//                  ),
//                ),
//              )
//            ],
//
//          ),
          ///Coupons Section
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              SizedBox(
                height: 20,
              ),
              Text(
                'Add Coupon',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      child: TextFormField(
                        validator: (val) {
                          return val.trim().isEmpty
                              ? "code cannot be empty."
                              : null;
                        },
                        onSaved: (val) {
                          _couponCode = val.trim();
                        },
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          hintText: 'Coupon Code',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      child: TextFormField(
                        validator: (String val) {
                          bool isNumeric(String str) {
                            try{
                              var value = double.parse(str);
                            } on FormatException {
                              return false;
                            } finally {
                              return true;
                            }
                          }
                          if (val.trim().isEmpty) {
                            return "Percentage cannot be empty";
                          } else if (isNumeric(val.trim()) == false) {
                            return "Must be a number e.g 20";
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _discPercentage = val.trim();
                        },

                        style: TextStyle(fontSize: 18),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Percentage',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
                Container(
                  margin: EdgeInsets.only(top: 16, bottom: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  width: 200,
                  child: FlatButton(
                    child: Text('Add coupon',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        //Only gets here if the fields pass
                        _formKey.currentState.save();
                        Firestore.instance.collection(discount_coupons_collection).add({
                          "promoCode": _couponCode,
                          'discPercentage':_discPercentage
                        });
                        setState(() {
                          _discPercentage = '';
                          _couponCode = "";
                        });
                      }
                    },
                  ),
                ),

            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[SizedBox(height: 20,),
              ///Available Coupons Section
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 16, top: 4),
                child: Text(
                  "Available Coupons",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(height: 120,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                padding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white70),
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection(discount_coupons_collection)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                            child: CircularProgressIndicator());
                        break;
                      default:
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            //scrollDirection: Axis.horizontal,
                            itemCount:
                            snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "code: "+ snapshot.data.documents[index].data['promoCode'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey
                                      ),
                                    ),
                                    Text(
                                      snapshot.data.documents[index].data['discPercentage']+"%",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    IconButton(icon: Icon(Icons.delete),
                                    onPressed: (){
                                      DocumentSnapshot doc= snapshot.data.documents[index];

                                      Firestore.instance.collection(discount_coupons_collection)
                                          .document(doc.documentID)
                                          .delete();
                                    },
                                    )
                                  ],
                                ),
                              );
                            });
                    }
                  },
                ),
              ),
            ],
          ),

          ///DeliveryTimeSection
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[SizedBox(height: 20,),
              ///Available Coupons Section
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 16, top: 4),
                child: Text(
                  "Manage Delivery Timings",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 100,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                padding:
                EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white70),
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection(delivery_timings_collection)
                  .orderBy('deliveryTime')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                            child: CircularProgressIndicator());
                        break;
                      default:
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            //scrollDirection: Axis.horizontal,
                            itemCount:
                            snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              return Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      snapshot
                                          .data
                                          .documents[index]
                                          .data["deliveryTime"],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight:
                                          FontWeight.w500,
                                          color: Theme.of(context).primaryColor),
                                    ),
                                    FlatButton(onPressed: (){
                                      Firestore.instance.collection(delivery_timings_collection)
                                          .document(snapshot.data.documents[index].documentID).updateData({
                                        'status':snapshot.data.documents[index].data['status'] == 'active'?
                                            'disabled':'active'
                                      });
                                    },
                                      child: Text(
                                        snapshot
                                            .data
                                            .documents[index]
                                            .data["status"]=='active'?'disable':'activate',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight.w400,
                                            color: Colors.grey),
                                      ),

                                    )
                                  ],
                                ),
                              );
                            });
                    }
                  },
                ),
              ),
              Container(
                height: 300,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                padding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white70),
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection(delivery_schedule_collection)
                  .orderBy('t')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                            child: CircularProgressIndicator());
                        break;
                      default:
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            //scrollDirection: Axis.horizontal,
                            itemCount:
                            snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              return Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      snapshot
                                          .data
                                          .documents[index]
                                          .data["deliveryTime"],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight:
                                          FontWeight.w500,
                                          color: Theme.of(context).primaryColor),
                                    ),

                                    FlatButton(onPressed: (){
                                      Firestore.instance.collection(delivery_schedule_collection)
                                          .document(snapshot.data.documents[index].documentID).updateData({
                                        'status':snapshot.data.documents[index].data['status'] == 'active'?
                                        'disabled':'active'
                                      });
                                    },
                                      child: Text(
                                        snapshot
                                            .data
                                            .documents[index]
                                            .data["status"]=='active'?'disable':'activate',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight.w400,
                                            color: Colors.grey),
                                      ),

                                    )
                                  ],
                                ),
                              );
                            });
                    }
                  },
                ),
              ),


            ],
          ),

          SizedBox(height: 20,),

        ],
      ),),
    );
  }
}
