import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:utem_foodir_vendor/screens/home_screen.dart';
import 'package:utem_foodir_vendor/widgets/drawer_menu_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  num totalSale = 0;
  num totalOrder = 0;
  num totalProduct = 0;
  num rating = 0;
  String comment = '';
  String commenterName = '';
  String time = '';
  String orderId = '';
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('orders')
        .where('seller.sellerId', isEqualTo: user!.uid)
        .get()
        .then((value) {
      value.docs.forEach((value) {
        totalSale += value['total'];
      });
      setState(() {});
    });
    FirebaseFirestore.instance
        .collection('products')
        .where('seller.sellerUid', isEqualTo: user!.uid)
        .get()
        .then((value) {
      totalProduct = value.size;
      setState(() {});
    });
    FirebaseFirestore.instance
        .collection('ratings')
        .where('sellerId', isEqualTo: user!.uid)
        .get()
        .then((value) {
      rating = value.docs.elementAt(0)['rating'];
      comment = value.docs.elementAt(0)['comment'];
      time = value.docs.elementAt(0)['time'];
      orderId = value.docs.elementAt(0)['orderId'];
      FirebaseFirestore.instance
          .collection('users')
          .doc(value.docs.elementAt(0)['userId'])
          .get()
          .then((value) {
        commenterName = '${value['firstName']} ${value['lastName']}';
        print(commenterName);
        setState(() {});
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 127, 0, 1),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('vendors')
                    .doc(user!.uid)
                    .get(),
                builder: (context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        documentSnapshot) {
                  if (documentSnapshot.hasData) {
                    return documentSnapshot.data!.get('accVerified') == true
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: Colors.red,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.warning,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'Your account is not verified',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Please wait for admin to verify your account',
                                            style: TextStyle(fontSize: 13),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                  }

                  return Container();
                }),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Color.fromRGBO(214, 40, 40, 1),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Total Sales',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    'RM${totalSale.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Color.fromRGBO(252, 191, 73, 1),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Text(
                                'Total Products',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    '$totalProduct',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'Products',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 25),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Color.fromRGBO(234, 226, 183, 1),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: commenterName != ''
                        ? Column(
                            children: [
                              Text(
                                'Recent Rating From Customer',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  color: Color.fromARGB(255, 194, 230, 255),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        RatingBar.builder(
                                          initialRating: rating.toDouble(),
                                          direction: Axis.horizontal,
                                          itemSize: 40,
                                          allowHalfRating: true,
                                          ignoreGestures: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {},
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('(${rating.toStringAsFixed(1)})'),
                                        ListTile(
                                            title: Text(
                                              commenterName,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25),
                                            ),
                                            subtitle: Row(
                                              children: [
                                                Flexible(
                                                    child: Text(
                                                  comment == ''
                                                      ? 'No Comment'
                                                      : comment,
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ))
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(time),
                                  SizedBox(
                                    width: 5,
                                  )
                                ],
                              )
                            ],
                          )
                        : Center(
                            child: Text('No Reviews Yet'),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
