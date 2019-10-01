-- MySQL dump 10.13  Distrib 8.0.16, for Win64 (x86_64)
--
-- Host: localhost    Database: bd_agcs
-- ------------------------------------------------------
-- Server version	8.0.16

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `address`
--

DROP TABLE IF EXISTS `address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `address` (
  `idAddress` int(11) NOT NULL AUTO_INCREMENT,
  `Locality` varchar(45) DEFAULT NULL,
  `Postal_Code` int(11) DEFAULT NULL,
  `Address` varchar(45) DEFAULT NULL,
  `Address_Number` int(11) DEFAULT NULL,
  `Floor` int(11) DEFAULT NULL,
  `Apartment` varchar(10) DEFAULT NULL,
  `Comments` varchar(200) DEFAULT NULL,
  `Delivery_idDelivery` int(11) NOT NULL,
  `Province_idProvince` int(11) NOT NULL,
  `Business_idBusiness` int(11) NOT NULL,
  `Clients_idClient` int(11) NOT NULL,
  PRIMARY KEY (`idAddress`) USING BTREE,
  KEY `fk_Address_Delivery1_idx` (`Delivery_idDelivery`),
  KEY `fk_Address_Province1_idx` (`Province_idProvince`),
  KEY `fk_Address_Business1_idx` (`Business_idBusiness`),
  KEY `fk_Address_Client1` (`Clients_idClient`),
  CONSTRAINT `fk_Address_Business1` FOREIGN KEY (`Business_idBusiness`) REFERENCES `business` (`idBusiness`),
  CONSTRAINT `fk_Address_Client1` FOREIGN KEY (`Clients_idClient`) REFERENCES `clients` (`idClient`),
  CONSTRAINT `fk_Address_Delivery1` FOREIGN KEY (`Delivery_idDelivery`) REFERENCES `delivery` (`idDelivery`),
  CONSTRAINT `fk_Address_Province1` FOREIGN KEY (`Province_idProvince`) REFERENCES `provinces` (`idProvince`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address`
--

LOCK TABLES `address` WRITE;
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
/*!40000 ALTER TABLE `address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bills`
--

DROP TABLE IF EXISTS `bills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `bills` (
  `idBill` int(11) NOT NULL AUTO_INCREMENT,
  `DateBill` date DEFAULT NULL,
  `Clients_idClient` int(11) DEFAULT NULL,
  `Employee_Code` int(11) DEFAULT NULL,
  `IVA_Condition` varchar(45) DEFAULT NULL,
  `TypeBill` varchar(1) DEFAULT NULL,
  `Subtotal` float(10,2) DEFAULT '0.00',
  `Discount` float(5,2) unsigned zerofill DEFAULT '00.00',
  `IVA_Recharge` float(5,2) unsigned zerofill DEFAULT '00.00',
  `WholeSaler` bit(1) DEFAULT NULL,
  `Total` float(2,2) DEFAULT '0.00',
  `Branches_idBranch` int(11) DEFAULT NULL,
  `Payment_Methods_idPayment_Method` int(11) DEFAULT NULL,
  `Macs_idMac` int(11) DEFAULT NULL,
  `Business_idBusiness` int(11) NOT NULL,
  PRIMARY KEY (`idBill`) USING BTREE,
  UNIQUE KEY `idBill` (`idBill`),
  KEY `fk_Bills_Branches1_idx` (`Branches_idBranch`) USING BTREE,
  KEY `fk_Bills_Payment_Methods1_idx` (`Payment_Methods_idPayment_Method`) USING BTREE,
  KEY `fk_Bills_Macs1_idx` (`Macs_idMac`) USING BTREE,
  KEY `fk_Bills_Business1_idx` (`Business_idBusiness`) USING BTREE,
  KEY `fk_Bills_Clients1_idx` (`Clients_idClient`),
  CONSTRAINT `bills_ibfk_1` FOREIGN KEY (`Clients_idClient`) REFERENCES `clients` (`idClient`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bills`
--

LOCK TABLES `bills` WRITE;
/*!40000 ALTER TABLE `bills` DISABLE KEYS */;
INSERT INTO `bills` VALUES (2,'2019-06-27',0,NULL,NULL,NULL,0.00,NULL,NULL,NULL,0.99,0,0,0,1),(3,'2019-06-27',0,NULL,NULL,NULL,0.00,NULL,NULL,NULL,0.99,0,0,0,1),(4,'2019-06-27',0,NULL,NULL,NULL,0.00,NULL,NULL,NULL,0.99,0,0,0,1),(60,'2019-09-06',56,NULL,NULL,NULL,0.00,00.00,00.00,NULL,0.99,NULL,NULL,NULL,2);
/*!40000 ALTER TABLE `bills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bills_x_products`
--

DROP TABLE IF EXISTS `bills_x_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `bills_x_products` (
  `idBills_X_Products` int(11) NOT NULL AUTO_INCREMENT,
  `Quantity` int(11) DEFAULT NULL,
  `Products_idProduct` int(11) NOT NULL,
  `Bills_idBill` int(11) NOT NULL,
  PRIMARY KEY (`idBills_X_Products`) USING BTREE,
  KEY `fk_Bill_X_Products_Products1_idx` (`Products_idProduct`) USING BTREE,
  KEY `fk_Bill_X_Products_Bills1_idx` (`Bills_idBill`) USING BTREE,
  CONSTRAINT `fk_Bills_X_Products_Bills1` FOREIGN KEY (`Bills_idBill`) REFERENCES `bills` (`idBill`),
  CONSTRAINT `fk_Bills_X_Products_Products1` FOREIGN KEY (`Products_idProduct`) REFERENCES `products` (`idProduct`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bills_x_products`
--

LOCK TABLES `bills_x_products` WRITE;
/*!40000 ALTER TABLE `bills_x_products` DISABLE KEYS */;
INSERT INTO `bills_x_products` VALUES (7,5,1,2),(70,1,23,60);
/*!40000 ALTER TABLE `bills_x_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `branches`
--

DROP TABLE IF EXISTS `branches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `branches` (
  `idBranch` int(11) NOT NULL AUTO_INCREMENT,
  `Address` varchar(100) DEFAULT NULL,
  `District` varchar(45) DEFAULT NULL,
  `Branch_Name` varchar(100) DEFAULT NULL,
  `Telephone` int(11) DEFAULT NULL,
  `Postal_Code` int(11) DEFAULT NULL,
  `Business_idBusiness` int(11) NOT NULL,
  `Province_idProvince` int(11) NOT NULL,
  PRIMARY KEY (`idBranch`) USING BTREE,
  KEY `fk_Branch_Business1_idx` (`Business_idBusiness`),
  KEY `fk_Branch_Province1_idx` (`Province_idProvince`),
  CONSTRAINT `fk_Branch_Business1` FOREIGN KEY (`Business_idBusiness`) REFERENCES `business` (`idBusiness`),
  CONSTRAINT `fk_Branch_Province1` FOREIGN KEY (`Province_idProvince`) REFERENCES `provinces` (`idProvince`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='	';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branches`
--

LOCK TABLES `branches` WRITE;
/*!40000 ALTER TABLE `branches` DISABLE KEYS */;
INSERT INTO `branches` VALUES (1,'Cabildo 6000','Belgrano','La revistería Cabildo',1500000000,4545,1,1);
/*!40000 ALTER TABLE `branches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business`
--

DROP TABLE IF EXISTS `business`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `business` (
  `idBusiness` int(11) NOT NULL AUTO_INCREMENT,
  `CUIT` int(11) DEFAULT NULL,
  `Name` varchar(45) DEFAULT NULL,
  `Gross_Income` int(11) DEFAULT NULL,
  `Beginning_of_Activities` date DEFAULT NULL,
  `Logo` varchar(100) DEFAULT NULL,
  `Signature` varchar(45) DEFAULT NULL,
  `Type` varchar(45) DEFAULT NULL,
  `Telephone` int(11) DEFAULT NULL,
  PRIMARY KEY (`idBusiness`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business`
--

LOCK TABLES `business` WRITE;
/*!40000 ALTER TABLE `business` DISABLE KEYS */;
INSERT INTO `business` VALUES (0,43994080,'AGCS',0,NULL,'xd','xdddd',NULL,NULL),(1,1234,'Prueba',3000,'2019-05-01','xdd','xdd','Mayorista',1121121),(2,4657456,'Don pepe y sus globos',8000,'1666-05-01','daze','xdd','Minorista',1511114444);
/*!40000 ALTER TABLE `business` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clients`
--

DROP TABLE IF EXISTS `clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `clients` (
  `idClient` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) DEFAULT NULL,
  `Surname` varchar(45) DEFAULT NULL,
  `DNI_CUIT` bigint(17) DEFAULT NULL,
  `Mail` varchar(45) DEFAULT NULL,
  `Telephone` varchar(20) DEFAULT NULL,
  `Cellphone` varchar(20) DEFAULT NULL,
  `Business_idBusiness` int(11) NOT NULL,
  `Active` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`idClient`) USING BTREE,
  KEY `fk_Clients_Business1_idx` (`Business_idBusiness`),
  CONSTRAINT `fk_Clients_Business1` FOREIGN KEY (`Business_idBusiness`) REFERENCES `business` (`idBusiness`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clients`
--

LOCK TABLES `clients` WRITE;
/*!40000 ALTER TABLE `clients` DISABLE KEYS */;
INSERT INTO `clients` VALUES (0,'Consumidor Final','Consumidor Final',1,' ','0','1',0,_binary ''),(8,'Yare Yare','Dawa',1211,'bot01@mail.com','113212113','11231213',1,_binary ''),(22,'MargossianEmpresa2','11',3,'a',NULL,'111',2,_binary ''),(23,'test','prueba',123456,NULL,NULL,'43214321',1,_binary ''),(25,'nombre','apellido',987654321,NULL,NULL,'40005000',1,_binary ''),(32,'Margossian','Nicolas',5555555,NULL,'1144322258','1165898555',1,_binary ''),(39,'aaa','aaa',43444,NULL,'1125458','1154898',1,_binary ''),(40,'asdf8','asdf9',3246,'hola9','2436','2344',1,_binary ''),(45,'hoola','q hace',555555,NULL,'0','123213213',1,_binary '\0'),(46,'Nicolas','Margossian',43994080,NULL,'0','111561730659',1,_binary ''),(47,'nicolas','margossian2343',439940804,'a','5613','2345',1,_binary ''),(52,'dawa','yareyare',1234,'mnail@q','123','5',1,_binary '\0'),(53,'R','lucas',7,NULL,NULL,NULL,1,_binary '\0'),(54,'xdd','aaa',9,'',NULL,NULL,1,_binary '\0'),(55,'Empresa2','Cliente',2345544,NULL,NULL,NULL,2,_binary ''),(56,'Gabriel','Guivi',32592593,NULL,NULL,'',2,_binary ''),(58,'wz','wz',17181915,'5','5','5',1,_binary '');
/*!40000 ALTER TABLE `clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delivery`
--

DROP TABLE IF EXISTS `delivery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `delivery` (
  `idDelivery` int(11) NOT NULL AUTO_INCREMENT,
  `Transportation_Company` varchar(45) DEFAULT NULL,
  `Telephone` int(11) DEFAULT NULL,
  `Business_idBusiness` int(11) NOT NULL,
  PRIMARY KEY (`idDelivery`) USING BTREE,
  KEY `fk_Delivery_Business1_idx` (`Business_idBusiness`),
  CONSTRAINT `fk_Delivery_Business1` FOREIGN KEY (`Business_idBusiness`) REFERENCES `business` (`idBusiness`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery`
--

LOCK TABLES `delivery` WRITE;
/*!40000 ALTER TABLE `delivery` DISABLE KEYS */;
/*!40000 ALTER TABLE `delivery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `macs`
--

DROP TABLE IF EXISTS `macs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `macs` (
  `idMac` int(11) NOT NULL AUTO_INCREMENT,
  `Mac_Address` varchar(45) DEFAULT NULL,
  `Business_idBusiness` int(11) NOT NULL,
  PRIMARY KEY (`idMac`) USING BTREE,
  KEY `fk_Macs_Business1_idx` (`Business_idBusiness`),
  CONSTRAINT `fk_Macs_Business1` FOREIGN KEY (`Business_idBusiness`) REFERENCES `business` (`idBusiness`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `macs`
--

LOCK TABLES `macs` WRITE;
/*!40000 ALTER TABLE `macs` DISABLE KEYS */;
INSERT INTO `macs` VALUES (1,'192.168.8.16',1);
/*!40000 ALTER TABLE `macs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_methods`
--

DROP TABLE IF EXISTS `payment_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `payment_methods` (
  `idPayment_Method` int(11) NOT NULL AUTO_INCREMENT,
  `Method` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idPayment_Method`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_methods`
--

LOCK TABLES `payment_methods` WRITE;
/*!40000 ALTER TABLE `payment_methods` DISABLE KEYS */;
INSERT INTO `payment_methods` VALUES (1,'BitCoins');
/*!40000 ALTER TABLE `payment_methods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `products` (
  `idProduct` int(11) NOT NULL AUTO_INCREMENT,
  `Article_number` int(11) DEFAULT NULL,
  `Description` varchar(45) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `Cost` float(10,2) unsigned zerofill DEFAULT '0000000.00',
  `Price` float(10,2) unsigned zerofill DEFAULT '0000000.00',
  `PriceW` float(10,2) unsigned zerofill DEFAULT '0000000.00',
  `Age` bit(1) DEFAULT NULL,
  `Stock` int(11) DEFAULT NULL,
  `CodeProduct` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `Suppliers_idSupplier` int(11) NOT NULL,
  `Business_idBusiness` int(11) NOT NULL,
  `Active` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`idProduct`) USING BTREE,
  KEY `fk_Products_Suppliers1_idx` (`Suppliers_idSupplier`),
  KEY `fk_Products_Business1_idx` (`Business_idBusiness`),
  CONSTRAINT `fk_Products_Business1` FOREIGN KEY (`Business_idBusiness`) REFERENCES `business` (`idBusiness`),
  CONSTRAINT `fk_Products_Suppliers1` FOREIGN KEY (`Suppliers_idSupplier`) REFERENCES `suppliers` (`idSupplier`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,1,'Manga Yakusoku no Neverland Vol 1',0002005.00,0000300.00,0000280.00,_binary '',150,'1',3,1,_binary ''),(2,2,'Manga Yakusoku no Neverland Vol 2',0000320.00,0000200.00,0000180.00,_binary '',-58,'2',3,1,_binary ''),(3,3,'Manga Yakusoku no Neverland Vol 4',0000320.00,0000300.00,0000096.00,_binary '',-1037,'3',3,1,_binary ''),(4,5,'Yogurisimo Con Cereales',0000019.00,0000050.00,0000034.00,_binary '',97,'7791337613027',2,1,_binary ''),(7,32,'amazing hat',0050056.00,0000600.00,0054958.00,NULL,32,'434',1,1,_binary ''),(8,85,'awful hat',0000005.00,0000331.00,0000328.00,NULL,-32,'32222',0,1,_binary ''),(9,75,'a beautiful hat',0000035.59,0000080.51,0000040.03,NULL,33,'707',1,1,_binary ''),(17,106,'loljajasalu2',0000081.00,0000071.00,0000082.00,NULL,89,'891',0,1,_binary '\0'),(18,218,'Tabla Periódica',0000010.00,0000040.00,0000030.00,NULL,50,'7798107220218',0,2,_binary ''),(19,1,'item borrar',0000100.00,0000500.00,0000300.00,NULL,75,'12',0,2,_binary ''),(20,3,'Castaña De Caju',0000050.00,0000150.00,0000100.00,NULL,101,'2670550000003',0,2,_binary ''),(21,524,'Liquid Paper',0000020.00,0000100.00,0000080.00,NULL,200,'8854556000524',0,2,_binary ''),(22,524,'liquid',0000030.00,0000030.00,0000030.00,NULL,100,'8854556000524',0,1,_binary '\0'),(23,358,'Elite',0000123.00,0000160.00,0000145.00,NULL,100,'7790250000358',0,2,_binary '');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `provinces`
--

DROP TABLE IF EXISTS `provinces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `provinces` (
  `idProvince` int(11) NOT NULL AUTO_INCREMENT,
  `Province` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`idProvince`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `provinces`
--

LOCK TABLES `provinces` WRITE;
/*!40000 ALTER TABLE `provinces` DISABLE KEYS */;
INSERT INTO `provinces` VALUES (1,'CABA'),(2,'Buenos Aires');
/*!40000 ALTER TABLE `provinces` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `suppliers` (
  `idSupplier` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) DEFAULT NULL,
  `Surname` varchar(45) DEFAULT NULL,
  `Telephone` int(11) DEFAULT NULL,
  `Cellphone` int(11) NOT NULL,
  `Factory` varchar(45) DEFAULT NULL,
  `Business_idBusiness` int(11) NOT NULL,
  `Address` varchar(200) DEFAULT NULL,
  `Mail` varchar(60) DEFAULT NULL,
  `Active` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`idSupplier`) USING BTREE,
  KEY `fk_Supplier_Business1_idx` (`Business_idBusiness`),
  CONSTRAINT `fk_Supplier_Business1` FOREIGN KEY (`Business_idBusiness`) REFERENCES `business` (`idBusiness`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
INSERT INTO `suppliers` VALUES (0,NULL,NULL,NULL,0,NULL,0,NULL,NULL,_binary ''),(1,'Aquiles','Traigo',43216543,13111111,'Nose q va aK xd',1,'En la loma del ort',NULL,_binary ''),(2,'Aquiles','Doy',45678912,1513317546,'yo tampoco jaja salu2',1,'viste china, bueno doblando a la izquierda',NULL,_binary ''),(3,'Ivrea','La',1,1,'EEEE',1,'a','a',_binary ''),(4,'void','main',0,0,'EEEEEEEE',1,NULL,NULL,_binary ''),(5,'Unpro','vedor',15115,14115,'F',2,'Acala vuelta 0','correo@correo',_binary ''),(7,'d','d',1,1,'g',1,'q','r',_binary '\0'),(8,'y','y',4,4,'y',1,'y','y',_binary ''),(9,'w','w',9,9,'w',1,'w','w',_binary '');
/*!40000 ALTER TABLE `suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_extrainfo`
--

DROP TABLE IF EXISTS `user_extrainfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `user_extrainfo` (
  `idUser_ExtraInfo` int(11) NOT NULL AUTO_INCREMENT,
  `Address` varchar(100) DEFAULT NULL,
  `Tel_Father` varchar(50) CHARACTER SET latin2 COLLATE latin2_general_ci DEFAULT NULL,
  `Tel_Mother` varchar(50) CHARACTER SET latin2 COLLATE latin2_general_ci DEFAULT NULL,
  `Tel_Brother` varchar(50) CHARACTER SET latin2 COLLATE latin2_general_ci DEFAULT NULL,
  `Tel_User` varchar(50) CHARACTER SET latin2 COLLATE latin2_general_ci DEFAULT NULL,
  `Healthcare_Company` varchar(45) DEFAULT NULL,
  `Sallary` int(11) DEFAULT NULL,
  `idUser` int(11) NOT NULL,
  `Cellphone` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`idUser_ExtraInfo`) USING BTREE,
  KEY `fk_User_ExtraInfo_Users1_idx` (`idUser`),
  CONSTRAINT `fk_User_ExtraInfo_Users1` FOREIGN KEY (`idUser`) REFERENCES `users` (`idUser`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_extrainfo`
--

LOCK TABLES `user_extrainfo` WRITE;
/*!40000 ALTER TABLE `user_extrainfo` DISABLE KEYS */;
INSERT INTO `user_extrainfo` VALUES (1,'Admin','4444444','333333','5555555','011',NULL,NULL,27,'12'),(2,'Av Rivadavia 6015 13C','01144404555','01149607853','01164538472','44322210',NULL,NULL,28,'11617306599'),(6,'para borrar usuario a','889','1000','778','110',NULL,NULL,32,'200'),(8,'Formosa 430','888','999','777','12',NULL,NULL,35,'13'),(10,NULL,NULL,NULL,NULL,NULL,NULL,NULL,37,NULL);
/*!40000 ALTER TABLE `user_extrainfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `users` (
  `idUser` int(11) NOT NULL AUTO_INCREMENT,
  `Mail` varchar(45) DEFAULT NULL,
  `Password` varchar(45) DEFAULT NULL,
  `Admin` bit(1) DEFAULT NULL,
  `Name` varchar(45) DEFAULT NULL,
  `Surname` varchar(45) DEFAULT NULL,
  `Name_Second` varchar(45) DEFAULT NULL,
  `Business_idBusiness` int(11) NOT NULL,
  `Dni` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idUser`) USING BTREE,
  KEY `fk_Users_Business1_idx` (`Business_idBusiness`),
  CONSTRAINT `fk_Users_Business1` FOREIGN KEY (`Business_idBusiness`) REFERENCES `business` (`idBusiness`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (27,'admin@admin','21232f297a57a5a743894a0e4a801fc3',_binary '','admin','admin','admin',1,'13'),(28,'nicolasmargossian@gmail.com','7510d498f23f5815d3376ea7bad64e29',_binary '\0','Nicolas','hola','Alejandro Anushavan',1,'43994080'),(32,'bo@boa','21232f297a57a5a743894a0e4a801fc3',_binary '\0','ParaBorrar a','Borrar a','borrar a',1,'300'),(34,'n@n','21232f297a57a5a743894a0e4a801fc3',_binary '','nico','margo','Alejandro Anushavan',2,'43994080'),(35,'mati@mati','4d186321c1a7f0f354b297e8914ab240',_binary '\0','Matias','Santoro','Javier',2,'43994857'),(37,'m@m','21232f297a57a5a743894a0e4a801fc3',_binary '\0','nombre modificar ','apellido modificar ',NULL,2,'11111');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'bd_agcs'
--
/*!50003 DROP PROCEDURE IF EXISTS `spBillInsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spBillInsert`(IN `pIdBusiness` INT, IN `pDate` DATETIME, IN `pTotal` FLOAT, IN `pDNI` INT)
BEGIN
	if EXISTS(select clients.idClient from clients where (clients.DNI_CUIT = pDNI and pIdBusiness = clients.Business_idBusiness and clients.Active = 1) or (pDNI = 1))
    THEN
    	SET  @idClient = (select clients.idClient from clients where clients.DNI_CUIT = pDNI and ((clients.Business_idBusiness = pIdBusiness and clients.Active = 1) or pDNI = 1));
		Insert into bills(bills.DateBill,bills.Total,bills.Business_idBusiness,bills.Clients_idClient) values( pDate, pTotal, pIdBusiness,@idClient);
    	select bills.idBill from bills where bills.idBill = LAST_INSERT_ID() and bills.DateBill = pDate and bills.Total = ptotal and bills.Business_idBusiness = pIdBusiness and bills.Clients_idClient = @idClient;
    ELSE
    	select -1 as idBill;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spBillXProductInsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spBillXProductInsert`(IN `pIdBill` INT, IN `pIdProduct` INT, IN `pQuantity` INT, IN `pIdBusiness` INT)
BEGIN
	if exists(select products.idProduct from products where products.idProduct = pIdProduct and products.Business_idBusiness = pIdBusiness and products.Active = 1) and exists(select bills.idBill from bills where bills.idBill = pIdBill and bills.Business_idBusiness = pIdBusiness)
    then
		if(pQuantity > 0 and pQuantity is not null)
        then
			insert into bills_x_products(bills_x_products.Products_idProduct,bills_x_products.Bills_idBill,bills_x_products.Quantity) values(pIdProduct,pIdBill,pQuantity);
            update products set products.Stock = products.Stock - pQuantity where products.idProduct = pIdProduct and products.Business_idBusiness = pIdBusiness and products.Active = 1;
		else
			insert into bills_x_products(bills_x_products.Products_idProduct,bills_x_products.Bills_idBill,bills_x_products.Quantity) values(pIdProduct,pIdBill,0);
        end if;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spClientDelete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spClientDelete`(IN `id` INT, IN `pIdBusiness` INT)
    NO SQL
if(EXISTS(SELECT clients.idClient FROM clients WHERE clients.idClient = id and clients.Business_idBusiness = pIdBusiness))
THEN
	Update clients set clients.Active = 0 where clients.idClient = id and clients.Business_idBusiness = pIdBusiness and clients.Active = 1;
end IF ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spClientGetByDNI` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spClientGetByDNI`(IN `pDNI` BIGINT, IN `pIdBusiness` INT)
    NO SQL
select clients.idClient,clients.Name, clients.Surname,clients.Cellphone,clients.Mail from clients where ((clients.DNI_CUIT = pDNI and clients.Business_idBusiness = pIdBusiness) or (pDNI = 1 and pDNI = clients.DNI_CUIT and clients.idClient = 0)) and clients.Active = 1 ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spClientGetById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spClientGetById`(IN `id` INT, IN `pIdBusiness` INT)
    NO SQL
SELECT * FROM clients WHERE clients.idClient = id and clients.Business_idBusiness = pIdBusiness and clients.Active = 1 ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spClientInsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spClientInsert`(IN `pIdBusiness` INT, IN `pName` VARCHAR(45), IN `pSurname` VARCHAR(45), IN `pDNI_CUIT` LONG, IN `pMail` VARCHAR(45), IN `pTelephone` VARCHAR(20), IN `pCellphone` VARCHAR(20))
    NO SQL
if( pIdBusiness > -1 && pName != "" && pSurname != "" && pDNI_CUIT > 1 && not exists(select clients.idClient from clients where clients.DNI_CUIT = pDNI_CUIT and clients.Business_idBusiness = pIdBusiness))
then
	insert into clients(clients.Name,clients.Surname,clients.DNI_CUIT,clients.Business_idBusiness) values( pName, pSurname, pDNI_CUIT, pIdBusiness);
	
    set @lastId = (select clients.idClient from clients where clients.idClient = LAST_INSERT_ID() and clients.Name = pName and clients.Surname = pSurname and clients.DNI_CUIT = pDNI_CUIT and clients.Business_idBusiness = pIdBusiness);
	
    if(@lastId is not null)
    then
    
		if( pMail is not null  /*and pMail != (SELECT clients.Mail from clients where clients.idClient = @lastId)*/) 
		THEN
			UPDATE clients set clients.Mail = pMail WHERE clients.idClient = @lastId and clients.Business_idBusiness = pIdBusiness; 
		end if;
		
		if( pTelephone is not null  /*and pTelephone != (SELECT clients.Telephone from clients where clients.idClient = @lastId)*/) 
		THEN
			UPDATE clients set clients.Telephone = pTelephone WHERE clients.idClient = @lastId and clients.Business_idBusiness = pIdBusiness; 
		end if;
		
		if( pCellphone is not null /*and pCellphone != (SELECT clients.Cellphone from clients where clients.idClient = @lastId)*/) 
		THEN
			UPDATE clients set clients.Cellphone = pCellphone WHERE clients.idClient = @lastId and clients.Business_idBusiness = pIdBusiness; 
		end if;
    end if;
end if ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spClientsGet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spClientsGet`(IN `pIdBusiness` INT)
    NO SQL
SELECT clients.idClient, clients.Name, clients.Surname, clients.DNI_CUIT, clients.Mail,clients.Cellphone FROM clients where clients.Business_idBusiness = pIdBusiness and clients.Active = 1 ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spClientUpdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spClientUpdate`(IN `id` INT, IN `pIdBusiness` INT, IN `pName` VARCHAR(45), IN `pSurname` VARCHAR(45), IN `pDNI_Cuit` LONG, IN `pMail` VARCHAR(45), IN `pTelephone` VARCHAR(20), IN `pCellphone` VARCHAR(20))
    NO SQL
if(EXISTS(SELECT clients.idClient from clients WHERE clients.idClient = id and clients.Business_idBusiness = pIdBusiness and clients.Active = 1))
THEN
	if(pName != "" and pSurname != "" and pDNI_CUIT > 0 and pDNI_CUIT != ""  )
    then
		if( pName is not null and pName!= (SELECT clients.Name from clients where clients.idClient = id) ) 
		THEN
			UPDATE clients set Name = pName WHERE clients.idClient = id and clients.Business_idBusiness = pIdBusiness; 
		end if;
		
		if( pSurname is not null and pSurname != (SELECT clients.Surname from clients where clients.idClient = id)) 
		THEN
			UPDATE clients set clients.Surname = pSurname WHERE clients.idClient = id and clients.Business_idBusiness = pIdBusiness; 
		end if;
		
		if( pDNI_CUIT is not null and pDNI_CUIT != (SELECT clients.DNI_CUIT from clients where clients.idClient = id) and not exists(SELECT clients.DNI_CUIT from clients where clients.DNI_CUIT = pDNI_CUIT and clients.Business_idBusiness = pIdBusiness)) 
		THEN
			UPDATE clients set clients.DNI_CUIT = pDNI_CUIT WHERE clients.idClient = id and clients.Business_idBusiness = pIdBusiness; 
		end if;
		
		if( pMail is not null) 
		THEN
			UPDATE clients set clients.Mail = pMail WHERE clients.idClient = id and clients.Business_idBusiness = pIdBusiness; 
		end if;
		
		UPDATE clients set clients.Telephone = pTelephone WHERE clients.idClient = id and clients.Business_idBusiness = pIdBusiness; 

		UPDATE clients set clients.Cellphone = pCellphone WHERE clients.idClient = id and clients.Business_idBusiness = pIdBusiness; 
		
	end if;
end if ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spProductDelete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spProductDelete`(IN `pId` INT, IN `pIdBusiness` INT)
BEGIN
    update products set products.Active = 0 where Products.idProduct = pId and Products.Business_idBusiness = pIdBusiness and products.active = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spProductGetByCode` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spProductGetByCode`(IN `pCode` LONG, IN `pIdBusiness` INT)
BEGIN
	SELECT * FROM products WHERE (/*products.Article_Number = pCode or */products.CodeProduct = pCode) and products.Business_idBusiness = pIdBusiness and products.Active = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spProductGetById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spProductGetById`(IN `pId` LONG, IN `pIdBusiness` INT)
BEGIN
	SELECT * FROM products WHERE products.idProduct = pId and products.Business_idBusiness = pIdBusiness and products.Active = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spProductInsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spProductInsert`(IN `pIdBusiness` INT, IN `pProduct_Number` INT, IN `pCode` VARCHAR(100), IN `pDescription` VARCHAR(50), IN `pCost` FLOAT(10,2), IN `pPrice` FLOAT(10,2), IN `pPriceW` FLOAT(10,2), IN `pStock` INT, IN `pIdSupplier` INT)
BEGIN
	if (not exists(select Products.idProduct from Products where Products.Business_idBusiness = pIdBusiness and (Products.CodeProduct = pCode or Products.Article_number = pProduct_Number)))
    then
		if exists(select Suppliers.idSupplier from Suppliers where (Suppliers.Business_idBusiness = pIdBusiness or Suppliers.Business_idBusiness = 0) and Suppliers.idSupplier = pIdSupplier)
        then
			if(pProduct_Number > 0)
            then 
				insert into Products(Products.Business_idBusiness,Products.Article_number,Products.CodeProduct,Products.Description,Products.Stock,Products.Suppliers_idSupplier) values(pIdBusiness, pProduct_Number, pCode, pDescription, pStock, pIdSupplier);
                set @lastId = (select Products.idProduct from Products where Products.idProduct = LAST_INSERT_ID());# and Products.Business_idBusiness = pIdBusiness /*and Products.Article_number = pProduct_Number*/ and Products.CodeProduct = pCode and Products.Description = pDescription/* and Products.Stock = pStock*/ and Products.Suppliers_idSupplier = pIdSupplier);
                if(@lastId is not null)
                then
					if(pCost > 0)
					then
						Update Products set Products.Cost = pCost where Products.idProduct = @lastId; 
					end if;
					if(pPrice > 0)
					then
						Update Products set Products.Price = pPrice where Products.idProduct = @lastId; 
					end if;
                    if(pPriceW > 0)
					then
						Update Products set Products.PriceW = pPriceW where Products.idProduct = @lastId; 
					end if;
				end if; #endif lastId is not null 
			end if;#endif ProductNumber > 0
        end if;#endif Supplier exists
	end if;#endif not exists product with same code or product number in the same business
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spProductsGet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spProductsGet`(IN `pIdBusiness` INT)
BEGIN
	select * from Products where Products.Business_idBusiness = pIdBusiness and products.Active = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spProductStockUpdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spProductStockUpdate`(IN `pidProduct` INT, IN `pIdBusiness` INT, IN `pStock` INT)
BEGIN
	update products set products.stock = pStock where products.idProduct = pidProduct and products.Business_idBusiness = pIdBusiness and products.Active = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spProductUpdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spProductUpdate`(IN `pId` INT, IN `pIdBusiness` INT, IN `pProduct_Number` INT, IN `pCode` VARCHAR(100), IN `pDescription` VARCHAR(50), IN `pCost` FLOAT, IN `pPrice` FLOAT, IN `pPriceW` FLOAT, IN `pStock` INT, IN `pIdSupplier` INT)
BEGIN
	if exists(select Products.idProduct from Products where Products.idProduct = pId and Products.Business_idBusiness = pIdBusiness and products.Active = 1)
    then
		#Product Number
        if (not exists(select Products.idProduct from Products where Products.Article_Number = pProduct_Number and Products.Business_idBusiness = pIdBusiness) and pProduct_Number > 0 and pProduct_Number is not null )
        then
			update Products set Products.Article_number = pProduct_Number where Products.idProduct = pId and Products.Business_idBusiness = pIdBusiness;
        end if;
        
		#Code
        if (not exists(select Products.idProduct from Products where Products.CodeProduct = pCode and Products.Business_idBusiness = pIdBusiness) and pCode != "" and pCode is not null )
        then
			update Products set Products.CodeProduct = pCode where Products.idProduct = pId and Products.Business_idBusiness = pIdBusiness;
        end if;
        
		#Description
        if (pDescription is not null )
        then
			update Products set Products.Description = pDescription where Products.idProduct = pId and Products.Business_idBusiness = pIdBusiness;
        end if;
        
		#Cost
        if (pCost != (select Products.Cost from Products where Products.idProduct = pId and Products.Business_idBusiness = pIdBusiness) and pCost > 0 and pCost is not null )
        then
			update Products set Products.Cost = pCost where Products.idProduct = pId and Products.Business_idBusiness = pIdBusiness;
        end if;
        
		#Price
        if (pPrice - (select Products.Price from Products where Products.idProduct = pId and Products.Business_idBusiness = pIdBusiness) != 0 and pPrice > 0 and pPrice is not null)
        then
			update Products set Products.Price = pPrice where Products.idProduct = pId and Products.Business_idBusiness = pIdBusiness;
        end if;
        
		#PriceW
        if (pPriceW - (select Products.PriceW from Products where Products.idProduct = pId and Products.Business_idBusiness = pIdBusiness) != 0 and pPriceW > 0 and pPriceW is not null)
        then
			    update Products set Products.PriceW = pPriceW where Products.idProduct = pId and Products.Business_idBusiness = pIdBusiness;
        end if;
	    	#Stock
		    update Products set Products.Stock = pStock where Products.idProduct = pId and Products.Business_idBusiness = pIdBusiness;
         
        #Supplier
        if (pIdSupplier != (select Products.Suppliers_idSupplier from Products where Products.idProduct = pId and Products.Business_idBusiness = pIdBusiness) and exists(select Suppliers.idSupplier from Suppliers where Suppliers.idSupplier = pIdSupplier and (Suppliers.Business_idBusiness = pIdBusiness or Suppliers.Business_idBusiness = 0)))
        then
			update Products set Products.Suppliers_idSupplier = pIdSupplier where Products.idProduct = pId and Products.Business_idBusiness = pIdBusiness;
        end if;
        
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSupplierDelete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spSupplierDelete`(IN `pId` INT, IN `pIdBusiness` INT)
BEGIN
if(EXISTS(SELECT suppliers.idSupplier FROM suppliers WHERE suppliers.idSupplier = pId and suppliers.Business_idBusiness = pIdBusiness))
THEN
	Update suppliers set suppliers.Active = 0 where suppliers.idSupplier = pId and suppliers.Business_idBusiness = pIdBusiness and suppliers.Active = 1;
end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSupplierGetById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spSupplierGetById`(In `pId` int,IN `pIdBusiness` INT)
BEGIN
	select * from suppliers where idSupplier = pId and Business_idBusiness = pIdBusiness and Active = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSupplierInsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spSupplierInsert`(IN `pIdBusiness` INT(20), IN `pName` VARCHAR(100), IN `pSurname` VARCHAR(100), IN `pTelephone` INT(20), IN `pCellphone` INT(20), IN `pFactory` VARCHAR(100), IN `pAddress` VARCHAR(200), IN `pMail` VARCHAR(100))
    NO SQL
if not EXISTS(select idSupplier from suppliers where Name = pName and Surname = pSurname and Business_idBusiness = pIdBusiness)
then
    INSERT INTO suppliers (Business_idBusiness, Name, Surname, Telephone, Cellphone, Factory, Address, Mail) VALUES(pIdBusiness, pName, pSurname, pTelephone, pCellphone, pFactory, pAddress, pMail);
end if ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSuppliersGet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spSuppliersGet`(IN `pIdBusiness` INT)
BEGIN
	select * from suppliers where Business_idBusiness = pIdBusiness and Active = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSupplierUpdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spSupplierUpdate`(IN `pId` INT(20), IN `pIdBusiness` INT(20), IN `pName` VARCHAR(100), IN `pSurname` VARCHAR(100), IN `pTelephone` VARCHAR(20), IN `pCellphone` VARCHAR(20), IN `pFactory` VARCHAR(100), IN `pAddress` VARCHAR(200), IN `pMail` VARCHAR(100))
    NO SQL
if EXISTS(select idSupplier from suppliers where idSupplier = pId and Business_idBusiness = pIdBusiness and Active = 1)
THEN
	if not EXISTS(select idSupplier from suppliers where Name = pName and Surname = pSurname and Business_idBusiness = pIdBusiness)
    THEN
		update suppliers set Name = pName where idSupplier = pId and Business_idBusiness = pIdBusiness;
        update suppliers set Surname = pSurname where idSupplier = pId and Business_idBusiness = pIdBusiness;
    end if;
    update suppliers set Telephone = pTelephone where idSupplier = pId and Business_idBusiness = pIdBusiness;
    update suppliers set Cellphone = pCellphone where idSupplier = pId and Business_idBusiness = pIdBusiness;
    update suppliers set Factory = pFactory where idSupplier = pId and Business_idBusiness = pIdBusiness;
    update suppliers set address = pAddress where idSupplier = pId and Business_idBusiness = pIdBusiness;
    update suppliers set Mail = pMail where idSupplier = pId and Business_idBusiness = pIdBusiness;
end if ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUserChangePassword` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spUserChangePassword`(IN `pOriginal` VARCHAR(60), IN `pNew` VARCHAR(60), IN `pId` BIGINT)
    NO SQL
if exists(select users.idUser from users where users.idUser = pId and users.Password = md5(pOriginal))
	then
    	update users set users.Password = md5(pNew) where users.idUser = pId;
    end if ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUserDelete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spUserDelete`(IN `pId` INT, IN `pIdBusiness` INT)
if(EXISTS(SELECT users.idUser FROM users WHERE users.idUser = pId and users.Business_idBusiness = pIdBusiness))
THEN
	DELETE from user_extrainfo WHERE  user_extrainfo.idUser = pId;
	DELETE from users WHERE users.idUser = pId and users.Business_idBusiness = pIdBusiness;
end IF ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUserGetById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spUserGetById`(IN `pId` INT, IN `pIdBusiness` INT)
    NO SQL
SELECT users.idUser, users.Mail ,users.Name ,users.Surname ,users.Name_Second ,users.Dni, user_extrainfo.Address, user_extrainfo.Tel_Father, user_extrainfo.Tel_Mother,user_extrainfo.Tel_Brother, user_extrainfo.Tel_User,user_extrainfo.Cellphone FROM users inner join user_extrainfo on user_extrainfo.idUser = users.idUser WHERE users.idUser = pId and users.Business_idBusiness= pIdBusiness ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUserInsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spUserInsert`(IN `pIdBusiness` INT, IN `pName` VARCHAR(60), IN `pSurname` VARCHAR(60), IN `pDni` BIGINT, IN `pMail` VARCHAR(60), IN `pTelephone` VARCHAR(60), IN `pPass` VARCHAR(60), IN `pCellphone` VARCHAR(60), IN `pAddress` VARCHAR(55), IN `pTelephoneM` VARCHAR(55), IN `pTelephoneF` VARCHAR(55), IN `pTelephoneB` VARCHAR(55), IN `pSecondN` VARCHAR(55))
    NO SQL
if( pIdBusiness > -1 and pName != "" and pPass != "" and pSurname != "" and not exists(select users.idUser from users where users.Mail = pMail or (users.Dni = pDni and users.Business_idBusiness = pIdBusiness)))
then
	insert into users (users.Name,users.Surname,users.Business_idBusiness, users.Password, users.Mail,users.Admin) values( pName, pSurname,pIdBusiness,md5(pPass),pMail,0);	
    set @lastId = (select users.idUser from users where users.idUser = LAST_INSERT_ID() and users.Name = pName and users.Surname = pSurname and users.Business_idBusiness = pIdBusiness);
    if(@lastId is not null)
    then    
    	insert into user_extrainfo (user_extrainfo.idUser) values (@lastId);
		if( pDni is not null) 
		THEN
			UPDATE users set users.Dni = pDni WHERE users.idUser = @lastId and users.Business_idBusiness = pIdBusiness; 
		end if;	
        if( pSecondN is not null) 
		THEN
			UPDATE users set users.Name_Second = pSecondN WHERE users.idUser = @lastId and users.Business_idBusiness = pIdBusiness; 
		end if;	
         if( pTelephone is not null) 
		THEN
			UPDATE user_extrainfo set user_extrainfo.Tel_User = pTelephone WHERE user_extrainfo.idUser = @lastId; 
		end if;	
        if( pTelephoneM is not null) 
		THEN
			UPDATE user_extrainfo set user_extrainfo.Tel_Mother = pTelephoneM WHERE user_extrainfo.idUser = @lastId; 
		end if;	
        if( pTelephoneF is not null) 
		THEN
			UPDATE user_extrainfo set user_extrainfo.Tel_Father = pTelephoneF WHERE user_extrainfo.idUser = @lastId; 
		end if;	
        if( pTelephoneB is not null) 
		THEN
			UPDATE user_extrainfo set user_extrainfo.Tel_Brother = pTelephoneB WHERE user_extrainfo.idUser = @lastId; 
		end if;
        if( pAddress is not null) 
		THEN
			UPDATE user_extrainfo set user_extrainfo.Address = pAddress WHERE user_extrainfo.idUser = @lastId; 
		end if;
        if( pCellphone is not null) 
		THEN
			UPDATE user_extrainfo set user_extrainfo.Cellphone = pCellphone WHERE user_extrainfo.idUser = @lastId; 
		end if;	
		
		select 1 as success; #Insert Success
    end if;
    else
		select 0 as success; #Insert Fail
end if ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUserLogin` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spUserLogin`(IN `Mail` VARCHAR(320), IN `Password` VARCHAR(200))
SELECT users.Name, users.Surname, users.Admin, users.idUser, business.idBusiness, business.Name as NameB from users INNER JOIN business ON business.idBusiness = users.Business_idBusiness where Mail = users.Mail and md5(Password) = users.Password ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUsersGet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spUsersGet`(IN `pIdBusiness` INT)
    NO SQL
SELECT user_extrainfo.Cellphone, users.idUser, users.Name, users.Surname, users.Dni, users.Mail FROM users left join user_extrainfo on users.idUser = user_extrainfo.idUser where users.Business_idBusiness = pIdBusiness and users.Admin != 1 ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUserUpdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spUserUpdate`(IN `id` INT, IN `pIdBusiness` INT, IN `pName` VARCHAR(60), IN `pSurname` VARCHAR(60), IN `pDNI_CUIT` INT, IN `pMail` VARCHAR(60), IN `pTelephone` VARCHAR(60), IN `pCellphone` VARCHAR(60), IN `pTelephoneM` VARCHAR(60), IN `pTelephoneF` VARCHAR(60), IN `pTelephoneB` VARCHAR(60), IN `pAddress` VARCHAR(60), IN `pSecondN` VARCHAR(60))
    NO SQL
if(EXISTS(SELECT users.idUser from users WHERE users.idUser = id and users.Business_idBusiness = pIdBusiness))
THEN
	if(pName != "" and pSurname != "" and pDNI_CUIT != "" and pMail!= "" )
    then
        
         if( pName is not null and pName!= (SELECT users.Name from users where users.idUser = id) ) 
		THEN
			UPDATE users set Name = pName WHERE users.idUser = id and users.Business_idBusiness = pIdBusiness; 
		end if;
        
        if( pSecondN is not null and pSecondN!= (SELECT users.Name_Second from users where users.idUser = id) ) 
		THEN
			UPDATE users set Name_Second = pSecondN WHERE users.idUser = id and users.Business_idBusiness = pIdBusiness; 
		end if;
		
		if( pSurname is not null and pSurname != (SELECT users.Surname from users where users.idUser = id)) 
		THEN
			UPDATE users set users.Surname = pSurname WHERE users.idUser = id and users.Business_idBusiness = pIdBusiness; 
		end if;
		
		if( pDNI_CUIT is not null and pDNI_CUIT != (SELECT users.Dni from users where users.idUser = id) and not exists(SELECT users.Dni from users where users.Dni = pDNI_CUIT and users.Business_idBusiness = pIdBusiness)) 
		THEN
			UPDATE users set users.Dni = pDNI_CUIT WHERE users.idUser = id and users.Business_idBusiness = pIdBusiness; 
		end if;
		
		if( pMail is not null and pMail != (SELECT users.Mail from users where users.idUser = id) and not exists(SELECT users.Mail from users where users.Mail = pMail and users.Business_idBusiness = pIdBusiness)) 
		THEN
			UPDATE users set users.Mail = pMail WHERE users.idUser = id and users.Business_idBusiness = pIdBusiness; 
		end if;
		
		if( pTelephone is not null and pTelephone != "") 
		THEN
			UPDATE user_ExtraInfo set user_ExtraInfo.Tel_User = pTelephone WHERE user_ExtraInfo.idUser = id; 
		end if;
		
		if( pCellphone is not null and pCellphone != "") 
		THEN
			UPDATE user_ExtraInfo set user_ExtraInfo.Cellphone = pCellphone WHERE user_ExtraInfo.idUser = id; 
		end if;
        
        if( pTelephoneM is not null and pTelephoneM != "") 
		THEN
			UPDATE user_ExtraInfo set user_ExtraInfo.Tel_Mother = pTelephoneM WHERE user_ExtraInfo.idUser = id; 
		end if;
        
        if( pTelephoneF is not null and pTelephoneF != "") 
		THEN
			UPDATE user_ExtraInfo set user_ExtraInfo.Tel_Father = pTelephoneF WHERE user_ExtraInfo.idUser = id; 
		end if;
        
        if( pTelephoneB is not null and pTelephoneB != "") 
		THEN
			UPDATE user_ExtraInfo set user_ExtraInfo.Tel_Brother = pTelephoneB WHERE user_ExtraInfo.idUser = id; 
		end if;
        
        if( pAddress is not null and pAddress != "") 
		THEN
			UPDATE user_ExtraInfo set user_ExtraInfo.Address = pAddress WHERE user_ExtraInfo.idUser = id; 
		end if;
        
        
	end if;
end if ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-09-30 22:53:21
