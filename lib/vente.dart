import 'package:application_suivi_stock/httpRequest/produits.dart';
import 'package:flutter/material.dart';

const List<String> list = <String>['stock', 'vente'];

void main() {
  runApp(const VenteApp());
}

class VenteApp extends StatelessWidget {
  const VenteApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'suivis de vente', // Titre de l'application
      theme: ThemeData(
        primarySwatch: Colors
            .deepPurple, // Utilisation de la couleur primaire de Material Design
        visualDensity: VisualDensity
            .adaptivePlatformDensity, // Adaptation de la densité visuelle en fonction de la plateforme
      ),
      home: const VenteAppPage(
        title: 'suivis de vente',
        userId: null,
      ), // Page d'accueil de l'application
    );
  }
}

class VenteAppPage extends StatefulWidget {
  final String title;
  final int? userId; // Le userId est maintenant de type int?

  const VenteAppPage({Key? key, required this.title, this.userId})
      : super(key: key);

  @override
  State<VenteAppPage> createState() => _VenteAppPagePageState(this.userId);
}

class _VenteAppPagePageState extends State<VenteAppPage> {
  bool _secureText =
      true; // Variable pour gérer l'affichage sécurisé du mot de passe
  final TextEditingController _quantite =
      TextEditingController(); // Contrôleur pour le champ nom
  // Contrôleur pour le champ mot de passe
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Clé pour identifier le formulaire
  String dropdownValue2 = list.first;
  String? dropdownValue1;

  int? userId;

  _VenteAppPagePageState(int? userId) {
    this.userId = userId;
  }

  Widget _buildDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Insertion des données'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), // Titre de la page d'accueil
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: DropdownButton<String>(
                    dropdownColor: Colors.white,
                    value: dropdownValue2,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 36,
                    isExpanded: true,
                    elevation: 16,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                    ),
                    underline: const SizedBox(),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue1 = value!;
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16), // Espacement entre les champs

                FutureBuilder<List<String>>(
                  future: Produits().makeGetRequest(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      //return Text('Data: ${snapshot.data}');
                      final List<String> data = snapshot.data!;
                      final uniqueData =
                          data.toSet().toList(); // Remove duplicates
                      if (dropdownValue1 == null && uniqueData.isNotEmpty) {
                        dropdownValue1 = uniqueData.first;
                      }
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: DropdownButton<String>(
                              dropdownColor: Colors.white,
                              value: dropdownValue1,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 36,
                              isExpanded: true,
                              elevation: 16,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                              underline: const SizedBox(),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  dropdownValue1 = value!;
                                });
                              },
                              items: data.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(
                              height: 16), // Espacement entre les champs
                        ],
                      );
                    } else {
                      return Text('No data');
                    }
                  },
                ),

                const SizedBox(height: 16), // Espacement entre les champs

                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _quantite,
                  decoration: const InputDecoration(
                    labelText: "Renseigner la quantité", // Libellé du champ nom
                    border: OutlineInputBorder(), // Style de bordure
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir une quantité';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16), // Espacement entre les champs

                Center(
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        print("Valeur 1: " + dropdownValue2);
                        print("Valeur 2: " + dropdownValue1!);
                        print("Quantite : " + _quantite.text);
                        print("UserId : " + userId.toString());
                        int status = await Produits().enregistreProduit(
                            userId.toString(),
                            dropdownValue1!,
                            dropdownValue2,
                            _quantite.text);
                        if (status == 200) {
                          showDialog<void>(
                            context: context,
                            useRootNavigator:
                                true, // ignore: avoid_redundant_argument_values
                            builder: _buildDialog,
                          );
                        }else {
                           print("produits non enregistrer");
                        }
                      }
                    },
                    icon: Icon(Icons.check),
                    label: const Text(
                      "Valider",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16), // Espacement entre les champs
              ],
            ),
          ),
        ),
      ),
    );
  }
}
