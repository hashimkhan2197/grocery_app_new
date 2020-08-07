import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/grocerry_kit/category_grid_view_Page.dart';
import 'package:groceryapp/grocerry_kit/category_products_package/add_category.dart';
import 'package:groceryapp/grocerry_kit/category_products_package/add_product.dart';
import 'package:groceryapp/grocerry_kit/category_products_package/update_category.dart';
import 'package:groceryapp/grocerry_kit/category_products_package/update_product.dart';
import 'package:groceryapp/grocerry_kit/product_grid_view_page.dart';
import 'package:groceryapp/grocerry_kit/store_package/stores_list_screen.dart';
import 'package:groceryapp/grocerry_kit/sub_pages/cart.dart';
import 'package:groceryapp/grocerry_kit/sub_pages/order_history.dart';
import 'package:groceryapp/providers/category.dart';
import 'package:groceryapp/providers/collection_names.dart';
import 'package:groceryapp/providers/product.dart';
import 'package:groceryapp/utils/cart_icons_icons.dart';
import 'package:provider/provider.dart';

import '../sub_category_grid_view.dart';

class HomeList extends StatefulWidget {
  HomeList(this.storeDocId,this.storeName);

  final String storeDocId;
  final String storeName;

  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,


        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(StoresListPage.routeName);
                },
                child: Text("Change Stores",style:TextStyle(color: Colors.white,
                    fontSize: 16,fontWeight: FontWeight.w500))),
            Text(
             widget.storeName ,
              style: TextStyle(color: Colors.white),
            ),
            GestureDetector(
                onTap: () {
//                  Navigator.of(context).pushNamed(OrderHistory.routeName);
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.shopping_cart,color: Colors.white,),
                  Icon(Icons.arrow_forward,color: Colors.white,)
                  ],
                )),
          ],
        ),
      ),
      body: Container(
        color: const Color(0xffF4F7FA),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 4),
                  child: Text(
                    'All Categories',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 4),
                  child: FlatButton(
                    onPressed: () {
                      //print(widget.storeDocId);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AddCategoryPage(widget.storeDocId);
                      }));
                    },
                    child: Text(
                      'Add Category',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 4),
                  child: FlatButton(
                    onPressed: () {
                      //print(widget.storeDocId);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return CategoryGridView(widget.storeDocId);
                          }));
                    },
                    child: Text(
                      'more..',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ],
            ),
            _buildCategoryList(),
            _buildCategoryList2()
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    //var items = addItems();
    return Container(
        height: 190,
        alignment: Alignment.centerLeft,
        child: StreamBuilder(
            stream: Firestore.instance
                .collection(stores_collection)
                .document(widget.storeDocId)
                .collection(category_collection)
                .snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                  break;
                default:
                  return snapshot.data.documents.length == 0
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("No categories added."),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.documents.length >3 ? 3 : snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data.documents[index];
                            var category = Provider.of<Category>(context)
                                .convertToCategoryModel(data);
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, top: 12),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) {
                                              return ProductGridView(
                                                  widget.storeDocId,category.categoryDocId,
                                                  category.categoryName
                                              );
                                            }));
                                      },
                                      child: CircleAvatar(
                                        maxRadius: 70,
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        backgroundImage: NetworkImage(
                                            category.categoryImageRef),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          category.categoryName+ " ",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) {
                                                  return UpdateCategoryPage(
                                                    storeDocId: widget.storeDocId,
                                                    categoryModel: category,
                                                  );
                                                }));
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            size: 22,
                                          ),
                                        )
                                      ],
                                    )
                                  ]),
                            );
                          },
                        );
              }
            }));
  }

  Widget _buildCategoryList2() {
    //var items = addItems();
    return StreamBuilder(
        stream: Firestore.instance
            .collection(stores_collection)
            .document(widget.storeDocId)
            .collection(category_collection)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
              break;
            default:
              return snapshot.data.documents.length == 0
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("No categories added."),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data.documents[index];
                        var category = Provider.of<Category>(context)
                            .convertToCategoryModel(data);
                        return Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 16, top: 4),
                                  child: Text(
                                    category.categoryName,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 16, top: 4),
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return AddProductPage(
                                          storeDocId: widget.storeDocId,
                                          categoryDocId: category.categoryDocId,
                                        );
                                      }));
                                    },
                                    child: Text(
                                      'Add Product',
                                      style: TextStyle(color: Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 16, top: 4),
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                            return ProductGridView(widget.storeDocId,
                                              category.categoryDocId,category.categoryName
                                            );
                                          }));
                                    },
                                    child: Text(
                                      'more..',
                                      style: TextStyle(color: Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            _buildCategoryProductsList(category.categoryDocId),
                          ],
                        );
                      },
                    );
          }
        });
  }

  Widget _buildCategoryProductsList(String categoryDocId) {
    //var items = addItems();
    return Container(
        height: 200,
        alignment: Alignment.centerLeft,
        child: StreamBuilder(
            stream: Firestore.instance
                .collection(stores_collection)
                .document(widget.storeDocId)
                .collection(category_collection)
                .document(categoryDocId)
                .collection(products_collection)
                .snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                  break;
                default:
                  return snapshot.data.documents.length == 0
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("No Products added."),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.documents.length > 3? 3 : snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data.documents[index];
                            ProductModel product = Provider.of<Product>(context)
                                .convertToProductModel(data);
                            return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context){
                                        return SubcategoryGridView(storeDocId: widget.storeDocId,
                                          categoryDocid: categoryDocId,
                                          productName: product.productName,
                                          subProductDocid: product.productDocId,);
                                      }));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      width: 130,
                                      height: 130,
                                      alignment: Alignment.bottomCenter,
                                      child: Image(
                                        fit: BoxFit.cover,
                                        //alignment: Alignment.topRight,
                                        image:
                                            NetworkImage(product.productImageRef),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[

                                        Text(product.productPrice == '' ? " ":
                                             " "+ product.productPrice +
                                              " SEK",
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return UpdateProductPage(
                                                storeDocId: widget.storeDocId,
                                                categoryDocId: categoryDocId,
                                                productModel: product,
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
                          },
                        );
              }
            }));
  }
}
