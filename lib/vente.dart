import 'package:flutter/material.dart';
import 'package:application_suivi_stock/httpRequest/produits.dart';

const List<String> list = <String>['stock', 'vente'];

void main() {
  runApp(const VenteApp());
}

class VenteApp extends StatelessWidget {
  const VenteApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'suivis de vente',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const VenteAppPage(
        title: 'suivis de vente',
        userId: null,
      ),
      debugShowCheckedModeBanner: false, // Ajout de cette ligne pour enlever la bannière de débogag
    );
  }
}

class VenteAppPage extends StatefulWidget {
  final String title;
  final int? userId;

  const VenteAppPage({Key? key, required this.title, this.userId}) : super(key: key);

  @override
  State<VenteAppPage> createState() => _VenteAppPagePageState(this.userId);
}

class _VenteAppPagePageState extends State<VenteAppPage> {
  bool _secureText = true;
  final TextEditingController _quantite = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Veuillez enregistrer vos ventes",
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
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
                          setState(() {
                            dropdownValue2 = value!;
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
                    const SizedBox(height: 16),
                    FutureBuilder<List<String>>(
                      future: Produits().makeGetRequest(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final List<String> data = snapshot.data!;
                          final uniqueData = data.toSet().toList();
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
                                    setState(() {
                                      dropdownValue1 = value!;
                                    });
                                  },
                                  items: uniqueData.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        } else {
                          return Text('No data');
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _quantite,
                      decoration: const InputDecoration(
                        labelText: "Renseigner la quantité",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir une quantité';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 32.0), backgroundColor: Colors.green,
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
                              useRootNavigator: true,
                              builder: _buildDialog,
                            );
                          } else {
                            print("produits non enregistrer");
                          }
                        }
                      },
                      icon: const Icon(Icons.check),
                      label: const Text(
                        "Valider",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
