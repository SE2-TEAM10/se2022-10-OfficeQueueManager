import 'package:flutter/material.dart';
import 'package:frontend/rest_client.dart';
import 'package:frontend/services/services.dart';

class AvailableServiceListElement extends StatefulWidget {
  const AvailableServiceListElement({
    required this.client,
    required this.service,
    required this.selectService,
    Key? key,
  }) : super(key: key);

  final Service service;
  final RestClient client;
  final Function(int) selectService;

  @override
  State<AvailableServiceListElement> createState() =>
      _AvailableServiceListElementState();
}

class _AvailableServiceListElementState
    extends State<AvailableServiceListElement> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 300,
        height: 100,
        child: Card(
          elevation: hover ? 8 : 1,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            side: BorderSide(
              color: Colors.lightBlue,
            ),
          ),
          child: InkWell(
            onHover: (val) => setState(() {
              hover = val;
            }),
            onTap: () => widget.selectService(widget.service.id),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${widget.service.id} ${widget.service.tag}'),
                  const SizedBox(
                    width: 8,
                  ),
                  const Icon(
                    Icons.add,
                    color: Colors.lightBlue,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
