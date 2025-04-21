import 'package:flutter/material.dart';
import 'gestion_produits.dart'; // Assure-toi que tu as importé la page GestionProduits

void main() {
  runApp(
    MaterialApp(
      title: 'Tableau de Bord',
      routes: {
        '/products': (context) => GestionProduits(), // Définir la route '/products'
        // Autres routes...
      },
      home: DashboardScreen(),
    ),
  );
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de Bord'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard('Commandes en Attente', '12', Colors.orange),
                _buildStatCard('Stocks Bas', '5', Colors.red),
                _buildStatCard('Ventes Totales', '154', Colors.green),
              ],
            ),
            SizedBox(height: 20),
            // Section Boutons de Navigation
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildNavigationButton(
                    context,
                    title: 'Gestion des Commandes', 
                    icon: Icons.list_alt,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pushNamed(context, '/orders');
                    },
                  ),
                  _buildNavigationButton(
                    context,
                    title: 'Gestion des Produits', // Le bouton pour naviguer vers GestionProduits
                    icon: Icons.shopping_bag,
                    color: Colors.green,
                    onTap: () {
                      Navigator.pushNamed(context, '/products'); // Navigue vers '/products'
                    },
                  ),
                  _buildNavigationButton(
                    context,
                    title: 'Gestion des Stocks',
                    icon: Icons.inventory,
                    color: Colors.amber,
                    onTap: () {
                      Navigator.pushNamed(context, '/stocks');
                    },
                  ),
                  _buildNavigationButton(
                    context,
                    title: 'Statistiques',
                    icon: Icons.bar_chart,
                    color: Colors.purple,
                    onTap: () {
                      // Naviguer vers la page des statistiques
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour afficher une carte de statistique
  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pour créer un bouton de navigation
  Widget _buildNavigationButton(BuildContext context,
      {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
