import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour décoder JSON

class Produits {
  Future<List<String>> makeGetRequest() async {
    // URL de l'API
    final url = Uri.parse('http://192.168.0.100:8000/api/produits');
    try {
      // Effectuer la requête GET
      final response = await http.get(url);

      // Vérifier le statut de la réponse
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Réponse du serveur: $responseData');

        Map<String, dynamic> decodedJson = jsonDecode(response.body);
        List<dynamic> produits = decodedJson['produits'];
        List<String> references = produits.map((produit) => produit['reference'].toString().trim()).toList();
    
        return references;
      } else {
        print('Erreur lors de la requête: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to load data');
    }
  }

  Future<int> enregistreProduit(String user_id, String reference, String action, String quantite ) async {
    // URL de l'API
    final url = Uri.parse('http://192.168.0.100:8000/api/enregistreProduit');

    // Corps de la requête
    final Map<String, dynamic> requestBody = {
      'user_id': user_id,
      'reference': reference,
      'action': action,
      'quantite': quantite,
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
        print(responseData['message']);
        return response.statusCode;
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
