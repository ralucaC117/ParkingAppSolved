import 'package:parking_app_client/space.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Space> fetchSpace() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:2021/space/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Space.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<List<Space>> fetchSpaces() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:2021/spaces'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Iterable l = json.decode(response.body);
    List<Space> spaces =
        List<Space>.from(l.map((model) => Space.fromJson(model)));
    return spaces;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<List<Space>> fetchFreeSpaces() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:2021/free'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Iterable l = json.decode(response.body);
    List<Space> spaces =
        List<Space>.from(l.map((model) => Space.fromJson(model)));
    spaces.sort((a, b) => a.number.compareTo(b.number));
    return spaces;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<http.Response> postSpace(Space space) {
  return http.post(
    Uri.parse('http://10.0.2.2:2021/space'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'number': space.number,
      'address': space.address,
    }),
  );
}

Future<http.Response> deleteSpace(int? id) async {
  final http.Response response = await http.delete(
    Uri.parse('http://10.0.2.2:2021/space/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  return response;
}

Future<http.Response> updateSpace(int? id) async {
  return http.post(
    Uri.parse('http://10.0.2.2:2021/take'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'id': id.toString()}),
  );
}
