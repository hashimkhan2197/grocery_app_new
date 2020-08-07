import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/providers/collection_names.dart';
import 'dart:io';

class ProductModel {
  String productDocId;
  String productName;
  String productPrice;
  String productImageRef;

  ProductModel(
      {@required this.productPrice,
      @required this.productName,
      @required this.productDocId,
      @required this.productImageRef});
}

class Product with ChangeNotifier {
  ///naming conventions for store model for firebase
  String _productName = "productName";
  String _productPrice = "productPrice";
  String _productImageRef = "productImage";

  ProductModel _storeProfile;

  ProductModel get storeProfile => _storeProfile;

  Future<void> addNewProduct(
      {@required ProductModel productModel,
      @required File image,
      @required String storeDocId,
      @required String categoryDocId}) async {
    var ran = new Random();
    final ref =
        FirebaseStorage.instance.ref().child('images').child(DateTime.now().toString()+ ".jpg");
    await ref.putFile(image).onComplete;

    final url = await ref.getDownloadURL();

    await Firestore.instance
        .collection(stores_collection)
        .document(storeDocId)
        .collection(category_collection)
        .document(categoryDocId)
        .collection(products_collection)
        .add({
      _productName: productModel.productName,
      _productPrice: productModel.productPrice,
      _productImageRef: url
    }).catchError((error) {
      throw error;
    });
    notifyListeners();
  }
  Future<void> addNewProductSubcategory(
      {@required ProductModel productModel,
        @required File image,
        @required String storeDocId,
        @required String categoryDocId,
      @required String subProductDocId}) async {
    var ran = new Random();
    final ref =
    FirebaseStorage.instance.ref().child('images').child(DateTime.now().toString()+".jpg");
    await ref.putFile(image).onComplete;

    final url = await ref.getDownloadURL();

    await Firestore.instance
        .collection(stores_collection)
        .document(storeDocId)
        .collection(category_collection)
        .document(categoryDocId)
        .collection(products_collection).document(subProductDocId)
        .collection('subcat').add({
      _productName: productModel.productName,
      _productPrice: productModel.productPrice,
      _productImageRef: url
    }).catchError((error) {
      throw error;
    });
    notifyListeners();
  }


  Future<void> updateProduct(
      {@required ProductModel updatedProductModel,
      @required String storeDocId,
      @required categoryDocId}) async {
    await Firestore.instance
        .collection(stores_collection)
        .document(storeDocId)
        .collection(category_collection)
        .document(categoryDocId)
        .collection(products_collection)
        .document(updatedProductModel.productDocId)
        .updateData({
      _productName: updatedProductModel.productName,
      _productPrice: updatedProductModel.productPrice,
    }).catchError((error) {
      throw error;
    });
    notifyListeners();
  }

  Future<void> updateProductSubcategory(
      {@required ProductModel updatedProductModel,
        @required String storeDocId,
        @required categoryDocId,
      @required subProductDocId}) async {
    await Firestore.instance
        .collection(stores_collection)
        .document(storeDocId)
        .collection(category_collection)
        .document(categoryDocId)
        .collection(products_collection).document(subProductDocId)
        .collection('subcat')
        .document(updatedProductModel.productDocId)
        .updateData({
      _productName: updatedProductModel.productName,
      _productPrice: updatedProductModel.productPrice,
    }).catchError((error) {
      throw error;
    });
    notifyListeners();
  }

  ProductModel convertToProductModel(DocumentSnapshot docu) {
    var doc = docu.data;
    return ProductModel(
        productDocId: docu.documentID,
        productName: doc[_productName],
        productPrice: doc[_productPrice],
        productImageRef: doc[_productImageRef]);
  }
}
