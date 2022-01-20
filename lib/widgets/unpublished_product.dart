import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utem_foodir_vendor/screens/edit_view_product.dart';
import 'package:utem_foodir_vendor/services/firebase_services.dart';

class UnPublishedProducts extends StatefulWidget {
  const UnPublishedProducts({Key? key}) : super(key: key);

  @override
  _UnPublishedProductsState createState() => _UnPublishedProductsState();
}

class _UnPublishedProductsState extends State<UnPublishedProducts> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();

    List<DataRow> _productDetails(QuerySnapshot? snapshot, context) {
      List<DataRow> newList = snapshot!.docs.map((DocumentSnapshot document) {
        return DataRow(cells: [
          DataCell(Container(
            child: Text(document['productName']),
          )),
          DataCell(Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Image.network(
                  document['productImage'],
                  width: 50,
                )
              ]),
            ),
          )),
          DataCell(IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditViewProduct(productId: document['productId'])));
            },
          )),
          DataCell(popupButton(document, context: context)),
        ]);
      }).toList();
      return newList;
    }

    return Container(
      child: StreamBuilder(
        stream: _services.product
            .where('published', isEqualTo: false)
            .where('seller.sellerUid', isEqualTo: user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong...');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: FittedBox(
              child: DataTable(
                showBottomBorder: true,
                dataRowHeight: 60,
                headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                columns: <DataColumn>[
                  DataColumn(label: Expanded(child: Text('Product Name'))),
                  DataColumn(label: Text('Image')),
                  DataColumn(label: Text('Info')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _productDetails(snapshot.data as QuerySnapshot, context),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget popupButton(data, {required BuildContext context}) {
    FirebaseServices _services = FirebaseServices();

    return PopupMenuButton<String>(
      onSelected: (String value) {
        if (value == 'publish') {
          _services.publishProduct(id: data['productId']);
        }
        if (value == 'delete') {
          _services.deleteProduct(id: data['productId']);
        }
      },
      itemBuilder: (BuildContext conetxt) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'publish',
          child: ListTile(
            leading: Icon(Icons.check),
            title: Text('Publish'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete_outline),
            title: Text('Delete Product'),
          ),
        ),
      ],
    );
  }
}
