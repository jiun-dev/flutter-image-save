import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SavaImage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
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

class SavaImage extends StatelessWidget {
  final PageController pageController = PageController(initialPage: 0);

  List<Widget> imageList = [];
  List<String> images = [
    "https://images.unsplash.com/photo-1533038590840-1cde6e668a91?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80",
    "https://images.unsplash.com/photo-1519770340285-c801df5ff3db?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=983&q=80",
    "https://images.unsplash.com/photo-1492321936769-b49830bc1d1e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=988&q=80",
    "https://images.unsplash.com/photo-1567016376408-0226e4d0c1ea?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80"
  ];

  void downloadImage(String url) async {
    var status = await Permission.storage.status;

    http.Response response = await http.get(
      Uri.parse(url),
    );

    if (status.isDenied) {
      await Permission.storage.request();
    } else {
      try {
        await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.bodyBytes),
          quality: 100,
          name: (DateTime.now().millisecondsSinceEpoch.toString()),
        );

        print("저장 성공!!");
      } catch (e) {
        print("저장 실패 ㅠㅠ");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    for (String image in images) {
      imageList.add(Image.network(image));
    }
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              PageView(
                controller: pageController,
                children: imageList,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Spacer(),
                    InkWell(
                      onTap: () {
                        int currentPageIndex = pageController.page!.toInt();
                        downloadImage(images[currentPageIndex]);
                      },
                      child: Container(
                        width: 120,
                        height: 50,
                        color: Colors.green,
                        child: Center(
                          child: Text("이 사진만 저장",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        for (int i = 0; i < images.length; ++i) {
                          downloadImage(images[i]);
                        }
                      },
                      child: Container(
                        width: 120,
                        height: 50,
                        color: Colors.green,
                        child: Center(
                          child: Text("모든 사진 저장",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
