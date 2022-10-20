import 'package:flutter/material.dart';
import 'package:frontend/rest_client.dart';
import 'package:frontend/services/available_service_list_element.dart';
import 'package:frontend/services/service_list_element.dart';
import 'package:frontend/services/services.dart';

class ServiceList extends StatefulWidget {
  const ServiceList({
    super.key,
    required this.client,
    required this.officerId,
  });

  final RestClient client;
  final int officerId;

  @override
  State<ServiceList> createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  int selectedOfficer = 0;
  int selectedService = 0;
  Services? officerServices;
  Services? allServices;
  Services? availableServices;

  @override
  void initState() {
    selectedOfficer = widget.officerId;
    super.initState();
  }

  void loadServices() async {
    final res = await Future.wait([
      widget.client.get(api: 'OfficerService/$selectedOfficer'),
      widget.client.get(api: 'services'),
    ]);
    setState(() {
      officerServices = Services.fromJson(res[0].body);
      allServices = Services.fromJson(res[1].body);
      availableServices = Services(
          results: allServices!.results!.where(
        (element) {
          final res = !officerServices!.results!.contains(element);
          return res;
        },
      ).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (availableServices == null || selectedOfficer != widget.officerId) {
      setState(() {
        selectedOfficer = widget.officerId;
      });
      loadServices();
    }
    return availableServices != null
        ? SingleChildScrollView(
            child: Column(
              children: [
                ...officerServices!.results!
                    .map((p) => ServiceListElement(
                          client: widget.client,
                          service: p,
                          selectService: (id) async {
                            await widget.client.delete(
                              api: 'OfficerService/',
                              body: {
                                'id_of': selectedOfficer,
                                'id_ser': id,
                              },
                            );
                            loadServices();
                          },
                        ))
                    .toList(),
                ...availableServices!.results!
                    .map((p) => AvailableServiceListElement(
                          client: widget.client,
                          service: p,
                          selectService: (id) async {
                            await widget.client.post(
                              api: 'OfficerService/',
                              body: {
                                'id_of': selectedOfficer,
                                'id_ser': id,
                              },
                            );
                            loadServices();
                          },
                        ))
                    .toList(),
              ],
            ),
          )
        : const CircularProgressIndicator();
  }
}
