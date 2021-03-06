import 'dart:io';

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

  List<String> _scannedFiles = [];

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

  void _scanFiles(Connector connector) async {
    List<String> outScannedPaths = [];
    ScanParameters scanParams = ScanParameters();
    scanParams.documentSize = MediaSize.A6;
    JobState jobState = await connector.performScan(scanParams, outScannedPaths);
    print ("JobState: $jobState");
    print("Files Scanned: $outScannedPaths");

    setState(() {
      _scannedFiles = outScannedPaths;
    });
  }

  void _printFiles(Connector connector) async {
    List<String> outScannedPaths = [];
    PrintParameters printParams = PrintParameters();
    printParams.paperSize = MediaSize.A4;
    JobState jobState = await connector.performPrint(printParams, outScannedPaths);
    print ("JobState: $jobState");
    print("Files Scanned: $outScannedPaths");

    setState(() {
      _scannedFiles = outScannedPaths;
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget body;

    if (_scannedFiles.isNotEmpty) {
      body = ListView.builder(
          itemCount: _scannedFiles.length,
          itemBuilder: (context ,index) {
            return GestureDetector(
                onTap: () {
                  setState(() {
                    _scannedFiles = [];
                  });
                },
                child: Image.file(File(_scannedFiles[index])));
          });
    }
    else {
      body = Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _fetchDevices,
          builder: (context, AsyncSnapshot<List<Connector>> snapshot) {
            print("Snapshot ${snapshot.data}");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Searching for scanners in your network.");
            }
            if (snapshot.hasData) {
              List<Connector> connectors = snapshot.data!;

              if (connectors.isEmpty) {
                return Text("No Scanners Found");
              }
              return ListView.builder(
                  itemCount: connectors.length,
                  itemBuilder: (context ,index) {
                    return ListTile(title: Text(connectors[index].getModelName()),
                      subtitle: Text(connectors[index].getDescriptorIdentifier()),
                      onTap: () {
                        _scanFiles(connectors[index]);
                        //_printFiles(connectors[index]);
                      },);
                  });
            }
            else {
              return Text("Searching for Devices");
            }
          },
        ),
      );
    }


    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: body,
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
