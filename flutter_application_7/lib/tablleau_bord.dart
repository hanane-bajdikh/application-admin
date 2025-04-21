import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tableau de Bord')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bienvenue, Administrateur !', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/orders'),
              child: Text('Gestion des commandes'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/products'),
              child: Text('Gestion des produits'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/stocks'),
              child: Text('Gestion des stocks'),
            ),
          ],
        ),
      ),
    );
  }
}
