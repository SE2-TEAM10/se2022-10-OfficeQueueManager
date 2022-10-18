import 'package:flutter/material.dart';
import 'package:frontend/rest_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import 'officer.dart';

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
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(client: client),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    required this.client,
    super.key,
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
            Center(
              child: FutureBuilder(
                future: client.get(api: 'officers'),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    final officers = Officers.fromJson(snapshot.data!.body);

                    return SingleChildScrollView(
                      child: Column(
                        children: officers.results!
                            .asMap()
                            .entries
                            .map((p) => OfficerListElement(
                                client: client,
                                index: p.key + 1,
                                officer: p.value))
                            .toList(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Container();
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OfficerListElement extends StatelessWidget {
  const OfficerListElement({
    required this.client,
    required this.index,
    required this.officer,
    Key? key,
  }) : super(key: key);

  final Officer officer;
  final int index;
  final RestClient client;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 500,
        height: 200,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(officer.name), //TODO
              ),
            ],
          ),
        ),
      ),
    );
  }
}
