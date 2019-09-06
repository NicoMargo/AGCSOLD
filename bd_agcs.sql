-- phpMyAdmin SQL Dump
-- version 4.7.9
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 06-09-2019 a las 15:15:01
-- Versión del servidor: 5.7.21
-- Versión de PHP: 5.6.35

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bd_agcs`
--

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `spBillInsert`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spBillInsert` (IN `pIdBusiness` INT, IN `pDate` DATETIME, IN `pTotal` FLOAT, IN `pDNI` INT)  BEGIN
	if EXISTS(select clients.idClients from clients where (clients.DNI_CUIT = pDNI and pIdBusiness = clients.Business_idBusiness and clients.Active = 1) or (pDNI = 1))
    THEN
    	SET  @idClient = (select clients.idClients from clients where clients.DNI_CUIT = pDNI and ((clients.Business_idBusiness = pIdBusiness and clients.Active = 1) or pDNI = 1));
		Insert into bills(bills.DateBill,bills.Total,bills.Business_idBusiness,bills.Clients_idClients) values( pDate, pTotal, pIdBusiness,@idClient);
    	select bills.idBills from bills where bills.idBills = LAST_INSERT_ID() and bills.DateBill = pDate and bills.Total = ptotal and bills.Business_idBusiness = pIdBusiness and bills.Clients_idClients = @idClient;
    ELSE
    	select -1 as idBills;
    end if;
END$$

DROP PROCEDURE IF EXISTS `spBillXProductInsert`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spBillXProductInsert` (IN `pIdBill` INT, IN `pIdProduct` INT, IN `pQuantity` INT, IN `pIdBusiness` INT)  BEGIN
	if exists(select products.idProducts from products where products.idProducts = pIdProduct and products.Business_idBusiness = pIdBusiness and products.Active = 1) and exists(select bills.idBills from bills where bills.idBills = pIdBill and bills.Business_idBusiness = pIdBusiness)
    then
		if(pQuantity > 0 and pQuantity is not null)
        then
			insert into bills_x_products(bills_x_products.Products_idProducts,bills_x_products.Bills_idBills,bills_x_products.Quantity) values(pIdProduct,pIdBill,pQuantity);
            update products set products.Stock = products.Stock - pQuantity where products.idProducts = pIdProduct and products.Business_idBusiness = pIdBusiness and products.Active = 1;
		else
			insert into bills_x_products(bills_x_products.Products_idProducts,bills_x_products.Bills_idBills,bills_x_products.Quantity) values(pIdProduct,pIdBill,0);
        end if;
    end if;
END$$

DROP PROCEDURE IF EXISTS `spClientDelete`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spClientDelete` (IN `id` INT, IN `pIdBusiness` INT)  NO SQL
if(EXISTS(SELECT clients.idClients FROM clients WHERE clients.idClients = id and clients.Business_idBusiness = pIdBusiness))
THEN
	Update clients set clients.Active = 0 where clients.idClients = id and clients.Business_idBusiness = pIdBusiness and clients.Active = 1;
end IF$$

DROP PROCEDURE IF EXISTS `spClientGetByDNI`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spClientGetByDNI` (IN `pDNI` BIGINT, IN `pIdBusiness` INT)  NO SQL
select clients.idClients,clients.Name, clients.Surname,clients.Cellphone,clients.eMail from clients where ((clients.DNI_CUIT = pDNI and clients.Business_idBusiness = pIdBusiness) or (pDNI = 1 and pDNI = clients.DNI_CUIT and clients.idClients = 0)) and clients.Active = 1$$

DROP PROCEDURE IF EXISTS `spClientGetById`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spClientGetById` (IN `id` INT, IN `pIdBusiness` INT)  NO SQL
SELECT * FROM clients WHERE clients.idClients = id and clients.Business_idBusiness = pIdBusiness and clients.Active = 1$$

DROP PROCEDURE IF EXISTS `spClientInsert`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spClientInsert` (IN `pIdBusiness` INT, IN `pName` VARCHAR(45), IN `pSurname` VARCHAR(45), IN `pDNI_CUIT` LONG, IN `pEmail` VARCHAR(45), IN `pTelephone` VARCHAR(20), IN `pCellphone` VARCHAR(20))  NO SQL
if( pIdBusiness > -1 && pName != "" && pSurname != "" && pDNI_CUIT > 1 && not exists(select clients.idClients from clients where clients.DNI_CUIT = pDNI_CUIT and clients.Business_idBusiness = pIdBusiness))
then
	insert into clients(clients.Name,clients.Surname,clients.DNI_CUIT,clients.Business_idBusiness) values( pName, pSurname, pDNI_CUIT, pIdBusiness);
	
    set @lastId = (select clients.idClients from clients where clients.idClients = LAST_INSERT_ID() and clients.Name = pName and clients.Surname = pSurname and clients.DNI_CUIT = pDNI_CUIT and clients.Business_idBusiness = pIdBusiness);
	
    if(@lastId is not null)
    then
    
		if( pEmail is not null  /*and pEmail != (SELECT clients.eMail from clients where clients.idClients = @lastId)*/) 
		THEN
			UPDATE clients set clients.eMail = pEmail WHERE clients.idClients = @lastId and clients.Business_idBusiness = pIdBusiness; 
		end if;
		
		if( pTelephone is not null  /*and pTelephone != (SELECT clients.Telephone from clients where clients.idClients = @lastId)*/) 
		THEN
			UPDATE clients set clients.Telephone = pTelephone WHERE clients.idClients = @lastId and clients.Business_idBusiness = pIdBusiness; 
		end if;
		
		if( pCellphone is not null /*and pCellphone != (SELECT clients.Cellphone from clients where clients.idClients = @lastId)*/) 
		THEN
			UPDATE clients set clients.Cellphone = pCellphone WHERE clients.idClients = @lastId and clients.Business_idBusiness = pIdBusiness; 
		end if;
		select 1 as success; #Insert Success
    end if;
    else
		select 0 as success; #Insert Fail
end if$$

DROP PROCEDURE IF EXISTS `spClientsGet`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spClientsGet` (IN `pIdBusiness` INT)  NO SQL
SELECT clients.idClients, clients.Name, clients.Surname, clients.DNI_CUIT, clients.eMail,clients.Cellphone FROM clients where clients.Business_idBusiness = pIdBusiness and clients.Active = 1$$

DROP PROCEDURE IF EXISTS `spClientUpdate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spClientUpdate` (IN `id` INT, IN `pIdBusiness` INT, IN `pName` VARCHAR(45), IN `pSurname` VARCHAR(45), IN `pDNI_Cuit` LONG, IN `pEmail` VARCHAR(45), IN `pTelephone` VARCHAR(20), IN `pCellphone` VARCHAR(20))  NO SQL
if(EXISTS(SELECT clients.idClients from clients WHERE clients.idClients = id and clients.Business_idBusiness = pIdBusiness and clients.Active = 1))
THEN
	if(pName != "" and pSurname != "" and pDNI_CUIT > 0 and pDNI_CUIT != ""  )
    then
		if( pName is not null and pName!= (SELECT clients.Name from clients where clients.idClients = id) ) 
		THEN
			UPDATE clients set Name = pName WHERE clients.idClients = id and clients.Business_idBusiness = pIdBusiness; 
		end if;
		
		if( pSurname is not null and pSurname != (SELECT clients.Surname from clients where clients.idClients = id)) 
		THEN
			UPDATE clients set clients.Surname = pSurname WHERE clients.idClients = id and clients.Business_idBusiness = pIdBusiness; 
		end if;
		
		if( pDNI_CUIT is not null and pDNI_CUIT != (SELECT clients.DNI_CUIT from clients where clients.idClients = id) and not exists(SELECT clients.DNI_CUIT from clients where clients.DNI_CUIT = pDNI_CUIT and clients.Business_idBusiness = pIdBusiness)) 
		THEN
			UPDATE clients set clients.DNI_CUIT = pDNI_CUIT WHERE clients.idClients = id and clients.Business_idBusiness = pIdBusiness; 
		end if;
		
		if( pEmail is not null) 
		THEN
			UPDATE clients set clients.eMail = pEmail WHERE clients.idClients = id and clients.Business_idBusiness = pIdBusiness; 
		end if;
		
		UPDATE clients set clients.Telephone = pTelephone WHERE clients.idClients = id and clients.Business_idBusiness = pIdBusiness; 

		UPDATE clients set clients.Cellphone = pCellphone WHERE clients.idClients = id and clients.Business_idBusiness = pIdBusiness; 
		
	end if;
end if$$

DROP PROCEDURE IF EXISTS `spProductDelete`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spProductDelete` (IN `pId` INT, IN `pIdBusiness` INT)  BEGIN
    update products set products.Active = 0 where Products.idProducts = pId and Products.Business_idBusiness = pIdBusiness and products.active = 1;
END$$

DROP PROCEDURE IF EXISTS `spProductGetByCode`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spProductGetByCode` (IN `pCode` LONG, IN `pIdBusiness` INT)  BEGIN
	SELECT * FROM products WHERE (/*products.Article_Number = pCode or */products.CodeProduct = pCode) and products.Business_idBusiness = pIdBusiness and products.Active = 1;
END$$

DROP PROCEDURE IF EXISTS `spProductGetById`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spProductGetById` (IN `pId` LONG, IN `pIdBusiness` INT)  BEGIN
	SELECT * FROM products WHERE products.idProducts = pId and products.Business_idBusiness = pIdBusiness and products.Active = 1;
END$$

DROP PROCEDURE IF EXISTS `spProductInsert`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spProductInsert` (IN `pIdBusiness` INT, IN `pProduct_Number` INT, IN `pCode` VARCHAR(100), IN `pDescription` VARCHAR(50), IN `pCost` FLOAT(10,2), IN `pPrice` FLOAT(10,2), IN `pPriceW` FLOAT(10,2), IN `pStock` INT, IN `pIdSupplier` INT)  BEGIN
	if (not exists(select Products.idProducts from Products where Products.Business_idBusiness = pIdBusiness and (Products.CodeProduct = pCode or Products.Article_number = pProduct_Number)))
    then
		if exists(select Suppliers.idSupplier from Suppliers where (Suppliers.Business_idBusiness = pIdBusiness or Suppliers.Business_idBusiness = 0) and Suppliers.idSupplier = pIdSupplier)
        then
			if(pProduct_Number > 0)
            then 
				insert into Products(Products.Business_idBusiness,Products.Article_number,Products.CodeProduct,Products.Description,Products.Stock,Products.Suppliers_idSupplier) values(pIdBusiness, pProduct_Number, pCode, pDescription, pStock, pIdSupplier);
                set @lastId = (select Products.idProducts from Products where Products.idProducts = LAST_INSERT_ID());# and Products.Business_idBusiness = pIdBusiness /*and Products.Article_number = pProduct_Number*/ and Products.CodeProduct = pCode and Products.Description = pDescription/* and Products.Stock = pStock*/ and Products.Suppliers_idSupplier = pIdSupplier);
                if(@lastId is not null)
                then
					if(pCost > 0)
					then
						Update Products set Products.Cost = pCost where Products.idProducts = @lastId; 
					end if;
					if(pPrice > 0)
					then
						Update Products set Products.Price = pPrice where Products.idProducts = @lastId; 
					end if;
                    if(pPriceW > 0)
					then
						Update Products set Products.PriceW = pPriceW where Products.idProducts = @lastId; 
					end if;
				end if; #endif lastId is not null 
			end if;#endif ProductNumber > 0
        end if;#endif Supplier exists
	end if;#endif not exists product with same code or product number in the same business
END$$

DROP PROCEDURE IF EXISTS `spProductsGet`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spProductsGet` (IN `pIdBusiness` INT)  BEGIN
	select * from Products where Products.Business_idBusiness = pIdBusiness and products.Active = 1;
END$$

DROP PROCEDURE IF EXISTS `spProductStockUpdate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spProductStockUpdate` (IN `pIdProducts` INT, IN `pIdBusiness` INT, IN `pStock` INT)  BEGIN
	update products set products.stock = pStock where products.idProducts = pIdProducts and products.Business_idBusiness = pIdBusiness and products.Active = 1;
END$$

DROP PROCEDURE IF EXISTS `spProductUpdate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spProductUpdate` (IN `pId` INT, IN `pIdBusiness` INT, IN `pProduct_Number` INT, IN `pCode` VARCHAR(100), IN `pDescription` VARCHAR(50), IN `pCost` FLOAT, IN `pPrice` FLOAT, IN `pPriceW` FLOAT, IN `pStock` INT, IN `pIdSupplier` INT)  BEGIN
	if exists(select Products.idProducts from Products where Products.idProducts = pId and Products.Business_idBusiness = pIdBusiness and products.Active = 1)
    then
		#Product Number
        if (not exists(select Products.idProducts from Products where Products.Article_Number = pProduct_Number and Products.Business_idBusiness = pIdBusiness) and pProduct_Number > 0 and pProduct_Number is not null )
        then
			update Products set Products.Article_number = pProduct_Number where Products.idProducts = pId and Products.Business_idBusiness = pIdBusiness;
        end if;
        
		#Code
        if (not exists(select Products.idProducts from Products where Products.CodeProduct = pCode and Products.Business_idBusiness = pIdBusiness) and pCode != "" and pCode is not null )
        then
			update Products set Products.CodeProduct = pCode where Products.idProducts = pId and Products.Business_idBusiness = pIdBusiness;
        end if;
        
		#Description
        if (pDescription is not null )
        then
			update Products set Products.Description = pDescription where Products.idProducts = pId and Products.Business_idBusiness = pIdBusiness;
        end if;
        
		#Cost
        if (pCost != (select Products.Cost from Products where Products.idProducts = pId and Products.Business_idBusiness = pIdBusiness) and pCost > 0 and pCost is not null )
        then
			update Products set Products.Cost = pCost where Products.idProducts = pId and Products.Business_idBusiness = pIdBusiness;
        end if;
        
		#Price
        if (pPrice - (select Products.Price from Products where Products.idProducts = pId and Products.Business_idBusiness = pIdBusiness) != 0 and pPrice > 0 and pPrice is not null)
        then
			update Products set Products.Price = pPrice where Products.idProducts = pId and Products.Business_idBusiness = pIdBusiness;
        end if;
        
		#PriceW
        if (pPriceW - (select Products.PriceW from Products where Products.idProducts = pId and Products.Business_idBusiness = pIdBusiness) != 0 and pPriceW > 0 and pPriceW is not null)
        then
			    update Products set Products.PriceW = pPriceW where Products.idProducts = pId and Products.Business_idBusiness = pIdBusiness;
        end if;
	    	#Stock
		    update Products set Products.Stock = pStock where Products.idProducts = pId and Products.Business_idBusiness = pIdBusiness;
         
        #Supplier
        if (pIdSupplier != (select Products.Suppliers_idSupplier from Products where Products.idProducts = pId and Products.Business_idBusiness = pIdBusiness) and exists(select Suppliers.idSupplier from Suppliers where Suppliers.idSupplier = pIdSupplier and (Suppliers.Business_idBusiness = pIdBusiness or Suppliers.Business_idBusiness = 0)))
        then
			update Products set Products.Suppliers_idSupplier = pIdSupplier where Products.idProducts = pId and Products.Business_idBusiness = pIdBusiness;
        end if;
        
    end if;
END$$

DROP PROCEDURE IF EXISTS `spSuppliersGet`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spSuppliersGet` (IN `pIdBusiness` INT)  BEGIN
	select idSupplier,Name,Surname from suppliers where Business_idBusiness = pIdBusiness;
END$$

DROP PROCEDURE IF EXISTS `spUserChangePassword`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spUserChangePassword` (IN `pOriginal` VARCHAR(60), IN `pNew` VARCHAR(60), IN `pId` BIGINT)  NO SQL
if exists(select users.idUser from users where users.idUser = pId and users.Password = md5(pOriginal))
	then
    	update users set users.Password = md5(pNew) where users.idUser = pId;
    end if$$

DROP PROCEDURE IF EXISTS `spUserDelete`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spUserDelete` (IN `pId` INT, IN `pIdBusiness` INT)  if(EXISTS(SELECT users.idUser FROM users WHERE users.idUser = pId and users.Business_idBusiness = pIdBusiness))
THEN
	DELETE from user_extrainfo WHERE  user_extrainfo.idUser = pId;
	DELETE from users WHERE users.idUser = pId and users.Business_idBusiness = pIdBusiness;
end IF$$

DROP PROCEDURE IF EXISTS `spUserGetById`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spUserGetById` (IN `pId` INT, IN `pIdBusiness` INT)  NO SQL
SELECT users.idUser, users.eMail ,users.Name ,users.Surname ,users.Name_Second ,users.Dni, user_extrainfo.Address, user_extrainfo.Tel_Father, user_extrainfo.Tel_Mother,user_extrainfo.Tel_Brother, user_extrainfo.Tel_User,user_extrainfo.Cellphone FROM users inner join user_extrainfo on user_extrainfo.idUser = users.idUser WHERE users.idUser = pId and users.Business_idBusiness= pIdBusiness$$

DROP PROCEDURE IF EXISTS `spUserInsert`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spUserInsert` (IN `pIdBusiness` INT, IN `pName` VARCHAR(60), IN `pSurname` VARCHAR(60), IN `pDni` BIGINT, IN `pEmail` VARCHAR(60), IN `pTelephone` VARCHAR(60), IN `pPass` VARCHAR(60), IN `pCellphone` VARCHAR(60), IN `pAddress` VARCHAR(55), IN `pTelephoneM` VARCHAR(55), IN `pTelephoneF` VARCHAR(55), IN `pTelephoneB` VARCHAR(55), IN `pSecondN` VARCHAR(55))  NO SQL
if( pIdBusiness > -1 and pName != "" and pPass != "" and pSurname != "" and not exists(select users.idUser from users where users.eMail = pEmail or (users.Dni = pDni and users.Business_idBusiness = pIdBusiness)))
then
	insert into users (users.Name,users.Surname,users.Business_idBusiness, users.Password, users.eMail,users.Admin) values( pName, pSurname,pIdBusiness,md5(pPass),pEmail,0);	
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
end if$$

DROP PROCEDURE IF EXISTS `spUserLogin`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spUserLogin` (IN `Email` VARCHAR(320), IN `Password` VARCHAR(200))  SELECT users.Name, users.Surname, users.Admin, users.idUser, business.idBusiness, business.Name as NameB from users INNER JOIN business ON business.idBusiness = users.Business_idBusiness where Email = users.eMail and md5(Password) = users.Password$$

DROP PROCEDURE IF EXISTS `spUsersGet`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spUsersGet` (IN `pIdBusiness` INT)  NO SQL
SELECT user_extrainfo.Cellphone, users.idUser, users.Name, users.Surname, users.Dni, users.eMail FROM users left join user_extrainfo on users.idUser = user_extrainfo.idUser where users.Business_idBusiness = pIdBusiness and users.Admin != 1$$

DROP PROCEDURE IF EXISTS `spUserUpdate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spUserUpdate` (IN `id` INT, IN `pIdBusiness` INT, IN `pName` VARCHAR(60), IN `pSurname` VARCHAR(60), IN `pDNI_CUIT` INT, IN `pEmail` VARCHAR(60), IN `pTelephone` VARCHAR(60), IN `pCellphone` VARCHAR(60), IN `pTelephoneM` VARCHAR(60), IN `pTelephoneF` VARCHAR(60), IN `pTelephoneB` VARCHAR(60), IN `pAddress` VARCHAR(60), IN `pSecondN` VARCHAR(60))  NO SQL
if(EXISTS(SELECT users.idUser from users WHERE users.idUser = id and users.Business_idBusiness = pIdBusiness))
THEN
	if(pName != "" and pSurname != "" and pDNI_CUIT != "" and pEmail!= "" )
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
		
		if( pEmail is not null and pEmail != (SELECT users.eMail from users where users.idUser = id) and not exists(SELECT users.eMail from users where users.eMail = pEmail and users.Business_idBusiness = pIdBusiness)) 
		THEN
			UPDATE users set users.eMail = pEmail WHERE users.idUser = id and users.Business_idBusiness = pIdBusiness; 
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
end if$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `address`
--

DROP TABLE IF EXISTS `address`;
CREATE TABLE IF NOT EXISTS `address` (
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
  `Clients_idClients` int(11) NOT NULL,
  PRIMARY KEY (`idAddress`) USING BTREE,
  KEY `fk_Address_Delivery1_idx` (`Delivery_idDelivery`),
  KEY `fk_Address_Province1_idx` (`Province_idProvince`),
  KEY `fk_Address_Business1_idx` (`Business_idBusiness`),
  KEY `fk_Address_Client1` (`Clients_idClients`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bills`
--

DROP TABLE IF EXISTS `bills`;
CREATE TABLE IF NOT EXISTS `bills` (
  `idBills` int(11) NOT NULL AUTO_INCREMENT,
  `DateBill` date DEFAULT NULL,
  `Clients_idClients` int(11) DEFAULT NULL,
  `Employee_Code` int(11) DEFAULT NULL,
  `IVA_Condition` varchar(45) DEFAULT NULL,
  `TypeBill` varchar(1) DEFAULT NULL,
  `Subtotal` float(10,2) DEFAULT '0.00',
  `Discount` float(5,2) UNSIGNED ZEROFILL DEFAULT '00.00',
  `IVA_Recharge` float(5,2) UNSIGNED ZEROFILL DEFAULT '00.00',
  `WholeSaler` bit(1) DEFAULT NULL,
  `Total` float(2,2) DEFAULT '0.00',
  `Branches_idBranch` int(11) DEFAULT NULL,
  `Payment_Methods_idPayment_Methods` int(11) DEFAULT NULL,
  `Macs_idMacs` int(11) DEFAULT NULL,
  `Business_idBusiness` int(11) NOT NULL,
  PRIMARY KEY (`idBills`) USING BTREE,
  UNIQUE KEY `idBills` (`idBills`),
  KEY `fk_Bills_Branches1_idx` (`Branches_idBranch`) USING BTREE,
  KEY `fk_Bills_Payment_Methods1_idx` (`Payment_Methods_idPayment_Methods`) USING BTREE,
  KEY `fk_Bills_Macs1_idx` (`Macs_idMacs`) USING BTREE,
  KEY `fk_Bills_Business1_idx` (`Business_idBusiness`) USING BTREE,
  KEY `fk_Bills_Clients1_idx` (`Clients_idClients`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `bills`
--

INSERT INTO `bills` (`idBills`, `DateBill`, `Clients_idClients`, `Employee_Code`, `IVA_Condition`, `TypeBill`, `Subtotal`, `Discount`, `IVA_Recharge`, `WholeSaler`, `Total`, `Branches_idBranch`, `Payment_Methods_idPayment_Methods`, `Macs_idMacs`, `Business_idBusiness`) VALUES
(2, '2019-06-27', 0, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, 0.99, 0, 0, 0, 1),
(3, '2019-06-27', 0, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, 0.99, 0, 0, 0, 1),
(4, '2019-06-27', 0, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, 0.99, 0, 0, 0, 1),
(60, '2019-09-06', 56, NULL, NULL, NULL, 0.00, 00.00, 00.00, NULL, 160.00, NULL, NULL, NULL, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bills_x_products`
--

DROP TABLE IF EXISTS `bills_x_products`;
CREATE TABLE IF NOT EXISTS `bills_x_products` (
  `idBills_X_Products` int(11) NOT NULL AUTO_INCREMENT,
  `Quantity` int(11) DEFAULT NULL,
  `Products_idProducts` int(11) NOT NULL,
  `Bills_idBills` int(11) NOT NULL,
  PRIMARY KEY (`idBills_X_Products`) USING BTREE,
  KEY `fk_Bill_X_Products_Products1_idx` (`Products_idProducts`) USING BTREE,
  KEY `fk_Bill_X_Products_Bills1_idx` (`Bills_idBills`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `bills_x_products`
--

INSERT INTO `bills_x_products` (`idBills_X_Products`, `Quantity`, `Products_idProducts`, `Bills_idBills`) VALUES
(7, 5, 1, 2),
(70, 1, 23, 60);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `branches`
--

DROP TABLE IF EXISTS `branches`;
CREATE TABLE IF NOT EXISTS `branches` (
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
  KEY `fk_Branch_Province1_idx` (`Province_idProvince`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='	';

--
-- Volcado de datos para la tabla `branches`
--

INSERT INTO `branches` (`idBranch`, `Address`, `District`, `Branch_Name`, `Telephone`, `Postal_Code`, `Business_idBusiness`, `Province_idProvince`) VALUES
(1, 'Cabildo 6000', 'Belgrano', 'La revistería Cabildo', 1500000000, 4545, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `business`
--

DROP TABLE IF EXISTS `business`;
CREATE TABLE IF NOT EXISTS `business` (
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

--
-- Volcado de datos para la tabla `business`
--

INSERT INTO `business` (`idBusiness`, `CUIT`, `Name`, `Gross_Income`, `Beginning_of_Activities`, `Logo`, `Signature`, `Type`, `Telephone`) VALUES
(0, 43994080, 'AGCS', 0, NULL, 'xd', 'xdddd', NULL, NULL),
(1, 1234, 'Prueba', 3000, '2019-05-01', 'xdd', 'xdd', 'Mayorista', 1121121),
(2, 4657456, 'Don pepe y sus globos', 8000, '1666-05-01', 'daze', 'xdd', 'Minorista', 1511114444);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clients`
--

DROP TABLE IF EXISTS `clients`;
CREATE TABLE IF NOT EXISTS `clients` (
  `idClients` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) DEFAULT NULL,
  `Surname` varchar(45) DEFAULT NULL,
  `DNI_CUIT` bigint(17) DEFAULT NULL,
  `eMail` varchar(45) DEFAULT NULL,
  `Telephone` varchar(20) DEFAULT NULL,
  `Cellphone` varchar(20) DEFAULT NULL,
  `Business_idBusiness` int(11) NOT NULL,
  `Active` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`idClients`) USING BTREE,
  KEY `fk_Clients_Business1_idx` (`Business_idBusiness`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `clients`
--

INSERT INTO `clients` (`idClients`, `Name`, `Surname`, `DNI_CUIT`, `eMail`, `Telephone`, `Cellphone`, `Business_idBusiness`, `Active`) VALUES
(0, 'Consumidor Final', 'Consumidor Final', 1, ' ', '0', '1', 0, b'1'),
(8, 'Yare Yare', 'Dawa', 1211, 'bot01@mail.com', '113212113', '11231213', 1, b'1'),
(22, 'MargossianEmpresa2', '11', 3, 'a', NULL, '111', 2, b'1'),
(23, 'test', 'prueba', 123456, NULL, NULL, '43214321', 1, b'1'),
(25, 'nombre', 'apellido', 987654321, NULL, NULL, '40005000', 1, b'1'),
(32, 'Margossian', 'Nicolas', 5555555, NULL, '1144322258', '1165898555', 1, b'1'),
(39, 'aaa', 'aaa', 43444, NULL, '1125458', '1154898', 1, b'1'),
(40, 'asdf8', 'asdf9', 3246, 'hola9', '2436', '2344', 1, b'1'),
(45, 'hoola', 'q hace', 555555, NULL, '0', '123213213', 1, b'0'),
(46, 'Nicolas', 'Margossian', 43994080, NULL, '0', '111561730659', 1, b'1'),
(47, 'nicolas', 'margossian2343', 439940804, 'a', '5613', '2345', 1, b'1'),
(52, 'dawa', 'yareyare', 1234, 'mnail@q', '123', '5', 1, b'0'),
(53, 'R', 'lucas', 7, NULL, NULL, NULL, 1, b'0'),
(54, 'xdd', 'aaa', 9, '', NULL, NULL, 1, b'0'),
(55, 'Empresa2', 'Cliente', 2345544, NULL, NULL, NULL, 2, b'1'),
(56, 'Gabriel', 'Guivi', 32592593, NULL, NULL, '', 2, b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `delivery`
--

DROP TABLE IF EXISTS `delivery`;
CREATE TABLE IF NOT EXISTS `delivery` (
  `idDelivery` int(11) NOT NULL AUTO_INCREMENT,
  `Transportation_Company` varchar(45) DEFAULT NULL,
  `Telephone` int(11) DEFAULT NULL,
  `Business_idBusiness` int(11) NOT NULL,
  PRIMARY KEY (`idDelivery`) USING BTREE,
  KEY `fk_Delivery_Business1_idx` (`Business_idBusiness`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `macs`
--

DROP TABLE IF EXISTS `macs`;
CREATE TABLE IF NOT EXISTS `macs` (
  `idMacs` int(11) NOT NULL AUTO_INCREMENT,
  `Mac_Address` varchar(45) DEFAULT NULL,
  `Business_idBusiness` int(11) NOT NULL,
  PRIMARY KEY (`idMacs`) USING BTREE,
  KEY `fk_Macs_Business1_idx` (`Business_idBusiness`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `macs`
--

INSERT INTO `macs` (`idMacs`, `Mac_Address`, `Business_idBusiness`) VALUES
(1, '192.168.8.16', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `payment_methods`
--

DROP TABLE IF EXISTS `payment_methods`;
CREATE TABLE IF NOT EXISTS `payment_methods` (
  `idPayment_Methods` int(11) NOT NULL AUTO_INCREMENT,
  `Method` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idPayment_Methods`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `payment_methods`
--

INSERT INTO `payment_methods` (`idPayment_Methods`, `Method`) VALUES
(1, 'BitCoins');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `products`
--

DROP TABLE IF EXISTS `products`;
CREATE TABLE IF NOT EXISTS `products` (
  `idProducts` int(11) NOT NULL AUTO_INCREMENT,
  `Article_number` int(11) DEFAULT NULL,
  `Description` varchar(45) CHARACTER SET latin1 DEFAULT NULL,
  `Cost` float(10,2) UNSIGNED ZEROFILL DEFAULT '0000000.00',
  `Price` float(10,2) UNSIGNED ZEROFILL DEFAULT '0000000.00',
  `PriceW` float(10,2) UNSIGNED ZEROFILL DEFAULT '0000000.00',
  `Age` bit(1) DEFAULT NULL,
  `Stock` int(11) DEFAULT NULL,
  `CodeProduct` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `Suppliers_idSupplier` int(11) NOT NULL,
  `Business_idBusiness` int(11) NOT NULL,
  `Active` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`idProducts`) USING BTREE,
  KEY `fk_Products_Suppliers1_idx` (`Suppliers_idSupplier`),
  KEY `fk_Products_Business1_idx` (`Business_idBusiness`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

--
-- Volcado de datos para la tabla `products`
--

INSERT INTO `products` (`idProducts`, `Article_number`, `Description`, `Cost`, `Price`, `PriceW`, `Age`, `Stock`, `CodeProduct`, `Suppliers_idSupplier`, `Business_idBusiness`, `Active`) VALUES
(1, 1, 'Manga Yakusoku no Neverland Vol 1', 0002005.00, 0000300.00, 0000280.00, b'1', 150, '1', 3, 1, b'1'),
(2, 2, 'Manga Yakusoku no Neverland Vol 2', 0000320.00, 0000200.00, 0000180.00, b'1', -58, '2', 3, 1, b'1'),
(3, 3, 'Manga Yakusoku no Neverland Vol 4', 0000320.00, 0000300.00, 0000096.00, b'1', -1037, '3', 3, 1, b'1'),
(4, 5, 'Yogurisimo Con Cereales', 0000019.00, 0000050.00, 0000034.00, b'1', 97, '7791337613027', 2, 1, b'1'),
(7, 32, 'amazing hat', 0050056.00, 0000600.00, 0054958.00, NULL, 32, '434', 1, 1, b'1'),
(8, 85, 'awful hat', 0000005.00, 0000331.00, 0000328.00, NULL, -32, '32222', 0, 1, b'1'),
(9, 75, 'a beautiful hat', 0000035.59, 0000080.51, 0000040.03, NULL, 33, '707', 1, 1, b'1'),
(17, 106, 'loljajasalu2', 0000081.00, 0000071.00, 0000082.00, NULL, 89, '891', 0, 1, b'0'),
(18, 218, 'Tabla Periódica', 0000010.00, 0000040.00, 0000030.00, NULL, 50, '7798107220218', 0, 2, b'1'),
(19, 1, 'item borrar', 0000100.00, 0000500.00, 0000300.00, NULL, 75, '12', 0, 2, b'1'),
(20, 3, 'Castaña De Caju', 0000050.00, 0000150.00, 0000100.00, NULL, 101, '2670550000003', 0, 2, b'1'),
(21, 524, 'Liquid Paper', 0000020.00, 0000100.00, 0000080.00, NULL, 200, '8854556000524', 0, 2, b'1'),
(22, 524, 'liquid', 0000030.00, 0000030.00, 0000030.00, NULL, 100, '8854556000524', 0, 1, b'0'),
(23, 358, 'Elite', 0000123.00, 0000160.00, 0000145.00, NULL, 100, '7790250000358', 0, 2, b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `provinces`
--

DROP TABLE IF EXISTS `provinces`;
CREATE TABLE IF NOT EXISTS `provinces` (
  `idProvince` int(11) NOT NULL AUTO_INCREMENT,
  `Province` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`idProvince`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `provinces`
--

INSERT INTO `provinces` (`idProvince`, `Province`) VALUES
(1, 'CABA'),
(2, 'Buenos Aires');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
CREATE TABLE IF NOT EXISTS `suppliers` (
  `idSupplier` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) DEFAULT NULL,
  `Surname` varchar(45) DEFAULT NULL,
  `Telephone` int(11) DEFAULT NULL,
  `Cellphone` int(11) NOT NULL,
  `Factory` varchar(45) DEFAULT NULL,
  `Business_idBusiness` int(11) NOT NULL,
  `Address` varchar(200) DEFAULT NULL,
  `Mail` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`idSupplier`) USING BTREE,
  KEY `fk_Supplier_Business1_idx` (`Business_idBusiness`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `suppliers`
--

INSERT INTO `suppliers` (`idSupplier`, `Name`, `Surname`, `Telephone`, `Cellphone`, `Factory`, `Business_idBusiness`, `Address`, `Mail`) VALUES
(0, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL),
(1, 'Aquiles', 'Traigo', 43216543, 13111111, 'Nose q va aK xd', 1, 'En la loma del ort', NULL),
(2, 'Aquiles', 'Doy', 45678912, 1513317546, 'yo tampoco jaja salu2', 1, 'viste china, bueno doblando a la izquierda', NULL),
(3, 'Ivrea', NULL, NULL, 154321321, 'EEEEEEEE', 1, 'Cabildo 6000', NULL),
(4, 'void', NULL, NULL, 154321321, 'EEEEEEEE', 1, 'Cabildo 6000', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `idUser` int(11) NOT NULL AUTO_INCREMENT,
  `eMail` varchar(45) DEFAULT NULL,
  `Password` varchar(45) DEFAULT NULL,
  `Admin` bit(1) DEFAULT NULL,
  `Name` varchar(45) DEFAULT NULL,
  `Surname` varchar(45) DEFAULT NULL,
  `Name_Second` varchar(45) DEFAULT NULL,
  `Business_idBusiness` int(11) NOT NULL,
  `Dni` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idUser`) USING BTREE,
  KEY `fk_Users_Business1_idx` (`Business_idBusiness`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`idUser`, `eMail`, `Password`, `Admin`, `Name`, `Surname`, `Name_Second`, `Business_idBusiness`, `Dni`) VALUES
(27, 'admin@admin', '21232f297a57a5a743894a0e4a801fc3', b'1', 'admin', 'admin', 'admin', 1, '13'),
(28, 'nicolasmargossian@gmail.com', '7510d498f23f5815d3376ea7bad64e29', b'0', 'Nicolas', 'hola', 'Alejandro Anushavan', 1, '43994080'),
(32, 'bo@bo', '21232f297a57a5a743894a0e4a801fc3', b'0', 'ParaBorrar', 'Borrar', 'borrar', 1, '334'),
(34, 'n@n', '21232f297a57a5a743894a0e4a801fc3', b'1', 'nico', 'margo', 'Alejandro Anushavan', 2, '43994080'),
(35, 'mati@mati', '4d186321c1a7f0f354b297e8914ab240', b'0', 'Matias', 'Santoro', 'Javier', 2, '43994857'),
(37, 'm@m', '21232f297a57a5a743894a0e4a801fc3', b'0', 'nombre modificar ', 'apellido modificar ', NULL, 2, '11111');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_extrainfo`
--

DROP TABLE IF EXISTS `user_extrainfo`;
CREATE TABLE IF NOT EXISTS `user_extrainfo` (
  `idUser_ExtraInfo` int(11) NOT NULL AUTO_INCREMENT,
  `Address` varchar(100) DEFAULT NULL,
  `Tel_Father` varchar(50) CHARACTER SET latin2 DEFAULT NULL,
  `Tel_Mother` varchar(50) CHARACTER SET latin2 DEFAULT NULL,
  `Tel_Brother` varchar(50) CHARACTER SET latin2 DEFAULT NULL,
  `Tel_User` varchar(50) CHARACTER SET latin2 DEFAULT NULL,
  `Healthcare_Company` varchar(45) DEFAULT NULL,
  `Sallary` int(11) DEFAULT NULL,
  `idUser` int(11) NOT NULL,
  `Cellphone` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`idUser_ExtraInfo`) USING BTREE,
  KEY `fk_User_ExtraInfo_Users1_idx` (`idUser`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `user_extrainfo`
--

INSERT INTO `user_extrainfo` (`idUser_ExtraInfo`, `Address`, `Tel_Father`, `Tel_Mother`, `Tel_Brother`, `Tel_User`, `Healthcare_Company`, `Sallary`, `idUser`, `Cellphone`) VALUES
(1, 'Admin', '4444444', '333333', '5555555', '011', NULL, NULL, 27, '12'),
(2, 'Av Rivadavia 6015 13C', '01144404555', '01149607853', '01164538472', '44322210', NULL, NULL, 28, '11617306599'),
(6, 'para borrar usuario', '888', '999', '777', '122', NULL, NULL, 32, '233'),
(8, 'Formosa 430', '888', '999', '777', '12', NULL, NULL, 35, '13'),
(10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 37, NULL);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `address`
--
ALTER TABLE `address`
  ADD CONSTRAINT `fk_Address_Business1` FOREIGN KEY (`Business_idBusiness`) REFERENCES `business` (`idBusiness`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Address_Client1` FOREIGN KEY (`Clients_idClients`) REFERENCES `clients` (`idClients`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Address_Delivery1` FOREIGN KEY (`Delivery_idDelivery`) REFERENCES `delivery` (`idDelivery`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Address_Province1` FOREIGN KEY (`Province_idProvince`) REFERENCES `provinces` (`idProvince`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `bills`
--
ALTER TABLE `bills`
  ADD CONSTRAINT `bills_ibfk_1` FOREIGN KEY (`Clients_idClients`) REFERENCES `clients` (`idClients`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `bills_x_products`
--
ALTER TABLE `bills_x_products`
  ADD CONSTRAINT `fk_Bills_X_Products_Bills1` FOREIGN KEY (`Bills_idBills`) REFERENCES `bills` (`idBills`),
  ADD CONSTRAINT `fk_Bills_X_Products_Products1` FOREIGN KEY (`Products_idProducts`) REFERENCES `products` (`idProducts`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `branches`
--
ALTER TABLE `branches`
  ADD CONSTRAINT `fk_Branch_Business1` FOREIGN KEY (`Business_idBusiness`) REFERENCES `business` (`idBusiness`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Branch_Province1` FOREIGN KEY (`Province_idProvince`) REFERENCES `provinces` (`idProvince`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `clients`
--
ALTER TABLE `clients`
  ADD CONSTRAINT `fk_Clients_Business1` FOREIGN KEY (`Business_idBusiness`) REFERENCES `business` (`idBusiness`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `delivery`
--
ALTER TABLE `delivery`
  ADD CONSTRAINT `fk_Delivery_Business1` FOREIGN KEY (`Business_idBusiness`) REFERENCES `business` (`idBusiness`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `macs`
--
ALTER TABLE `macs`
  ADD CONSTRAINT `fk_Macs_Business1` FOREIGN KEY (`Business_idBusiness`) REFERENCES `business` (`idBusiness`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_Products_Business1` FOREIGN KEY (`Business_idBusiness`) REFERENCES `business` (`idBusiness`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Products_Suppliers1` FOREIGN KEY (`Suppliers_idSupplier`) REFERENCES `suppliers` (`idSupplier`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `suppliers`
--
ALTER TABLE `suppliers`
  ADD CONSTRAINT `fk_Supplier_Business1` FOREIGN KEY (`Business_idBusiness`) REFERENCES `business` (`idBusiness`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_Users_Business1` FOREIGN KEY (`Business_idBusiness`) REFERENCES `business` (`idBusiness`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `user_extrainfo`
--
ALTER TABLE `user_extrainfo`
  ADD CONSTRAINT `fk_User_ExtraInfo_Users1` FOREIGN KEY (`idUser`) REFERENCES `users` (`idUser`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
