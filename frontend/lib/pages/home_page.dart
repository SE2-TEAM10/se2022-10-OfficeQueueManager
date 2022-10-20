import 'package:flutter/material.dart';
import 'package:frontend/officer/officer_list.dart';
import 'package:frontend/rest_client.dart';
import 'package:frontend/services/service_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.client,
  });

  final RestClient client;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? selectedOfficer;

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
              client: widget.client,
              onSelect: (id) => setState(() => selectedOfficer = id),
            ),
            if (selectedOfficer != null)
              ServiceList(
                client: widget.client,
                officerId: selectedOfficer!,
              )
          ],
        ),
      ),
    );
  }
}
