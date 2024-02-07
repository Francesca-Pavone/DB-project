-- MySQL dump 10.13  Distrib 8.0.29, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: pizzeriaDB
-- ------------------------------------------------------
-- Server version	8.0.29

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `Ingredienti`
--

LOCK TABLES `Ingredienti` WRITE;
/*!40000 ALTER TABLE `Ingredienti` DISABLE KEYS */;
INSERT INTO `Ingredienti` VALUES ('acciughe',20,1.00),('bresaola',20,2.00),('capperi',10,1.00),('carciofi',10,2.00),('ciliegino',30,1.00),('cipolla',20,1.00),('cozze',10,1.00),('emmenthal',10,1.00),('fior di latte',40,1.00),('frutti di mare',20,2.00),('funghi porcini',20,2.00),('gamberoni',10,2.00),('gorgonzola',1,1.00),('grana',10,1.00),('granella di pistacchio',10,1.00),('kebab',10,1.00),('melanzane',10,1.00),('misto funghi',20,2.00),('misto mare',20,2.00),('mortadella',15,1.00),('mozzarella',50,1.00),('mozzarella di bufala',20,2.00),('pancetta affumicata',10,1.00),('patatine fritte',20,1.00),('peperoncino',10,1.00),('pomodoro',40,1.00),('porchetta',20,2.00),('prosciutto cotto',10,1.00),('ricotta salata',10,1.00),('rucola',10,1.00),('salsa BBQ',10,1.00),('scamorza',10,1.00),('sottilette',10,1.00),('speck',20,2.00),('uovo',10,1.00);
/*!40000 ALTER TABLE `Ingredienti` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


