import 'package:flutter/material.dart';
import 'package:frontend/officer/officer.dart';
import 'package:frontend/officer/officer_list_element.dart';
import 'package:frontend/rest_client.dart';

class OfficersList extends StatefulWidget {
  const OfficersList({
    super.key,
    required this.client,
    required this.onSelect,
  });

  final RestClient client;
  final Function(int) onSelect;

  @override
  State<OfficersList> createState() => _OfficersListState();
}

class _OfficersListState extends State<OfficersList> {
  int selectedOfficer = 0;

  void selectOfficer(int id) {
    setState(() {
      selectedOfficer = id;
    });
    widget.onSelect.call(id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
    );
  }
}
