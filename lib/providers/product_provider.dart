import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier {
  String selectedCategory = 'Not selected';
  String selectedSubCategory = 'Not selected';
  String categoryImage = '';
  File image;
  String pickerError = '';
  String productUrl = '';
  String shopName = '';

  //need to bring shop name here

  selectCategory(mainCategory, categoryImage) {
    this.selectedCategory = mainCategory;
    this.categoryImage = categoryImage; //need to bring image here
    notifyListeners();
  }

  selectSubCategory(selected) {
    this.selectedSubCategory = selected;
    notifyListeners();
  }

  getShopName(shopName) {
    this.shopName = shopName;
    notifyListeners();
  }

  //upload product image
  Future<String> uploadProductImage(filePath, productName) async {
    File file = File(
        filePath); //need file path to upload, we already have it inside provider
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;

    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage
          .ref('productImage/${this.shopName}/$productName$timeStamp')
          .putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }
    //now after upload file we need to get file url path to save in database
    String downloadURL = await _storage
        .ref('productImage/${this.shopName}/$productName$timeStamp')
        .getDownloadURL();
    this.productUrl = downloadURL;
    notifyListeners();
    return downloadURL;
  }

  Future<File> getProductImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);

    if (pickedFile != null) {
      this.image = File(pickedFile.path);
      notifyListeners();
    } else {
      this.pickerError = 'No image selected';
      print('No image selected');
      notifyListeners();
    }
    return this.image;
  }

  alertDialog({context, title, content}) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  //save product data to firestore
  Future<void> saveProductDataToDb(
      {productName,
      description,
      price,
      collection,
      brand,
      sku,
      comparedPrice,
      weight,
      tax,
      stockQty,
      lowStockQty,
      context}) {
    //need to bring these details from Add Product Screen

    var timeStamp =
        DateTime.now().microsecondsSinceEpoch; //will use this as product id
    User user = FirebaseAuth.instance.currentUser;

    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    try {
      _products.doc(timeStamp.toString()).set({
        'seller': {'shopName': this.shopName, 'sellerUid': user.uid},
        'productName': productName,
        'description': description,
        'price': price,
        'comparedPrice': comparedPrice,
        'collection': collection,
        'brand': brand,
        'sku': sku,
        'category': {
          'mainCategory': this.selectedSubCategory,
          'subCategory': this.selectedSubCategory,
          'categoryImage': this.categoryImage
        },
        'weight': weight,
        'tax': tax,
        'stockQty': stockQty,
        'lowStockQty': lowStockQty,
        'published': false, //keep initial value as false
        'productId': timeStamp.toString(),
        'productImage': this.productUrl
      });
      this.alertDialog(
          context: context,
          title: 'SAVE DATA',
          content: 'Product Details saved successfully');
    } catch (e) {
      this.alertDialog(
          context: context, title: 'SAVE DATA', content: '${e.toString()}');
    }
    return null;
  }
}
