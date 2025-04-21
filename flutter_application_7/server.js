const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const db = mysql.createConnection({
    host: '172.20.10.2',  // Changé pour localhost
    user: 'hanane',      // Utilisateur par défaut
    password: 'HBbts$$//qsd.28',      // Mot de passe vide par défaut
    database: 'myshop',
    port: 3306,
    // connectTimeout: 10000 // Timeout augmenté à 10 secondes
});

// Connexion à MySQL
db.connect((err) => {
  if (err) {
    console.error('Erreur de connexion à MySQL:', err);
    return;
  }
  console.log('Connecté à la base de données MySQL');
  console.log(`CTRL + Click sur : http://172.20.10.2/phpmyadmin`);
});

// verifier la connexion à la base de données
app.get('/user', (req, res) => {
  const sql = 'SELECT * FROM admins';
  db.query(sql, (err, results) => {
    if (err) {
      return res.status(500).send(err);
    }
    res.json(results);
  });
});

// Endpoint pour ajouter une nouvelle nation
app.post('/inscription', async (req, res) => {
  const { email, password, confirm_password, nom, prenom} = req.body;

  try {
    const hashPassword = await bcrypt.hash(password, 10);

    const sql ='INSERT INTO admins(email, password, confirm_password, nom, prenom) VALUES (?, ?, ?, ?, ?)';
    db.query(sql, [email, hashPassword, confirm_password, nom, prenom], (err, result) => {
      if (err) {
        return res.status(500).send(err);
      }
      res.json({ id: result.insertId, email, password, confirm_password, nom, prenom });
    });
  } catch (error) {
    res.status(500).send('Erreur lors de l\'inscription');
  }
});

// Routes pour gérer la connexion
app.post('/connexion', async (req, res) => {
    const { email, password } = req.body;
  
    if (!email || !password) {
      return res.status(400).json({ message: 'Email et mot de passe requis' });
    }
    const sql = 'SELECT * FROM `admins` WHERE email = ?';
    db.query(sql, [email], async (err, results) => {
      if (err) {
        return res.status(500).send(err);
      }
      if (results.length === 0) {
        return res.status(401).json({ message: 'Email ou mot de passe incorrect' });
      }
  
      const utilisateur = results[0];
  
      bcrypt.compare(password, utilisateur.password, (err, result) => {
        if (err) {
          return res.status(500).send(err);
        }
        if (!result) {
          return res.status(401).json({ message: 'Email ou mot de passe incorrect' });
        }
  
        res.json({ message: 'Connexion réussie', utilisateur });
  
      });
    });
  });
  
// Démarrage du serveur
app.listen(db.port, () => {
  console.log(`Serveur API en écoute sur http://localhost:${db.port}`);
});
