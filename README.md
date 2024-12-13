# Projet d'analyse des performances commerciales

## Description du projet
Ce projet consiste à analyser les performances des employés et des bureaux d'une entreprise à travers des données commerciales, des schémas de base de données et des requêtes SQL. Les analyses comprennent des résultats sur les employés ayant réalisé les meilleures ventes, les produits les plus et les moins vendus, ainsi que les bureaux les plus performants en termes de chiffre d'affaires.

## Contenu du projet
1. **Organigramme RH** :
   - Une vue hiérarchique des employés et de leurs responsables directs (N+1).
   - Données présentées sous forme de tableau pour comprendre les relations hiérarchiques.

2. **Analyse des ventes des employés :**
   - Identifiants des employés et de leurs responsables avec les meilleures performances.
   - Le CA (chiffre d'affaires) associé aux ventes.

3. **Diagramme de base de données :**
   - Modèle relationnel présentant les tables : `employees`, `orders`, `orderdetails`, `products`, `offices`, `customers`, etc.
   - Relations et clés entre ces tables pour faciliter les requêtes SQL.

4. **Requêtes SQL :**
   - **Quel est le bureau qui a généré le plus de chiffre d'affaires ?**
     ```sql
     SELECT offices.officeCode AS 'Bureau', offices.addressLine1 AS 'Adresse', offices.city AS 'Ville', offices.country AS 'Pays', SUM(quantityOrdered * priceEach) AS 'CA'
     FROM orderdetails
     INNER JOIN orders ON orders.orderNumber = orderdetails.orderNumber
     INNER JOIN customers ON customers.customerNumber = orders.customerNumber
     INNER JOIN employees ON employees.employeeNumber = customers.salesRepEmployeeNumber
     INNER JOIN offices ON offices.officeCode = employees.officeCode
     GROUP BY offices.officeCode, offices.addressLine1, offices.city, offices.country
     ORDER BY SUM(quantityOrdered * priceEach) DESC
     LIMIT 1;
     ```

   - **Top 5 des produits les plus vendus en termes de quantités commandées :**
     ```sql
     SELECT productName, SUM(quantityOrdered)
     FROM products
     JOIN orderdetails ON products.productCode = orderdetails.productCode
     GROUP BY productName
     ORDER BY SUM(quantityOrdered) DESC
     LIMIT 5;
     ```

   - **Top 5 des produits les moins vendus en termes de quantités commandées :**
     ```sql
     SELECT productName, SUM(quantityOrdered)
     FROM products
     JOIN orderdetails ON products.productCode = orderdetails.productCode
     GROUP BY productName
     ORDER BY SUM(quantityOrdered) ASC
     LIMIT 5;
     ```

5. **Résultats principaux :**
   - **Bureau ayant généré le plus de chiffre d'affaires :**
     - Bureau : `Tokyo`
     - Adresse : `4-1 Koicho`
     - Chiffre d'affaires : `452,978.58`
   
   - **Employé avec la plus grosse vente :**
     - Employé : `1370`
     - Responsable : `1102`
     - Chiffre d'affaires : `962,660.38`

   - **Top produits :**
     - Produits les plus vendus : Noms et quantités en tête de liste.
     - Produits les moins vendus : Identifiés pour analyse et optimisation.

## Fichiers fournis
- `Organigramme RH.png` : Visualisation des relations hiérarchiques des employés.
- `Diagram.png` : Diagramme de la base de données relationnelle.
- `BDD.sql` : Script SQL pour la création de la base de données.
- `Projet_1.sql` : Requêtes SQL utilisées pour les analyses.
- Résultats d'analyse sous forme d'images et de fichiers associés.

## Comment exécuter les analyses ?
1. Charger la base de données à l'aide du fichier `BDD.sql`.
2. Exécuter les requêtes dans `Projet_1.sql` pour reproduire les analyses.
3. Examiner les résultats dans les fichiers de sortie ou visualiser les données dans un outil SQL.

## Améliorations possibles
- Ajouter des visualisations interactives pour les performances des bureaux et des produits.
- Intégrer des prédictions basées sur les tendances des ventes avec des outils d'analyse avancés.
- Mettre en place des tableaux de bord dynamiques pour un suivi en temps réel.
