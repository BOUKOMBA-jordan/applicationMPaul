import 'package:application_suivi_stock/vente.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connexion', // Titre de l'application
      theme: ThemeData(
        primarySwatch: Colors
            .deepPurple, // Utilisation de la couleur primaire de Material Design
        visualDensity: VisualDensity
            .adaptivePlatformDensity, // Adaptation de la densité visuelle en fonction de la plateforme
      ),
      home: const MyHomePage(
          title: 'Connexion'), // Page d'accueil de l'application
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _secureText =true; // Variable pour gérer l'affichage sécurisé du mot de passe
  final TextEditingController _nameController = TextEditingController(); // Contrôleur pour le champ nom
  final TextEditingController _descriptionController = TextEditingController(); // Contrôleur pour le champ description
  final TextEditingController _passwordController = TextEditingController(); // Contrôleur pour le champ mot de passe
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Clé pour identifier le formulaire

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
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Nom", // Libellé du champ nom
                    border: OutlineInputBorder(), // Style de bordure
                  ),
                  
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre nom';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16), // Espacement entre les champs
               
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Mot de passe", // Libellé du champ mot de passe
                    border: const OutlineInputBorder(), // Style de bordure
                    suffixIcon: IconButton(
                      icon: Icon(
                        _secureText
                            ? Icons
                                .visibility_off // Icône pour afficher/masquer le mot de passe
                            : Icons.remove_red_eye,
                      ),
                      onPressed: () {
                        setState(() {
                          _secureText = !_secureText;
                        });
                      },
                    ),
                  ),
                  obscureText:
                      _secureText, // Masquage du texte du champ mot de passe
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un mot de passe';
                    }
                    if (value.length < 4) {
                      return 'Le mot de passe doit contenir au moins 4 caractères';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                Center(
                  child: ElevatedButton.icon(
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.all(20)),
                      backgroundColor: WidgetStatePropertyAll(Colors.green)
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print("Nom: " + _nameController.text);
                        print("Description: " + _descriptionController.text);
                        print("Mot de passe: " + _passwordController.text);
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VenteAppPage(title: 'suivis  de vente',)),
                      );
                    },
                    label: const Text(
                      "Se connecter",
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
