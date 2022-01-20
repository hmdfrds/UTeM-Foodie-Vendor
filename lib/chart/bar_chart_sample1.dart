import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';

class BarChartSample1 extends StatefulWidget {
  final List<Color> availableColors = const [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];

  const BarChartSample1({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);
  User? user = FirebaseAuth.instance.currentUser;
  DateTime monday =
      DateTime.now().add(new Duration(days: -(DateTime.now().weekday - 1)));
  double totalOrderMonday = 0;
  double totalOrderTuesday = 0;
  double totalOrderWenesday = 0;
  double totalOrderThursday = 0;
  double totalOrderFriday = 0;
  double totalOrderSaturday = 0;
  double totalOrderSunday = 0;

  int touchedIndex = -1;

  bool isPlaying = false;

  @override
  void initState() {
    DateTime tuesday = monday.add(new Duration(days: 1));
    DateTime wenesday = monday.add(new Duration(days: 2));
    DateTime thursday = monday.add(new Duration(days: 3));
    DateTime friday = monday.add(new Duration(days: 4));
    DateTime saturday = monday.add(new Duration(days: 5));
    DateTime sunday = monday.add(new Duration(days: 6));

    FirebaseFirestore.instance
        .collection('orders')
        .where('seller.sellerId', isEqualTo: user!.uid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        // Timestamp myTimeStamp = Timestamp.fromDate(element['timestamp']);
        // DateTime myDateTime = myTimeStamp.toDate();
        var myDateTime = DateTime.parse(element['timestamp']);

        if (myDateTime.difference(monday).inDays == 0) {
          totalOrderMonday++;
        } else if (myDateTime.difference(tuesday).inDays == 0) {
          totalOrderTuesday++;
        } else if (myDateTime.difference(wenesday).inDays == 0) {
          totalOrderWenesday++;
        } else if (myDateTime.difference(thursday).inDays == 0) {
          totalOrderThursday++;
        } else if (myDateTime.difference(friday).inDays == 0) {
          totalOrderFriday++;
        } else if (myDateTime.difference(saturday).inDays == 0) {
          totalOrderSaturday++;
        } else if (myDateTime.difference(sunday).inDays == 0) {
          totalOrderSunday++;
        }
      });
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: const Color(0xff81e5cd),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: 600,
          height: 500,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Weekly',
                  style: TextStyle(
                      color: Color(0xff0f4a3c),
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  'Total Order Graph',
                  style: TextStyle(
                      color: Color(0xff379982),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 38,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: BarChart(
                            mainBarData(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 30,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.yellow] : [barColor],
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.yellow, width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 20,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, totalOrderMonday,
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, totalOrderTuesday,
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, totalOrderWenesday,
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, totalOrderThursday,
                isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, totalOrderFriday,
                isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, totalOrderSaturday,
                isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, totalOrderSunday,
                isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  break;
                case 3:
                  weekDay = 'Thursday';
                  break;
                case 4:
                  weekDay = 'Friday';
                  break;
                case 5:
                  weekDay = 'Saturday';
                  break;
                case 6:
                  weekDay = 'Sunday';
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                weekDay + '\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.y - 1).toString(),
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      await refreshState();
    }
  }
}
