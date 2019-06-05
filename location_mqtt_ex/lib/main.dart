import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:wifi/wifi.dart';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';

void main() => runApp(MyApp());

String address = "172.16.30.110";
String image = '';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.lime,
        ),
        home: new MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  String title = '교통사고 감지 서비스';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController user_id = TextEditingController();
  TextEditingController server_ip = TextEditingController();

  String _ip = 'click button to get ip.';
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var location = new Location();
  Map<String, double> userLocation;

  @override
  Widget build(BuildContext context) {
    _getIP();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Flexible(
              child: Container(
                alignment: Alignment(0.0, 0.0),
                height: 45,
                margin: EdgeInsets.only(left: 30, right: 30, top: 15),
                padding: EdgeInsets.only(left: 20, right: 20),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(width: 1, color: Colors.black12)),
                child: Row(children: <Widget>[
                  Container(
                    width: 60,
                    child: Text("User ID",
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      child: TextField(
                        controller: user_id,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Input Your ID',
                            hintStyle: TextStyle(color: Colors.grey[300])),
                        cursorColor: Colors.blue,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Flexible(
              child: Container(
                alignment: Alignment(0.0, 0.0),
                height: 45,
                margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                padding: EdgeInsets.only(left: 20, right: 20),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(width: 1, color: Colors.black12)),
                child: Row(children: <Widget>[
                  Container(
                    width: 60,
                    child: Text("Server",
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      child: TextField(
                        controller: server_ip,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Input Server ip address',
                            hintStyle: TextStyle(color: Colors.grey[300])),
                        cursorColor: Colors.blue,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Flexible(
              child: Container(
                alignment: Alignment(0.0, 0.0),
                height: 45,
                margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                padding: EdgeInsets.only(left: 20, right: 20),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(width: 1, color: Colors.black12)),
                child: Row(children: <Widget>[
                  Container(
                    width: 60,
                    child: Text("IP주소",
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                  Text(
                    _ip,
                    style: TextStyle(fontSize: 16),
                  ),
                ]),
              ),
            ),

            /*userLocation == null
                ? CircularProgressIndicator()
                : Text("Location:" +
                userLocation["latitude"].toString() +
                " " +
                userLocation["longitude"].toString()),
            Flexible(
              child: Container(
                alignment: Alignment(0.0, 0.0),
                height: 45,
                margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                padding: EdgeInsets.only(left: 20, right: 20),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(width: 1, color: Colors.black12)),
                child: Row(children: <Widget>[
                  Container(
                    width: 60,
                    child: Text("현재위치",
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                  Flexible(
                    child: RaisedButton(
                      onPressed: () {
                        _getLocation().then((value) {
                          setState(() {
                            userLocation = value;
                          });
                        });
                      },
                      color: Colors.blue,
                      child: Text(
                        "Get Location",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Flexible(
              child: RaisedButton(
                onPressed: () {
                  _getLocation().then((value) {
                    setState(() {
                      userLocation = value;
                    });
                  });
                },
                color: Colors.green,
                child: Text(
                  "Connect",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),*/

            Flexible(
              child: Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Start'),
                        color: Colors.green,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SecondRoute()));
                        },
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _getIP() async {
    String ip = await Wifi.ip;
    setState(() {
      _ip = ip;
    });
  }

  Future<Map<String, double>> _getLocation() async {
    var currentLocation = <String, double>{};
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }
}

class SecondRoute extends StatefulWidget {
  @override
  SecondRouteState createState() => new SecondRouteState();
}

class SecondRouteState extends State<SecondRoute> {
  String sendmessage = "";
  String recivemessage = "";
  List<String> m_list = [];

  @override
  Widget build(BuildContext context) {
    _getIP();
    setState(() {
      if (recivemessage == "warning! traffic accident")
        m_list.add(recivemessage);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Connect"),
      ),
      body: Container(
        color: Colors.white,
        margin: new EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
        child: Column(
          children: <Widget>[
            SizedBox(
                width: 215,
                height: 55,
                child: RaisedButton(
                    onPressed: () {
                      sendmessage = _ip;
                      main();
                    },
                    child: Text('Connect',
                        style: TextStyle(color: Colors.black, fontSize: 17.0)),
                    color: Colors.green)),
            Flexible(
                child: Container(
                    padding: EdgeInsets.only(top:10.0),
                    child: Column(children: <Widget>[
                      RaisedButton.icon(
                          icon: Image.asset('assets/accident.png',
                              width: 100, height: 60),
                          color: Colors.red,
                          onPressed: () {
                            image = 'assets/warning.png';
                            sendmessage = "warning! traffic accident";
                            main();
                          },
                          label: Text("Emergency",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0))),
                    ]
                    ))),
            Flexible(child: Container( child: Column(children: <Widget>[
              Image.asset(image, width: 170, height: 130)]))),

            Flexible(
              child: Container(
                child: Column(children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: m_list.reversed.map((data) {
                        return Dismissible(
                          key: Key(data),
                          child: ListTile(
                            title: Center(
                              // 항목 가운데 배치
                              child: Text(
                                data,
                                style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );

  }

  String _ip = 'click button to get ip.';

  final MqttClient client = MqttClient(address, '1883');
  Future<int> main() async {
    /// Set logging on if needed, defaults to off
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;

    try {
      await client.connect();
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      client.disconnect();
    }

    /// Check we are connected
    if (client.connectionStatus.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      exit(-1);
    }

    /// Ok, lets try a subscription
    print('EXAMPLE::Subscribing to the desIP');
    const String topic = 'desIP'; // Not a wildcard topic
    const String topic1 = 'Emergency'; // Not a wildcard topic
    client.subscribe(topic, MqttQos.atMostOnce);
    client.subscribe(topic1, MqttQos.atMostOnce);

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      print(
          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      print('');
      setState(() {
        if (c[0].topic == "Emergency") {
          recivemessage = pt;
        } else if (c[0].topic == "desIP") {
          address = pt;
          main();
        }
      });
    });

    client.published.listen((MqttPublishMessage message) {
      print(
          'EXAMPLE::Published notification:: topic is ${message.variableHeader.topicName}, with Qos ${message.header.qos}');
    });

    const String pubTopic = 'Emergency';
    const String pubTopic1 = 'reqIP';
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    if (sendmessage == _ip) {
      builder.addString(sendmessage);
      client.publishMessage(pubTopic1, MqttQos.exactlyOnce, builder.payload);
    } else if (sendmessage == "warning! traffic accident") {
      builder.addString(sendmessage);
      client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload);
    }

    print('EXAMPLE::Sleeping....');
    await MqttUtilities.asyncSleep(120);

    /// Finally, unsubscribe and exit gracefully
    print('EXAMPLE::Unsubscribing');
    client.unsubscribe(topic);

    /// Wait for the unsubscribe message from the broker if you wish.
    await MqttUtilities.asyncSleep(2);
    print('EXAMPLE::Disconnecting');
    client.disconnect();
    return 0;
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus.returnCode == MqttConnectReturnCode.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
    exit(-1);
  }

  /// The successful connect callback
  void onConnected() {
    print(
        'EXAMPLE::OnConnected client callback - Client connection was sucessful');
  }

  /// Pong callback
  void pong() {
    print('EXAMPLE::핑퐁핑퐁');
  }

  Future<Null> _getIP() async {
    String ip = await Wifi.ip;
    _ip = ip;
  }
}
