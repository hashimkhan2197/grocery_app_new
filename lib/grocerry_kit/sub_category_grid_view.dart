import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/grocerry_kit/category_products_package/add_category.dart';
import 'package:groceryapp/grocerry_kit/category_products_package/update_product_subcategory.dart';
import 'package:groceryapp/providers/category.dart';
import 'package:groceryapp/providers/collection_names.dart';
import 'package:groceryapp/providers/product.dart';
import 'package:provider/provider.dart';

import 'category_products_package/add_product.dart';
import 'category_products_package/add_product_subcategory.dart';
import 'category_products_package/update_category.dart';
import 'category_products_package/update_product.dart';

class SubcategoryGridView extends StatefulWidget {
  final String storeDocId;
  final String categoryDocid;
  final String subProductDocid;
  final String productName;

  SubcategoryGridView(
      {@required this.storeDocId,
      @required this.categoryDocid,
      @required this.productName,
      @required this.subProductDocid});

  @override
  _SubcategoryGridViewState createState() => _SubcategoryGridViewState();
}

class _SubcategoryGridViewState extends State<SubcategoryGridView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: true,
        title: Text(
          widget.productName,
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return AddProductSubcategoryPage(storeDocId: widget.storeDocId,
                    categoryDocId: widget.categoryDocid,
                    subCatProductDocId: widget.subProductDocid,);
                }));
              },
              child: Row(
                children: <Widget>[Padding(
                  padding: const EdgeInsets.only(right:8.0),
                  child: Text("Add subcat",style: TextStyle(color: Colors.white),),
                )],
              ))
        ],
      ),
      body: Container(
        child: categoryItems(),
      ),
    );
  }

  Widget categoryItems() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: StreamBuilder(
          stream: Firestore.instance
              .collection(stores_collection)
              .document(widget.storeDocId)
              .collection(category_collection)
              .document(widget.categoryDocid)
              .collection(products_collection)
          .document(widget.subProductDocid).collection('subcat')
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final snapShotData = snapshot.data.documents;
            if (snapShotData.length == 0) {
              return Center(
                child: Text("No subcategories."),
              );
            }
            return GridView.builder(
                itemCount: snapShotData.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  var data = snapshot.data.documents[index];
                  ProductModel product =
                      Provider.of<Product>(context).convertToProductModel(data);
                  return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(10),
                          width: 130,
                          height: 130,
                          alignment: Alignment.bottomCenter,
                          child: Image(
                            fit: BoxFit.cover,
                            //alignment: Alignment.topRight,
                            image: NetworkImage(product.productImageRef),
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(4),
                            //color: Theme.of(context).scaffoldBackgroundColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 5),
                                blurRadius: 15,
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 130,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            product.productName,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        Container(
                          width: 130,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                product.productPrice == ''
                                    ? " "
                                    : " " + product.productPrice + " SEK",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return UpdateProductSubcategoryPage(
                                      storeDocId: widget.storeDocId,
                                      categoryDocId: widget.categoryDocid,
                                      productModel: product,
                                      subCatProductDocId: widget.subProductDocid,
                                    );
                                  }));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Icon(
                                    Icons.edit,
                                    size: 20,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ]);
                });
          }),
    );
  }
}
