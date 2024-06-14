import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  Future<int> login(String email, String password) async {
    // URL de l'API
    final url = Uri.parse('http://192.168.0.107:8000/api/login');

    // Corps de la requête
    final Map<String, dynamic> requestBody = {
      'email': email,
      'password': password,
    };

    try {
      // Effectuer la requête POST
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      // Vérifier le statut de la réponse
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData['user']['id']);
        return responseData['user']['id'];
      } else {
        print('Erreur lors de la requête: ${response.statusCode}');
        return response.statusCode;
      }
    } catch (e) {
      print('Exception: erreur de l\'envoie de la requete ');
      return 0;
    }
  }
}
