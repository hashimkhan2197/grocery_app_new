import 'package:flutter/material.dart';
import 'package:groceryapp/providers/category.dart';
import 'package:groceryapp/providers/product.dart';
import 'package:groceryapp/style_functions.dart';
import 'package:groceryapp/widgets/custom_image_picker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'dart:io';

// ignore: must_be_immutable
class AddProductPage extends StatefulWidget {
  static const routeName = "/addNewProductPage";

  AddProductPage({@required this.storeDocId, @required this.categoryDocId});

  String storeDocId;
  String categoryDocId;

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String _productName;

  String _productPrice='';
  var _isLoading;
  StyleFunctions styleFunctions = StyleFunctions();
  File _productImageFile;
  void _pickedImage(File image) {
    _productImageFile = image;
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
            "Add Product",style: TextStyle(color: Colors.white,fontSize: 24)
        ),

      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 28,
            ),
            Text(
              'New Product',
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
                    UserImagePicker(_pickedImage),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      child: TextFormField(
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
                          validator: (val) {
                            bool isNumeric(String str) {
                              try{
                                var value = double.parse(str);
                                return true;
                              } on FormatException {
                                return false;
                              }
                            }
                            if (val.trim().isEmpty) {
                              return null;
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
                            if (_productImageFile == null) {
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
                              final ProductModel newProduct = ProductModel(
                                  productDocId: "does not matter",
                                  productName: _productName,
                                  productPrice: _productPrice,
                                  productImageRef: "doesnot matter");
                              print(widget.storeDocId);

                              //TODO Check values and navigate to new page
                              Provider.of<Product>(context, listen: false)
                                  .addNewProduct(
                                      storeDocId: widget.storeDocId,
                                      categoryDocId: widget.categoryDocId,
                                      image: _productImageFile,
                                      productModel: newProduct)
                                  .then((e) {
                                    Navigator.of(context).pop();
                                    // Provider.of<Products>(context).login();
                                  })
                                  .then((value) => {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text('Product Created'),
                                            content: Text(
                                                'The New Product has been Created.'),
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
                            'Add Product',
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
