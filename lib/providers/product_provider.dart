import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier {
  String? selectedCategory;
  String? selectedSubCategory;
  String? categoryImage;
  File? image;
  String? pickerError;
  String? shopName;
  String? productUrl;

  selectCategory(selectedCategory, categoryImage) {
    this.selectedCategory = selectedCategory;
    this.categoryImage = categoryImage;
    notifyListeners();
  }

  selectSubCategory(selected) {
    selectedSubCategory = selected;
    notifyListeners();
  }

  
    Future<File?> _cropImage(img) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: img!.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1)
       
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        iosUiSettings: const IOSUiSettings(
          title: 'Crop Image',
        ));
    if (croppedFile != null) {
      img = croppedFile;
    } else {
      pickerError = 'No image selected.';
    }
    return img;
  }

  Future<File?> getProductImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
    final croptedFile = await _cropImage(pickedFile);

    if (croptedFile != null) {
      image = File(croptedFile.path);
    } else {
      pickerError = 'No image selected.';
    }
    notifyListeners();
    return image;
  }

  alertDialog({context, title, content}) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  resetProvider() {
    selectedCategory = null;
    selectedSubCategory = null;
    categoryImage = null;
    image = null;
    productUrl = null;
  }

  Future<String> uploadProductImage(image, productName) async {
    FirebaseStorage _storage = FirebaseStorage.instance;
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;
    try {
      await _storage
          .ref('productImage/$shopName/$productName$timeStamp')
          .putFile(image!);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }
    String downloadURL = await _storage
        .ref('productImage/$shopName/$productName$timeStamp')
        .getDownloadURL();
    productUrl = downloadURL;
    return downloadURL;
  }

  getShopName(shopName) {
    this.shopName = shopName;
  }

  Future<void>? saveProductDataToDb(
    
    productName,
    description,
    price,

    collection,

    stockQuantity,
    stockLowQuantity,
    context,
  ) {
    var timeStamp = DateTime.now().microsecondsSinceEpoch;
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    try {
      _products.doc(timeStamp.toString()).set({
        'seller': {'shopName': shopName, 'sellerUid': user!.uid},
        'productName': productName,
        'description': description,
        'price': price,

        'collection': collection,

        'category': {
          'mainCategory': selectedCategory,
          'subCategory': selectedSubCategory,
          'categoryImage': categoryImage
        },

        'stockQuantity': stockQuantity,
        'stockLowQuantity': stockLowQuantity,
        'published': false,
        'productId': timeStamp.toString(),
        'productImage': productUrl
      });
      alertDialog(
          content: 'Product Details saved successfully',
          title: 'SAVE DATA',
          context: context);
    } catch (e) {
      alertDialog(context: context, title: 'SAVE DATA', content: e.toString());
    }
    return null;
  }

  Future<void>? updateProduct(
    productName,
    description,
    price,

    collection,

    stockQuantity,
    stockLowQuantity,
    context,
    productId,
    productImage,
    category,
    subCategory,
    categoryImage,
  ) {

    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    try {
      _products.doc(productId).update({
        'productName': productName,
        'description': description,
        'price': price,
        'collection': collection,
        'category': {
          'mainCategory': category,
          'subCategory': subCategory,
          'categoryImage':
              categoryImage != null ? categoryImage : this.categoryImage,
        },
        'stockQuantity': stockQuantity,
        'stockLowQuantity': stockLowQuantity,
        'productImage':
            this.productUrl == null ? productImage : this.productUrl,
      });
      alertDialog(
          content: 'Product Details saved successfully',
          title: 'SAVE DATA',
          context: context);
    } catch (e) {
      alertDialog(context: context, title: 'SAVE DATA', content: e.toString());
    }
    return null;
  }
}
