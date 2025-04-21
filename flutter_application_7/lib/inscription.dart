import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard_screen.dart';

class InscriptionPage extends StatefulWidget {
  @override
  _InscriptionPageState createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Gestion du formulaire
  bool _isPasswordVisible = false;
  bool _isLoading = false; // Indicateur de chargement

  // Fonction pour gérer l'inscription
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Création du compte Firebase
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Ajout des infos utilisateur à Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'email': emailController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      // Redirection vers le tableau de bord
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Une erreur est survenue';

      if (e.code == 'weak-password') {
        message = 'Le mot de passe est trop faible';
      } else if (e.code == 'email-already-in-use') {
        message = 'Cet email est déjà utilisé';
      } else if (e.code == 'invalid-email') {
        message = 'Adresse email invalide';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inscription')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[400]!, Colors.blue[800]!],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey, // Ajout du formulaire
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_add, size: 100, color: Colors.white),
                    SizedBox(height: 40),

                    // Champ Email
                    TextFormField(
                      controller: emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Email', Icons.email),
                      validator: (value) {
                        if (value == null || value.isEmpty) return "L'email est requis";
                        if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                          return "Veuillez entrer un email valide";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Champ Mot de Passe
                    TextFormField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      style: TextStyle(color: Colors.white),
                      decoration: _passwordInputDecoration('Mot de passe'),
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Le mot de passe est requis";
                        if (value.length < 6) return "Le mot de passe doit contenir au moins 6 caractères";
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Champ Confirmation Mot de Passe
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: !_isPasswordVisible,
                      style: TextStyle(color: Colors.white),
                      decoration: _passwordInputDecoration('Confirmer le mot de passe'),
                      validator: (value) {
                        if (value != passwordController.text) return "Les mots de passe ne correspondent pas";
                        return null;
                      },
                    ),
                    SizedBox(height: 30),

                    // Bouton Inscription
                    ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.blue)
                          : Text("S'inscrire", style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Style des champs de texte
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white70),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  // Style des champs de mot de passe avec icône de visibilité
  InputDecoration _passwordInputDecoration(String label) {
    return _inputDecoration(label, Icons.lock).copyWith(
      suffixIcon: IconButton(
        icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white70),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
