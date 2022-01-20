import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference category =
      FirebaseFirestore.instance.collection('category');
  CollectionReference product =
      FirebaseFirestore.instance.collection('products');
  CollectionReference vendorBanner =
      FirebaseFirestore.instance.collection('vendorbanner');
  CollectionReference boys = FirebaseFirestore.instance.collection('boys');
  CollectionReference vendors =
      FirebaseFirestore.instance.collection('vendors');
        CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');
              CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<void> publishProduct({id}) {
    return product.doc(id).update({
      'published': true,
    });
  }

  Future<void> unPublishProduct({id}) {
    return product.doc(id).update({
      'published': false,
    });
  }

  Future<void> deleteProduct({id}) {
    return product.doc(id).delete();
  }

  Future<void> saveBanenr(url) {
    return vendorBanner.add({
      'imageUrl': url,
      'sellerUid': user!.uid,
    });
  }

  Future<void> deleteBanner({id}) {
    return vendorBanner.doc(id).delete();
  }

  Future<DocumentSnapshot> getShopDetails() async {
    return await vendors.doc(user!.uid).get();
    
  }

  Future<DocumentSnapshot> getCustomerDetail(id) async {
    return await users.doc(id).get();
    
  }

    Future<void> selectBoys(orderId, name, image, phone,email) {
    return orders.doc(orderId).update({
      'deliveryBoy':{
        'email': email,
        'name': name,
        'image':image,
        'phone': phone,
      }
    });
  }
}
