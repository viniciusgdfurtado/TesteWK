CREATE DATABASE  IF NOT EXISTS `wk` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `wk`;
-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: wk
-- ------------------------------------------------------
-- Server version	8.0.40

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
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `codigo` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `cidade` varchar(50) DEFAULT NULL,
  `uf` char(2) DEFAULT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'Cliente 1','São Paulo','SP'),(2,'Cliente 2','Rio de Janeiro','RJ'),(3,'Cliente 3','Belo Horizonte','MG'),(4,'Cliente 4','Curitiba','PR'),(5,'Cliente 5','Florianópolis','SC'),(6,'Cliente 6','Porto Alegre','RS'),(7,'Cliente 7','Brasília','DF'),(8,'Cliente 8','Salvador','BA'),(9,'Cliente 9','Fortaleza','CE'),(10,'Cliente 10','Recife','PE'),(11,'Cliente 11','Manaus','AM'),(12,'Cliente 12','Belém','PA'),(13,'Cliente 13','Goiânia','GO'),(14,'Cliente 14','Campinas','SP'),(15,'Cliente 15','São Luís','MA'),(16,'Cliente 16','Maceió','AL'),(17,'Cliente 17','Aracaju','SE'),(18,'Cliente 18','João Pessoa','PB'),(19,'Cliente 19','Natal','RN'),(20,'Cliente 20','Vitória','ES'),(21,'Cliente 21','Cuiabá','MT'),(22,'Cliente 22','Campo Grande','MS'),(23,'Cliente 23','São José','SC'),(24,'Cliente 24','Londrina','PR'),(25,'Cliente 25','Ribeirão Preto','SP'),(26,'Cliente 26','Uberlândia','MG'),(27,'Cliente 27','Juiz de Fora','MG'),(28,'Cliente 28','Sorocaba','SP'),(29,'Cliente 29','Bauru','SP'),(30,'Cliente 30','Volta Redonda','RJ');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-10  0:26:11
