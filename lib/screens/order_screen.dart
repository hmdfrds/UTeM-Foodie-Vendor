import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:utem_foodir_vendor/providers/order_provider.dart';
import 'package:utem_foodir_vendor/services/order_services.dart';
import 'package:utem_foodir_vendor/widgets/order_sumary_card.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);
  static const String id = 'order-screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrderServices _orderServices = OrderServices();
  User? user = FirebaseAuth.instance.currentUser;

  int tag = 0;
  List<String> options = [
    'All Orders',
    'Ordered',
    'Accepted',
    'Picked Up',
    'On The Way',
    'Delivered',
  ];

  Color? statusColors(document) {
    if (document['currentOrderStatus'] == 'Rejected') {
      return Colors.red;
    }
    if (document['currentOrderStatus'] == 'Accepted') {
      return Colors.blueGrey[400];
    }
    if (document['currentOrderStatus'] == 'Picked Up') {
      return Colors.pink[900];
    }
    if (document['currentOrderStatus'] == 'On The Way') {
      return Colors.deepPurpleAccent;
    }
    if (document['currentOrderStatus'] == 'Delivered') {
      return Colors.green;
    }
    return Colors.orangeAccent;
  }

  @override
  Widget build(BuildContext context) {
    var _orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(children: [
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            color: Colors.orange,
            child: Center(
              child: Text(
                'My Orders',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: ChipsChoice<int>.single(
              value: tag,
              onChanged: (val) => setState(() {
                tag = val;
                if (val > 0) {
                  _orderProvider.filterOrder(options[val]);
                } else {
                  _orderProvider.filterOrder(null);
                }
              }),
              choiceItems: C2Choice.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
              choiceStyle: C2ChoiceStyle(
                color: Colors.red,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
            ),
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: _orderServices.orders
                  .where('seller.sellerId', isEqualTo: user!.uid)
                  .where('currentOrderStatus', isEqualTo: _orderProvider.status)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data!.size == 0) {
                  return Center(
                    child: Text('No ${options[tag]} Order.'),
                  );
                }

                return Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: snapshot.data!.docs.map((document) {
                      return OrderSumarryCard(document: document);
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ]));
  }
}
