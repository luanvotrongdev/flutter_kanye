import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'package:rxdart/rxdart.dart';
//import 'package:clipboard_manager/clipboard_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Kanye',
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
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _dio = Dio();
  PublishSubject _quotePublishObject = PublishSubject();

  void _showSnackbar() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Copied to clipboard"),
    ));
  }

  void _requestQuote() {
    _dio.get("https://api.kanye.rest/").then((resp) {
      if (resp.statusCode == 200) {
        Map<String, dynamic> responseData = resp.data;
        _quotePublishObject.add(responseData["quote"]);
      }
    });
  }

  @override
  initState() {
    super.initState();
    _requestQuote();
    _quotePublishObject.startWith("fsafsd");
  }

  Widget _buildBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
      padding: EdgeInsets.fromLTRB(5, 30, 5, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: size.width / 3,
            height: size.width / 3,
            child: Image.asset("images/logo.png"),
          ),
          FlatButton(
              onPressed: () async {
//                const url = 'https://github.com/ajzbc/kanye.rest';
//                if (await canLaunch(url)) {
//                  await launch(url);
//                } else {
//                  throw 'Could not launch $url';
//                }
              },
              child: const Text("kanye.rest")),
          Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      OutlineButton(
                        child: const Text("Facebook"),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      OutlineButton(
                        child: const Text("Copy"),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                                onPressed: ()
                                {
                                  _showSnackbar();
                                },
                      ),
                      OutlineButton(
                        child: const Text("Refresh"),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        onPressed: _requestQuote,
                      ),
                    ],
                  ),
                  Divider(),
                  StreamBuilder(
                    stream: _quotePublishObject,
                    initialData: "",
                    builder: (context, snapshot) {
                      String str = "";
                      if (snapshot.data != null) str = snapshot.data;
                      return Text('"$str"');
                    },
                  )
                ],
              ))
        ],
      ),
    ));
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
      key: _scaffoldKey,
      body: _buildBody(
          context), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
