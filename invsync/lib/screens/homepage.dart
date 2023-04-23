import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:invsync/widgets/myDrawer.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  // Generate some dummy data for the cahrt
  // This will be used to draw the red line
  // Generate dummy data for y-axis values between 0 and 50
  final List<FlSpot> dummyData1 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), Random().nextDouble() * 50);
  });

// Generate dummy data for y-axis values between 0 and 100
  final List<FlSpot> dummyData2 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), Random().nextDouble() * 100);
  });

  // This will be used to draw the blue line

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Title(color: Colors.black, child: const Text("InvSync")),
    //   ),
    //   drawer: MyDrawer(),
    // );
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      drawer: MyDrawer(),
      body: Center(
        child: Text('This is the inventory screen'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.35,
          child: LineChart(
            swapAnimationDuration:
                const Duration(milliseconds: 150), // Optional
            swapAnimationCurve: Curves.linear, //
            LineChartData(
              minY: 0,
              maxY: 100,
              borderData: FlBorderData(show: false),
              lineBarsData: [
                // The red line
                LineChartBarData(
                    spots: dummyData1,
                    isCurved: true,
                    barWidth: 3,
                    color: Colors.red),
                // The orange line
                LineChartBarData(
                    spots: dummyData2,
                    isCurved: true,
                    barWidth: 3,
                    color: Colors.orange),
                // The blue line
              ],
            ),
          ),
        ),
      ),
    );
  }
}
