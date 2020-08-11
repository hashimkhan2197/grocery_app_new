import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/providers/category.dart';
import 'package:groceryapp/providers/collection_names.dart';
import 'package:groceryapp/providers/product.dart';
import 'package:groceryapp/style_functions.dart';
import 'package:groceryapp/widgets/custom_image_picker.dart';
import 'package:groceryapp/widgets/custom_update_image_picker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'dart:io';

// ignore: must_be_immutable
class UpdateProductSubcategoryPage extends StatefulWidget {
  static const routeName = "/updateProductsubPage";

  UpdateProductSubcategoryPage(
      {@required this.storeDocId,
      @required this.categoryDocId,
      @required this.productModel,
      @required this.subCatProductDocId});

  String storeDocId;
  String categoryDocId;
  String subCatProductDocId;
  ProductModel productModel;

  @override
  _UpdateProductSubcategoryPageState createState() =>
      _UpdateProductSubcategoryPageState();
}

class _UpdateProductSubcategoryPageState
    extends State<UpdateProductSubcategoryPage> {
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
    _productImageRef = widget.productModel.productImageRef;
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
            "Edit Subcategory",style: TextStyle(color: Colors.white,fontSize: 24)
        ),

      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 28,
            ),
            Text(
              'Edit Subcategory',
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
                        _pickedImage, widget.productModel.productImageRef),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      child: TextFormField(
                          initialValue: widget.productModel.productName,
                          validator: (val) {
                            if (val.trim().isEmpty) {
                              return "Name cannot be empty.";
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
                              .formTextFieldDecoration("Subcategory Name")),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      child: TextFormField(
                          initialValue: widget.productModel.productPrice,
                          validator: (val) {
                            bool isNumeric(String str) {
                              try {
                                var value = double.parse(str);
                                return true;
                              } on FormatException {
                                return false;
                              }
                            }

                            if (val.trim().isEmpty) {
                              return "Price cannot be empty.";
                            } else if (isNumeric(val.trim()) == false) {
                              return "Price must be a number";
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
                              final ProductModel updatedProduct = ProductModel(
                                  productDocId:
                                      widget.productModel.productDocId,
                                  productName: _productName,
                                  productPrice: _productPrice,
                                  productImageRef: _productImageRef);

                              //TODO Check values and navigate to new page
                              Provider.of<Product>(context, listen: false)
                                  .updateProductSubcategory(
                                      categoryDocId: widget.categoryDocId,
                                      storeDocId: widget.storeDocId,
                                      updatedProductModel: updatedProduct,
                                      subProductDocId:
                                          widget.subCatProductDocId,image: _newImageFile)
                                  .then((e) {
                                    Navigator.of(context).pop();
                                    // Provider.of<Products>(context).login();
                                  })
                                  .then((value) => {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text('Update Subcategory'),
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
                            'Save Changes',
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
                                .collection(category_collection)
                                .document(widget.categoryDocId)
                                .collection(products_collection)
                                .document(widget.subCatProductDocId)
                                .collection('subcat')
                                .document(widget.productModel.productDocId)
                                .delete()
                                .then((e) {
                                  Navigator.of(context).pop();
                                  // Provider.of<Products>(context).login();
                                })
                                .then((value) => {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text('Delete Subcategory'),
                                          content: Text(
                                              'The Subcategory has been deleted.'),
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
                            'Delete Subcategory',
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
