import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utem_foodir_vendor/services/firebase_services.dart';

class DeliveryBoysList extends StatefulWidget {
  DocumentSnapshot orderDocument;
  DeliveryBoysList({Key? key, required this.orderDocument}) : super(key: key);

  @override
  _DeliveryBoysListState createState() => _DeliveryBoysListState();
}

class _DeliveryBoysListState extends State<DeliveryBoysList> {
  FirebaseServices _firebaseServices = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              backgroundColor: Colors.orange,
              title: Text(
                'Select Delivery Boy',
                style: TextStyle(color: Colors.white),
              ),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firebaseServices.boys
                    .where('accVerified', isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Something Went Wrong'),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.size == 0) {
                    return Center(
                      child: Text('No Delivery Boys available'),
                    );
                  }
                  return ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map((document) {
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              EasyLoading.show(status: 'Assigning Boys');
                              _firebaseServices
                                  .selectBoys(
                                      widget.orderDocument.id,
                                      document['name'],
                                      document['imageUrl'],
                                      document['mobile'],
                                      document['email'])
                                  .then((value) {
                                EasyLoading.showSuccess(
                                    'Assigned Delivery Boy');
                              });
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Image.network(document['imageUrl']),
                            ),
                            title: Text(document['name']),
                            subtitle: Text(document['email']),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      _launchURL(document['mobile']);
                                    },
                                    icon: Icon(Icons.phone))
                              ],
                            ),
                          ),
                          Divider(
                            height: 2,
                            color: Colors.grey,
                          )
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _launchURL(number) async {
    if (!await launch('tel:$number')) throw 'Could not launch $number';
  }
}
