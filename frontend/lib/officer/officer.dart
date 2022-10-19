import 'dart:convert';

class Officer {
  Officer({
    required this.id,
    required this.name,
    required this.surname,
  });

  final int id;
  final String name;
  final String surname;

  static Officer fromJson(String jsonString) {
    final res = jsonDecode(jsonString);

    return Officer(
      id: res['id'] ?? 0,
      name: res['name'] ?? 'NA',
      surname: res['surname'] ?? 'NA',
    );
  }
}

class Officers {
  Officers({
    this.results,
  });

  final List<Officer>? results;

  static Officers fromJson(String jsonString) {
    final res = jsonDecode(jsonString);
    final results = res as List<dynamic>;

    return Officers(
      results: results.asMap().entries.map((p) {
        p.value['id'] = p.key + 1;
        return Officer.fromJson(
          json.encode(p.value),
        );
      }).toList(),
    );
  }
}
