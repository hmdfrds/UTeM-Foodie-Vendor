import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AuthProvider extends ChangeNotifier {
  File? image;
  bool isPicAvail = false;
  String pickerError = "";
  String error = "";
  String mobile = "";
  String email = "";
  String shopName = "";

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

  Future<File?> getImage() async {
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

  Future<UserCredential?> registerVendor(email, password) async {
    this.email = email;
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      error = e.code;
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
    return userCredential;
  }

   Future<UserCredential?> checkUserThenLogin(
      String email, String password) async {
    return FirebaseFirestore.instance
        .collection('vendors')
        .where('email', isEqualTo: email)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        try {
          return await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);
        } catch (e) {
          error = e.toString();
        }
      } else {
        error = 'Looks like you are not a vendors!';
      }
    });
  }

  Future<UserCredential?> loginVendor(email, password) async {
    this.email = email;
    UserCredential? userCredential;
    try {
      userCredential = await checkUserThenLogin(email, password);
    } on FirebaseAuthException catch (e) {
      error = e.code;
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
    return userCredential;
  }

  Future<void> resetVendorPassword(email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      error = e.code;
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }

  Future<void>? saveVendorDataToDb(
      {String? url, String? shopName, String? mobile,String? location,String? about}) {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentReference _vendors =
        FirebaseFirestore.instance.collection('vendors').doc(user!.uid);
    _vendors.set({
      'uid': user.uid,
      'shopName': shopName,
      'about':about,
      'location':location,
      'mobile': mobile,
      'email': email,
      'shopOpen': true,
      'rating': 0.00,
      'totalRating': 0,
      'isTopPicked': false,
      'imageUrl': url,
      'accVerified': false,
    });
    return null;
  }
}
