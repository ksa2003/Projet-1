/*

Projet 1

SQL & BI - Toys & Models

Vous êtes mandaté par une entreprise qui vend des modèles et des maquettes.

L’entreprise possède déjà une base de données qui répertorie les employés, les produits, les commandes et bien plus encore. Vous êtes invité à explorer et découvrir cette base de données.

Le directeur de l’entreprise souhaite avoir un tableau de bord qu’il pourrait actualiser chaque matin pour obtenir les dernières informations afin de gérer l’entreprise.

*/

USE toys_and_models;

SELECT * FROM employees;

SELECT * FROM products;

SELECT * FROM productLines;

SELECT * FROM payments;

/*

Objectif & Enjeux

Votre tableau de bord doit s’articuler autour de ces 4 sujets principaux : ventes, finances, logistique, et ressources humaines. Voici les indicateurs obligatoires qui doivent figurer dans votre tableau de bord. Il est recommandé de créer des KPI supplémentaires. Cette partie est très importante pour développer vos compétences/créativité en tant que data analyst.

    Ventes : Le nombre de produits vendus par catégorie et par mois, avec comparaison et taux de variation par rapport au même mois de l’année précédente.
    Finances :
        Le chiffre d’affaires des commandes des deux derniers mois par pays.
        Les commandes qui n’ont pas encore été payées.
    Logistique : Le stock des 5 produits les plus commandés.
    Ressources humaines : Chaque mois, les 2 vendeurs ayant réalisé le plus de chiffre d’affaires.

*/

-- Quel est le top 5 des produits les plus vendus en termes de quantités commandées :

SELECT productName, SUM(quantityordered)
FROM products
JOIN orderdetails ON products.productCode = orderdetails.productCode
GROUP BY productName
ORDER BY SUM(quantityordered) DESC
LIMIT 5;

-- Quel est le top 5 des produits les moins vendus en termes de quantités commandées :

SELECT productName, SUM(quantityordered)
FROM products
JOIN orderdetails ON products.productCode = orderdetails.productCode
GROUP BY productName
ORDER BY SUM(quantityordered) ASC
LIMIT 5;


-- Quel est le bureau qui a généré le plus de chiffre d'affaires :

SELECT offices.officeCode AS 'Bureau', offices.addressLine1 AS 'Adresse', offices.city AS 'Ville', offices.country AS 'Pays', SUM(quantityOrdered * priceEach) AS 'CA'
FROM orderdetails
INNER JOIN orders ON orders.orderNumber = orderdetails.orderNumber
INNER JOIN customers ON customers.customerNumber = orders.customerNumber
INNER JOIN employees ON employees.employeeNumber = customers.salesRepEmployeeNumber
INNER JOIN offices ON offices.officeCode = employees.officeCode
GROUP BY offices.officeCode, offices.addressLine1, offices.city, offices.country
ORDER BY SUM(quantityOrdered * priceEach) DESC
LIMIT 1;



-- Quel est le bureau qui a généré le moins de chiffres d'affaires :

SELECT offices.officeCode AS 'Bureau', offices.addressLine1 AS 'Adresse', offices.city AS 'Ville', offices.country AS 'Pays', SUM(quantityOrdered * priceEach) AS 'CA'
FROM orderdetails
INNER JOIN orders ON orders.orderNumber = orderdetails.orderNumber
INNER JOIN customers ON customers.customerNumber = orders.customerNumber
INNER JOIN employees ON employees.employeeNumber = customers.salesRepEmployeeNumber
INNER JOIN offices ON offices.officeCode = employees.officeCode
GROUP BY offices.officeCode, offices.addressLine1, offices.city, offices.country
ORDER BY SUM(quantityOrdered * priceEach) ASC
LIMIT 1;

-- Le N + 1 avec l'équipe qui a la plus grosse vente :

SELECT employees.employeeNumber AS 'Numéro employé avec la plus grosse vente', employees.reportsTo AS 'Numéro du N + 1 avec la plus grosse vente', SUM(quantityOrdered * priceEach) AS 'CA'
FROM orderdetails
INNER JOIN orders ON orders.orderNumber = orderdetails.orderNumber
INNER JOIN customers ON customers.customerNumber = orders.customerNumber
INNER JOIN employees ON employees.employeeNumber = customers.salesRepEmployeeNumber
GROUP BY employees.employeeNumber
ORDER BY SUM(quantityOrdered * priceEach) DESC
LIMIT 1;

-- Organigramme RH :
                               
CREATE VIEW N_Plus_Un AS (

                              SELECT employees.firstname AS 'Prenom_Manager', employees.lastname AS 'Nom_Manager', employees.employeeNumber AS 'ID_Manager', employees.jobTitle AS 'Poste'
                              
                              FROM employees
                                                            
                              );
                              
SELECT employees.employeeNumber AS 'ID_Employé', employees.firstname AS 'Prenom_Employé', employees.lastname AS 'Nom_Employé', employees.jobTitle AS 'Poste_Employé', N_Plus_Un.ID_Manager AS 'ID_Manager', N_Plus_Un.Prenom_Manager AS 'Prenom_Manager', N_Plus_Un.Nom_Manager AS 'Nom_Manager', N_Plus_Un.Poste AS 'Poste_Manager'

FROM employees

LEFT JOIN N_Plus_Un ON N_Plus_Un.ID_Manager = employees.reportsto

GROUP BY employees.employeeNumber;



