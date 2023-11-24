import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currentDateAndTime = "";
  bool isBusy = true;

  @override
  initState() {
    get();
    super.initState();
  }

  get() async {
    setState(() {
      isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isBusy
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //layout
                  Text(
                    currentDateAndTime,
                  ),
                  const SizedBox(
                    height: 200,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        FlutterBackgroundService().invoke("stop_service");
                      },
                      child: const Text("stop service")),
                  ElevatedButton(
                      onPressed: () {
                        FlutterBackgroundService().startService();
                      },
                      child: const Text("start service")),
                ],
              ),
            ),
    );
  }
}
