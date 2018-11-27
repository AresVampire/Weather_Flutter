import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Weather {
  final double temp;
  final double temp_min;
  final double temp_max;
  final String cond;

  Weather({this.temp, this.temp_min, this.temp_max, this.cond});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temp: json['main']['temp'],
      temp_min: json['main']['temp_min'],
      temp_max: json['main']['temp_max'],
      cond: (json['weather'] as List)[0]['main'],
    );
  }
}

Future<Weather> fetchWeather(String city) async {
  final response =
  await http.get('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=9f83c91100de619bf5581359b6d44b55');
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    print(json.decode(response.body));
    return(Weather.fromJson(json.decode(response.body)));
  } else {
    // If that call was not successful, throw an error.
    print("Failed to load post");
    throw Exception('Failed to load post');
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _location = "";
  String _weather = "25C";

  void _incrementCounter() async {
    final weather =
    await fetchWeather(_location);
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      final temp = (weather.temp - 273.15).toStringAsFixed(2);
      final temp_min = weather.temp_min - 273.15;
      final temp_max = weather.temp_max - 273.15;
      final cond = weather.cond;
      _weather = 'Current: $temp, Min: $temp_min, Max: $temp_max $cond';
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              child: TextField(
                onChanged: (text) {
                  setState(() {
                    // This call to setState tells the Flutter framework that something has
                    // changed in this State, which causes it to rerun the build method below
                    // so that the display can reflect the updated values. If we changed
                    // _counter without calling setState(), then the build method would not be
                    // called again, and so nothing would appear to happen.
                    _location = text;
                  });
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 18.0, left: 8.0, right: 8.0),
              child: Text(
                _weather,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
