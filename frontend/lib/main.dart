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
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(client: client),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.client});

  final RestClient client;

  @override
  State<MyHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<MyHomePage> {
  int selectedOfficer = 0;

  void selectOfficer(int id) {
    setState(() {
      selectedOfficer = id;
    });
  }

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
                future: widget.client.get(api: 'officers'),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    final officers = Officers.fromJson(snapshot.data!.body);

                    return SingleChildScrollView(
                      child: Column(
                        children: officers.results!
                            .asMap()
                            .entries
                            .map((p) => OfficerListElement(
                                client: widget.client,
                                index: p.key + 1,
                                officer: p.value,
                                selectedOfficer: selectedOfficer,
                                selectOfficer: selectOfficer))
                            .toList(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
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
    required this.selectedOfficer,
    required this.selectOfficer,
    Key? key,
  }) : super(key: key);

  final Officer officer;
  final int index;
  final RestClient client;
  final int selectedOfficer;
  final Function(int) selectOfficer;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectOfficer(index),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 200,
          height: 100,
          child: Card(
            shape: (selectedOfficer == index)
                ? const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.green))
                : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text('${officer.name} ${officer.surname}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  /*setState(() {
      selectedOfficer = id;
    });
    */
}
