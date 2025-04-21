import 'package:flutter/material.dart';

class TableauBord extends StatelessWidget {
  const TableauBord({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de Bord'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenue, Administrateur !', 
              style: TextStyle(fontSize: 20)
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/orders'),
              child: const Text('Gestion des commandes'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/products'),
              child: const Text('Gestion des produits'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/stocks'),
              child: const Text('Gestion des stocks'),
            ),
          ],
        ),
      ),
    );
  }
}
