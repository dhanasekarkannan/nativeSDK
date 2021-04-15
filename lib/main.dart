import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
  static const _batteryChannel =
      const MethodChannel("com.example.nativesdk/batteryLevel");
  static const _messageChannel =
      const MethodChannel("com.example.nativesdk/textMessage");
  String _textMessage = "Empty Message";
  String _batteryLevel = "Unknown Battery Level";

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await _batteryChannel.invokeMethod('getBatteryLevel');
      batteryLevel = "Battery is $result %";
    } catch (e) {
      batteryLevel = e.message;
    }
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> _getNativeTextMessage() async {
    String textMessage;
    try {
      textMessage =
          await _messageChannel.invokeMethod("getTextMessage", {"age" : "26", "name":"Dhanasekar kannan"});
    } on PlatformException catch (e) {
      textMessage = "Exception in fetching Native Text Message" + e.message;
    }
    setState(() {
      _textMessage = textMessage;
    });
  }

  @override
  void initState() {
    _getNativeTextMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Native SDK Integration"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(_batteryLevel),
            ElevatedButton(
              child: Text('Click to get Battery Level'),
              onPressed: () {
                _getBatteryLevel();
              },
            ),
            Text(_textMessage),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
