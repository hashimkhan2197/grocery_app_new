import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/providers/category.dart';
import 'package:groceryapp/providers/collection_names.dart';
import 'package:groceryapp/providers/product.dart';
import 'package:groceryapp/providers/store.dart';
import 'package:groceryapp/style_functions.dart';
import 'package:groceryapp/widgets/custom_image_picker.dart';
import 'package:groceryapp/widgets/custom_update_image_picker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'dart:io';

// ignore: must_be_immutable
class EditStorePage extends StatefulWidget {
  static const routeName = "/updateProductPage";

  EditStorePage(
      {@required this.storeDocId,
        @required this.storeModel});

  String storeDocId;
  StoreModel storeModel;

  @override
  _EditStorePageState createState() => _EditStorePageState();
}

class _EditStorePageState extends State<EditStorePage> {
  final _formKey = GlobalKey<FormState>();
  String _productName;
  String _productImageRef;
  String _productPrice;
  File _newImageFile;
  var _isLoading;
  StyleFunctions styleFunctions = StyleFunctions();

  void _pickedImage(File image) {
    _newImageFile = image;
  }

  @override
  void initState() {
    _productImageRef = widget.storeModel.storeImageRef;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: BottomBar(),
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        elevation: 0,
        backgroundColor: Hexcolor('#0644e3'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        title: Text(
            "Edit Product",style: TextStyle(color: Colors.white,fontSize: 24)
        ),

      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 28,
            ),
            Text(
              'Edit Product',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    UserUpdateImagePicker(
                        _pickedImage, widget.storeModel.storeImageRef),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      child: TextFormField(
                          initialValue: widget.storeModel.storeName,
                          validator: (val) {
                            if (val.trim().isEmpty) {
                              return "Product Name cannot be empty.";
                            } else if (val.trim().length > 30) {
                              return "Name cannot be 30+ characters";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            _productName = val.trim();
                          },
                          keyboardType: TextInputType.text,
                          style: styleFunctions.formFieldTextStyle(),
                          decoration: styleFunctions
                              .formTextFieldDecoration("Product Name")),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      child: TextFormField(
                          initialValue: widget.storeModel.storeAddress,
                          validator: (val) {

                            if (val.trim().isEmpty) {
                              return null;
                            }
                            return null;
                          },
                          onSaved: (val) {
                            _productPrice = val.trim();
                          },
                          keyboardType: TextInputType.number,
                          style: styleFunctions.formFieldTextStyle(),
                          decoration: styleFunctions
                              .formTextFieldDecoration("Product Price")),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    Align(
                      child: SizedBox(
                        height: 50.0,
                        width: 270.0,
                        child: FlatButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              //Only gets here if the fields pass
                              _formKey.currentState.save();
                              final StoreModel updatedProduct = StoreModel(
                                  storeDocId:
                                  widget.storeModel.storeDocId,
                                  storeName:  _productName,
                                  storeAddress: _productPrice,
                                  storeImageRef: _productImageRef,storeId: '',storePassword: '');

                              //TODO Check values and navigate to new page
                              Provider.of<Store>(context, listen: false)
                                  .updateStore(
                                  updatedProduct,widget.storeDocId,_newImageFile)
                                  .then((e) {
                                Navigator.of(context).pop();
                                // Provider.of<Products>(context).login();
                              })
                                  .then((value) => {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Update Store'),
                                    content: Text(
                                        'Your changes have been saved.'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          'Okay',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                      )
                                    ],
                                  ),
                                )
                              })
                                  .catchError((e) {
                                print(e);
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('An error occurred!'),
                                    content: Text(
                                        'Something went wrong. Please Try again later.'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Okay',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                      )
                                    ],
                                  ),
                                );
                              });
                            }
                          },
                          color: Theme.of(context).primaryColor,
                          //Color.fromRGBO(58, 66, 86, 1.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Text(
                            'SaveChanges',
                            style: Theme.of(context).primaryTextTheme.button,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Align(
                      child: SizedBox(
                        height: 50.0,
                        width: 270.0,
                        child: FlatButton(
                          onPressed: () {
                            //Only gets here if the fields pass
                            //TODO Check values and navigate to new page
                            Firestore.instance
                                .collection(stores_collection)
                                .document(widget.storeDocId)
                                .delete()
                                .then((e) {
                              Navigator.of(context).pop();
                              // Provider.of<Products>(context).login();
                            })
                                .then((value) => {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Delete Store'),
                                  content: Text(
                                      'The store has been deleted.'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        'Okay',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor),
                                      ),
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                    )
                                  ],
                                ),
                              )
                            })
                                .catchError((e) {
                              print(e);
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('An error occurred!'),
                                  content: Text(
                                      'Something went wrong. Please Try again later.'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Okay',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                    )
                                  ],
                                ),
                              );
                            });
                          },
                          color: Theme.of(context).primaryColor,
                          //Color.fromRGBO(58, 66, 86, 1.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Text(
                            'Delete store',
                            style: Theme.of(context).primaryTextTheme.button,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
