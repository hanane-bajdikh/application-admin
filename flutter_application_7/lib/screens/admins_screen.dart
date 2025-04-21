import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tableau de Bord')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminsScreen()),
            );
          },
          child: Text('Voir les Administrateurs'),
        ),
      ),
    );
  }
}

class AdminsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrateurs'),
      ),
      body: Center(
        child: Text('Liste des administrateurs'),
      ),
    );
  }
}