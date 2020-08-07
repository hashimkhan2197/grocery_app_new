import 'package:flutter/material.dart';
import 'package:groceryapp/grocerry_kit/store_package/stores_list_screen.dart';
import 'package:groceryapp/providers/store.dart';
import 'package:groceryapp/style_functions.dart';
import 'package:groceryapp/widgets/custom_image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class AddStorePage extends StatefulWidget {
  static const routeName = "/addNewStore";

  @override
  _AddStorePageState createState() => _AddStorePageState();
}

class _AddStorePageState extends State<AddStorePage> {
  final _formKey = GlobalKey<FormState>();
  String _storeName;
  String _storeAddress;
  File _storeImageFile;
  var _isLoading;
  bool _isObscured = true;
  Color _eyeButtonColor = Colors.grey[700];
  StyleFunctions styleFunctions = StyleFunctions();

  ///To make sure we pick an image and get it from another class
  void _pickedImage(File image) {
    _storeImageFile = image;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: BottomBar(),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Add Store",
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 28,
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
//                    SizedBox(
//                      height: 10,
//                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      child: UserImagePicker(_pickedImage),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      child: TextFormField(
                          validator: (val) {
                            if (val
                                .trim()
                                .isEmpty) {
                              return "Name cannot be empty.";
                            } else if (val
                                .trim()
                                .length > 30) {
                              return "Name cannot be 30+ characters";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            _storeName = val.trim();
                          },
                          keyboardType: TextInputType.text,
                          style: styleFunctions.formFieldTextStyle(),
                          decoration: styleFunctions
                              .formTextFieldDecoration("Store Name")),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      child: TextFormField(
                          validator: (val) {
                            if (val
                                .trim()
                                .isEmpty) {
                              return "Address cannot be empty.";
                            } else if (val
                                .trim()
                                .length > 300) {
                              return "Name cannot be 300+ characters";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            _storeAddress = val.trim();
                          },
                          keyboardType: TextInputType.text,
                          style: styleFunctions.formFieldTextStyle(),
                          decoration: styleFunctions
                              .formTextFieldDecoration("Store Addresss")),
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
                            if (_storeImageFile == null) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('Please pick an image'),
                                backgroundColor: Theme
                                    .of(context)
                                    .errorColor,));
                              return;
                            }
                            if (_formKey.currentState.validate()) {
                              //Only gets here if the fields pass
                              _formKey.currentState.save();
                              final StoreModel newStore = StoreModel(
                                  storeAddress: _storeAddress,
                                  storeDocId: "not necessary",
                                  storeId: 'nothing',
                                  storeName: _storeName,
                                  storePassword: 'nothing',
                                  storeImageRef: "doesnotMatter");
                              //TODO Check values and navigate to new page
                              Provider.of<Store>(context, listen: false)
                                  .addNewStore(newStore,_storeImageFile)
                                  .then((e) {
                                Navigator.of(context)
                                    .pushNamedAndRemoveUntil(
                                    StoresListPage.routeName,
                                        (Route<dynamic> route) => false);
                                // Provider.of<Products>(context).login();
                              })
                                  .then((value) =>
                              {
                                showDialog(
                                  context: context,
                                  builder: (ctx) =>
                                      AlertDialog(
                                        title: Text('Store Created'),
                                        content: Text(
                                            'The New Store has been Created.'),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text(
                                              'Okay',
                                              style: TextStyle(
                                                  color: Theme
                                                      .of(context)
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
                                  builder: (ctx) =>
                                      AlertDialog(
                                        title: Text('An error occurred!'),
                                        content: Text(
                                            e.toString()),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('Okay',
                                                style: TextStyle(
                                                    color: Theme
                                                        .of(context)
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
                          color: Theme
                              .of(context)
                              .primaryColor,
                          //Color.fromRGBO(58, 66, 86, 1.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Text(
                            'Add Store',
                            style: Theme
                                .of(context)
                                .primaryTextTheme
                                .button,
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
