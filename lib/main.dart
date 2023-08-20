import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wave Chart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> frequencies = [
    "1HZ",
    "2HZ",
    "3HZ",
    "4HZ",
    "5HZ",
    "6HZ",
    "7HZ",
    "8HZ",
    "9HZ",
    "10HZ"
  ];
  String selectedFrequency = "1HZ";
  double initialZoomLevel = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wave Chart with SyncFusion'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFrequencyDropdown(),
            _buildChart(),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _zoomIn();
            },
            tooltip: 'Zoom In',
            child: Icon(Icons.zoom_in),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              _zoomOut();
            },
            tooltip: 'Zoom Out',
            child: Icon(Icons.zoom_out),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyDropdown() {
    return DropdownButton<String>(
      value: selectedFrequency,
      onChanged: (String ? newValue) {
        setState(() {
          selectedFrequency = newValue!;
        });
      },
      items: frequencies.map((String frequency) {
        return DropdownMenuItem<String>(
          value: frequency,
          child: Text(frequency),
        );
      }).toList(),
    );
  }

  Widget _buildChart() {
    double frequencyValue = double.parse(selectedFrequency.replaceAll(RegExp('[^0-9]'), ''));

    List<ChartData> data = generateChartData(frequencyValue);

    return SfCartesianChart(
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        enableDoubleTapZooming: true,
        enableSelectionZooming: true,


        // zoomMode: ZoomMode.,
      ),
      primaryXAxis: NumericAxis(),
      primaryYAxis: NumericAxis(),
      series: <LineSeries<ChartData, double>>[
        LineSeries<ChartData, double>(
          dataSource: data,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
        ),
      ],
    );
  }

  List<ChartData> generateChartData(double frequency) {
    List<ChartData> data = [];
    int s = 1000;
    for (int i = 0; i <= s; i++) {
      double y = 1.2 * sin(2 * pi * frequency * i / s);
      data.add(ChartData(i.toDouble(), y));
    }
    return data;
  }

  void _zoomIn() {
    setState(() {
      initialZoomLevel /= 1.5;
    });
  }

  void _zoomOut() {
    setState(() {
      initialZoomLevel *= 1.5;
    });
  }
}

class ChartData {
  final double x;
  final double y;

  ChartData(this.x, this.y);
}
