import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SensorData {
  final String timestamp;
  final double temperature;
  final double humidity;
  final double co2;

  DateTime getDateTime() {
    return DateTime.parse(timestamp);
  }

  SensorData(this.timestamp, this.temperature, this.humidity, this.co2);

  @override
  String toString() {
    return 'SensorData(timestamp: $timestamp, temperature: $temperature, humidity: $humidity, co2: $co2)';
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<SensorData>> myFuture;
  List<SensorData> sensorDataList = [];
  Future<List<SensorData>> fetchSensorDataFromFirebase() async {
    final ref = FirebaseDatabase.instance
        .refFromURL("https://invsync-f07e2-default-rtdb.firebaseio.com/");

    ref.child('sensorData').once().then((DatabaseEvent snapshot) {
      Map<dynamic, dynamic>? sensorDataMap =
          snapshot.snapshot.value as Map<dynamic, dynamic>?;
      List<SensorData> fetchedSensorData = [];
      if (sensorDataMap != null) {
        // Iterate over each child node and retrieve the sensor data
        sensorDataMap.forEach((key, value) {
          double co2 = value['co2'];
          double humidity = value['humidity'];
          double temperature = value['temperature'];
          String timestamp = value['timestamp'];

          // Use the retrieved values as needed
          SensorData sensorData =
              SensorData(timestamp, temperature, humidity, co2);
          fetchedSensorData.add(sensorData);
          fetchedSensorData.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          setState(() {
            sensorDataList = fetchedSensorData.sublist(
              fetchedSensorData.length > 12 ? fetchedSensorData.length - 12 : 0,
              fetchedSensorData.length,
            );
          });
        });
      } else {
        print('No sensor data found');
      }
    }).catchError((error) {
      print('Failed to retrieve sensor data: $error');
    });
    return sensorDataList;
  }

  // Chart configs.
  charts.BehaviorPosition _titlePosition = charts.BehaviorPosition.bottom;
  charts.BehaviorPosition _legendPosition = charts.BehaviorPosition.bottom;

  @override
  void initState() {
    super.initState();
    myFuture = fetchSensorDataFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8, left: 16, right: 8),
      child: ListView(
        children: <Widget>[
          FutureBuilder(
            future: myFuture,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                children = <Widget>[
                  SizedBox(
                    height: 300,
                    child: charts.TimeSeriesChart(
                      domainAxis: const charts.DateTimeAxisSpec(
                        tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                          day: charts.TimeFormatterSpec(
                            format:
                                'HH:mm', // Specify the format as 'HH:mm' for hours and minutes
                            transitionFormat:
                                'HH:mm', // Specify the transition format as 'HH:mm'
                          ),
                        ),
                        renderSpec: charts.SmallTickRendererSpec(
                          // Customizations for x-axis labels
                          labelAnchor: charts.TickLabelAnchor.after,
                          labelStyle: charts.TextStyleSpec(
                            fontSize: 12, // Set font size for x-axis labels
                            color: charts.MaterialPalette.black,
                          ),
                        ),
                      ),
                      /*seriesList=*/ [
                        charts.Series<SensorData, DateTime>(
                          id: 'Temperature',
                          colorFn: (_, __) =>
                              charts.MaterialPalette.blue.shadeDefault,
                          domainFn: (dynamic sensorData, _) =>
                              sensorData.getDateTime(),
                          measureFn: (dynamic sensorData, _) =>
                              sensorData.temperature,
                          data: sensorDataList,
                        ),
                      ],
                      defaultInteractions: true,
                      defaultRenderer: charts.LineRendererConfig(
                        includePoints: false,
                        includeArea: true,
                        areaOpacity: 0.05,
                        stacked: true,
                      ),
                      animate: true,
                      behaviors: [
                        // Add title.
                        charts.ChartTitle(
                          'Temperature',
                          behaviorPosition: _titlePosition,
                        ),
                        // Add legend.
                        // charts.SeriesLegend(position: _legendPosition),
                        // Highlight X and Y value of selected point.
                        charts.LinePointHighlighter(
                          showHorizontalFollowLine:
                              charts.LinePointHighlighterFollowLineType.all,
                          showVerticalFollowLine:
                              charts.LinePointHighlighterFollowLineType.nearest,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: charts.TimeSeriesChart(
                      domainAxis: const charts.DateTimeAxisSpec(
                        tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                          day: charts.TimeFormatterSpec(
                            format:
                                'HH:mm', // Specify the format as 'HH:mm' for hours and minutes
                            transitionFormat:
                                'HH:mm', // Specify the transition format as 'HH:mm'
                          ),
                        ),
                        renderSpec: charts.SmallTickRendererSpec(
                          // Customizations for x-axis labels
                          labelAnchor: charts.TickLabelAnchor.after,
                          labelStyle: charts.TextStyleSpec(
                            fontSize: 12, // Set font size for x-axis labels
                            color: charts.MaterialPalette.black,
                          ),
                        ),
                      ),
                      /*seriesList=*/ [
                        charts.Series<SensorData, DateTime>(
                          id: 'Humidity',
                          colorFn: (_, __) =>
                              charts.MaterialPalette.deepOrange.shadeDefault,
                          domainFn: (dynamic sensorData, _) =>
                              sensorData.getDateTime(),
                          measureFn: (dynamic sensorData, _) =>
                              sensorData.humidity,
                          data: sensorDataList,
                        ),
                      ],
                      defaultInteractions: true,
                      defaultRenderer: charts.LineRendererConfig(
                        includePoints: false,
                        includeArea: true,
                        stacked: true,
                      ),
                      animate: true,
                      behaviors: [
                        // Add title.
                        charts.ChartTitle(
                          'Humidity',
                          behaviorPosition: _titlePosition,
                        ),
                        // Add legend.
                        // charts.SeriesLegend(position: _legendPosition),
                        // Highlight X and Y value of selected point.
                        charts.LinePointHighlighter(
                          showHorizontalFollowLine:
                              charts.LinePointHighlighterFollowLineType.all,
                          showVerticalFollowLine:
                              charts.LinePointHighlighterFollowLineType.nearest,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: charts.TimeSeriesChart(
                      domainAxis: const charts.DateTimeAxisSpec(
                        tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                          day: charts.TimeFormatterSpec(
                            format:
                                'HH:mm', // Specify the format as 'HH:mm' for hours and minutes
                            transitionFormat:
                                'HH:mm', // Specify the transition format as 'HH:mm'
                          ),
                        ),
                        renderSpec: charts.SmallTickRendererSpec(
                          // Customizations for x-axis labels
                          labelAnchor: charts.TickLabelAnchor.after,
                          labelStyle: charts.TextStyleSpec(
                            fontSize: 12, // Set font size for x-axis labels
                            color: charts.MaterialPalette.black,
                          ),
                        ),
                      ),
                      /*seriesList=*/ [
                        charts.Series<SensorData, DateTime>(
                          id: 'CO2 levels',
                          colorFn: (_, __) =>
                              charts.MaterialPalette.purple.shadeDefault,
                          domainFn: (dynamic sensorData, _) =>
                              sensorData.getDateTime(),
                          measureFn: (dynamic sensorData, _) => sensorData.co2,
                          data: sensorDataList,
                        ),
                      ],
                      defaultInteractions: true,
                      defaultRenderer: charts.LineRendererConfig(
                        includePoints: false,
                        includeArea: true,
                        stacked: true,
                      ),
                      animate: true,
                      behaviors: [
                        // Add title.
                        charts.ChartTitle(
                          'CO2 levels',
                          behaviorPosition: _titlePosition,
                        ),
                        // Add legend.
                        // charts.SeriesLegend(position: _legendPosition),
                        // Highlight X and Y value of selected point.
                        charts.LinePointHighlighter(
                          showHorizontalFollowLine:
                              charts.LinePointHighlighterFollowLineType.all,
                          showVerticalFollowLine:
                              charts.LinePointHighlighterFollowLineType.nearest,
                        ),
                      ],
                    ),
                  ),
                ];
              } else if (snapshot.hasError) {
                children = <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                ];
              } else {
                children = const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  ),
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
