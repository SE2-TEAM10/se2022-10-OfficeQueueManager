import 'package:flutter/material.dart';
import 'package:frontend/officer/officer.dart';
import 'package:frontend/rest_client.dart';

class OfficerListElement extends StatefulWidget {
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
  State<OfficerListElement> createState() => _OfficerListElementState();
}

class _OfficerListElementState extends State<OfficerListElement> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 200,
        height: 100,
        child: Card(
          elevation: hover ? 8 : 1,
          shape: (widget.selectedOfficer == widget.index)
              ? const RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.green,
                  ),
                )
              : null,
          child: InkWell(
            onHover: (val) => setState(() {
              hover = val;
            }),
            onTap: () => widget.selectOfficer(widget.index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child:
                      Text('${widget.officer.name} ${widget.officer.surname}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
