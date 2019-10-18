-- phpMyAdmin SQL Dump
-- version 4.7.9
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 18-10-2019 a las 12:00:05
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `spClientsGet` (IN `pIdBusiness` INT, IN `pPage` INT)  NO SQL
BEGIN
DECLARE pag INT DEFAULT 0;
SET pag = 20*pPage;
SELECT clients.idClients, clients.Name, clients.Surname, clients.DNI_CUIT, clients.eMail,clients.Cellphone FROM clients where clients.Business_idBusiness = pIdBusiness and clients.Active = 1 LIMIT 25 OFFSET pag;
END$$

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

DROP PROCEDURE IF EXISTS `spProductStockMovment`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spProductStockMovment` (IN `pIdProducts` INT, IN `pStock` INT)  BEGIN
	update products set products.stock = products.stock- pStock where products.idProducts = pIdProducts and products.Active = 1;
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
(60, '2019-09-06', 56, NULL, NULL, NULL, 0.00, 00.00, 00.00, NULL, 0.99, NULL, NULL, NULL, 2);

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
) ENGINE=InnoDB AUTO_INCREMENT=1318 DEFAULT CHARSET=latin1;

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
(56, 'Gabriel', 'Guivi', 32592593, NULL, NULL, '', 2, b'1'),
(57, 'for', 'for', 2, 'for', '12', '12', 1, b'1'),
(58, 'for', 'for', 3, 'for', '12', '12', 1, b'1'),
(59, 'for', 'for', 4, 'for', '12', '12', 1, b'1'),
(60, 'for', 'for', 5, 'for', '12', '12', 1, b'1'),
(61, 'for', 'for', 6, 'for', '12', '12', 1, b'1'),
(62, 'for', 'for', 8, 'for', '12', '12', 1, b'1'),
(63, 'for', 'for', 10, 'for', '12', '12', 1, b'1'),
(64, 'for', 'for', 11, 'asdf', '234', '234', 1, b'1'),
(65, 'for', 'for', 12, 'asdf', '234', '234', 1, b'1'),
(66, 'for', 'for', 13, 'asdf', '234', '234', 1, b'1'),
(67, 'for', 'for', 14, 'asdf', '234', '234', 1, b'1'),
(68, 'for', 'for', 15, 'asdf', '234', '234', 1, b'1'),
(69, 'for', 'for', 16, 'asdf', '234', '234', 1, b'1'),
(70, 'for', 'for', 17, 'asdf', '234', '234', 1, b'1'),
(71, 'for', 'for', 18, 'asdf', '234', '234', 1, b'1'),
(72, 'for', 'for', 19, 'asdf', '234', '234', 1, b'1'),
(73, 'for', 'for', 20, 'asdf', '234', '234', 1, b'1'),
(74, 'for', 'for', 21, 'asdf', '234', '234', 1, b'1'),
(75, 'for', 'for', 22, 'asdf', '234', '234', 1, b'1'),
(76, 'for', 'for', 23, 'asdf', '234', '234', 1, b'1'),
(77, 'for', 'for', 24, 'asdf', '234', '234', 1, b'1'),
(78, 'for', 'for', 25, 'asdf', '234', '234', 1, b'1'),
(79, 'for', 'for', 26, 'asdf', '234', '234', 1, b'1'),
(80, 'for', 'for', 27, 'asdf', '234', '234', 1, b'1'),
(81, 'for', 'for', 28, 'asdf', '234', '234', 1, b'1'),
(82, 'for', 'for', 29, 'asdf', '234', '234', 1, b'1'),
(83, 'for', 'for', 30, 'asdf', '234', '234', 1, b'1'),
(84, 'for', 'for', 31, 'asdf', '234', '234', 1, b'1'),
(85, 'for', 'for', 32, 'asdf', '234', '234', 1, b'1'),
(86, 'for', 'for', 33, 'asdf', '234', '234', 1, b'1'),
(87, 'for', 'for', 34, 'asdf', '234', '234', 1, b'1'),
(88, 'for', 'for', 35, 'asdf', '234', '234', 1, b'1'),
(89, 'for', 'for', 36, 'asdf', '234', '234', 1, b'1'),
(90, 'for', 'for', 37, 'asdf', '234', '234', 1, b'1'),
(91, 'for', 'for', 38, 'asdf', '234', '234', 1, b'1'),
(92, 'for', 'for', 39, 'asdf', '234', '234', 1, b'1'),
(93, 'for', 'for', 40, 'asdf', '234', '234', 1, b'1'),
(94, 'for', 'for', 41, 'asdf', '234', '234', 1, b'1'),
(95, 'for', 'for', 42, 'asdf', '234', '234', 1, b'1'),
(96, 'for', 'for', 43, 'asdf', '234', '234', 1, b'1'),
(97, 'for', 'for', 44, 'asdf', '234', '234', 1, b'1'),
(98, 'for', 'for', 45, 'asdf', '234', '234', 1, b'1'),
(99, 'for', 'for', 46, 'asdf', '234', '234', 1, b'1'),
(100, 'for', 'for', 47, 'asdf', '234', '234', 1, b'1'),
(101, 'for', 'for', 48, 'asdf', '234', '234', 1, b'1'),
(102, 'for', 'for', 49, 'asdf', '234', '234', 1, b'1'),
(103, 'for', 'for', 50, 'asdf', '234', '234', 1, b'1'),
(104, 'for', 'for', 51, 'asdf', '234', '234', 1, b'1'),
(105, 'for', 'for', 52, 'asdf', '234', '234', 1, b'1'),
(106, 'for', 'for', 53, 'asdf', '234', '234', 1, b'1'),
(107, 'for', 'for', 54, 'asdf', '234', '234', 1, b'1'),
(108, 'for', 'for', 55, 'asdf', '234', '234', 1, b'1'),
(109, 'for', 'for', 56, 'asdf', '234', '234', 1, b'1'),
(110, 'for', 'for', 57, 'asdf', '234', '234', 1, b'1'),
(111, 'for', 'for', 58, 'asdf', '234', '234', 1, b'1'),
(112, 'for', 'for', 59, 'asdf', '234', '234', 1, b'1'),
(113, 'for', 'for', 60, 'asdf', '234', '234', 1, b'1'),
(114, 'for', 'for', 61, 'asdf', '234', '234', 1, b'1'),
(115, 'for', 'for', 62, 'asdf', '234', '234', 1, b'1'),
(116, 'for', 'for', 63, 'asdf', '234', '234', 1, b'1'),
(117, 'for', 'for', 64, 'asdf', '234', '234', 1, b'1'),
(118, 'for', 'for', 65, 'asdf', '234', '234', 1, b'1'),
(119, 'for', 'for', 66, 'asdf', '234', '234', 1, b'1'),
(120, 'for', 'for', 67, 'asdf', '234', '234', 1, b'1'),
(121, 'for', 'for', 68, 'asdf', '234', '234', 1, b'1'),
(122, 'for', 'for', 69, 'asdf', '234', '234', 1, b'1'),
(123, 'for', 'for', 70, 'asdf', '234', '234', 1, b'1'),
(124, 'for', 'for', 71, 'asdf', '234', '234', 1, b'1'),
(125, 'for', 'for', 72, 'asdf', '234', '234', 1, b'1'),
(126, 'for', 'for', 73, 'asdf', '234', '234', 1, b'1'),
(127, 'for', 'for', 74, 'asdf', '234', '234', 1, b'1'),
(128, 'for', 'for', 75, 'asdf', '234', '234', 1, b'1'),
(129, 'for', 'for', 76, 'asdf', '234', '234', 1, b'1'),
(130, 'for', 'for', 77, 'asdf', '234', '234', 1, b'1'),
(131, 'for', 'for', 78, 'asdf', '234', '234', 1, b'1'),
(132, 'for', 'for', 79, 'asdf', '234', '234', 1, b'1'),
(133, 'for', 'for', 80, 'asdf', '234', '234', 1, b'1'),
(134, 'for', 'for', 81, 'asdf', '234', '234', 1, b'1'),
(135, 'for', 'for', 82, 'asdf', '234', '234', 1, b'1'),
(136, 'for', 'for', 83, 'asdf', '234', '234', 1, b'1'),
(137, 'for', 'for', 84, 'asdf', '234', '234', 1, b'1'),
(138, 'for', 'for', 85, 'asdf', '234', '234', 1, b'1'),
(139, 'for', 'for', 86, 'asdf', '234', '234', 1, b'1'),
(140, 'for', 'for', 87, 'asdf', '234', '234', 1, b'1'),
(141, 'for', 'for', 88, 'asdf', '234', '234', 1, b'1'),
(142, 'for', 'for', 89, 'asdf', '234', '234', 1, b'1'),
(143, 'for', 'for', 90, 'asdf', '234', '234', 1, b'1'),
(144, 'for', 'for', 91, 'asdf', '234', '234', 1, b'1'),
(145, 'for', 'for', 92, 'asdf', '234', '234', 1, b'1'),
(146, 'for', 'for', 93, 'asdf', '234', '234', 1, b'1'),
(147, 'for', 'for', 94, 'asdf', '234', '234', 1, b'1'),
(148, 'for', 'for', 95, 'asdf', '234', '234', 1, b'1'),
(149, 'for', 'for', 96, 'asdf', '234', '234', 1, b'1'),
(150, 'for', 'for', 97, 'asdf', '234', '234', 1, b'1'),
(151, 'for', 'for', 98, 'asdf', '234', '234', 1, b'1'),
(152, 'for', 'for', 99, 'asdf', '234', '234', 1, b'1'),
(153, 'for', 'for', 100, 'asdf', '234', '234', 1, b'1'),
(154, 'for', 'for', 101, 'asdf', '234', '234', 1, b'1'),
(155, 'for', 'for', 102, 'asdf', '234', '234', 1, b'1'),
(156, 'for', 'for', 103, 'asdf', '234', '234', 1, b'1'),
(157, 'for', 'for', 104, 'asdf', '234', '234', 1, b'1'),
(158, 'for', 'for', 105, 'asdf', '234', '234', 1, b'1'),
(159, 'for', 'for', 106, 'asdf', '234', '234', 1, b'1'),
(160, 'for', 'for', 107, 'asdf', '234', '234', 1, b'1'),
(161, 'for', 'for', 108, 'asdf', '234', '234', 1, b'1'),
(162, 'for', 'for', 109, 'asdf', '234', '234', 1, b'1'),
(163, 'for', 'for', 110, 'asdf', '234', '234', 1, b'1'),
(164, 'for', 'for', 111, 'asdf', '234', '234', 1, b'1'),
(165, 'for', 'for', 112, 'asdf', '234', '234', 1, b'1'),
(166, 'for', 'for', 113, 'asdf', '234', '234', 1, b'1'),
(167, 'for', 'for', 114, 'asdf', '234', '234', 1, b'1'),
(168, 'for', 'for', 115, 'asdf', '234', '234', 1, b'1'),
(169, 'for', 'for', 116, 'asdf', '234', '234', 1, b'1'),
(170, 'for', 'for', 117, 'asdf', '234', '234', 1, b'1'),
(171, 'for', 'for', 118, 'asdf', '234', '234', 1, b'1'),
(172, 'for', 'for', 119, 'asdf', '234', '234', 1, b'1'),
(173, 'for', 'for', 120, 'asdf', '234', '234', 1, b'1'),
(174, 'for', 'for', 121, 'asdf', '234', '234', 1, b'1'),
(175, 'for', 'for', 122, 'asdf', '234', '234', 1, b'1'),
(176, 'for', 'for', 123, 'asdf', '234', '234', 1, b'1'),
(177, 'for', 'for', 124, 'asdf', '234', '234', 1, b'1'),
(178, 'for', 'for', 125, 'asdf', '234', '234', 1, b'1'),
(179, 'for', 'for', 126, 'asdf', '234', '234', 1, b'1'),
(180, 'for', 'for', 127, 'asdf', '234', '234', 1, b'1'),
(181, 'for', 'for', 128, 'asdf', '234', '234', 1, b'1'),
(182, 'for', 'for', 129, 'asdf', '234', '234', 1, b'1'),
(183, 'for', 'for', 130, 'asdf', '234', '234', 1, b'1'),
(184, 'for', 'for', 131, 'asdf', '234', '234', 1, b'1'),
(185, 'for', 'for', 132, 'asdf', '234', '234', 1, b'1'),
(186, 'for', 'for', 133, 'asdf', '234', '234', 1, b'1'),
(187, 'for', 'for', 134, 'asdf', '234', '234', 1, b'1'),
(188, 'for', 'for', 135, 'asdf', '234', '234', 1, b'1'),
(189, 'for', 'for', 136, 'asdf', '234', '234', 1, b'1'),
(190, 'for', 'for', 137, 'asdf', '234', '234', 1, b'1'),
(191, 'for', 'for', 138, 'asdf', '234', '234', 1, b'1'),
(192, 'for', 'for', 139, 'asdf', '234', '234', 1, b'1'),
(193, 'for', 'for', 140, 'asdf', '234', '234', 1, b'1'),
(194, 'for', 'for', 141, 'asdf', '234', '234', 1, b'1'),
(195, 'for', 'for', 142, 'asdf', '234', '234', 1, b'1'),
(196, 'for', 'for', 143, 'asdf', '234', '234', 1, b'1'),
(197, 'for', 'for', 144, 'asdf', '234', '234', 1, b'1'),
(198, 'for', 'for', 145, 'asdf', '234', '234', 1, b'1'),
(199, 'for', 'for', 146, 'asdf', '234', '234', 1, b'1'),
(200, 'for', 'for', 147, 'asdf', '234', '234', 1, b'1'),
(201, 'for', 'for', 148, 'asdf', '234', '234', 1, b'1'),
(202, 'for', 'for', 149, 'asdf', '234', '234', 1, b'1'),
(203, 'for', 'for', 150, 'asdf', '234', '234', 1, b'1'),
(204, 'for', 'for', 151, 'asdf', '234', '234', 1, b'1'),
(205, 'for', 'for', 152, 'asdf', '234', '234', 1, b'1'),
(206, 'for', 'for', 153, 'asdf', '234', '234', 1, b'1'),
(207, 'for', 'for', 154, 'asdf', '234', '234', 1, b'1'),
(208, 'for', 'for', 155, 'asdf', '234', '234', 1, b'1'),
(209, 'for', 'for', 156, 'asdf', '234', '234', 1, b'1'),
(210, 'for', 'for', 157, 'asdf', '234', '234', 1, b'1'),
(211, 'for', 'for', 158, 'asdf', '234', '234', 1, b'1'),
(212, 'for', 'for', 159, 'asdf', '234', '234', 1, b'1'),
(213, 'for', 'for', 160, 'asdf', '234', '234', 1, b'1'),
(214, 'for', 'for', 161, 'asdf', '234', '234', 1, b'1'),
(215, 'for', 'for', 162, 'asdf', '234', '234', 1, b'1'),
(216, 'for', 'for', 163, 'asdf', '234', '234', 1, b'1'),
(217, 'for', 'for', 164, 'asdf', '234', '234', 1, b'1'),
(218, 'for', 'for', 165, 'asdf', '234', '234', 1, b'1'),
(219, 'for', 'for', 166, 'asdf', '234', '234', 1, b'1'),
(220, 'for', 'for', 167, 'asdf', '234', '234', 1, b'1'),
(221, 'for', 'for', 168, 'asdf', '234', '234', 1, b'1'),
(222, 'for', 'for', 169, 'asdf', '234', '234', 1, b'1'),
(223, 'for', 'for', 170, 'asdf', '234', '234', 1, b'1'),
(224, 'for', 'for', 171, 'asdf', '234', '234', 1, b'1'),
(225, 'for', 'for', 172, 'asdf', '234', '234', 1, b'1'),
(226, 'for', 'for', 173, 'asdf', '234', '234', 1, b'1'),
(227, 'for', 'for', 174, 'asdf', '234', '234', 1, b'1'),
(228, 'for', 'for', 175, 'asdf', '234', '234', 1, b'1'),
(229, 'for', 'for', 176, 'asdf', '234', '234', 1, b'1'),
(230, 'for', 'for', 177, 'asdf', '234', '234', 1, b'1'),
(231, 'for', 'for', 178, 'asdf', '234', '234', 1, b'1'),
(232, 'for', 'for', 179, 'asdf', '234', '234', 1, b'1'),
(233, 'for', 'for', 180, 'asdf', '234', '234', 1, b'1'),
(234, 'for', 'for', 181, 'asdf', '234', '234', 1, b'1'),
(235, 'for', 'for', 182, 'asdf', '234', '234', 1, b'1'),
(236, 'for', 'for', 183, 'asdf', '234', '234', 1, b'1'),
(237, 'for', 'for', 184, 'asdf', '234', '234', 1, b'1'),
(238, 'for', 'for', 185, 'asdf', '234', '234', 1, b'1'),
(239, 'for', 'for', 186, 'asdf', '234', '234', 1, b'1'),
(240, 'for', 'for', 187, 'asdf', '234', '234', 1, b'1'),
(241, 'for', 'for', 188, 'asdf', '234', '234', 1, b'1'),
(242, 'for', 'for', 189, 'asdf', '234', '234', 1, b'1'),
(243, 'for', 'for', 190, 'asdf', '234', '234', 1, b'1'),
(244, 'for', 'for', 191, 'asdf', '234', '234', 1, b'1'),
(245, 'for', 'for', 192, 'asdf', '234', '234', 1, b'1'),
(246, 'for', 'for', 193, 'asdf', '234', '234', 1, b'1'),
(247, 'for', 'for', 194, 'asdf', '234', '234', 1, b'1'),
(248, 'for', 'for', 195, 'asdf', '234', '234', 1, b'1'),
(249, 'for', 'for', 196, 'asdf', '234', '234', 1, b'1'),
(250, 'for', 'for', 197, 'asdf', '234', '234', 1, b'1'),
(251, 'for', 'for', 198, 'asdf', '234', '234', 1, b'1'),
(252, 'for', 'for', 199, 'asdf', '234', '234', 1, b'1'),
(253, 'for', 'for', 200, 'asdf', '234', '234', 1, b'1'),
(254, 'for', 'for', 201, 'asdf', '234', '234', 1, b'1'),
(255, 'for', 'for', 202, 'asdf', '234', '234', 1, b'1'),
(256, 'for', 'for', 203, 'asdf', '234', '234', 1, b'1'),
(257, 'for', 'for', 204, 'asdf', '234', '234', 1, b'1'),
(258, 'for', 'for', 205, 'asdf', '234', '234', 1, b'1'),
(259, 'for', 'for', 206, 'asdf', '234', '234', 1, b'1'),
(260, 'for', 'for', 207, 'asdf', '234', '234', 1, b'1'),
(261, 'for', 'for', 208, 'asdf', '234', '234', 1, b'1'),
(262, 'for', 'for', 209, 'asdf', '234', '234', 1, b'1'),
(263, 'for', 'for', 210, 'asdf', '234', '234', 1, b'1'),
(264, 'for', 'for', 211, 'asdf', '234', '234', 1, b'1'),
(265, 'for', 'for', 212, 'asdf', '234', '234', 1, b'1'),
(266, 'for', 'for', 213, 'asdf', '234', '234', 1, b'1'),
(267, 'for', 'for', 214, 'asdf', '234', '234', 1, b'1'),
(268, 'for', 'for', 215, 'asdf', '234', '234', 1, b'1'),
(269, 'for', 'for', 216, 'asdf', '234', '234', 1, b'1'),
(270, 'for', 'for', 217, 'asdf', '234', '234', 1, b'1'),
(271, 'for', 'for', 218, 'asdf', '234', '234', 1, b'1'),
(272, 'for', 'for', 219, 'asdf', '234', '234', 1, b'1'),
(273, 'for', 'for', 220, 'asdf', '234', '234', 1, b'1'),
(274, 'for', 'for', 221, 'asdf', '234', '234', 1, b'1'),
(275, 'for', 'for', 222, 'asdf', '234', '234', 1, b'1'),
(276, 'for', 'for', 223, 'asdf', '234', '234', 1, b'1'),
(277, 'for', 'for', 224, 'asdf', '234', '234', 1, b'1'),
(278, 'for', 'for', 225, 'asdf', '234', '234', 1, b'1'),
(279, 'for', 'for', 226, 'asdf', '234', '234', 1, b'1'),
(280, 'for', 'for', 227, 'asdf', '234', '234', 1, b'1'),
(281, 'for', 'for', 228, 'asdf', '234', '234', 1, b'1'),
(282, 'for', 'for', 229, 'asdf', '234', '234', 1, b'1'),
(283, 'for', 'for', 230, 'asdf', '234', '234', 1, b'1'),
(284, 'for', 'for', 231, 'asdf', '234', '234', 1, b'1'),
(285, 'for', 'for', 232, 'asdf', '234', '234', 1, b'1'),
(286, 'for', 'for', 233, 'asdf', '234', '234', 1, b'1'),
(287, 'for', 'for', 234, 'asdf', '234', '234', 1, b'1'),
(288, 'for', 'for', 235, 'asdf', '234', '234', 1, b'1'),
(289, 'for', 'for', 236, 'asdf', '234', '234', 1, b'1'),
(290, 'for', 'for', 237, 'asdf', '234', '234', 1, b'1'),
(291, 'for', 'for', 238, 'asdf', '234', '234', 1, b'1'),
(292, 'for', 'for', 239, 'asdf', '234', '234', 1, b'1'),
(293, 'for', 'for', 240, 'asdf', '234', '234', 1, b'1'),
(294, 'for', 'for', 241, 'asdf', '234', '234', 1, b'1'),
(295, 'for', 'for', 242, 'asdf', '234', '234', 1, b'1'),
(296, 'for', 'for', 243, 'asdf', '234', '234', 1, b'1'),
(297, 'for', 'for', 244, 'asdf', '234', '234', 1, b'1'),
(298, 'for', 'for', 245, 'asdf', '234', '234', 1, b'1'),
(299, 'for', 'for', 246, 'asdf', '234', '234', 1, b'1'),
(300, 'for', 'for', 247, 'asdf', '234', '234', 1, b'1'),
(301, 'for', 'for', 248, 'asdf', '234', '234', 1, b'1'),
(302, 'for', 'for', 249, 'asdf', '234', '234', 1, b'1'),
(303, 'for', 'for', 250, 'asdf', '234', '234', 1, b'1'),
(304, 'for', 'for', 251, 'asdf', '234', '234', 1, b'1'),
(305, 'for', 'for', 252, 'asdf', '234', '234', 1, b'1'),
(306, 'for', 'for', 253, 'asdf', '234', '234', 1, b'1'),
(307, 'for', 'for', 254, 'asdf', '234', '234', 1, b'1'),
(308, 'for', 'for', 255, 'asdf', '234', '234', 1, b'1'),
(309, 'for', 'for', 256, 'asdf', '234', '234', 1, b'1'),
(310, 'for', 'for', 257, 'asdf', '234', '234', 1, b'1'),
(311, 'for', 'for', 258, 'asdf', '234', '234', 1, b'1'),
(312, 'for', 'for', 259, 'asdf', '234', '234', 1, b'1'),
(313, 'for', 'for', 260, 'asdf', '234', '234', 1, b'1'),
(314, 'for', 'for', 261, 'asdf', '234', '234', 1, b'1'),
(315, 'for', 'for', 262, 'asdf', '234', '234', 1, b'1'),
(316, 'for', 'for', 263, 'asdf', '234', '234', 1, b'1'),
(317, 'for', 'for', 264, 'asdf', '234', '234', 1, b'1'),
(318, 'for', 'for', 265, 'asdf', '234', '234', 1, b'1'),
(319, 'for', 'for', 266, 'asdf', '234', '234', 1, b'1'),
(320, 'for', 'for', 267, 'asdf', '234', '234', 1, b'1'),
(321, 'for', 'for', 268, 'asdf', '234', '234', 1, b'1'),
(322, 'for', 'for', 269, 'asdf', '234', '234', 1, b'1'),
(323, 'for', 'for', 270, 'asdf', '234', '234', 1, b'1'),
(324, 'for', 'for', 271, 'asdf', '234', '234', 1, b'1'),
(325, 'for', 'for', 272, 'asdf', '234', '234', 1, b'1'),
(326, 'for', 'for', 273, 'asdf', '234', '234', 1, b'1'),
(327, 'for', 'for', 274, 'asdf', '234', '234', 1, b'1'),
(328, 'for', 'for', 275, 'asdf', '234', '234', 1, b'1'),
(329, 'for', 'for', 276, 'asdf', '234', '234', 1, b'1'),
(330, 'for', 'for', 277, 'asdf', '234', '234', 1, b'1'),
(331, 'for', 'for', 278, 'asdf', '234', '234', 1, b'1'),
(332, 'for', 'for', 279, 'asdf', '234', '234', 1, b'1'),
(333, 'for', 'for', 280, 'asdf', '234', '234', 1, b'1'),
(334, 'for', 'for', 281, 'asdf', '234', '234', 1, b'1'),
(335, 'for', 'for', 282, 'asdf', '234', '234', 1, b'1'),
(336, 'for', 'for', 283, 'asdf', '234', '234', 1, b'1'),
(337, 'for', 'for', 284, 'asdf', '234', '234', 1, b'1'),
(338, 'for', 'for', 285, 'asdf', '234', '234', 1, b'1'),
(339, 'for', 'for', 286, 'asdf', '234', '234', 1, b'1'),
(340, 'for', 'for', 287, 'asdf', '234', '234', 1, b'1'),
(341, 'for', 'for', 288, 'asdf', '234', '234', 1, b'1'),
(342, 'for', 'for', 289, 'asdf', '234', '234', 1, b'1'),
(343, 'for', 'for', 290, 'asdf', '234', '234', 1, b'1'),
(344, 'for', 'for', 291, 'asdf', '234', '234', 1, b'1'),
(345, 'for', 'for', 292, 'asdf', '234', '234', 1, b'1'),
(346, 'for', 'for', 293, 'asdf', '234', '234', 1, b'1'),
(347, 'for', 'for', 294, 'asdf', '234', '234', 1, b'1'),
(348, 'for', 'for', 295, 'asdf', '234', '234', 1, b'1'),
(349, 'for', 'for', 296, 'asdf', '234', '234', 1, b'1'),
(350, 'for', 'for', 297, 'asdf', '234', '234', 1, b'1'),
(351, 'for', 'for', 298, 'asdf', '234', '234', 1, b'1'),
(352, 'for', 'for', 299, 'asdf', '234', '234', 1, b'1'),
(353, 'for', 'for', 300, 'asdf', '234', '234', 1, b'1'),
(354, 'for', 'for', 301, 'asdf', '234', '234', 1, b'1'),
(355, 'for', 'for', 302, 'asdf', '234', '234', 1, b'1'),
(356, 'for', 'for', 303, 'asdf', '234', '234', 1, b'1'),
(357, 'for', 'for', 304, 'asdf', '234', '234', 1, b'1'),
(358, 'for', 'for', 305, 'asdf', '234', '234', 1, b'1'),
(359, 'for', 'for', 306, 'asdf', '234', '234', 1, b'1'),
(360, 'for', 'for', 307, 'asdf', '234', '234', 1, b'1'),
(361, 'for', 'for', 308, 'asdf', '234', '234', 1, b'1'),
(362, 'for', 'for', 309, 'asdf', '234', '234', 1, b'1'),
(363, 'for', 'for', 310, 'asdf', '234', '234', 1, b'1'),
(364, 'for', 'for', 311, 'asdf', '234', '234', 1, b'1'),
(365, 'for', 'for', 312, 'asdf', '234', '234', 1, b'1'),
(366, 'for', 'for', 313, 'asdf', '234', '234', 1, b'1'),
(367, 'for', 'for', 314, 'asdf', '234', '234', 1, b'1'),
(368, 'for', 'for', 315, 'asdf', '234', '234', 1, b'1'),
(369, 'for', 'for', 316, 'asdf', '234', '234', 1, b'1'),
(370, 'for', 'for', 317, 'asdf', '234', '234', 1, b'1'),
(371, 'for', 'for', 318, 'asdf', '234', '234', 1, b'1'),
(372, 'for', 'for', 319, 'asdf', '234', '234', 1, b'1'),
(373, 'for', 'for', 320, 'asdf', '234', '234', 1, b'1'),
(374, 'for', 'for', 321, 'asdf', '234', '234', 1, b'1'),
(375, 'for', 'for', 322, 'asdf', '234', '234', 1, b'1'),
(376, 'for', 'for', 323, 'asdf', '234', '234', 1, b'1'),
(377, 'for', 'for', 324, 'asdf', '234', '234', 1, b'1'),
(378, 'for', 'for', 325, 'asdf', '234', '234', 1, b'1'),
(379, 'for', 'for', 326, 'asdf', '234', '234', 1, b'1'),
(380, 'for', 'for', 327, 'asdf', '234', '234', 1, b'1'),
(381, 'for', 'for', 328, 'asdf', '234', '234', 1, b'1'),
(382, 'for', 'for', 329, 'asdf', '234', '234', 1, b'1'),
(383, 'for', 'for', 330, 'asdf', '234', '234', 1, b'1'),
(384, 'for', 'for', 331, 'asdf', '234', '234', 1, b'1'),
(385, 'for', 'for', 332, 'asdf', '234', '234', 1, b'1'),
(386, 'for', 'for', 333, 'asdf', '234', '234', 1, b'1'),
(387, 'for', 'for', 334, 'asdf', '234', '234', 1, b'1'),
(388, 'for', 'for', 335, 'asdf', '234', '234', 1, b'1'),
(389, 'for', 'for', 336, 'asdf', '234', '234', 1, b'1'),
(390, 'for', 'for', 337, 'asdf', '234', '234', 1, b'1'),
(391, 'for', 'for', 338, 'asdf', '234', '234', 1, b'1'),
(392, 'for', 'for', 339, 'asdf', '234', '234', 1, b'1'),
(393, 'for', 'for', 340, 'asdf', '234', '234', 1, b'1'),
(394, 'for', 'for', 341, 'asdf', '234', '234', 1, b'1'),
(395, 'for', 'for', 342, 'asdf', '234', '234', 1, b'1'),
(396, 'for', 'for', 343, 'asdf', '234', '234', 1, b'1'),
(397, 'for', 'for', 344, 'asdf', '234', '234', 1, b'1'),
(398, 'for', 'for', 345, 'asdf', '234', '234', 1, b'1'),
(399, 'for', 'for', 346, 'asdf', '234', '234', 1, b'1'),
(400, 'for', 'for', 347, 'asdf', '234', '234', 1, b'1'),
(401, 'for', 'for', 348, 'asdf', '234', '234', 1, b'1'),
(402, 'for', 'for', 349, 'asdf', '234', '234', 1, b'1'),
(403, 'for', 'for', 350, 'asdf', '234', '234', 1, b'1'),
(404, 'for', 'for', 351, 'asdf', '234', '234', 1, b'1'),
(405, 'for', 'for', 352, 'asdf', '234', '234', 1, b'1'),
(406, 'for', 'for', 353, 'asdf', '234', '234', 1, b'1'),
(407, 'for', 'for', 354, 'asdf', '234', '234', 1, b'1'),
(408, 'for', 'for', 355, 'asdf', '234', '234', 1, b'1'),
(409, 'for', 'for', 356, 'asdf', '234', '234', 1, b'1'),
(410, 'for', 'for', 357, 'asdf', '234', '234', 1, b'1'),
(411, 'for', 'for', 358, 'asdf', '234', '234', 1, b'1'),
(412, 'for', 'for', 359, 'asdf', '234', '234', 1, b'1'),
(413, 'for', 'for', 360, 'asdf', '234', '234', 1, b'1'),
(414, 'for', 'for', 361, 'asdf', '234', '234', 1, b'1'),
(415, 'for', 'for', 362, 'asdf', '234', '234', 1, b'1'),
(416, 'for', 'for', 363, 'asdf', '234', '234', 1, b'1'),
(417, 'for', 'for', 364, 'asdf', '234', '234', 1, b'1'),
(418, 'for', 'for', 365, 'asdf', '234', '234', 1, b'1'),
(419, 'for', 'for', 366, 'asdf', '234', '234', 1, b'1'),
(420, 'for', 'for', 367, 'asdf', '234', '234', 1, b'1'),
(421, 'for', 'for', 368, 'asdf', '234', '234', 1, b'1'),
(422, 'for', 'for', 369, 'asdf', '234', '234', 1, b'1'),
(423, 'for', 'for', 370, 'asdf', '234', '234', 1, b'1'),
(424, 'for', 'for', 371, 'asdf', '234', '234', 1, b'1'),
(425, 'for', 'for', 372, 'asdf', '234', '234', 1, b'1'),
(426, 'for', 'for', 373, 'asdf', '234', '234', 1, b'1'),
(427, 'for', 'for', 374, 'asdf', '234', '234', 1, b'1'),
(428, 'for', 'for', 375, 'asdf', '234', '234', 1, b'1'),
(429, 'for', 'for', 376, 'asdf', '234', '234', 1, b'1'),
(430, 'for', 'for', 377, 'asdf', '234', '234', 1, b'1'),
(431, 'for', 'for', 378, 'asdf', '234', '234', 1, b'1'),
(432, 'for', 'for', 379, 'asdf', '234', '234', 1, b'1'),
(433, 'for', 'for', 380, 'asdf', '234', '234', 1, b'1'),
(434, 'for', 'for', 381, 'asdf', '234', '234', 1, b'1'),
(435, 'for', 'for', 382, 'asdf', '234', '234', 1, b'1'),
(436, 'for', 'for', 383, 'asdf', '234', '234', 1, b'1'),
(437, 'for', 'for', 384, 'asdf', '234', '234', 1, b'1'),
(438, 'for', 'for', 385, 'asdf', '234', '234', 1, b'1'),
(439, 'for', 'for', 386, 'asdf', '234', '234', 1, b'1'),
(440, 'for', 'for', 387, 'asdf', '234', '234', 1, b'1'),
(441, 'for', 'for', 388, 'asdf', '234', '234', 1, b'1'),
(442, 'for', 'for', 389, 'asdf', '234', '234', 1, b'1'),
(443, 'for', 'for', 390, 'asdf', '234', '234', 1, b'1'),
(444, 'for', 'for', 391, 'asdf', '234', '234', 1, b'1'),
(445, 'for', 'for', 392, 'asdf', '234', '234', 1, b'1'),
(446, 'for', 'for', 393, 'asdf', '234', '234', 1, b'1'),
(447, 'for', 'for', 394, 'asdf', '234', '234', 1, b'1'),
(448, 'for', 'for', 395, 'asdf', '234', '234', 1, b'1'),
(449, 'for', 'for', 396, 'asdf', '234', '234', 1, b'1'),
(450, 'for', 'for', 397, 'asdf', '234', '234', 1, b'1'),
(451, 'for', 'for', 398, 'asdf', '234', '234', 1, b'1'),
(452, 'for', 'for', 399, 'asdf', '234', '234', 1, b'1'),
(453, 'for', 'for', 400, 'asdf', '234', '234', 1, b'1'),
(454, 'for', 'for', 401, 'asdf', '234', '234', 1, b'1'),
(455, 'for', 'for', 402, 'asdf', '234', '234', 1, b'1'),
(456, 'for', 'for', 403, 'asdf', '234', '234', 1, b'1'),
(457, 'for', 'for', 404, 'asdf', '234', '234', 1, b'1'),
(458, 'for', 'for', 405, 'asdf', '234', '234', 1, b'1'),
(459, 'for', 'for', 406, 'asdf', '234', '234', 1, b'1'),
(460, 'for', 'for', 407, 'asdf', '234', '234', 1, b'1'),
(461, 'for', 'for', 408, 'asdf', '234', '234', 1, b'1'),
(462, 'for', 'for', 409, 'asdf', '234', '234', 1, b'1'),
(463, 'for', 'for', 410, 'asdf', '234', '234', 1, b'1'),
(464, 'for', 'for', 411, 'asdf', '234', '234', 1, b'1'),
(465, 'for', 'for', 412, 'asdf', '234', '234', 1, b'1'),
(466, 'for', 'for', 413, 'asdf', '234', '234', 1, b'1'),
(467, 'for', 'for', 414, 'asdf', '234', '234', 1, b'1'),
(468, 'for', 'for', 415, 'asdf', '234', '234', 1, b'1'),
(469, 'for', 'for', 416, 'asdf', '234', '234', 1, b'1'),
(470, 'for', 'for', 417, 'asdf', '234', '234', 1, b'1'),
(471, 'for', 'for', 418, 'asdf', '234', '234', 1, b'1'),
(472, 'for', 'for', 419, 'asdf', '234', '234', 1, b'1'),
(473, 'for', 'for', 420, 'asdf', '234', '234', 1, b'1'),
(474, 'for', 'for', 421, 'asdf', '234', '234', 1, b'1'),
(475, 'for', 'for', 422, 'asdf', '234', '234', 1, b'1'),
(476, 'for', 'for', 423, 'asdf', '234', '234', 1, b'1'),
(477, 'for', 'for', 424, 'asdf', '234', '234', 1, b'1'),
(478, 'for', 'for', 425, 'asdf', '234', '234', 1, b'1'),
(479, 'for', 'for', 426, 'asdf', '234', '234', 1, b'1'),
(480, 'for', 'for', 427, 'asdf', '234', '234', 1, b'1'),
(481, 'for', 'for', 428, 'asdf', '234', '234', 1, b'1'),
(482, 'for', 'for', 429, 'asdf', '234', '234', 1, b'1'),
(483, 'for', 'for', 430, 'asdf', '234', '234', 1, b'1'),
(484, 'for', 'for', 431, 'asdf', '234', '234', 1, b'1'),
(485, 'for', 'for', 432, 'asdf', '234', '234', 1, b'1'),
(486, 'for', 'for', 433, 'asdf', '234', '234', 1, b'1'),
(487, 'for', 'for', 434, 'asdf', '234', '234', 1, b'1'),
(488, 'for', 'for', 435, 'asdf', '234', '234', 1, b'1'),
(489, 'for', 'for', 436, 'asdf', '234', '234', 1, b'1'),
(490, 'for', 'for', 437, 'asdf', '234', '234', 1, b'1'),
(491, 'for', 'for', 438, 'asdf', '234', '234', 1, b'1'),
(492, 'for', 'for', 439, 'asdf', '234', '234', 1, b'1'),
(493, 'for', 'for', 440, 'asdf', '234', '234', 1, b'1'),
(494, 'for', 'for', 441, 'asdf', '234', '234', 1, b'1'),
(495, 'for', 'for', 442, 'asdf', '234', '234', 1, b'1'),
(496, 'for', 'for', 443, 'asdf', '234', '234', 1, b'1'),
(497, 'for', 'for', 444, 'asdf', '234', '234', 1, b'1'),
(498, 'for', 'for', 445, 'asdf', '234', '234', 1, b'1'),
(499, 'for', 'for', 446, 'asdf', '234', '234', 1, b'1'),
(500, 'for', 'for', 447, 'asdf', '234', '234', 1, b'1'),
(501, 'for', 'for', 448, 'asdf', '234', '234', 1, b'1'),
(502, 'for', 'for', 449, 'asdf', '234', '234', 1, b'1'),
(503, 'for', 'for', 450, 'asdf', '234', '234', 1, b'1'),
(504, 'for', 'for', 451, 'asdf', '234', '234', 1, b'1'),
(505, 'for', 'for', 452, 'asdf', '234', '234', 1, b'1'),
(506, 'for', 'for', 453, 'asdf', '234', '234', 1, b'1'),
(507, 'for', 'for', 454, 'asdf', '234', '234', 1, b'1'),
(508, 'for', 'for', 455, 'asdf', '234', '234', 1, b'1'),
(509, 'for', 'for', 456, 'asdf', '234', '234', 1, b'1'),
(510, 'for', 'for', 457, 'asdf', '234', '234', 1, b'1'),
(511, 'for', 'for', 458, 'asdf', '234', '234', 1, b'1'),
(512, 'for', 'for', 459, 'asdf', '234', '234', 1, b'1'),
(513, 'for', 'for', 460, 'asdf', '234', '234', 1, b'1'),
(514, 'for', 'for', 461, 'asdf', '234', '234', 1, b'1'),
(515, 'for', 'for', 462, 'asdf', '234', '234', 1, b'1'),
(516, 'for', 'for', 463, 'asdf', '234', '234', 1, b'1'),
(517, 'for', 'for', 464, 'asdf', '234', '234', 1, b'1'),
(518, 'for', 'for', 465, 'asdf', '234', '234', 1, b'1'),
(519, 'for', 'for', 466, 'asdf', '234', '234', 1, b'1'),
(520, 'for', 'for', 467, 'asdf', '234', '234', 1, b'1'),
(521, 'for', 'for', 468, 'asdf', '234', '234', 1, b'1'),
(522, 'for', 'for', 469, 'asdf', '234', '234', 1, b'1'),
(523, 'for', 'for', 470, 'asdf', '234', '234', 1, b'1'),
(524, 'for', 'for', 471, 'asdf', '234', '234', 1, b'1'),
(525, 'for', 'for', 472, 'asdf', '234', '234', 1, b'1'),
(526, 'for', 'for', 473, 'asdf', '234', '234', 1, b'1'),
(527, 'for', 'for', 474, 'asdf', '234', '234', 1, b'1'),
(528, 'for', 'for', 475, 'asdf', '234', '234', 1, b'1'),
(529, 'for', 'for', 476, 'asdf', '234', '234', 1, b'1'),
(530, 'for', 'for', 477, 'asdf', '234', '234', 1, b'1'),
(531, 'for', 'for', 478, 'asdf', '234', '234', 1, b'1'),
(532, 'for', 'for', 479, 'asdf', '234', '234', 1, b'1'),
(533, 'for', 'for', 480, 'asdf', '234', '234', 1, b'1'),
(534, 'for', 'for', 481, 'asdf', '234', '234', 1, b'1'),
(535, 'for', 'for', 482, 'asdf', '234', '234', 1, b'1'),
(536, 'for', 'for', 483, 'asdf', '234', '234', 1, b'1'),
(537, 'for', 'for', 484, 'asdf', '234', '234', 1, b'1'),
(538, 'for', 'for', 485, 'asdf', '234', '234', 1, b'1'),
(539, 'for', 'for', 486, 'asdf', '234', '234', 1, b'1'),
(540, 'for', 'for', 487, 'asdf', '234', '234', 1, b'1'),
(541, 'for', 'for', 488, 'asdf', '234', '234', 1, b'1'),
(542, 'for', 'for', 489, 'asdf', '234', '234', 1, b'1'),
(543, 'for', 'for', 490, 'asdf', '234', '234', 1, b'1'),
(544, 'for', 'for', 491, 'asdf', '234', '234', 1, b'1'),
(545, 'for', 'for', 492, 'asdf', '234', '234', 1, b'1'),
(546, 'for', 'for', 493, 'asdf', '234', '234', 1, b'1'),
(547, 'for', 'for', 494, 'asdf', '234', '234', 1, b'1'),
(548, 'for', 'for', 495, 'asdf', '234', '234', 1, b'1'),
(549, 'for', 'for', 496, 'asdf', '234', '234', 1, b'1'),
(550, 'for', 'for', 497, 'asdf', '234', '234', 1, b'1'),
(551, 'for', 'for', 498, 'asdf', '234', '234', 1, b'1'),
(552, 'for', 'for', 499, 'asdf', '234', '234', 1, b'1'),
(553, 'for', 'for', 500, 'asdf', '234', '234', 1, b'1'),
(554, 'for', 'for', 501, 'asdf', '234', '234', 1, b'1'),
(555, 'for', 'for', 502, 'asdf', '234', '234', 1, b'1'),
(556, 'for', 'for', 503, 'asdf', '234', '234', 1, b'1'),
(557, 'for', 'for', 504, 'asdf', '234', '234', 1, b'1'),
(558, 'for', 'for', 505, 'asdf', '234', '234', 1, b'1'),
(559, 'for', 'for', 506, 'asdf', '234', '234', 1, b'1'),
(560, 'for', 'for', 507, 'asdf', '234', '234', 1, b'1'),
(561, 'for', 'for', 508, 'asdf', '234', '234', 1, b'1'),
(562, 'for', 'for', 509, 'asdf', '234', '234', 1, b'1'),
(563, 'for', 'for', 510, 'asdf', '234', '234', 1, b'1'),
(564, 'for', 'for', 511, 'asdf', '234', '234', 1, b'1'),
(565, 'for', 'for', 512, 'asdf', '234', '234', 1, b'1'),
(566, 'for', 'for', 513, 'asdf', '234', '234', 1, b'1'),
(567, 'for', 'for', 514, 'asdf', '234', '234', 1, b'1'),
(568, 'for', 'for', 515, 'asdf', '234', '234', 1, b'1'),
(569, 'for', 'for', 516, 'asdf', '234', '234', 1, b'1'),
(570, 'for', 'for', 517, 'asdf', '234', '234', 1, b'1'),
(571, 'for', 'for', 518, 'asdf', '234', '234', 1, b'1'),
(572, 'for', 'for', 519, 'asdf', '234', '234', 1, b'1'),
(573, 'for', 'for', 520, 'asdf', '234', '234', 1, b'1'),
(574, 'for', 'for', 521, 'asdf', '234', '234', 1, b'1'),
(575, 'for', 'for', 522, 'asdf', '234', '234', 1, b'1'),
(576, 'for', 'for', 523, 'asdf', '234', '234', 1, b'1'),
(577, 'for', 'for', 524, 'asdf', '234', '234', 1, b'1'),
(578, 'for', 'for', 525, 'asdf', '234', '234', 1, b'1'),
(579, 'for', 'for', 526, 'asdf', '234', '234', 1, b'1'),
(580, 'for', 'for', 527, 'asdf', '234', '234', 1, b'1'),
(581, 'for', 'for', 528, 'asdf', '234', '234', 1, b'1'),
(582, 'for', 'for', 529, 'asdf', '234', '234', 1, b'1'),
(583, 'for', 'for', 530, 'asdf', '234', '234', 1, b'1'),
(584, 'for', 'for', 531, 'asdf', '234', '234', 1, b'1'),
(585, 'for', 'for', 532, 'asdf', '234', '234', 1, b'1'),
(586, 'for', 'for', 533, 'asdf', '234', '234', 1, b'1'),
(587, 'for', 'for', 534, 'asdf', '234', '234', 1, b'1'),
(588, 'for', 'for', 535, 'asdf', '234', '234', 1, b'1'),
(589, 'for', 'for', 536, 'asdf', '234', '234', 1, b'1'),
(590, 'for', 'for', 537, 'asdf', '234', '234', 1, b'1'),
(591, 'for', 'for', 538, 'asdf', '234', '234', 1, b'1'),
(592, 'for', 'for', 539, 'asdf', '234', '234', 1, b'1'),
(593, 'for', 'for', 540, 'asdf', '234', '234', 1, b'1'),
(594, 'for', 'for', 541, 'asdf', '234', '234', 1, b'1'),
(595, 'for', 'for', 542, 'asdf', '234', '234', 1, b'1'),
(596, 'for', 'for', 543, 'asdf', '234', '234', 1, b'1'),
(597, 'for', 'for', 544, 'asdf', '234', '234', 1, b'1'),
(598, 'for', 'for', 545, 'asdf', '234', '234', 1, b'1'),
(599, 'for', 'for', 546, 'asdf', '234', '234', 1, b'1'),
(600, 'for', 'for', 547, 'asdf', '234', '234', 1, b'1'),
(601, 'for', 'for', 548, 'asdf', '234', '234', 1, b'1'),
(602, 'for', 'for', 549, 'asdf', '234', '234', 1, b'1'),
(603, 'for', 'for', 550, 'asdf', '234', '234', 1, b'1'),
(604, 'for', 'for', 551, 'asdf', '234', '234', 1, b'1'),
(605, 'for', 'for', 552, 'asdf', '234', '234', 1, b'1'),
(606, 'for', 'for', 553, 'asdf', '234', '234', 1, b'1'),
(607, 'for', 'for', 554, 'asdf', '234', '234', 1, b'1'),
(608, 'for', 'for', 555, 'asdf', '234', '234', 1, b'1'),
(609, 'for', 'for', 556, 'asdf', '234', '234', 1, b'1'),
(610, 'for', 'for', 557, 'asdf', '234', '234', 1, b'1'),
(611, 'for', 'for', 558, 'asdf', '234', '234', 1, b'1'),
(612, 'for', 'for', 559, 'asdf', '234', '234', 1, b'1'),
(613, 'for', 'for', 560, 'asdf', '234', '234', 1, b'1'),
(614, 'for', 'for', 561, 'asdf', '234', '234', 1, b'1'),
(615, 'for', 'for', 562, 'asdf', '234', '234', 1, b'1'),
(616, 'for', 'for', 563, 'asdf', '234', '234', 1, b'1'),
(617, 'for', 'for', 564, 'asdf', '234', '234', 1, b'1'),
(618, 'for', 'for', 565, 'asdf', '234', '234', 1, b'1'),
(619, 'for', 'for', 566, 'asdf', '234', '234', 1, b'1'),
(620, 'for', 'for', 567, 'asdf', '234', '234', 1, b'1'),
(621, 'for', 'for', 568, 'asdf', '234', '234', 1, b'1'),
(622, 'for', 'for', 569, 'asdf', '234', '234', 1, b'1'),
(623, 'for', 'for', 570, 'asdf', '234', '234', 1, b'1'),
(624, 'for', 'for', 571, 'asdf', '234', '234', 1, b'1'),
(625, 'for', 'for', 572, 'asdf', '234', '234', 1, b'1'),
(626, 'for', 'for', 573, 'asdf', '234', '234', 1, b'1'),
(627, 'for', 'for', 574, 'asdf', '234', '234', 1, b'1'),
(628, 'for', 'for', 575, 'asdf', '234', '234', 1, b'1'),
(629, 'for', 'for', 576, 'asdf', '234', '234', 1, b'1'),
(630, 'for', 'for', 577, 'asdf', '234', '234', 1, b'1'),
(631, 'for', 'for', 578, 'asdf', '234', '234', 1, b'1'),
(632, 'for', 'for', 579, 'asdf', '234', '234', 1, b'1'),
(633, 'for', 'for', 580, 'asdf', '234', '234', 1, b'1'),
(634, 'for', 'for', 581, 'asdf', '234', '234', 1, b'1'),
(635, 'for', 'for', 582, 'asdf', '234', '234', 1, b'1'),
(636, 'for', 'for', 583, 'asdf', '234', '234', 1, b'1'),
(637, 'for', 'for', 584, 'asdf', '234', '234', 1, b'1'),
(638, 'for', 'for', 585, 'asdf', '234', '234', 1, b'1'),
(639, 'for', 'for', 586, 'asdf', '234', '234', 1, b'1'),
(640, 'for', 'for', 587, 'asdf', '234', '234', 1, b'1'),
(641, 'for', 'for', 588, 'asdf', '234', '234', 1, b'1'),
(642, 'for', 'for', 589, 'asdf', '234', '234', 1, b'1'),
(643, 'for', 'for', 590, 'asdf', '234', '234', 1, b'1'),
(644, 'for', 'for', 591, 'asdf', '234', '234', 1, b'1'),
(645, 'for', 'for', 592, 'asdf', '234', '234', 1, b'1'),
(646, 'for', 'for', 593, 'asdf', '234', '234', 1, b'1'),
(647, 'for', 'for', 594, 'asdf', '234', '234', 1, b'1'),
(648, 'for', 'for', 595, 'asdf', '234', '234', 1, b'1'),
(649, 'for', 'for', 596, 'asdf', '234', '234', 1, b'1'),
(650, 'for', 'for', 597, 'asdf', '234', '234', 1, b'1'),
(651, 'for', 'for', 598, 'asdf', '234', '234', 1, b'1'),
(652, 'for', 'for', 599, 'asdf', '234', '234', 1, b'1'),
(653, 'for', 'for', 600, 'asdf', '234', '234', 1, b'1'),
(654, 'for', 'for', 601, 'asdf', '234', '234', 1, b'1'),
(655, 'for', 'for', 602, 'asdf', '234', '234', 1, b'1'),
(656, 'for', 'for', 603, 'asdf', '234', '234', 1, b'1'),
(657, 'for', 'for', 604, 'asdf', '234', '234', 1, b'1'),
(658, 'for', 'for', 605, 'asdf', '234', '234', 1, b'1'),
(659, 'for', 'for', 606, 'asdf', '234', '234', 1, b'1'),
(660, 'for', 'for', 607, 'asdf', '234', '234', 1, b'1'),
(661, 'for', 'for', 608, 'asdf', '234', '234', 1, b'1'),
(662, 'for', 'for', 609, 'asdf', '234', '234', 1, b'1'),
(663, 'for', 'for', 610, 'asdf', '234', '234', 1, b'1'),
(664, 'for', 'for', 611, 'asdf', '234', '234', 1, b'1'),
(665, 'for', 'for', 612, 'asdf', '234', '234', 1, b'1'),
(666, 'for', 'for', 613, 'asdf', '234', '234', 1, b'1'),
(667, 'for', 'for', 614, 'asdf', '234', '234', 1, b'1'),
(668, 'for', 'for', 615, 'asdf', '234', '234', 1, b'1'),
(669, 'for', 'for', 616, 'asdf', '234', '234', 1, b'1'),
(670, 'for', 'for', 617, 'asdf', '234', '234', 1, b'1'),
(671, 'for', 'for', 618, 'asdf', '234', '234', 1, b'1'),
(672, 'for', 'for', 619, 'asdf', '234', '234', 1, b'1'),
(673, 'for', 'for', 620, 'asdf', '234', '234', 1, b'1'),
(674, 'for', 'for', 621, 'asdf', '234', '234', 1, b'1'),
(675, 'for', 'for', 622, 'asdf', '234', '234', 1, b'1'),
(676, 'for', 'for', 623, 'asdf', '234', '234', 1, b'1'),
(677, 'for', 'for', 624, 'asdf', '234', '234', 1, b'1'),
(678, 'for', 'for', 625, 'asdf', '234', '234', 1, b'1'),
(679, 'for', 'for', 626, 'asdf', '234', '234', 1, b'1'),
(680, 'for', 'for', 627, 'asdf', '234', '234', 1, b'1'),
(681, 'for', 'for', 628, 'asdf', '234', '234', 1, b'1'),
(682, 'for', 'for', 629, 'asdf', '234', '234', 1, b'1'),
(683, 'for', 'for', 630, 'asdf', '234', '234', 1, b'1'),
(684, 'for', 'for', 631, 'asdf', '234', '234', 1, b'1'),
(685, 'for', 'for', 632, 'asdf', '234', '234', 1, b'1'),
(686, 'for', 'for', 633, 'asdf', '234', '234', 1, b'1'),
(687, 'for', 'for', 634, 'asdf', '234', '234', 1, b'1'),
(688, 'for', 'for', 635, 'asdf', '234', '234', 1, b'1'),
(689, 'for', 'for', 636, 'asdf', '234', '234', 1, b'1'),
(690, 'for', 'for', 637, 'asdf', '234', '234', 1, b'1'),
(691, 'for', 'for', 638, 'asdf', '234', '234', 1, b'1'),
(692, 'for', 'for', 639, 'asdf', '234', '234', 1, b'1'),
(693, 'for', 'for', 640, 'asdf', '234', '234', 1, b'1'),
(694, 'for', 'for', 641, 'asdf', '234', '234', 1, b'1'),
(695, 'for', 'for', 642, 'asdf', '234', '234', 1, b'1'),
(696, 'for', 'for', 643, 'asdf', '234', '234', 1, b'1'),
(697, 'for', 'for', 644, 'asdf', '234', '234', 1, b'1'),
(698, 'for', 'for', 645, 'asdf', '234', '234', 1, b'1'),
(699, 'for', 'for', 646, 'asdf', '234', '234', 1, b'1'),
(700, 'for', 'for', 647, 'asdf', '234', '234', 1, b'1'),
(701, 'for', 'for', 648, 'asdf', '234', '234', 1, b'1'),
(702, 'for', 'for', 649, 'asdf', '234', '234', 1, b'1'),
(703, 'for', 'for', 650, 'asdf', '234', '234', 1, b'1'),
(704, 'for', 'for', 651, 'asdf', '234', '234', 1, b'1'),
(705, 'for', 'for', 652, 'asdf', '234', '234', 1, b'1'),
(706, 'for', 'for', 653, 'asdf', '234', '234', 1, b'1'),
(707, 'for', 'for', 654, 'asdf', '234', '234', 1, b'1'),
(708, 'for', 'for', 655, 'asdf', '234', '234', 1, b'1'),
(709, 'for', 'for', 656, 'asdf', '234', '234', 1, b'1'),
(710, 'for', 'for', 657, 'asdf', '234', '234', 1, b'1'),
(711, 'for', 'for', 658, 'asdf', '234', '234', 1, b'1'),
(712, 'for', 'for', 659, 'asdf', '234', '234', 1, b'1'),
(713, 'for', 'for', 660, 'asdf', '234', '234', 1, b'1'),
(714, 'for', 'for', 661, 'asdf', '234', '234', 1, b'1'),
(715, 'for', 'for', 662, 'asdf', '234', '234', 1, b'1'),
(716, 'for', 'for', 663, 'asdf', '234', '234', 1, b'1'),
(717, 'for', 'for', 664, 'asdf', '234', '234', 1, b'1'),
(718, 'for', 'for', 665, 'asdf', '234', '234', 1, b'1'),
(719, 'for', 'for', 666, 'asdf', '234', '234', 1, b'1'),
(720, 'for', 'for', 667, 'asdf', '234', '234', 1, b'1'),
(721, 'for', 'for', 668, 'asdf', '234', '234', 1, b'1'),
(722, 'for', 'for', 669, 'asdf', '234', '234', 1, b'1'),
(723, 'for', 'for', 670, 'asdf', '234', '234', 1, b'1'),
(724, 'for', 'for', 671, 'asdf', '234', '234', 1, b'1'),
(725, 'for', 'for', 672, 'asdf', '234', '234', 1, b'1'),
(726, 'for', 'for', 673, 'asdf', '234', '234', 1, b'1'),
(727, 'for', 'for', 674, 'asdf', '234', '234', 1, b'1'),
(728, 'for', 'for', 675, 'asdf', '234', '234', 1, b'1'),
(729, 'for', 'for', 676, 'asdf', '234', '234', 1, b'1'),
(730, 'for', 'for', 677, 'asdf', '234', '234', 1, b'1'),
(731, 'for', 'for', 678, 'asdf', '234', '234', 1, b'1'),
(732, 'for', 'for', 679, 'asdf', '234', '234', 1, b'1'),
(733, 'for', 'for', 680, 'asdf', '234', '234', 1, b'1'),
(734, 'for', 'for', 681, 'asdf', '234', '234', 1, b'1'),
(735, 'for', 'for', 682, 'asdf', '234', '234', 1, b'1'),
(736, 'for', 'for', 683, 'asdf', '234', '234', 1, b'1'),
(737, 'for', 'for', 684, 'asdf', '234', '234', 1, b'1'),
(738, 'for', 'for', 685, 'asdf', '234', '234', 1, b'1'),
(739, 'for', 'for', 686, 'asdf', '234', '234', 1, b'1'),
(740, 'for', 'for', 687, 'asdf', '234', '234', 1, b'1'),
(741, 'for', 'for', 688, 'asdf', '234', '234', 1, b'1'),
(742, 'for', 'for', 689, 'asdf', '234', '234', 1, b'1'),
(743, 'for', 'for', 690, 'asdf', '234', '234', 1, b'1'),
(744, 'for', 'for', 691, 'asdf', '234', '234', 1, b'1'),
(745, 'for', 'for', 692, 'asdf', '234', '234', 1, b'1'),
(746, 'for', 'for', 693, 'asdf', '234', '234', 1, b'1'),
(747, 'for', 'for', 694, 'asdf', '234', '234', 1, b'1'),
(748, 'for', 'for', 695, 'asdf', '234', '234', 1, b'1'),
(749, 'for', 'for', 696, 'asdf', '234', '234', 1, b'1'),
(750, 'for', 'for', 697, 'asdf', '234', '234', 1, b'1'),
(751, 'for', 'for', 698, 'asdf', '234', '234', 1, b'1'),
(752, 'for', 'for', 699, 'asdf', '234', '234', 1, b'1'),
(753, 'for', 'for', 700, 'asdf', '234', '234', 1, b'1'),
(754, 'for', 'for', 701, 'asdf', '234', '234', 1, b'1'),
(755, 'for', 'for', 702, 'asdf', '234', '234', 1, b'1'),
(756, 'for', 'for', 703, 'asdf', '234', '234', 1, b'1'),
(757, 'for', 'for', 704, 'asdf', '234', '234', 1, b'1'),
(758, 'for', 'for', 705, 'asdf', '234', '234', 1, b'1'),
(759, 'for', 'for', 706, 'asdf', '234', '234', 1, b'1'),
(760, 'for', 'for', 707, 'asdf', '234', '234', 1, b'1'),
(761, 'for', 'for', 708, 'asdf', '234', '234', 1, b'1'),
(762, 'for', 'for', 709, 'asdf', '234', '234', 1, b'1'),
(763, 'for', 'for', 710, 'asdf', '234', '234', 1, b'1'),
(764, 'for', 'for', 711, 'asdf', '234', '234', 1, b'1'),
(765, 'for', 'for', 712, 'asdf', '234', '234', 1, b'1'),
(766, 'for', 'for', 713, 'asdf', '234', '234', 1, b'1'),
(767, 'for', 'for', 714, 'asdf', '234', '234', 1, b'1'),
(768, 'for', 'for', 715, 'asdf', '234', '234', 1, b'1'),
(769, 'for', 'for', 716, 'asdf', '234', '234', 1, b'1'),
(770, 'for', 'for', 717, 'asdf', '234', '234', 1, b'1'),
(771, 'for', 'for', 718, 'asdf', '234', '234', 1, b'1'),
(772, 'for', 'for', 719, 'asdf', '234', '234', 1, b'1'),
(773, 'for', 'for', 720, 'asdf', '234', '234', 1, b'1'),
(774, 'for', 'for', 721, 'asdf', '234', '234', 1, b'1'),
(775, 'for', 'for', 722, 'asdf', '234', '234', 1, b'1'),
(776, 'for', 'for', 723, 'asdf', '234', '234', 1, b'1'),
(777, 'for', 'for', 724, 'asdf', '234', '234', 1, b'1'),
(778, 'for', 'for', 725, 'asdf', '234', '234', 1, b'1'),
(779, 'for', 'for', 726, 'asdf', '234', '234', 1, b'1'),
(780, 'for', 'for', 727, 'asdf', '234', '234', 1, b'1'),
(781, 'for', 'for', 728, 'asdf', '234', '234', 1, b'1'),
(782, 'for', 'for', 729, 'asdf', '234', '234', 1, b'1'),
(783, 'for', 'for', 730, 'asdf', '234', '234', 1, b'1'),
(784, 'for', 'for', 731, 'asdf', '234', '234', 1, b'1'),
(785, 'for', 'for', 732, 'asdf', '234', '234', 1, b'1'),
(786, 'for', 'for', 733, 'asdf', '234', '234', 1, b'1'),
(787, 'for', 'for', 734, 'asdf', '234', '234', 1, b'1'),
(788, 'for', 'for', 735, 'asdf', '234', '234', 1, b'1'),
(789, 'for', 'for', 736, 'asdf', '234', '234', 1, b'1'),
(790, 'for', 'for', 737, 'asdf', '234', '234', 1, b'1'),
(791, 'for', 'for', 738, 'asdf', '234', '234', 1, b'1'),
(792, 'for', 'for', 739, 'asdf', '234', '234', 1, b'1'),
(793, 'for', 'for', 740, 'asdf', '234', '234', 1, b'1'),
(794, 'for', 'for', 741, 'asdf', '234', '234', 1, b'1'),
(795, 'for', 'for', 742, 'asdf', '234', '234', 1, b'1'),
(796, 'for', 'for', 743, 'asdf', '234', '234', 1, b'1'),
(797, 'for', 'for', 744, 'asdf', '234', '234', 1, b'1'),
(798, 'for', 'for', 745, 'asdf', '234', '234', 1, b'1'),
(799, 'for', 'for', 746, 'asdf', '234', '234', 1, b'1'),
(800, 'for', 'for', 747, 'asdf', '234', '234', 1, b'1'),
(801, 'for', 'for', 748, 'asdf', '234', '234', 1, b'1'),
(802, 'for', 'for', 749, 'asdf', '234', '234', 1, b'1'),
(803, 'for', 'for', 750, 'asdf', '234', '234', 1, b'1'),
(804, 'for', 'for', 751, 'asdf', '234', '234', 1, b'1'),
(805, 'for', 'for', 752, 'asdf', '234', '234', 1, b'1'),
(806, 'for', 'for', 753, 'asdf', '234', '234', 1, b'1'),
(807, 'for', 'for', 754, 'asdf', '234', '234', 1, b'1'),
(808, 'for', 'for', 755, 'asdf', '234', '234', 1, b'1'),
(809, 'for', 'for', 756, 'asdf', '234', '234', 1, b'1'),
(810, 'for', 'for', 757, 'asdf', '234', '234', 1, b'1'),
(811, 'for', 'for', 758, 'asdf', '234', '234', 1, b'1'),
(812, 'for', 'for', 759, 'asdf', '234', '234', 1, b'1'),
(813, 'for', 'for', 760, 'asdf', '234', '234', 1, b'1'),
(814, 'for', 'for', 761, 'asdf', '234', '234', 1, b'1'),
(815, 'for', 'for', 762, 'asdf', '234', '234', 1, b'1'),
(816, 'for', 'for', 763, 'asdf', '234', '234', 1, b'1'),
(817, 'for', 'for', 764, 'asdf', '234', '234', 1, b'1'),
(818, 'for', 'for', 765, 'asdf', '234', '234', 1, b'1'),
(819, 'for', 'for', 766, 'asdf', '234', '234', 1, b'1'),
(820, 'for', 'for', 767, 'asdf', '234', '234', 1, b'1'),
(821, 'for', 'for', 768, 'asdf', '234', '234', 1, b'1'),
(822, 'for', 'for', 769, 'asdf', '234', '234', 1, b'1'),
(823, 'for', 'for', 770, 'asdf', '234', '234', 1, b'1'),
(824, 'for', 'for', 771, 'asdf', '234', '234', 1, b'1'),
(825, 'for', 'for', 772, 'asdf', '234', '234', 1, b'1'),
(826, 'for', 'for', 773, 'asdf', '234', '234', 1, b'1'),
(827, 'for', 'for', 774, 'asdf', '234', '234', 1, b'1'),
(828, 'for', 'for', 775, 'asdf', '234', '234', 1, b'1'),
(829, 'for', 'for', 776, 'asdf', '234', '234', 1, b'1'),
(830, 'for', 'for', 777, 'asdf', '234', '234', 1, b'1'),
(831, 'for', 'for', 778, 'asdf', '234', '234', 1, b'1'),
(832, 'for', 'for', 779, 'asdf', '234', '234', 1, b'1'),
(833, 'for', 'for', 780, 'asdf', '234', '234', 1, b'1'),
(834, 'for', 'for', 781, 'asdf', '234', '234', 1, b'1'),
(835, 'for', 'for', 782, 'asdf', '234', '234', 1, b'1'),
(836, 'for', 'for', 783, 'asdf', '234', '234', 1, b'1'),
(837, 'for', 'for', 784, 'asdf', '234', '234', 1, b'1'),
(838, 'for', 'for', 785, 'asdf', '234', '234', 1, b'1'),
(839, 'for', 'for', 786, 'asdf', '234', '234', 1, b'1'),
(840, 'for', 'for', 787, 'asdf', '234', '234', 1, b'1'),
(841, 'for', 'for', 788, 'asdf', '234', '234', 1, b'1'),
(842, 'for', 'for', 789, 'asdf', '234', '234', 1, b'1'),
(843, 'for', 'for', 790, 'asdf', '234', '234', 1, b'1'),
(844, 'for', 'for', 791, 'asdf', '234', '234', 1, b'1'),
(845, 'for', 'for', 792, 'asdf', '234', '234', 1, b'1'),
(846, 'for', 'for', 793, 'asdf', '234', '234', 1, b'1'),
(847, 'for', 'for', 794, 'asdf', '234', '234', 1, b'1'),
(848, 'for', 'for', 795, 'asdf', '234', '234', 1, b'1'),
(849, 'for', 'for', 796, 'asdf', '234', '234', 1, b'1'),
(850, 'for', 'for', 797, 'asdf', '234', '234', 1, b'1'),
(851, 'for', 'for', 798, 'asdf', '234', '234', 1, b'1'),
(852, 'for', 'for', 799, 'asdf', '234', '234', 1, b'1'),
(853, 'for', 'for', 800, 'asdf', '234', '234', 1, b'1'),
(854, 'for', 'for', 801, 'asdf', '234', '234', 1, b'1'),
(855, 'for', 'for', 802, 'asdf', '234', '234', 1, b'1'),
(856, 'for', 'for', 803, 'asdf', '234', '234', 1, b'1'),
(857, 'for', 'for', 804, 'asdf', '234', '234', 1, b'1'),
(858, 'for', 'for', 805, 'asdf', '234', '234', 1, b'1'),
(859, 'for', 'for', 806, 'asdf', '234', '234', 1, b'1'),
(860, 'for', 'for', 807, 'asdf', '234', '234', 1, b'1'),
(861, 'for', 'for', 808, 'asdf', '234', '234', 1, b'1'),
(862, 'for', 'for', 809, 'asdf', '234', '234', 1, b'1'),
(863, 'for', 'for', 810, 'asdf', '234', '234', 1, b'1'),
(864, 'for', 'for', 811, 'asdf', '234', '234', 1, b'1'),
(865, 'for', 'for', 812, 'asdf', '234', '234', 1, b'1'),
(866, 'for', 'for', 813, 'asdf', '234', '234', 1, b'1'),
(867, 'for', 'for', 814, 'asdf', '234', '234', 1, b'1'),
(868, 'for', 'for', 815, 'asdf', '234', '234', 1, b'1'),
(869, 'for', 'for', 816, 'asdf', '234', '234', 1, b'1'),
(870, 'for', 'for', 817, 'asdf', '234', '234', 1, b'1'),
(871, 'for', 'for', 818, 'asdf', '234', '234', 1, b'1'),
(872, 'for', 'for', 819, 'asdf', '234', '234', 1, b'1'),
(873, 'for', 'for', 820, 'asdf', '234', '234', 1, b'1'),
(874, 'for', 'for', 821, 'asdf', '234', '234', 1, b'1'),
(875, 'for', 'for', 822, 'asdf', '234', '234', 1, b'1'),
(876, 'for', 'for', 823, 'asdf', '234', '234', 1, b'1'),
(877, 'for', 'for', 824, 'asdf', '234', '234', 1, b'1'),
(878, 'for', 'for', 825, 'asdf', '234', '234', 1, b'1'),
(879, 'for', 'for', 826, 'asdf', '234', '234', 1, b'1'),
(880, 'for', 'for', 827, 'asdf', '234', '234', 1, b'1'),
(881, 'for', 'for', 828, 'asdf', '234', '234', 1, b'1'),
(882, 'for', 'for', 829, 'asdf', '234', '234', 1, b'1'),
(883, 'for', 'for', 830, 'asdf', '234', '234', 1, b'1'),
(884, 'for', 'for', 831, 'asdf', '234', '234', 1, b'1'),
(885, 'for', 'for', 832, 'asdf', '234', '234', 1, b'1'),
(886, 'for', 'for', 833, 'asdf', '234', '234', 1, b'1'),
(887, 'for', 'for', 834, 'asdf', '234', '234', 1, b'1'),
(888, 'for', 'for', 835, 'asdf', '234', '234', 1, b'1'),
(889, 'for', 'for', 836, 'asdf', '234', '234', 1, b'1'),
(890, 'for', 'for', 837, 'asdf', '234', '234', 1, b'1'),
(891, 'for', 'for', 838, 'asdf', '234', '234', 1, b'1'),
(892, 'for', 'for', 839, 'asdf', '234', '234', 1, b'1'),
(893, 'for', 'for', 840, 'asdf', '234', '234', 1, b'1'),
(894, 'for', 'for', 841, 'asdf', '234', '234', 1, b'1'),
(895, 'for', 'for', 842, 'asdf', '234', '234', 1, b'1'),
(896, 'for', 'for', 843, 'asdf', '234', '234', 1, b'1'),
(897, 'for', 'for', 844, 'asdf', '234', '234', 1, b'1'),
(898, 'for', 'for', 845, 'asdf', '234', '234', 1, b'1'),
(899, 'for', 'for', 846, 'asdf', '234', '234', 1, b'1'),
(900, 'for', 'for', 847, 'asdf', '234', '234', 1, b'1'),
(901, 'for', 'for', 848, 'asdf', '234', '234', 1, b'1'),
(902, 'for', 'for', 849, 'asdf', '234', '234', 1, b'1'),
(903, 'for', 'for', 850, 'asdf', '234', '234', 1, b'1'),
(904, 'for', 'for', 851, 'asdf', '234', '234', 1, b'1'),
(905, 'for', 'for', 852, 'asdf', '234', '234', 1, b'1'),
(906, 'for', 'for', 853, 'asdf', '234', '234', 1, b'1'),
(907, 'for', 'for', 854, 'asdf', '234', '234', 1, b'1'),
(908, 'for', 'for', 855, 'asdf', '234', '234', 1, b'1'),
(909, 'for', 'for', 856, 'asdf', '234', '234', 1, b'1'),
(910, 'for', 'for', 857, 'asdf', '234', '234', 1, b'1'),
(911, 'for', 'for', 858, 'asdf', '234', '234', 1, b'1'),
(912, 'for', 'for', 859, 'asdf', '234', '234', 1, b'1'),
(913, 'for', 'for', 860, 'asdf', '234', '234', 1, b'1'),
(914, 'for', 'for', 861, 'asdf', '234', '234', 1, b'1'),
(915, 'for', 'for', 862, 'asdf', '234', '234', 1, b'1'),
(916, 'for', 'for', 863, 'asdf', '234', '234', 1, b'1'),
(917, 'for', 'for', 864, 'asdf', '234', '234', 1, b'1'),
(918, 'for', 'for', 865, 'asdf', '234', '234', 1, b'1'),
(919, 'for', 'for', 866, 'asdf', '234', '234', 1, b'1'),
(920, 'for', 'for', 867, 'asdf', '234', '234', 1, b'1'),
(921, 'for', 'for', 868, 'asdf', '234', '234', 1, b'1'),
(922, 'for', 'for', 869, 'asdf', '234', '234', 1, b'1'),
(923, 'for', 'for', 870, 'asdf', '234', '234', 1, b'1'),
(924, 'for', 'for', 871, 'asdf', '234', '234', 1, b'1'),
(925, 'for', 'for', 872, 'asdf', '234', '234', 1, b'1'),
(926, 'for', 'for', 873, 'asdf', '234', '234', 1, b'1'),
(927, 'for', 'for', 874, 'asdf', '234', '234', 1, b'1'),
(928, 'for', 'for', 875, 'asdf', '234', '234', 1, b'1'),
(929, 'for', 'for', 876, 'asdf', '234', '234', 1, b'1'),
(930, 'for', 'for', 877, 'asdf', '234', '234', 1, b'1'),
(931, 'for', 'for', 878, 'asdf', '234', '234', 1, b'1'),
(932, 'for', 'for', 879, 'asdf', '234', '234', 1, b'1'),
(933, 'for', 'for', 880, 'asdf', '234', '234', 1, b'1'),
(934, 'for', 'for', 881, 'asdf', '234', '234', 1, b'1'),
(935, 'for', 'for', 882, 'asdf', '234', '234', 1, b'1'),
(936, 'for', 'for', 883, 'asdf', '234', '234', 1, b'1'),
(937, 'for', 'for', 884, 'asdf', '234', '234', 1, b'1'),
(938, 'for', 'for', 885, 'asdf', '234', '234', 1, b'1'),
(939, 'for', 'for', 886, 'asdf', '234', '234', 1, b'1'),
(940, 'for', 'for', 887, 'asdf', '234', '234', 1, b'1'),
(941, 'for', 'for', 888, 'asdf', '234', '234', 1, b'1'),
(942, 'for', 'for', 889, 'asdf', '234', '234', 1, b'1'),
(943, 'for', 'for', 890, 'asdf', '234', '234', 1, b'1'),
(944, 'for', 'for', 891, 'asdf', '234', '234', 1, b'1'),
(945, 'for', 'for', 892, 'asdf', '234', '234', 1, b'1'),
(946, 'for', 'for', 893, 'asdf', '234', '234', 1, b'1');
INSERT INTO `clients` (`idClients`, `Name`, `Surname`, `DNI_CUIT`, `eMail`, `Telephone`, `Cellphone`, `Business_idBusiness`, `Active`) VALUES
(947, 'for', 'for', 894, 'asdf', '234', '234', 1, b'1'),
(948, 'for', 'for', 895, 'asdf', '234', '234', 1, b'1'),
(949, 'for', 'for', 896, 'asdf', '234', '234', 1, b'1'),
(950, 'for', 'for', 897, 'asdf', '234', '234', 1, b'1'),
(951, 'for', 'for', 898, 'asdf', '234', '234', 1, b'1'),
(952, 'for', 'for', 899, 'asdf', '234', '234', 1, b'1'),
(953, 'for', 'for', 900, 'asdf', '234', '234', 1, b'1'),
(954, 'for', 'for', 901, 'asdf', '234', '234', 1, b'1'),
(955, 'for', 'for', 902, 'asdf', '234', '234', 1, b'1'),
(956, 'for', 'for', 903, 'asdf', '234', '234', 1, b'1'),
(957, 'for', 'for', 904, 'asdf', '234', '234', 1, b'1'),
(958, 'for', 'for', 905, 'asdf', '234', '234', 1, b'1'),
(959, 'for', 'for', 906, 'asdf', '234', '234', 1, b'1'),
(960, 'for', 'for', 907, 'asdf', '234', '234', 1, b'1'),
(961, 'for', 'for', 908, 'asdf', '234', '234', 1, b'1'),
(962, 'for', 'for', 909, 'asdf', '234', '234', 1, b'1'),
(963, 'for', 'for', 910, 'asdf', '234', '234', 1, b'1'),
(964, 'for', 'for', 911, 'asdf', '234', '234', 1, b'1'),
(965, 'for', 'for', 912, 'asdf', '234', '234', 1, b'1'),
(966, 'for', 'for', 913, 'asdf', '234', '234', 1, b'1'),
(967, 'for', 'for', 914, 'asdf', '234', '234', 1, b'1'),
(968, 'for', 'for', 915, 'asdf', '234', '234', 1, b'1'),
(969, 'for', 'for', 916, 'asdf', '234', '234', 1, b'1'),
(970, 'for', 'for', 917, 'asdf', '234', '234', 1, b'1'),
(971, 'for', 'for', 918, 'asdf', '234', '234', 1, b'1'),
(972, 'for', 'for', 919, 'asdf', '234', '234', 1, b'1'),
(973, 'for', 'for', 920, 'asdf', '234', '234', 1, b'1'),
(974, 'for', 'for', 921, 'asdf', '234', '234', 1, b'1'),
(975, 'for', 'for', 922, 'asdf', '234', '234', 1, b'1'),
(976, 'for', 'for', 923, 'asdf', '234', '234', 1, b'1'),
(977, 'for', 'for', 924, 'asdf', '234', '234', 1, b'1'),
(978, 'for', 'for', 925, 'asdf', '234', '234', 1, b'1'),
(979, 'for', 'for', 926, 'asdf', '234', '234', 1, b'1'),
(980, 'for', 'for', 927, 'asdf', '234', '234', 1, b'1'),
(981, 'for', 'for', 928, 'asdf', '234', '234', 1, b'1'),
(982, 'for', 'for', 929, 'asdf', '234', '234', 1, b'1'),
(983, 'for', 'for', 930, 'asdf', '234', '234', 1, b'1'),
(984, 'for', 'for', 931, 'asdf', '234', '234', 1, b'1'),
(985, 'for', 'for', 932, 'asdf', '234', '234', 1, b'1'),
(986, 'for', 'for', 933, 'asdf', '234', '234', 1, b'1'),
(987, 'for', 'for', 934, 'asdf', '234', '234', 1, b'1'),
(988, 'for', 'for', 935, 'asdf', '234', '234', 1, b'1'),
(989, 'for', 'for', 936, 'asdf', '234', '234', 1, b'1'),
(990, 'for', 'for', 937, 'asdf', '234', '234', 1, b'1'),
(991, 'for', 'for', 938, 'asdf', '234', '234', 1, b'1'),
(992, 'for', 'for', 939, 'asdf', '234', '234', 1, b'1'),
(993, 'for', 'for', 940, 'asdf', '234', '234', 1, b'1'),
(994, 'for', 'for', 941, 'asdf', '234', '234', 1, b'1'),
(995, 'for', 'for', 942, 'asdf', '234', '234', 1, b'1'),
(996, 'for', 'for', 943, 'asdf', '234', '234', 1, b'1'),
(997, 'for', 'for', 944, 'asdf', '234', '234', 1, b'1'),
(998, 'for', 'for', 945, 'asdf', '234', '234', 1, b'1'),
(999, 'for', 'for', 946, 'asdf', '234', '234', 1, b'1'),
(1000, 'for', 'for', 947, 'asdf', '234', '234', 1, b'1'),
(1001, 'for', 'for', 948, 'asdf', '234', '234', 1, b'1'),
(1002, 'for', 'for', 949, 'asdf', '234', '234', 1, b'1'),
(1003, 'for', 'for', 950, 'asdf', '234', '234', 1, b'1'),
(1004, 'for', 'for', 951, 'asdf', '234', '234', 1, b'1'),
(1005, 'for', 'for', 952, 'asdf', '234', '234', 1, b'1'),
(1006, 'for', 'for', 953, 'asdf', '234', '234', 1, b'1'),
(1007, 'for', 'for', 954, 'asdf', '234', '234', 1, b'1'),
(1008, 'for', 'for', 955, 'asdf', '234', '234', 1, b'1'),
(1009, 'for', 'for', 956, 'asdf', '234', '234', 1, b'1'),
(1010, 'for', 'for', 957, 'asdf', '234', '234', 1, b'1'),
(1011, 'for', 'for', 958, 'asdf', '234', '234', 1, b'1'),
(1012, 'for', 'for', 959, 'asdf', '234', '234', 1, b'1'),
(1013, 'for', 'for', 960, 'asdf', '234', '234', 1, b'1'),
(1014, 'for', 'for', 961, 'asdf', '234', '234', 1, b'1'),
(1015, 'for', 'for', 962, 'asdf', '234', '234', 1, b'1'),
(1016, 'for', 'for', 963, 'asdf', '234', '234', 1, b'1'),
(1017, 'for', 'for', 964, 'asdf', '234', '234', 1, b'1'),
(1018, 'for', 'for', 965, 'asdf', '234', '234', 1, b'1'),
(1019, 'for', 'for', 966, 'asdf', '234', '234', 1, b'1'),
(1020, 'for', 'for', 967, 'asdf', '234', '234', 1, b'1'),
(1021, 'for', 'for', 968, 'asdf', '234', '234', 1, b'1'),
(1022, 'for', 'for', 969, 'asdf', '234', '234', 1, b'1'),
(1023, 'for', 'for', 970, 'asdf', '234', '234', 1, b'1'),
(1024, 'for', 'for', 971, 'asdf', '234', '234', 1, b'1'),
(1025, 'for', 'for', 972, 'asdf', '234', '234', 1, b'1'),
(1026, 'for', 'for', 973, 'asdf', '234', '234', 1, b'1'),
(1027, 'for', 'for', 974, 'asdf', '234', '234', 1, b'1'),
(1028, 'for', 'for', 975, 'asdf', '234', '234', 1, b'1'),
(1029, 'for', 'for', 976, 'asdf', '234', '234', 1, b'1'),
(1030, 'for', 'for', 977, 'asdf', '234', '234', 1, b'1'),
(1031, 'for', 'for', 978, 'asdf', '234', '234', 1, b'1'),
(1032, 'for', 'for', 979, 'asdf', '234', '234', 1, b'1'),
(1033, 'for', 'for', 980, 'asdf', '234', '234', 1, b'1'),
(1034, 'for', 'for', 981, 'asdf', '234', '234', 1, b'1'),
(1035, 'for', 'for', 982, 'asdf', '234', '234', 1, b'1'),
(1036, 'for', 'for', 983, 'asdf', '234', '234', 1, b'1'),
(1037, 'for', 'for', 984, 'asdf', '234', '234', 1, b'1'),
(1038, 'for', 'for', 985, 'asdf', '234', '234', 1, b'1'),
(1039, 'for', 'for', 986, 'asdf', '234', '234', 1, b'1'),
(1040, 'for', 'for', 987, 'asdf', '234', '234', 1, b'1'),
(1041, 'for', 'for', 988, 'asdf', '234', '234', 1, b'1'),
(1042, 'for', 'for', 989, 'asdf', '234', '234', 1, b'1'),
(1043, 'for', 'for', 990, 'asdf', '234', '234', 1, b'1'),
(1044, 'for', 'for', 991, 'asdf', '234', '234', 1, b'1'),
(1045, 'for', 'for', 992, 'asdf', '234', '234', 1, b'1'),
(1046, 'for', 'for', 993, 'asdf', '234', '234', 1, b'1'),
(1047, 'for', 'for', 994, 'asdf', '234', '234', 1, b'1'),
(1048, 'for', 'for', 995, 'asdf', '234', '234', 1, b'1'),
(1049, 'for', 'for', 996, 'asdf', '234', '234', 1, b'1'),
(1050, 'for', 'for', 997, 'asdf', '234', '234', 1, b'1'),
(1051, 'for', 'for', 998, 'asdf', '234', '234', 1, b'1'),
(1052, 'for', 'for', 999, 'asdf', '234', '234', 1, b'1'),
(1053, 'for', 'for', 1000, 'asdf', '234', '234', 1, b'1'),
(1054, 'for', 'for', 1001, 'asdf', '234', '234', 1, b'1'),
(1055, 'for', 'for', 1002, 'asdf', '234', '234', 1, b'1'),
(1056, 'for', 'for', 1003, 'asdf', '234', '234', 1, b'1'),
(1057, 'for', 'for', 1004, 'asdf', '234', '234', 1, b'1'),
(1058, 'for', 'for', 1005, 'asdf', '234', '234', 1, b'1'),
(1059, 'for', 'for', 1006, 'asdf', '234', '234', 1, b'1'),
(1060, 'for', 'for', 1007, 'asdf', '234', '234', 1, b'1'),
(1061, 'for', 'for', 1008, 'asdf', '234', '234', 1, b'1'),
(1062, 'for', 'for', 1009, 'asdf', '234', '234', 1, b'1'),
(1063, 'for', 'for', 1010, 'asdf', '234', '234', 1, b'1'),
(1064, 'for', 'for', 1011, 'asdf', '234', '234', 1, b'1'),
(1065, 'for', 'for', 1012, 'asdf', '234', '234', 1, b'1'),
(1066, 'for', 'for', 1013, 'asdf', '234', '234', 1, b'1'),
(1067, 'for', 'for', 1014, 'asdf', '234', '234', 1, b'1'),
(1068, 'for', 'for', 1015, 'asdf', '234', '234', 1, b'1'),
(1069, 'for', 'for', 1016, 'asdf', '234', '234', 1, b'1'),
(1070, 'for', 'for', 1017, 'asdf', '234', '234', 1, b'1'),
(1071, 'for', 'for', 1018, 'asdf', '234', '234', 1, b'1'),
(1072, 'for', 'for', 1019, 'asdf', '234', '234', 1, b'1'),
(1073, 'for', 'for', 1020, 'asdf', '234', '234', 1, b'1'),
(1074, 'for', 'for', 1021, 'asdf', '234', '234', 1, b'1'),
(1075, 'for', 'for', 1022, 'asdf', '234', '234', 1, b'1'),
(1076, 'for', 'for', 1023, 'asdf', '234', '234', 1, b'1'),
(1077, 'for', 'for', 1024, 'asdf', '234', '234', 1, b'1'),
(1078, 'for', 'for', 1025, 'asdf', '234', '234', 1, b'1'),
(1079, 'for', 'for', 1026, 'asdf', '234', '234', 1, b'1'),
(1080, 'for', 'for', 1027, 'asdf', '234', '234', 1, b'1'),
(1081, 'for', 'for', 1028, 'asdf', '234', '234', 1, b'1'),
(1082, 'for', 'for', 1029, 'asdf', '234', '234', 1, b'1'),
(1083, 'for', 'for', 1030, 'asdf', '234', '234', 1, b'1'),
(1084, 'for', 'for', 1031, 'asdf', '234', '234', 1, b'1'),
(1085, 'for', 'for', 1032, 'asdf', '234', '234', 1, b'1'),
(1086, 'for', 'for', 1033, 'asdf', '234', '234', 1, b'1'),
(1087, 'for', 'for', 1034, 'asdf', '234', '234', 1, b'1'),
(1088, 'for', 'for', 1035, 'asdf', '234', '234', 1, b'1'),
(1089, 'for', 'for', 1036, 'asdf', '234', '234', 1, b'1'),
(1090, 'for', 'for', 1037, 'asdf', '234', '234', 1, b'1'),
(1091, 'for', 'for', 1038, 'asdf', '234', '234', 1, b'1'),
(1092, 'for', 'for', 1039, 'asdf', '234', '234', 1, b'1'),
(1093, 'for', 'for', 1040, 'asdf', '234', '234', 1, b'1'),
(1094, 'for', 'for', 1041, 'asdf', '234', '234', 1, b'1'),
(1095, 'for', 'for', 1042, 'asdf', '234', '234', 1, b'1'),
(1096, 'for', 'for', 1043, 'asdf', '234', '234', 1, b'1'),
(1097, 'for', 'for', 1044, 'asdf', '234', '234', 1, b'1'),
(1098, 'for', 'for', 1045, 'asdf', '234', '234', 1, b'1'),
(1099, 'for', 'for', 1046, 'asdf', '234', '234', 1, b'1'),
(1100, 'for', 'for', 1047, 'asdf', '234', '234', 1, b'1'),
(1101, 'for', 'for', 1048, 'asdf', '234', '234', 1, b'1'),
(1102, 'for', 'for', 1049, 'asdf', '234', '234', 1, b'1'),
(1103, 'for', 'for', 1050, 'asdf', '234', '234', 1, b'1'),
(1104, 'for', 'for', 1051, 'asdf', '234', '234', 1, b'1'),
(1105, 'for', 'for', 1052, 'asdf', '234', '234', 1, b'1'),
(1106, 'for', 'for', 1053, 'asdf', '234', '234', 1, b'1'),
(1107, 'for', 'for', 1054, 'asdf', '234', '234', 1, b'1'),
(1108, 'for', 'for', 1055, 'asdf', '234', '234', 1, b'1'),
(1109, 'for', 'for', 1056, 'asdf', '234', '234', 1, b'1'),
(1110, 'for', 'for', 1057, 'asdf', '234', '234', 1, b'1'),
(1111, 'for', 'for', 1058, 'asdf', '234', '234', 1, b'1'),
(1112, 'for', 'for', 1059, 'asdf', '234', '234', 1, b'1'),
(1113, 'for', 'for', 1060, 'asdf', '234', '234', 1, b'1'),
(1114, 'for', 'for', 1061, 'asdf', '234', '234', 1, b'1'),
(1115, 'for', 'for', 1062, 'asdf', '234', '234', 1, b'1'),
(1116, 'for', 'for', 1063, 'asdf', '234', '234', 1, b'1'),
(1117, 'for', 'for', 1064, 'asdf', '234', '234', 1, b'1'),
(1118, 'for', 'for', 1065, 'asdf', '234', '234', 1, b'1'),
(1119, 'for', 'for', 1066, 'asdf', '234', '234', 1, b'1'),
(1120, 'for', 'for', 1067, 'asdf', '234', '234', 1, b'1'),
(1121, 'for', 'for', 1068, 'asdf', '234', '234', 1, b'1'),
(1122, 'for', 'for', 1069, 'asdf', '234', '234', 1, b'1'),
(1123, 'for', 'for', 1070, 'asdf', '234', '234', 1, b'1'),
(1124, 'for', 'for', 1071, 'asdf', '234', '234', 1, b'1'),
(1125, 'for', 'for', 1072, 'asdf', '234', '234', 1, b'1'),
(1126, 'for', 'for', 1073, 'asdf', '234', '234', 1, b'1'),
(1127, 'for', 'for', 1074, 'asdf', '234', '234', 1, b'1'),
(1128, 'for', 'for', 1075, 'asdf', '234', '234', 1, b'1'),
(1129, 'for', 'for', 1076, 'asdf', '234', '234', 1, b'1'),
(1130, 'for', 'for', 1077, 'asdf', '234', '234', 1, b'1'),
(1131, 'for', 'for', 1078, 'asdf', '234', '234', 1, b'1'),
(1132, 'for', 'for', 1079, 'asdf', '234', '234', 1, b'1'),
(1133, 'for', 'for', 1080, 'asdf', '234', '234', 1, b'1'),
(1134, 'for', 'for', 1081, 'asdf', '234', '234', 1, b'1'),
(1135, 'for', 'for', 1082, 'asdf', '234', '234', 1, b'1'),
(1136, 'for', 'for', 1083, 'asdf', '234', '234', 1, b'1'),
(1137, 'for', 'for', 1084, 'asdf', '234', '234', 1, b'1'),
(1138, 'for', 'for', 1085, 'asdf', '234', '234', 1, b'1'),
(1139, 'for', 'for', 1086, 'asdf', '234', '234', 1, b'1'),
(1140, 'for', 'for', 1087, 'asdf', '234', '234', 1, b'1'),
(1141, 'for', 'for', 1088, 'asdf', '234', '234', 1, b'1'),
(1142, 'for', 'for', 1089, 'asdf', '234', '234', 1, b'1'),
(1143, 'for', 'for', 1090, 'asdf', '234', '234', 1, b'1'),
(1144, 'for', 'for', 1091, 'asdf', '234', '234', 1, b'1'),
(1145, 'for', 'for', 1092, 'asdf', '234', '234', 1, b'1'),
(1146, 'for', 'for', 1093, 'asdf', '234', '234', 1, b'1'),
(1147, 'for', 'for', 1094, 'asdf', '234', '234', 1, b'1'),
(1148, 'for', 'for', 1095, 'asdf', '234', '234', 1, b'1'),
(1149, 'for', 'for', 1096, 'asdf', '234', '234', 1, b'1'),
(1150, 'for', 'for', 1097, 'asdf', '234', '234', 1, b'1'),
(1151, 'for', 'for', 1098, 'asdf', '234', '234', 1, b'1'),
(1152, 'for', 'for', 1099, 'asdf', '234', '234', 1, b'1'),
(1153, 'for', 'for', 1100, 'asdf', '234', '234', 1, b'1'),
(1154, 'for', 'for', 1101, 'asdf', '234', '234', 1, b'1'),
(1155, 'for', 'for', 1102, 'asdf', '234', '234', 1, b'1'),
(1156, 'for', 'for', 1103, 'asdf', '234', '234', 1, b'1'),
(1157, 'for', 'for', 1104, 'asdf', '234', '234', 1, b'1'),
(1158, 'for', 'for', 1105, 'asdf', '234', '234', 1, b'1'),
(1159, 'for', 'for', 1106, 'asdf', '234', '234', 1, b'1'),
(1160, 'for', 'for', 1107, 'asdf', '234', '234', 1, b'1'),
(1161, 'for', 'for', 1108, 'asdf', '234', '234', 1, b'1'),
(1162, 'for', 'for', 1109, 'asdf', '234', '234', 1, b'1'),
(1163, 'for', 'for', 1110, 'asdf', '234', '234', 1, b'1'),
(1164, 'for', 'for', 1111, 'asdf', '234', '234', 1, b'1'),
(1165, 'for', 'for', 1112, 'asdf', '234', '234', 1, b'1'),
(1166, 'for', 'for', 1113, 'asdf', '234', '234', 1, b'1'),
(1167, 'for', 'for', 1114, 'asdf', '234', '234', 1, b'1'),
(1168, 'for', 'for', 1115, 'asdf', '234', '234', 1, b'1'),
(1169, 'for', 'for', 1116, 'asdf', '234', '234', 1, b'1'),
(1170, 'for', 'for', 1117, 'asdf', '234', '234', 1, b'1'),
(1171, 'for', 'for', 1118, 'asdf', '234', '234', 1, b'1'),
(1172, 'for', 'for', 1119, 'asdf', '234', '234', 1, b'1'),
(1173, 'for', 'for', 1120, 'asdf', '234', '234', 1, b'1'),
(1174, 'for', 'for', 1121, 'asdf', '234', '234', 1, b'1'),
(1175, 'for', 'for', 1122, 'asdf', '234', '234', 1, b'1'),
(1176, 'for', 'for', 1123, 'asdf', '234', '234', 1, b'1'),
(1177, 'for', 'for', 1124, 'asdf', '234', '234', 1, b'1'),
(1178, 'for', 'for', 1125, 'asdf', '234', '234', 1, b'1'),
(1179, 'for', 'for', 1126, 'asdf', '234', '234', 1, b'1'),
(1180, 'for', 'for', 1127, 'asdf', '234', '234', 1, b'1'),
(1181, 'for', 'for', 1128, 'asdf', '234', '234', 1, b'1'),
(1182, 'for', 'for', 1129, 'asdf', '234', '234', 1, b'1'),
(1183, 'for', 'for', 1130, 'asdf', '234', '234', 1, b'1'),
(1184, 'for', 'for', 1131, 'asdf', '234', '234', 1, b'1'),
(1185, 'for', 'for', 1132, 'asdf', '234', '234', 1, b'1'),
(1186, 'for', 'for', 1133, 'asdf', '234', '234', 1, b'1'),
(1187, 'for', 'for', 1134, 'asdf', '234', '234', 1, b'1'),
(1188, 'for', 'for', 1135, 'asdf', '234', '234', 1, b'1'),
(1189, 'for', 'for', 1136, 'asdf', '234', '234', 1, b'1'),
(1190, 'for', 'for', 1137, 'asdf', '234', '234', 1, b'1'),
(1191, 'for', 'for', 1138, 'asdf', '234', '234', 1, b'1'),
(1192, 'for', 'for', 1139, 'asdf', '234', '234', 1, b'1'),
(1193, 'for', 'for', 1140, 'asdf', '234', '234', 1, b'1'),
(1194, 'for', 'for', 1141, 'asdf', '234', '234', 1, b'1'),
(1195, 'for', 'for', 1142, 'asdf', '234', '234', 1, b'1'),
(1196, 'for', 'for', 1143, 'asdf', '234', '234', 1, b'1'),
(1197, 'for', 'for', 1144, 'asdf', '234', '234', 1, b'1'),
(1198, 'for', 'for', 1145, 'asdf', '234', '234', 1, b'1'),
(1199, 'for', 'for', 1146, 'asdf', '234', '234', 1, b'1'),
(1200, 'for', 'for', 1147, 'asdf', '234', '234', 1, b'1'),
(1201, 'for', 'for', 1148, 'asdf', '234', '234', 1, b'1'),
(1202, 'for', 'for', 1149, 'asdf', '234', '234', 1, b'1'),
(1203, 'for', 'for', 1150, 'asdf', '234', '234', 1, b'1'),
(1204, 'for', 'for', 1151, 'asdf', '234', '234', 1, b'1'),
(1205, 'for', 'for', 1152, 'asdf', '234', '234', 1, b'1'),
(1206, 'for', 'for', 1153, 'asdf', '234', '234', 1, b'1'),
(1207, 'for', 'for', 1154, 'asdf', '234', '234', 1, b'1'),
(1208, 'for', 'for', 1155, 'asdf', '234', '234', 1, b'1'),
(1209, 'for', 'for', 1156, 'asdf', '234', '234', 1, b'1'),
(1210, 'for', 'for', 1157, 'asdf', '234', '234', 1, b'1'),
(1211, 'for', 'for', 1158, 'asdf', '234', '234', 1, b'1'),
(1212, 'for', 'for', 1159, 'asdf', '234', '234', 1, b'1'),
(1213, 'for', 'for', 1160, 'asdf', '234', '234', 1, b'1'),
(1214, 'for', 'for', 1161, 'asdf', '234', '234', 1, b'1'),
(1215, 'for', 'for', 1162, 'asdf', '234', '234', 1, b'1'),
(1216, 'for', 'for', 1163, 'asdf', '234', '234', 1, b'1'),
(1217, 'for', 'for', 1164, 'asdf', '234', '234', 1, b'1'),
(1218, 'for', 'for', 1165, 'asdf', '234', '234', 1, b'1'),
(1219, 'for', 'for', 1166, 'asdf', '234', '234', 1, b'1'),
(1220, 'for', 'for', 1167, 'asdf', '234', '234', 1, b'1'),
(1221, 'for', 'for', 1168, 'asdf', '234', '234', 1, b'1'),
(1222, 'for', 'for', 1169, 'asdf', '234', '234', 1, b'1'),
(1223, 'for', 'for', 1170, 'asdf', '234', '234', 1, b'1'),
(1224, 'for', 'for', 1171, 'asdf', '234', '234', 1, b'1'),
(1225, 'for', 'for', 1172, 'asdf', '234', '234', 1, b'1'),
(1226, 'for', 'for', 1173, 'asdf', '234', '234', 1, b'1'),
(1227, 'for', 'for', 1174, 'asdf', '234', '234', 1, b'1'),
(1228, 'for', 'for', 1175, 'asdf', '234', '234', 1, b'1'),
(1229, 'for', 'for', 1176, 'asdf', '234', '234', 1, b'1'),
(1230, 'for', 'for', 1177, 'asdf', '234', '234', 1, b'1'),
(1231, 'for', 'for', 1178, 'asdf', '234', '234', 1, b'1'),
(1232, 'for', 'for', 1179, 'asdf', '234', '234', 1, b'1'),
(1233, 'for', 'for', 1180, 'asdf', '234', '234', 1, b'1'),
(1234, 'for', 'for', 1181, 'asdf', '234', '234', 1, b'1'),
(1235, 'for', 'for', 1182, 'asdf', '234', '234', 1, b'1'),
(1236, 'for', 'for', 1183, 'asdf', '234', '234', 1, b'1'),
(1237, 'for', 'for', 1184, 'asdf', '234', '234', 1, b'1'),
(1238, 'for', 'for', 1185, 'asdf', '234', '234', 1, b'1'),
(1239, 'for', 'for', 1186, 'asdf', '234', '234', 1, b'1'),
(1240, 'for', 'for', 1187, 'asdf', '234', '234', 1, b'1'),
(1241, 'for', 'for', 1188, 'asdf', '234', '234', 1, b'1'),
(1242, 'for', 'for', 1189, 'asdf', '234', '234', 1, b'1'),
(1243, 'for', 'for', 1190, 'asdf', '234', '234', 1, b'1'),
(1244, 'for', 'for', 1191, 'asdf', '234', '234', 1, b'1'),
(1245, 'for', 'for', 1192, 'asdf', '234', '234', 1, b'1'),
(1246, 'for', 'for', 1193, 'asdf', '234', '234', 1, b'1'),
(1247, 'for', 'for', 1194, 'asdf', '234', '234', 1, b'1'),
(1248, 'for', 'for', 1195, 'asdf', '234', '234', 1, b'1'),
(1249, 'for', 'for', 1196, 'asdf', '234', '234', 1, b'1'),
(1250, 'for', 'for', 1197, 'asdf', '234', '234', 1, b'1'),
(1251, 'for', 'for', 1198, 'asdf', '234', '234', 1, b'1'),
(1252, 'for', 'for', 1199, 'asdf', '234', '234', 1, b'1'),
(1253, 'for', 'for', 1200, 'asdf', '234', '234', 1, b'1'),
(1254, 'for', 'for', 1201, 'asdf', '234', '234', 1, b'1'),
(1255, 'for', 'for', 1202, 'asdf', '234', '234', 1, b'1'),
(1256, 'for', 'for', 1203, 'asdf', '234', '234', 1, b'1'),
(1257, 'for', 'for', 1204, 'asdf', '234', '234', 1, b'1'),
(1258, 'for', 'for', 1205, 'asdf', '234', '234', 1, b'1'),
(1259, 'for', 'for', 1206, 'asdf', '234', '234', 1, b'1'),
(1260, 'for', 'for', 1207, 'asdf', '234', '234', 1, b'1'),
(1261, 'for', 'for', 1208, 'asdf', '234', '234', 1, b'1'),
(1262, 'for', 'for', 1209, 'asdf', '234', '234', 1, b'1'),
(1263, 'for', 'for', 1210, 'asdf', '234', '234', 1, b'1'),
(1264, 'for', 'for', 1212, 'asdf', '234', '234', 1, b'1'),
(1265, 'for', 'for', 1213, 'asdf', '234', '234', 1, b'1'),
(1266, 'for', 'for', 1214, 'asdf', '234', '234', 1, b'1'),
(1267, 'for', 'for', 1215, 'asdf', '234', '234', 1, b'1'),
(1268, 'for', 'for', 1216, 'asdf', '234', '234', 1, b'1'),
(1269, 'for', 'for', 1217, 'asdf', '234', '234', 1, b'1'),
(1270, 'for', 'for', 1218, 'asdf', '234', '234', 1, b'1'),
(1271, 'for', 'for', 1219, 'asdf', '234', '234', 1, b'1'),
(1272, 'for', 'for', 1220, 'asdf', '234', '234', 1, b'1'),
(1273, 'for', 'for', 1221, 'asdf', '234', '234', 1, b'1'),
(1274, 'for', 'for', 1222, 'asdf', '234', '234', 1, b'1'),
(1275, 'for', 'for', 1223, 'asdf', '234', '234', 1, b'1'),
(1276, 'for', 'for', 1224, 'asdf', '234', '234', 1, b'1'),
(1277, 'for', 'for', 1225, 'asdf', '234', '234', 1, b'1'),
(1278, 'for', 'for', 1226, 'asdf', '234', '234', 1, b'1'),
(1279, 'for', 'for', 1227, 'asdf', '234', '234', 1, b'1'),
(1280, 'for', 'for', 1228, 'asdf', '234', '234', 1, b'1'),
(1281, 'for', 'for', 1229, 'asdf', '234', '234', 1, b'1'),
(1282, 'for', 'for', 1230, 'asdf', '234', '234', 1, b'1'),
(1283, 'for', 'for', 1231, 'asdf', '234', '234', 1, b'1'),
(1284, 'for', 'for', 1232, 'asdf', '234', '234', 1, b'1'),
(1285, 'for', 'for', 1233, 'asdf', '234', '234', 1, b'1'),
(1286, 'for', 'for', 1235, 'asdf', '234', '234', 1, b'1'),
(1287, 'for', 'for', 1236, 'asdf', '234', '234', 1, b'1'),
(1288, 'for', 'for', 1237, 'asdf', '234', '234', 1, b'1'),
(1289, 'for', 'for', 1238, 'asdf', '234', '234', 1, b'1'),
(1290, 'for', 'for', 1239, 'asdf', '234', '234', 1, b'1'),
(1291, 'for', 'for', 1240, 'asdf', '234', '234', 1, b'1'),
(1292, 'for', 'for', 1241, 'asdf', '234', '234', 1, b'1'),
(1293, 'for', 'for', 1242, 'asdf', '234', '234', 1, b'1'),
(1294, 'for', 'for', 1243, 'asdf', '234', '234', 1, b'1'),
(1295, 'for', 'for', 1244, 'asdf', '234', '234', 1, b'1'),
(1296, 'for', 'for', 1245, 'asdf', '234', '234', 1, b'1'),
(1297, 'for', 'for', 1246, 'asdf', '234', '234', 1, b'1'),
(1298, 'for', 'for', 1247, 'asdf', '234', '234', 1, b'1'),
(1299, 'for', 'for', 1248, 'asdf', '234', '234', 1, b'1'),
(1300, 'for', 'for', 1249, 'asdf', '234', '234', 1, b'1'),
(1301, 'for', 'for', 1250, 'asdf', '234', '234', 1, b'1'),
(1302, 'for', 'for', 1251, 'asdf', '234', '234', 1, b'1'),
(1303, 'for', 'for', 1252, 'asdf', '234', '234', 1, b'1'),
(1304, 'for', 'for', 1253, 'asdf', '234', '234', 1, b'1'),
(1305, 'for', 'for', 1254, 'asdf', '234', '234', 1, b'1'),
(1306, 'for', 'for', 1255, 'asdf', '234', '234', 1, b'1'),
(1307, 'for', 'for', 1256, 'asdf', '234', '234', 1, b'1'),
(1308, 'for', 'for', 1257, 'asdf', '234', '234', 1, b'1'),
(1309, 'for', 'for', 1258, 'asdf', '234', '234', 1, b'1'),
(1310, 'for', 'for', 1259, 'asdf', '234', '234', 1, b'1'),
(1311, 'for', 'for', 1260, 'asdf', '234', '234', 1, b'1'),
(1312, 'for', 'for', 1261, 'asdf', '234', '234', 1, b'1'),
(1313, 'for', 'for', 1262, 'asdf', '234', '234', 1, b'1'),
(1314, 'for', 'for', 1263, 'asdf', '234', '234', 1, b'1'),
(1315, 'for', 'for', 1264, 'asdf', '234', '234', 1, b'1'),
(1316, 'for', 'for', 1265, 'asdf', '234', '234', 1, b'1'),
(1317, 'for', 'for', 1266, 'asdf', '234', '234', 1, b'1');

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
(1, 1, 'Manga Yakusoku no Neverland Vol 1', 0002005.00, 0000300.00, 0000280.00, b'1', -10, '1', 3, 1, b'1'),
(2, 2, 'Manga Yakusoku no Neverland Vol 2', 0000320.00, 0000200.00, 0000180.00, b'1', 80, '2', 3, 1, b'1'),
(3, 3, 'Manga Yakusoku no Neverland Vol 4', 0000320.00, 0000300.00, 0000096.00, b'1', -1037, '3', 3, 1, b'1'),
(4, 5, 'Yogurisimo Con Cereales', 0000019.00, 0000050.00, 0000034.00, b'1', -1, '7791337613027', 2, 1, b'1'),
(7, 32, 'amazing hat', 0050056.00, 0000600.00, 0054958.00, NULL, -1, '434', 1, 1, b'1'),
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
-- Estructura de tabla para la tabla `stock_movement`
--

DROP TABLE IF EXISTS `stock_movement`;
CREATE TABLE IF NOT EXISTS `stock_movement` (
  `idStockMovement` int(20) NOT NULL,
  `type` tinyint(3) DEFAULT NULL,
  `idProduct` int(11) NOT NULL,
  `quant` int(11) DEFAULT NULL,
  `description` varchar(800) DEFAULT NULL,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`idStockMovement`),
  KEY `fk_stock_movement_products_idx` (`idProduct`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
-- Filtros para la tabla `stock_movement`
--
ALTER TABLE `stock_movement`
  ADD CONSTRAINT `fk_stock_movement_products` FOREIGN KEY (`idProduct`) REFERENCES `products` (`idProducts`);

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
