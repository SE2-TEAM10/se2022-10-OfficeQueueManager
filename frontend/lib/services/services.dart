import 'dart:convert';

import 'package:equatable/equatable.dart';

class Service extends Equatable {
  const Service({
    required this.id,
    required this.tag,
    required this.time,
  });

  final int id;
  final String tag;
  final String time;

  static Service fromJson(String jsonString) {
    final res = jsonDecode(jsonString);

    return Service(
      id: res['id'] ?? 0,
      tag: res['tag_name'] ?? 'NA',
      time: res['service_time'] ?? 'NA',
    );
  }

  @override
  List<Object?> get props => [id, tag, time];
}

class Services {
  Services({
    this.results,
  });

  final List<Service>? results;

  static Services fromJson(String jsonString) {
    final res = jsonDecode(jsonString);
    final results = res as List<dynamic>;

    return Services(
      results: results.map((p) {
        return Service.fromJson(
          json.encode(p),
        );
      }).toList(),
    );
  }

  void remove(int id) {
    results?.removeWhere((element) => element.id == id);
  }
}
