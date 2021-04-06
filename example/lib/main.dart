import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:air_brother/air_brother.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  Future<List<Connector>> _fetchDevices = AirBrother.getNetworkDevices(5000);

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }



  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await AirBrother.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body:FutureBuilder(
          future: _fetchDevices,
          builder: (context, snapshot) {
            print("Snapshot ${snapshot.data}");
            if (snapshot.hasData) {
              List<Connector> connectors = snapshot.data;
              return ListView.builder(
                  itemCount: connectors.length,
                  itemBuilder: (context ,index) {
                    return ListTile(title: Text(connectors[index].getModelName()), subtitle: Text(connectors[index].getDescriptorIdentifier()),);
              });
            }
            else {
              return Text("Searching for Devices");
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              // Add your onPressed code here!
              _fetchDevices = AirBrother.getNetworkDevices(5000);
            });

          },
          child: Icon(Icons.navigation),
          backgroundColor: Colors.green,
        ),
        ),
      );

  }
}
