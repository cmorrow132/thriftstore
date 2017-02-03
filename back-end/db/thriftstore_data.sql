-- MySQL dump 10.13  Distrib 5.7.17, for Linux (i686)
--
-- Host: 192.168.1.190    Database: thriftstore
-- ------------------------------------------------------
-- Server version	5.7.17

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `BARCODE_CD`
--

DROP TABLE IF EXISTS `BARCODE_CD`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `BARCODE_CD` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `barcode` varchar(40) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `id_2` (`id`),
  UNIQUE KEY `barcode` (`barcode`),
  UNIQUE KEY `barcode_2` (`barcode`),
  UNIQUE KEY `id_3` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BARCODE_CD`
--

LOCK TABLES `BARCODE_CD` WRITE;
/*!40000 ALTER TABLE `BARCODE_CD` DISABLE KEYS */;
INSERT INTO `BARCODE_CD` VALUES (4,'1000000016-2081-1318-4425-2540');
/*!40000 ALTER TABLE `BARCODE_CD` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CATEGORY_CD`
--

DROP TABLE IF EXISTS `CATEGORY_CD`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CATEGORY_CD` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1000000023 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CATEGORY_CD`
--

LOCK TABLES `CATEGORY_CD` WRITE;
/*!40000 ALTER TABLE `CATEGORY_CD` DISABLE KEYS */;
INSERT INTO `CATEGORY_CD` VALUES (1000000020,'Books'),(1000000016,'Clothes-b'),(999999999,'No category');
/*!40000 ALTER TABLE `CATEGORY_CD` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CREDENTIALS`
--

DROP TABLE IF EXISTS `CREDENTIALS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CREDENTIALS` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL,
  `password` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CREDENTIALS`
--

LOCK TABLES `CREDENTIALS` WRITE;
/*!40000 ALTER TABLE `CREDENTIALS` DISABLE KEYS */;
INSERT INTO `CREDENTIALS` VALUES (149,'admin','7110eda4d09e062aa5e4a390b0a572ac0d2c0220'),(150,'matt','7110eda4d09e062aa5e4a390b0a572ac0d2c0220'),(151,'test1','7110eda4d09e062aa5e4a390b0a572ac0d2c0220');
/*!40000 ALTER TABLE `CREDENTIALS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DISCOUNT_CD`
--

DROP TABLE IF EXISTS `DISCOUNT_CD`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DISCOUNT_CD` (
  `id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `type` varchar(20) DEFAULT NULL,
  `amount` int(11) NOT NULL,
  `colorcode` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DISCOUNT_CD`
--

LOCK TABLES `DISCOUNT_CD` WRITE;
/*!40000 ALTER TABLE `DISCOUNT_CD` DISABLE KEYS */;
INSERT INTO `DISCOUNT_CD` VALUES (32,'senior',4,''),(33,'military',25,''),(34,'color',0,'RGB(255,255,255)'),(35,'color',0,'RGB(255,163,23)'),(36,'color',15,'RGB(255,31,0)'),(37,'color',0,'RGB(255,247,0)'),(38,'color',0,'RGB(62,255,0)'),(39,'color',0,'RGB(0,116,255)'),(40,'color',2,'RGB(112,0,255)'),(41,'color',0,'RGB(255,0,251)');
/*!40000 ALTER TABLE `DISCOUNT_CD` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GROUPS`
--

DROP TABLE IF EXISTS `GROUPS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GROUPS` (
  `username` varchar(20) NOT NULL,
  `groups` varchar(255) NOT NULL,
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GROUPS`
--

LOCK TABLES `GROUPS` WRITE;
/*!40000 ALTER TABLE `GROUPS` DISABLE KEYS */;
INSERT INTO `GROUPS` VALUES ('admin','admin|'),('matt','inv|'),('test1','inv|');
/*!40000 ALTER TABLE `GROUPS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GROUPS_CD`
--

DROP TABLE IF EXISTS `GROUPS_CD`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GROUPS_CD` (
  `name` varchar(20) NOT NULL,
  `description` varchar(20) NOT NULL,
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GROUPS_CD`
--

LOCK TABLES `GROUPS_CD` WRITE;
/*!40000 ALTER TABLE `GROUPS_CD` DISABLE KEYS */;
INSERT INTO `GROUPS_CD` VALUES ('admin','System administrator'),('inv','Inventory management'),('pos','POS operator');
/*!40000 ALTER TABLE `GROUPS_CD` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `INVENTORY_CD`
--

DROP TABLE IF EXISTS `INVENTORY_CD`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `INVENTORY_CD` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `category` bigint(20) NOT NULL,
  `discount` tinyint(4) DEFAULT NULL,
  `description` varchar(30) DEFAULT NULL,
  `price` decimal(3,2) NOT NULL,
  `barcode` varchar(40) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `INVENTORY_CD`
--

LOCK TABLES `INVENTORY_CD` WRITE;
/*!40000 ALTER TABLE `INVENTORY_CD` DISABLE KEYS */;
INSERT INTO `INVENTORY_CD` VALUES (4,1000000016,34,'Test product 1',0.50,'1000000016-2081-1318-4425-2540');
/*!40000 ALTER TABLE `INVENTORY_CD` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LICENSE`
--

DROP TABLE IF EXISTS `LICENSE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `LICENSE` (
  `license` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LICENSE`
--

LOCK TABLES `LICENSE` WRITE;
/*!40000 ALTER TABLE `LICENSE` DISABLE KEYS */;
INSERT INTO `LICENSE` VALUES ('12345');
/*!40000 ALTER TABLE `LICENSE` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-02-03 12:06:40
