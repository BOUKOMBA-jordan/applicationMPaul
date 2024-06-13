import 'package:flutter/material.dart';


const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

void main() {
  runApp(const VenteApp());
}

class VenteApp extends StatelessWidget {
  const VenteApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'suivis  de vente', // Titre de l'application
      theme: ThemeData(
        primarySwatch: Colors
            .deepPurple, // Utilisation de la couleur primaire de Material Design
        visualDensity: VisualDensity
            .adaptivePlatformDensity, // Adaptation de la densité visuelle en fonction de la plateforme
      ),
      home: const VenteAppPage(
          title: 'suivis  de vente'), // Page d'accueil de l'application
    );
  }
}

class VenteAppPage extends StatefulWidget {
  const VenteAppPage({Key? key, required this.title});

  final String title;

  @override
  State<VenteAppPage> createState() => _VenteAppPagePageState();
}

class _VenteAppPagePageState extends State<VenteAppPage> {
  bool _secureText =true; // Variable pour gérer l'affichage sécurisé du mot de passe
  final TextEditingController _nameController = TextEditingController(); // Contrôleur pour le champ nom
  final TextEditingController _descriptionController = TextEditingController(); // Contrôleur pour le champ description
  final TextEditingController _passwordController = TextEditingController(); // Contrôleur pour le champ mot de passe
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Clé pour identifier le formulaire
   String dropdownValue1 = list.first;
   String dropdownValue2 = list.first;

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
                    border: Border.all(color: Colors.grey,width: 1),
                    borderRadius: BorderRadius.circular(15)
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
                    fontSize: 22,
                  ),
                  underline: const SizedBox(),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue1= value!;
                    });
                  },
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList()
                  ),
                ),
                const SizedBox(height: 16), // Espacement entre les champs

                Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey,width: 1),
                    borderRadius: BorderRadius.circular(15)
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
                      dropdownValue2 = value!;
                    });
                  },
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList()
                  ),
                ),
                const SizedBox(height: 16), // Espacement entre les champs

                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Renseigner la quantitée", // Libellé du champ nom
                    border: OutlineInputBorder(), // Style de bordure
                  ),
                  
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisire une quantitée';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16), // Espacement entre les champs
               
                Center(
                  child: ElevatedButton.icon(
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.all(20)),
                      backgroundColor: WidgetStatePropertyAll(Colors.green)
                    ),
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        useRootNavigator:
                            true, // ignore: avoid_redundant_argument_values
                        builder: _buildDialog,
                      );
                      if (_formKey.currentState!.validate()) {
                        print("Nom: " + _nameController.text);
                        print("Description: " + dropdownValue1);
                        print("Mot de passe: " + dropdownValue2);

                      }
                      
                    },
                    label: const Text(
                      "Valider",
                      style: TextStyle(
                      fontSize: 20,
                    ),
                    ),
                
                  )
                 
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
