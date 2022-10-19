import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/officer/officer_list.dart';
import 'package:frontend/rest_client.dart';
import 'package:http/http.dart';

void main() async {
  await dotenv.load(fileName: "../.env");
  final httpClient = Client();
  final client = RestClient(httpClient: httpClient);

  runApp(
    MyApp(
      client: client,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    required this.client,
    super.key,
  });

  final RestClient client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(client: client),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
    required this.client,
  });

  final RestClient client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Services",
        ),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            OfficersList(
              client: client,
            )
          ],
        ),
      ),
    );
  }
}
