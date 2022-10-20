import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/rest_client.dart';

void main() async {
  await dotenv.load(fileName: "../.env");
  final client = RestClient();

  runApp(
    MyApp(
      client: client,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    required this.client,
    super.key,
  });

  final RestClient client;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var loading = true;
  var isLogged = false;

  @override
  void initState() {
    widget.client.get(api: 'sessions/current').then((value) {
      setState(() {
        isLogged = json.decode(value.body)['error'] != null ? false : true;
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: loading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : isLogged
              ? MyHomePage(
                  client: widget.client,
                )
              : LoginPage(
                  client: widget.client,
                  onLogged: (val) => setState(() => isLogged = val),
                ),
    );
  }
}
