import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GestionProduits extends StatefulWidget {
  @override
  _GestionProduitsState createState() => _GestionProduitsState();
}

class _GestionProduitsState extends State<GestionProduits> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  @override
  void dispose() {
    // Libération des contrôleurs à la fermeture de la page
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }

  Future<void> _addProduct() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter un produit'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nom du produit',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Prix',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: stockController,
                  decoration: InputDecoration(
                    labelText: 'Stock',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Réinitialiser les champs lorsque l'utilisateur annule
                nameController.clear();
                priceController.clear();
                stockController.clear();
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    priceController.text.isEmpty ||
                    stockController.text.isEmpty) {
                  // Afficher un message d'erreur si les champs sont vides
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Veuillez remplir tous les champs.')),
                  );
                  return;
                }

                try {
                  await _firestore.collection('products').add({
                    'name': nameController.text,
                    'price': double.parse(priceController.text),
                    'stock': int.parse(stockController.text),
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  // Réinitialiser les champs après ajout
                  nameController.clear();
                  priceController.clear();
                  stockController.clear();
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur lors de l\'ajout du produit.')),
                  );
                }
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Produits'),
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[400]!, Colors.blue[800]!],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('products').orderBy('timestamp', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Une erreur est survenue'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final product = snapshot.data!.docs[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: ListTile(
                    title: Text(
                      product['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Prix: ${product['price']}€'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Stock: ${product['stock']}'),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // Edit functionality
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await _firestore.collection('products').doc(product.id).delete();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[800],
        tooltip: 'Ajouter un produit',
      ),
    );
  }
}
