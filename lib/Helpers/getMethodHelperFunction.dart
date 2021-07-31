import 'package:http/http.dart' as http;

Future getMethod(url) async {
  try {
    final uri = Uri.parse(url);
    final result = await http.get(
      uri,
    );
    return result;
  } catch (e) {
    print("Error From get method helper function");
    print(e);
  }
}
