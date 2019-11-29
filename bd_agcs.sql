-- phpMyAdmin SQL Dump
-- version 4.7.9
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 22-11-2019 a las 14:57:20
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `spBillInsert` (IN `pIdBusiness` INT, IN `pDate` DATETIME, IN `pTotal` FLOAT, IN `pDNI` INT, IN `pIdUser` INT)  BEGIN
	if EXISTS(select idClient from clients where (DNI_CUIT = pDNI and pIdBusiness = Business_id and Active = 1) or (pDNI = 1)) and exists(select idUser from Users where idUser = pIdUser and Business_id = pIdBusiness and Active = 1)
    THEN
    SET  @idClient = (select idClient from clients where DNI_CUIT = pDNI and ((Business_id = pIdBusiness and Active = 1) or pDNI = 1));
		Insert into bills(DateBill,Total,Business_id,Clients_id, Users_id) values( pDate, pTotal, pIdBusiness,@idClient,@idUser);
    	select idBill from bills where idBill = LAST_INSERT_ID() and Business_id = pIdBusiness;
    ELSE
    	select -1 as idBill;
    end if;
END$$

DROP PROCEDURE IF EXISTS `spBillXProductInsert`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spBillXProductInsert` (IN `pIdBill` INT, IN `pIdProduct` INT, IN `pQuantity` INT, IN `pIdBusiness` INT, IN `pIdUser` INT)  BEGIN
	if exists(select idProduct from products where idProduct = pIdProduct and Business_id = pIdBusiness and Active = 1) and exists(select idBill from bills where idBill = pIdBill and Business_id = pIdBusiness) and exists(select idUser from Users where idUser = pIdUser and Business_id = pIdBusiness and Active = 1)
    then
    	set @price = (select Price from products where idProduct = pIdProduct and Business_id = pIdBusiness); 
		if(pQuantity > 0 and pQuantity is not null)
        then
			insert into bills_x_products(Products_id, Bills_id, Quantity, Price) values(pIdProduct,pIdBill,pQuantity,@price);
            update products set Stock = Stock - pQuantity where idProduct = pIdProduct and Business_id = pIdBusiness and Active = 1;
            call bd_agcs.spMovementInsert(pIdProduct, pQuantity, pIdUser, "Venta de producto", 0,@price,pIdBusiness);
		else
			insert into bills_x_products(Products_id, Bills_id, Quantity, Price) values(pIdProduct,pIdBill,0,@price);
        end if;
    end if;
END$$

DROP PROCEDURE IF EXISTS `spClientDelete`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spClientDelete` (IN `id` INT, IN `pIdBusiness` INT)  NO SQL
Update clients set clients.Active = 0 where clients.idClient = id and clients.Business_id = pIdBusiness and clients.Active = 1$$

DROP PROCEDURE IF EXISTS `spClientGetByDNI`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spClientGetByDNI` (IN `pDNI` BIGINT, IN `pIdBusiness` INT)  NO SQL
select clients.idClient,clients.Name, clients.Surname,clients.Cellphone,clients.Mail from clients where ((clients.DNI_CUIT = pDNI and clients.Business_id = pIdBusiness) or (pDNI = 1 and pDNI = clients.DNI_CUIT and clients.idClient = 0)) and clients.Active = 1$$

DROP PROCEDURE IF EXISTS `spClientGetById`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spClientGetById` (IN `id` INT, IN `pIdBusiness` INT)  NO SQL
SELECT * FROM clients WHERE clients.idClient = id and clients.Business_id = pIdBusiness and clients.Active = 1$$

DROP PROCEDURE IF EXISTS `spClientInsert`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spClientInsert` (IN `pIdBusiness` INT, IN `pName` VARCHAR(45), IN `pSurname` VARCHAR(45), IN `pDNI_CUIT` LONG, IN `pMail` VARCHAR(45), IN `pTelephone` VARCHAR(20), IN `pCellphone` VARCHAR(20))  NO SQL
if( pIdBusiness > -1 && pName != "" && pSurname != "" && pDNI_CUIT > 1 && not exists(select clients.idClient from clients where clients.DNI_CUIT = pDNI_CUIT and clients.Business_id = pIdBusiness))
then
	insert into clients(clients.Name,clients.Surname,clients.DNI_CUIT,clients.Business_id) values( pName, pSurname, pDNI_CUIT, pIdBusiness);
	
    set @lastId = (select clients.idClient from clients where clients.idClient = LAST_INSERT_ID() and clients.Name = pName and clients.Surname = pSurname and clients.DNI_CUIT = pDNI_CUIT and clients.Business_id = pIdBusiness);
	
    if(@lastId is not null)
    then
		if( pMail is not null) 
		THEN
			UPDATE clients set clients.Mail = pMail WHERE clients.idClient = @lastId and clients.Business_id = pIdBusiness; 
		end if;
		
		if( pTelephone is not null) 
		THEN
			UPDATE clients set clients.Telephone = pTelephone WHERE clients.idClient = @lastId and clients.Business_id = pIdBusiness; 
		end if;
		
		if( pCellphone is not null) 
		THEN
			UPDATE clients set clients.Cellphone = pCellphone WHERE clients.idClient = @lastId and clients.Business_id = pIdBusiness; 
		end if;
    end if;
end if$$

DROP PROCEDURE IF EXISTS `spClientsGet`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spClientsGet` (IN `pIdBusiness` INT, IN `pPage` INT, IN `pSearch` VARCHAR(500))  NO SQL
BEGIN
	DECLARE pag INT DEFAULT 0;
	SET pag = 20*pPage;
	if(pSearch is null)
    THEN
    	set @search = "%%";
    ELSE
		set @search = concat("%",pSearch,"%");
    end if;
	SELECT clients.idClient, clients.Name, clients.Surname, clients.DNI_CUIT, clients.Mail,clients.Cellphone FROM clients where clients.Business_id = pIdBusiness and clients.Active = 1  and (Name like @search or Surname like @search or DNI_CUIT like @search) LIMIT 25 OFFSET pag;
END$$

DROP PROCEDURE IF EXISTS `spClientUpdate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spClientUpdate` (IN `id` INT, IN `pIdBusiness` INT, IN `pName` VARCHAR(45), IN `pSurname` VARCHAR(45), IN `pDNI_Cuit` LONG, IN `pMail` VARCHAR(45), IN `pTelephone` VARCHAR(20), IN `pCellphone` VARCHAR(20))  NO SQL
if(EXISTS(SELECT clients.idClient from clients WHERE clients.idClient = id and clients.Business_id = pIdBusiness and clients.Active = 1))
THEN
	if(pName != "" and pSurname != "" and pDNI_CUIT > 0 and pDNI_CUIT != ""  )
    then
		if( pName is not null ) 
		THEN
			UPDATE clients set Name = pName WHERE clients.idClient = id and clients.Business_id = pIdBusiness; 
		end if;
		
		if( pSurname is not null) 
		THEN
			UPDATE clients set clients.Surname = pSurname WHERE clients.idClient = id and clients.Business_id = pIdBusiness; 
		end if;
		
		if( pDNI_CUIT is not null and not exists(SELECT clients.DNI_CUIT from clients where clients.DNI_CUIT = pDNI_CUIT and clients.Business_id = pIdBusiness)) 
		THEN
			UPDATE clients set clients.DNI_CUIT = pDNI_CUIT WHERE clients.idClient = id and clients.Business_id = pIdBusiness; 
		end if;
		
		if( pMail is not null) 
		THEN
			UPDATE clients set clients.Mail = pMail WHERE clients.idClient = id and clients.Business_id = pIdBusiness; 
		end if;
		
		UPDATE clients set clients.Telephone = pTelephone WHERE clients.idClient = id and clients.Business_id = pIdBusiness; 

		UPDATE clients set clients.Cellphone = pCellphone WHERE clients.idClient = id and clients.Business_id = pIdBusiness; 
		
	end if;
end if$$

DROP PROCEDURE IF EXISTS `spMovementGet`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spMovementGet` (IN `pIdProduct` INT)  BEGIN
	Select * from stock_movement inner join users on stock_movement.Users_id = users.idUser where pIdProduct = stock_movement.Products_id order by datetime desc;
END$$

DROP PROCEDURE IF EXISTS `spMovementInsert`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spMovementInsert` (IN `pIdProduct` INT, IN `pQuant` INT, IN `pIdUser` INT, IN `pDescription` VARCHAR(500), IN `pType` TINYINT, IN `pAmount` FLOAT(10,2), IN `pIdBusiness` INT(11))  BEGIN
	if exists(select idProduct from products where idProduct = pIdProduct and Business_id = pIdBusiness and Active = 1) and exists(select idUser from Users where idUser = pIdUser and Business_id = pIdBusiness and Active = 1)
  THEN
    insert into stock_movement(type,description,Products_id, dateTime,quant,Amount,Users_id)values(pType,pDescription,pIdProduct,now(), pQuant,pAmount,pIdUser);
  end if;
END$$

DROP PROCEDURE IF EXISTS `spProductDelete`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spProductDelete` (IN `pId` INT, IN `pIdBusiness` INT)  BEGIN
    update products set products.Active = 0 where Products.idProduct = pId and Products.Business_id = pIdBusiness and products.active = 1;
END$$

DROP PROCEDURE IF EXISTS `spProductGetByCode`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spProductGetByCode` (IN `pCode` INT, IN `pIdBusiness` INT)  BEGIN

	SELECT * FROM products WHERE (/*products.Article_Number = pCode or */products.CodeProduct = pCode) and products.Business_id = pIdBusiness and products.Active = 1;

END$$

DROP PROCEDURE IF EXISTS `spProductGetById`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spProductGetById` (IN `pId` LONG, IN `pIdBusiness` INT)  BEGIN
	SELECT * FROM products WHERE products.idProduct = pId and products.Business_id = pIdBusiness and products.Active = 1;
END$$

DROP PROCEDURE IF EXISTS `spProductInsert`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spProductInsert` (IN `pIdBusiness` INT, IN `pProduct_Number` INT, IN `pCode` VARCHAR(100), IN `pName` VARCHAR(200), IN `pDescription` VARCHAR(200), IN `pCost` FLOAT(10,2), IN `pPrice` FLOAT(10,2), IN `pPriceW` FLOAT(10,2), IN `pImage` VARCHAR(2000))  BEGIN
	if (not exists(select idProduct from Products where Business_id = pIdBusiness and (CodeProduct = pCode or Article_number = pProduct_Number or Products.Name = pName)))
    then
    	if(pProduct_Number > 0)
        then 
        	insert into Products(Business_id,Article_number,CodeProduct,Name) values(pIdBusiness, pProduct_Number, pCode, pName);
            set @lastId = (select Products.idProduct from Products where Products.idProduct = LAST_INSERT_ID());# and Products.Business_id = pIdBusiness /*and Products.Article_number = pProduct_Number*/ and Products.CodeProduct = pCode and Products.Description = pDescription/* and Products.Stock = pStock*/ and Products.Suppliers_id = pIdSupplier);
            if(@lastId is not null)
            then
            	if(pDescription !="" and pDescription is not null)
                THEN
                	Update Products set Description = pDescription where idProduct = @lastId;
                end if;
            	if(pCost > 0)
                then
                	Update Products set Cost = pCost where idProduct = @lastId; 
				end if;
				if(pPrice > 0)
				then
					Update Products set Price = pPrice where idProduct = @lastId; 
				end if;
				if(pPriceW > 0)
				then
					Update Products set PriceW = pPriceW where idProduct = @lastId; 
				end if;
				update products set Image = pImage where idProduct = @lastId; 
			end if; #endif lastId is not null 
		end if;#endif ProductNumber > 0
	end if;#endif not exists product with same code or product number in the same business
END$$

DROP PROCEDURE IF EXISTS `spProductsGet`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spProductsGet` (IN `pIdBusiness` INT, IN `pSearch` VARCHAR(500))  BEGIN
	if(pSearch is null)
    THEN
    	set @search = "%%";
    ELSE
		set @search = concat("%",pSearch,"%");
    end if;
	select * from Products where Products.Business_id = pIdBusiness and products.Active = 1 and (Name like @search or CodeProduct like @search or Article_number like @search);
END$$

DROP PROCEDURE IF EXISTS `spProductStockUpdate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spProductStockUpdate` (IN `pId` INT, IN `pStock` INT, IN `pDesc` VARCHAR(500), IN `pIdUser` INT, IN `pIdBusiness` INT)  BEGIN
	if exists(select idProduct from Products where idProduct = pId and Active = 1 and Business_id = pIdBusiness) and exists(select idUser from Users where idUser = pIdUser and Business_id = pIdBusiness and Active = 1)
    then
		update Products set stock = (stock-pStock) where idProduct = pId and Active = 1 and Business_id = pIdBusiness;	
        call bd_agcs.spMovementInsert(pId, pStock, pIdUser, pDesc, 2,0, pIdBusiness);
    end if;
END$$

DROP PROCEDURE IF EXISTS `spProductUpdate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spProductUpdate` (IN `pId` INT, IN `pIdBusiness` INT, IN `pProduct_Number` INT, IN `pCode` VARCHAR(100), IN `pName` VARCHAR(200), IN `pDescription` VARCHAR(200), IN `pCost` FLOAT, IN `pPrice` FLOAT, IN `pPriceW` FLOAT, IN `pImage` VARCHAR(2000))  BEGIN
	if exists(select idProduct from Products where idProduct = pId and Business_id = pIdBusiness and Active = 1)
    then
		#Product Number
        if (not exists(select Products.idProduct from Products where Products.Article_Number = pProduct_Number and Products.Business_id = pIdBusiness) and pProduct_Number > 0 and pProduct_Number is not null )
        then
			update Products set Products.Article_number = pProduct_Number where Products.idProduct = pId and Products.Business_id = pIdBusiness;
        end if;
        
		#Code
        if (not exists(select Products.idProduct from Products where Products.CodeProduct = pCode and Products.Business_id = pIdBusiness) and pCode != "" and pCode is not null )
        then
			update Products set Products.CodeProduct = pCode where Products.idProduct = pId and Products.Business_id = pIdBusiness;
        end if;        
        #Name
        if (not exists(select idProduct from Products where Name = pName and Business_id = pIdBusiness) and pName != "" and pName is not null )
        then
			update Products set Name = pName where idProduct = pId and Business_id = pIdBusiness;
        end if;
        #Description
        if (pDescription != "" and pDescription is not null )
        then
			update Products set Products.Description = pDescription where Products.idProduct = pId and Products.Business_id = pIdBusiness;
        end if;
		#Cost
        if (pCost > 0 and pCost is not null )
        then
			update Products set Products.Cost = pCost where Products.idProduct = pId and Products.Business_id = pIdBusiness;
        end if;
		#Price
        if (pPrice > 0 and pPrice is not null)
        then
			update Products set Products.Price = pPrice where Products.idProduct = pId and Products.Business_id = pIdBusiness;
        end if;
		#PriceW
        if (pPriceW > 0 and pPriceW is not null)
        then
			    update Products set Products.PriceW = pPriceW where Products.idProduct = pId and Products.Business_id = pIdBusiness;
        end if;        
        update products set Image = pImage where idProduct = pId and Business_id = pIdBusiness;
    end if;
END$$

DROP PROCEDURE IF EXISTS `spPurchaseInsert`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spPurchaseInsert` (IN `pIdBusiness` INT(11) UNSIGNED, IN `pDate` DATE, IN `pTotal` FLOAT(10,2), IN `pIdSupplier` INT(11) UNSIGNED, IN `pIdUser` INT(11) UNSIGNED)  NO SQL
if EXISTS(select idSupplier from suppliers where idSupplier = pIdSupplier and (Business_id = pIdBusiness or Business_id = 0) and Active = 1) 
THEN
	if exists(select idSupplier from suppliers where idSupplier = pIdSupplier and Business_id = pIdBusiness) and exists(select idUser from users where idUser = pIdUser and Business_id = pIdBusiness)
    THEN
    	Insert into purchases(date,total,Business_id,Suppliers_id,Users_id) values( pDate, pTotal, pIdBusiness,pIdSupplier, pIdUser);
    	select idPurchase from purchases where idPurchase = LAST_INSERT_ID() and total = pTotal and purchases.Business_id = pIdBusiness ;
	end if;
ELSE
	select -1 as idPurchase;
end if$$

DROP PROCEDURE IF EXISTS `spPurchaseXProductInsert`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spPurchaseXProductInsert` (IN `pIdPurchase` INT(11) UNSIGNED, IN `pCost` FLOAT(10,2) UNSIGNED, IN `pPrice` FLOAT(10,2), IN `pPriceW` FLOAT(10,2), IN `pIdUser` INT(11) UNSIGNED, IN `pIdProduct` INT(11) UNSIGNED, IN `pQuantity` INT(11), IN `pIdBusiness` INT(11), IN `pIdSupplier` INT(11))  NO SQL
if exists(select idProduct from products where idProduct = pIdProduct and Business_id = pIdBusiness and Active = 1) and exists(select idPurchase from purchases where idPurchase = pIdPurchase and Business_id = pIdBusiness) and exists(select idUser from Users where idUser = pIdUser and Business_id = pIdBusiness and Active = 1) and EXISTS(select idSupplier from suppliers where idSupplier = pIdSupplier and (Business_id = pIdBusiness or Business_id = 0 ) and Active = 1)
then
	if not EXISTS(SELECT idProductsXSuppliers from products_x_suppliers where Products_id = pIdProduct and Suppliers_id = pIdSupplier)
    THEN
    	insert into products_x_suppliers(Products_id,Suppliers_id) VALUES(pIdProduct,pIdSupplier);
    end if;
	if(pQuantity > 0 and pQuantity is not null)
    then
	insert into purchases_x_products(Purchases_id,Products_id,Quantity,Cost) values(pIdPurchase,pIdProduct,pQuantity,pCost);
    update products set products.Stock = products.Stock + pQuantity, products.cost = pCost, products.price = pPrice, products.priceW = pPriceW where products.idProduct = pIdProduct and Business_id = pIdBusiness  and Active = 1;
    call bd_agcs.spMovementInsert(pIdProduct, pQuantity, pIdUser, "Compra de producto", 1,pCost, pIdBusiness);
	else
		insert into purchases_x_products(idPurchase,idProduct,Quantity,Cost) values(pIdPurchase,pIdProduct,0,pCost);
    end if;
end if$$

DROP PROCEDURE IF EXISTS `spSupplierDelete`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spSupplierDelete` (IN `pId` INT, IN `pIdBusiness` INT)  BEGIN
if(EXISTS(SELECT suppliers.idSupplier FROM suppliers WHERE suppliers.idSupplier = pId and suppliers.Business_id = pIdBusiness))
THEN
	Update suppliers set suppliers.Active = 0 where suppliers.idSupplier = pId and suppliers.Business_id = pIdBusiness and suppliers.Active = 1;
end if;
end$$

DROP PROCEDURE IF EXISTS `spSupplierGetById`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spSupplierGetById` (IN `pId` INT, IN `pIdBusiness` INT)  BEGIN
	select * from suppliers where idSupplier = pId and Business_id = pIdBusiness and Active = 1;
END$$

DROP PROCEDURE IF EXISTS `spSupplierInsert`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spSupplierInsert` (IN `pIdBusiness` INT(20), IN `pCuit` INT(11), IN `pName` VARCHAR(100), IN `pSurname` VARCHAR(100), IN `pCompany` VARCHAR(100), IN `pFanciful` VARCHAR(100), IN `pTelephone` VARCHAR(20), IN `pCellphone` VARCHAR(20), IN `pAddress` VARCHAR(200), IN `pMail` VARCHAR(100))  NO SQL
if not EXISTS(select idSupplier from suppliers where ((Name = pName and Surname = pSurname) or (Cuit = pCuit)) and Business_id = pIdBusiness)
then
	if (((pName != "" and pName is not null) or (pSurname != "" and pSurname is not null)) and ( (pCompany != "" and pCompany is not null) or (pFanciful != "" and pFanciful is not null)))
    THEN
  	  INSERT INTO suppliers (Business_id, Cuit, Name, Surname, Telephone, Cellphone, Company,Fanciful_name, Address, Mail) VALUES(pIdBusiness, pCuit, pName, pSurname, pTelephone, pCellphone, pCompany, pFanciful, pAddress, pMail);
    end if;
end if$$

DROP PROCEDURE IF EXISTS `spSuppliersGet`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spSuppliersGet` (IN `pIdBusiness` INT, IN `pSearch` VARCHAR(500))  BEGIN
	if(pSearch is null)
    THEN
    	set @search = "%%";
    ELSE
		set @search = concat("%",pSearch,"%");
    end if;
	select * from suppliers where Business_id = pIdBusiness and Active = 1 and (Name like @search or Surname like @search or Fanciful_name like @search or Cuit like @search);
END$$

DROP PROCEDURE IF EXISTS `spSupplierUpdate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spSupplierUpdate` (IN `pId` INT(20), IN `pIdBusiness` INT(20), IN `pName` VARCHAR(100), IN `pSurname` VARCHAR(100), IN `pTelephone` VARCHAR(20), IN `pCellphone` VARCHAR(20), IN `pCompany` VARCHAR(100), IN `pAddress` VARCHAR(200), IN `pMail` VARCHAR(100), IN `pCuit` INT(11), IN `pFanciful` VARCHAR(100))  NO SQL
if EXISTS(select idSupplier from suppliers where idSupplier = pId and Business_id = pIdBusiness and Active = 1)
THEN	
    if NOT((pName = "" or pName is null) and (pSurname = "" or pSurname is null) )
    THEN
		if not EXISTS(select idSupplier from suppliers where Name = pName and Surname = pSurname and Business_id = pIdBusiness)	
        then
			update suppliers set Name = pName where idSupplier = pId and Business_id = pIdBusiness;
			update suppliers set Surname = pSurname where idSupplier = pId and Business_id = pIdBusiness;
		end if;
    end if;
    if(pCuit is not null and pCuit > 0 and not EXISTS(select idSupplier from suppliers where Cuit = pCUit))
    THEN
    	update suppliers set Cuit = pCUit where idSupplier = pId;
    end if;
    update suppliers set Telephone = pTelephone where idSupplier = pId and Business_id = pIdBusiness;
    update suppliers set Cellphone = pCellphone where idSupplier = pId and Business_id = pIdBusiness;
    update suppliers set address = pAddress where idSupplier = pId and Business_id = pIdBusiness;
    update suppliers set Mail = pMail where idSupplier = pId and Business_id = pIdBusiness;
    if( (pCompany != "" and pCompany is not null) or (pFanciful != "" and pFanciful is not null))
    THEN
        update suppliers set Company = pCompany where idSupplier = pId and Business_id = pIdBusiness;
        update suppliers set Fanciful_name = pFanciful where idSupplier = pId and Business_id = pIdBusiness;
    end if;
end if$$

DROP PROCEDURE IF EXISTS `spUserChangePassword`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spUserChangePassword` (IN `pOriginal` VARCHAR(60), IN `pNew` VARCHAR(60), IN `pId` BIGINT)  NO SQL
if exists(select users.idUser from users where users.idUser = pId and users.Password = md5(pOriginal))
	then
    	update users set users.Password = md5(pNew) where users.idUser = pId;
    end if$$

DROP PROCEDURE IF EXISTS `spUserDelete`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spUserDelete` (IN `pId` INT, IN `pIdBusiness` INT)  Update users set Active = 0 where idUser = pId and Business_id = pIdBusiness and Active = 1$$

DROP PROCEDURE IF EXISTS `spUserGetById`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spUserGetById` (IN `pId` INT, IN `pIdBusiness` INT)  NO SQL
SELECT users.idUser, users.Mail ,users.Name ,users.Surname ,users.Name_Second ,users.Dni, user_extrainfo.Address, user_extrainfo.Tel_Father, user_extrainfo.Tel_Mother,user_extrainfo.Tel_Brother, user_extrainfo.Tel_User,user_extrainfo.Cellphone FROM users inner join user_extrainfo on user_extrainfo.Users_id = users.idUser WHERE users.idUser = pId and users.Business_id= pIdBusiness$$

DROP PROCEDURE IF EXISTS `spUserInsert`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spUserInsert` (IN `pIdBusiness` INT, IN `pName` VARCHAR(60), IN `pSurname` VARCHAR(60), IN `pDni` BIGINT, IN `pMail` VARCHAR(60), IN `pTelephone` VARCHAR(60), IN `pPass` VARCHAR(60), IN `pCellphone` VARCHAR(60), IN `pAddress` VARCHAR(55), IN `pTelephoneM` VARCHAR(55), IN `pTelephoneF` VARCHAR(55), IN `pTelephoneB` VARCHAR(55), IN `pSecondN` VARCHAR(55))  NO SQL
if( pIdBusiness > -1 and pName != "" and pPass != "" and pSurname != "" and not exists(select users.idUser from users where users.Mail = pMail or (users.Dni = pDni and users.Business_id = pIdBusiness)))
then
	insert into users (users.Name,users.Surname,users.Business_id, users.Password, users.Mail,users.Admin) values( pName, pSurname,pIdBusiness,md5(pPass),pMail,0);	
    set @lastId = (select users.idUser from users where users.idUser = LAST_INSERT_ID() and users.Name = pName and users.Surname = pSurname and users.Business_id = pIdBusiness);
    if(@lastId is not null)
    then    
    	insert into user_extrainfo (user_extrainfo.Users_id) values (@lastId);
		if( pDni is not null) 
		THEN
			UPDATE users set users.Dni = pDni WHERE users.idUser = @lastId and users.Business_id = pIdBusiness; 
		end if;	
        if( pSecondN is not null) 
		THEN
			UPDATE users set users.Name_Second = pSecondN WHERE users.idUser = @lastId and users.Business_id = pIdBusiness; 
		end if;	
         if( pTelephone is not null) 
		THEN
			UPDATE user_extrainfo set user_extrainfo.Tel_User = pTelephone WHERE user_extrainfo.Users_id = @lastId; 
		end if;	
        if( pTelephoneM is not null) 
		THEN
			UPDATE user_extrainfo set user_extrainfo.Tel_Mother = pTelephoneM WHERE user_extrainfo.Users_id = @lastId; 
		end if;	
        if( pTelephoneF is not null) 
		THEN
			UPDATE user_extrainfo set user_extrainfo.Tel_Father = pTelephoneF WHERE user_extrainfo.Users_id = @lastId; 
		end if;	
        if( pTelephoneB is not null) 
		THEN
			UPDATE user_extrainfo set user_extrainfo.Tel_Brother = pTelephoneB WHERE user_extrainfo.Users_id = @lastId; 
		end if;
        if( pAddress is not null) 
		THEN
			UPDATE user_extrainfo set user_extrainfo.Address = pAddress WHERE user_extrainfo.Users_id = @lastId; 
		end if;
        if( pCellphone is not null) 
		THEN
			UPDATE user_extrainfo set user_extrainfo.Cellphone = pCellphone WHERE user_extrainfo.Users_id = @lastId; 
		end if;	
		
		select 1 as success; #Insert Success
    end if;
    else
		select 0 as success; #Insert Fail
end if$$

DROP PROCEDURE IF EXISTS `spUserLogin`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spUserLogin` (IN `Mail` VARCHAR(320), IN `Password` VARCHAR(200))  SELECT users.Name, users.Surname, users.Admin, users.idUser, business.idBusiness, business.Name as NameB from users INNER JOIN business ON business.idBusiness = users.Business_id where Mail = users.Mail and md5(Password) = users.Password$$

DROP PROCEDURE IF EXISTS `spUsersGet`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spUsersGet` (IN `pIdBusiness` INT)  NO SQL
SELECT user_extrainfo.Cellphone, users.idUser, users.Name, users.Surname, users.Dni, users.Mail FROM users left join user_extrainfo on users.idUser = user_extrainfo.Users_id where users.Business_id = pIdBusiness and users.Admin != 1$$

DROP PROCEDURE IF EXISTS `spUserUpdate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spUserUpdate` (IN `id` INT, IN `pIdBusiness` INT, IN `pName` VARCHAR(60), IN `pSurname` VARCHAR(60), IN `pDNI_CUIT` INT, IN `pMail` VARCHAR(60), IN `pTelephone` VARCHAR(60), IN `pCellphone` VARCHAR(60), IN `pTelephoneM` VARCHAR(60), IN `pTelephoneF` VARCHAR(60), IN `pTelephoneB` VARCHAR(60), IN `pAddress` VARCHAR(60), IN `pSecondN` VARCHAR(60))  NO SQL
if(EXISTS(SELECT users.idUser from users WHERE users.idUser = id and users.Business_id = pIdBusiness))
THEN
	if(pDNI_CUIT >0 and pDNI_CUIT is not null and pMail!= "" and pMail is not null and not exists(SELECT users.Dni from users where users.Mail = pMail or (users.Dni = pDNI_CUIT and users.Business_id = pIdBusiness)))
    then
        if( pName is not null and pName != "") 
		THEN
			UPDATE users set Name = pName WHERE users.idUser = id and users.Business_id = pIdBusiness; 
		end if;
		UPDATE users set Name_Second = pSecondN WHERE users.idUser = id and users.Business_id = pIdBusiness; 
		if( pSurname is not null and pSurname != "") 
		THEN
			UPDATE users set users.Surname = pSurname WHERE users.idUser = id and users.Business_id = pIdBusiness; 
		end if;
		UPDATE users set users.Dni = pDNI_CUIT WHERE users.idUser = id and users.Business_id = pIdBusiness; 
		UPDATE users set users.Mail = pMail WHERE users.idUser = id and users.Business_id = pIdBusiness; 
		UPDATE user_ExtraInfo set user_ExtraInfo.Tel_User = pTelephone WHERE user_ExtraInfo.idUser = id; 
		UPDATE user_ExtraInfo set user_ExtraInfo.Cellphone = pCellphone WHERE user_ExtraInfo.idUser = id; 
		UPDATE user_ExtraInfo set user_ExtraInfo.Tel_Mother = pTelephoneM WHERE user_ExtraInfo.idUser = id; 
		UPDATE user_ExtraInfo set user_ExtraInfo.Tel_Father = pTelephoneF WHERE user_ExtraInfo.idUser = id; 
		UPDATE user_ExtraInfo set user_ExtraInfo.Tel_Brother = pTelephoneB WHERE user_ExtraInfo.idUser = id; 
		UPDATE user_ExtraInfo set user_ExtraInfo.Address = pAddress WHERE user_ExtraInfo.idUser = id; 
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
  `Delivery_id` int(11) NOT NULL,
  `Province_id` int(11) NOT NULL,
  `Business_id` int(11) NOT NULL,
  `Clients_id` int(11) NOT NULL,
  PRIMARY KEY (`idAddress`) USING BTREE,
  KEY `fk_Address_Delivery1_idx` (`Delivery_id`),
  KEY `fk_Address_Province1_idx` (`Province_id`),
  KEY `fk_Address_Business1_idx` (`Business_id`),
  KEY `fk_Address_Client1` (`Clients_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bills`
--

DROP TABLE IF EXISTS `bills`;
CREATE TABLE IF NOT EXISTS `bills` (
  `idBill` int(11) NOT NULL AUTO_INCREMENT,
  `DateBill` date DEFAULT NULL,
  `Clients_id` int(11) DEFAULT NULL,
  `Users_id` int(11) DEFAULT NULL,
  `IVA_Condition` varchar(45) DEFAULT NULL,
  `TypeBill` varchar(1) DEFAULT NULL,
  `Subtotal` float(10,2) DEFAULT '0.00',
  `Discount` float(5,2) UNSIGNED ZEROFILL DEFAULT '00.00',
  `IVA_Recharge` float(5,2) UNSIGNED ZEROFILL DEFAULT '00.00',
  `WholeSaler` bit(1) DEFAULT NULL,
  `Total` float(2,2) DEFAULT '0.00',
  `Branches_id` int(11) DEFAULT NULL,
  `Payment_Methods_id` int(11) DEFAULT NULL,
  `Macs_id` int(11) DEFAULT NULL,
  `Business_id` int(11) NOT NULL,
  PRIMARY KEY (`idBill`) USING BTREE,
  UNIQUE KEY `idBill` (`idBill`),
  KEY `fk_Bills_Branches1_idx` (`Branches_id`) USING BTREE,
  KEY `fk_Bills_Payment_Methods1_idx` (`Payment_Methods_id`) USING BTREE,
  KEY `fk_Bills_Macs1_idx` (`Macs_id`) USING BTREE,
  KEY `fk_Bills_Business1_idx` (`Business_id`) USING BTREE,
  KEY `fk_Bills_Clients1_idx` (`Clients_id`)
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `bills`
--

INSERT INTO `bills` (`idBill`, `DateBill`, `Clients_id`, `Users_id`, `IVA_Condition`, `TypeBill`, `Subtotal`, `Discount`, `IVA_Recharge`, `WholeSaler`, `Total`, `Branches_id`, `Payment_Methods_id`, `Macs_id`, `Business_id`) VALUES
(2, '2019-06-27', 0, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, 0.99, 0, 0, 0, 1),
(3, '2019-06-27', 0, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, 0.99, 0, 0, 0, 1),
(4, '2019-06-27', 0, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, 0.99, 0, 0, 0, 1),
(60, '2019-09-06', 56, NULL, NULL, NULL, 0.00, 00.00, 00.00, NULL, 0.99, NULL, NULL, NULL, 8),
(61, '2019-10-22', 46, NULL, NULL, NULL, 0.00, 00.00, 00.00, NULL, 0.99, NULL, NULL, NULL, 1),
(62, '2019-10-22', 46, NULL, NULL, NULL, 0.00, 00.00, 00.00, NULL, 0.99, NULL, NULL, NULL, 1),
(63, '2019-10-22', 46, NULL, NULL, NULL, 0.00, 00.00, 00.00, NULL, 0.99, NULL, NULL, NULL, 1),
(64, '0000-00-00', 0, NULL, NULL, NULL, 0.00, 00.00, 00.00, NULL, 0.99, NULL, NULL, NULL, 0),
(65, '0000-00-00', 0, NULL, NULL, NULL, 0.00, 00.00, 00.00, NULL, 0.99, NULL, NULL, NULL, 1),
(66, '0000-00-00', 0, NULL, NULL, NULL, 0.00, 00.00, 00.00, NULL, 0.99, NULL, NULL, NULL, 3),
(67, '0000-00-00', 0, NULL, NULL, NULL, 0.00, 00.00, 00.00, NULL, 0.99, NULL, NULL, NULL, 3),
(68, '2019-10-22', 0, NULL, NULL, NULL, 0.00, 00.00, 00.00, NULL, 0.99, NULL, NULL, NULL, 1),
(69, '2019-10-24', 0, NULL, NULL, NULL, 0.00, 00.00, 00.00, NULL, 0.99, NULL, NULL, NULL, 1),
(70, '2019-10-25', 46, NULL, NULL, NULL, 0.00, 00.00, 00.00, NULL, 0.99, NULL, NULL, NULL, 1),
(71, '2019-10-25', 46, NULL, NULL, NULL, 0.00, 00.00, 00.00, NULL, 0.99, NULL, NULL, NULL, 1),
(72, '2019-11-07', 0, NULL, NULL, NULL, 0.00, 00.00, 00.00, NULL, 0.99, NULL, NULL, NULL, 1),
(73, '2019-11-07', 47, NULL, NULL, NULL, 0.00, 00.00, 00.00, NULL, 0.99, NULL, NULL, NULL, 1),
(74, '2019-11-22', 0, NULL, NULL, NULL, 0.00, 00.00, 00.00, NULL, 1800.00, NULL, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bills_x_products`
--

DROP TABLE IF EXISTS `bills_x_products`;
CREATE TABLE IF NOT EXISTS `bills_x_products` (
  `idBills_X_Products` int(11) NOT NULL AUTO_INCREMENT,
  `Bills_id` int(11) NOT NULL,
  `Products_id` int(11) NOT NULL,
  `Quantity` int(11) DEFAULT NULL,
  `Price` float(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`idBills_X_Products`) USING BTREE,
  KEY `fk_Bill_X_Products_Products1_idx` (`Products_id`) USING BTREE,
  KEY `fk_Bill_X_Products_Bills1_idx` (`Bills_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `bills_x_products`
--

INSERT INTO `bills_x_products` (`idBills_X_Products`, `Bills_id`, `Products_id`, `Quantity`, `Price`) VALUES
(7, 2, 1, 5, 0.00),
(70, 60, 23, 1, 0.00),
(71, 63, 2, 6, 200.00),
(72, 68, 1, 2, 300.00),
(73, 68, 2, 2, 200.00),
(74, 69, 1, 5, 300.00),
(75, 69, 2, 8, 200.00),
(76, 69, 3, 4, 300.00),
(77, 70, 2, 2, 60.00),
(78, 71, 2, 4, 60.00),
(79, 72, 2, 2, 300.00),
(80, 72, 3, 3, 300.00),
(81, 72, 27, 5, 200.00),
(82, 73, 2, 10, 300.00),
(83, 74, 2, 1, 300.00),
(84, 74, 1, 5, 300.00);

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
  `Business_id` int(11) NOT NULL,
  `Province_id` int(11) NOT NULL,
  PRIMARY KEY (`idBranch`) USING BTREE,
  KEY `fk_Branch_Business1_idx` (`Business_id`),
  KEY `fk_Branch_Province1_idx` (`Province_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='	';

--
-- Volcado de datos para la tabla `branches`
--

INSERT INTO `branches` (`idBranch`, `Address`, `District`, `Branch_Name`, `Telephone`, `Postal_Code`, `Business_id`, `Province_id`) VALUES
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
(1, 1234, 'AGCS', 3000, '2019-05-01', 'xdd', 'xdd', 'Mayorista', 1121121),
(2, 4657456, 'Don pepe y sus globos', 8000, '1666-05-01', 'daze', 'xdd', 'Minorista', 1511114444),
(3, 15648646, 'Halex', 98000, '0000-00-00', 'dawa', 'daze', 'Mayorista', 1531357918);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clients`
--

DROP TABLE IF EXISTS `clients`;
CREATE TABLE IF NOT EXISTS `clients` (
  `idClient` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) DEFAULT NULL,
  `Surname` varchar(45) DEFAULT NULL,
  `DNI_CUIT` bigint(17) DEFAULT NULL,
  `Mail` varchar(45) DEFAULT NULL,
  `Telephone` varchar(20) DEFAULT NULL,
  `Cellphone` varchar(20) DEFAULT NULL,
  `Business_id` int(11) NOT NULL,
  `Active` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`idClient`) USING BTREE,
  KEY `fk_Clients_Business1_idx` (`Business_id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `clients`
--

INSERT INTO `clients` (`idClient`, `Name`, `Surname`, `DNI_CUIT`, `Mail`, `Telephone`, `Cellphone`, `Business_id`, `Active`) VALUES
(0, 'Consumidor Final', 'Consumidor Final', 1, ' ', '0', '1', 0, b'1'),
(8, 'Yare Yare', 'Dawa', 1211, 'bot01@mail.com', '113212113', '11231213', 1, b'0'),
(22, 'MargossianEmpresa2', '11', 3, 'a', NULL, '111', 2, b'1'),
(23, 'test', 'prueba', 123456, NULL, NULL, '43214321', 1, b'0'),
(25, 'nombre', 'apellido', 987654321, NULL, NULL, '40005000', 1, b'0'),
(32, 'Margossian', 'Nicolas', 5555555, NULL, '1144322258', '1165898555', 1, b'0'),
(39, 'aaa', 'aaa', 43444, NULL, '1125458', '1154898', 1, b'0'),
(40, 'asdf8', 'asdf9', 3246, 'hola9', '2436', '2344', 1, b'0'),
(45, 'hoola', 'q hace', 555555, NULL, '0', '123213213', 1, b'0'),
(46, 'Nicolas', 'Margossian', 43994080, NULL, '0', '111561730659', 1, b'0'),
(47, 'Nicolas', 'Margossian', 439940804, 'nico@gmail.com', '5613', '1561730659', 1, b'1'),
(52, 'dawa', 'yareyare', 1234, 'mnail@q', '123', '5', 1, b'0'),
(53, 'R', 'lucas', 7, NULL, NULL, NULL, 1, b'0'),
(54, 'xdd', 'aaa', 9, '', NULL, NULL, 1, b'0'),
(55, 'Empresa2', 'Cliente', 2345544, NULL, NULL, NULL, 2, b'1'),
(56, 'Gabriel', 'Guivi', 32592593, NULL, NULL, '', 2, b'1'),
(58, 'wz', 'wz', 17181915, '5', '5', '5', 1, b'0'),
(59, 'Jonathan', 'Liu', 43403847, 'Jony@gmail.com', '0', '1546374589', 1, b'1'),
(60, 'Federico', 'Snieg', 29475860, 'fede@gmail.com', '0', '1547305867', 1, b'1'),
(61, 'test', 'test', 1234567, NULL, '0', '0', 1, b'1'),
(62, 'b', 'a', 135794521, 'a', '1', '1', 1, b'0');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `delivery`
--

DROP TABLE IF EXISTS `delivery`;
CREATE TABLE IF NOT EXISTS `delivery` (
  `idDelivery` int(11) NOT NULL AUTO_INCREMENT,
  `Transportation_Company` varchar(45) DEFAULT NULL,
  `Telephone` int(11) DEFAULT NULL,
  `Business_id` int(11) NOT NULL,
  PRIMARY KEY (`idDelivery`) USING BTREE,
  KEY `fk_Delivery_Business1_idx` (`Business_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `macs`
--

DROP TABLE IF EXISTS `macs`;
CREATE TABLE IF NOT EXISTS `macs` (
  `idMac` int(11) NOT NULL AUTO_INCREMENT,
  `Mac_Address` varchar(45) DEFAULT NULL,
  `Business_id` int(11) NOT NULL,
  PRIMARY KEY (`idMac`) USING BTREE,
  KEY `fk_Macs_Business1_idx` (`Business_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `macs`
--

INSERT INTO `macs` (`idMac`, `Mac_Address`, `Business_id`) VALUES
(1, '192.168.8.16', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `payment_methods`
--

DROP TABLE IF EXISTS `payment_methods`;
CREATE TABLE IF NOT EXISTS `payment_methods` (
  `idPayment_Method` int(11) NOT NULL AUTO_INCREMENT,
  `Method` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idPayment_Method`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `payment_methods`
--

INSERT INTO `payment_methods` (`idPayment_Method`, `Method`) VALUES
(1, 'BitCoins');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `products`
--

DROP TABLE IF EXISTS `products`;
CREATE TABLE IF NOT EXISTS `products` (
  `idProduct` int(11) NOT NULL AUTO_INCREMENT,
  `Article_number` int(11) DEFAULT NULL,
  `Name` varchar(200) COLLATE latin1_bin NOT NULL,
  `Description` varchar(200) CHARACTER SET latin1 DEFAULT NULL,
  `Cost` float(10,2) UNSIGNED ZEROFILL DEFAULT '0000000.00',
  `Price` float(10,2) UNSIGNED ZEROFILL DEFAULT '0000000.00',
  `PriceW` float(10,2) UNSIGNED ZEROFILL DEFAULT '0000000.00',
  `Image` varchar(2000) COLLATE latin1_bin NOT NULL DEFAULT '',
  `Age` bit(1) DEFAULT NULL,
  `Stock` int(11) DEFAULT '0',
  `CodeProduct` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `Business_id` int(11) NOT NULL,
  `Active` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`idProduct`) USING BTREE,
  KEY `fk_Products_Business1_idx` (`Business_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

--
-- Volcado de datos para la tabla `products`
--

INSERT INTO `products` (`idProduct`, `Article_number`, `Name`, `Description`, `Cost`, `Price`, `PriceW`, `Image`, `Age`, `Stock`, `CodeProduct`, `Business_id`, `Active`) VALUES
(1, 666, '	Manga Yakusoku no Neverland Vol 1', 'Manga Yakusoku no Neverland Vol 1', 0000500.00, 0000300.00, 0000200.00, 'https://inmanga.com/thumbnails/manga/The-Promised-Neverland/df035c49-d49f-4f15-bd2d-4ae9ea94d72d', b'1', 2290, '777', 1, b'1'),
(2, 2, 'Manga Yakusoku no Neverland Vol 2', 'Manga Yakusoku no Neverland Vol 2', 0000010.00, 0000300.00, 0000200.00, 'http://www.normaeditorial.com/libros_img/978846793089401_G.jpg', b'1', 92, '2', 1, b'1'),
(3, 3, 'Manga Yakusoku no Neverland Vol 4', 'Manga Yakusoku no Neverland Vol 4', 0000800.00, 0000300.00, 0000200.00, 'http://www.normaeditorial.com/libros_img/978846793289801_G.jpg', b'1', -936, '3', 1, b'1'),
(4, 5, 'Yogurisimo Con Cereales', 'Yogurisimo Con Cereales', 0000019.00, 0000050.00, 0000034.00, 'https://www.google.com/url?sa=i&source=images&cd=&ved=2ahUKEwj0g-ub0djlAhVXI7kGHRZtCZsQjRx6BAgBEAQ&url=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DTzzXd2b2xaM&psig=AOvVaw1Ho3pxUY9tQ7FfifW8uuT6&ust=1573234455794867', b'1', -1, '7791337613027', 1, b'0'),
(7, 32, 'amazing hat', 'amazing hat', 0050056.00, 0000600.00, 0054958.00, 'https://i0.pngocean.com/files/12/157/298/minecraft-breastplate-motorcycle-helmets-armour-pickaxe.jpg', NULL, -1, '434', 1, b'0'),
(8, 85, 'awful hat', 'awful hat', 0000005.00, 0000331.00, 0000328.00, 'https://66.media.tumblr.com/2f4da14349d6ff0a065e6e7035df2fb1/tumblr_o130144hGr1tm6273o8_400.png', NULL, -32, '32222', 1, b'0'),
(9, 75, 'a beautiful hat', 'a beautiful hat', 0000035.59, 0000080.51, 0000040.03, '', NULL, 0, '707', 1, b'0'),
(17, 106, 'loljajasalu2', 'loljajasalu2', 0000081.00, 0000071.00, 0000082.00, '', NULL, 89, '891', 1, b'0'),
(18, 218, 'Tabla Periódica', 'Tabla Periódica', 0000010.00, 0000040.00, 0000030.00, '', NULL, 50, '7798107220218', 2, b'1'),
(19, 1, 'item borrar', 'item borrar', 0000100.00, 0000500.00, 0000300.00, '', NULL, 75, '12', 2, b'1'),
(20, 3, 'Castaña De Caju', 'Castaña De Caju', 0000050.00, 0000150.00, 0000100.00, '', NULL, 101, '2670550000003', 2, b'1'),
(21, 524, 'Liquid Paper', 'Liquid Paper', 0000020.00, 0000100.00, 0000080.00, '', NULL, 200, '8854556000524', 2, b'1'),
(22, 524, 'liquid', 'liquid', 0000030.00, 0000030.00, 0000030.00, '', NULL, 100, '8854556000524', 1, b'0'),
(23, 358, 'Elite', 'Elite', 0000123.00, 0000160.00, 0000145.00, '', NULL, 100, '7790250000358', 2, b'1'),
(24, 2345, '2345', '2345', 0002345.00, 0002345.00, 0002345.00, '', NULL, 0, '34523452', 1, b'0'),
(25, 84, 'Nerf maverick', 'Nerf maverick', 0000500.00, 0000700.00, 0000650.00, 'https://http2.mlstatic.com/pistolas-nerf-maverick-rev-6-sol-y-lanza-hidrogel-blaster-D_NQ_NP_838401-MLM27678430146_072018-F.jpg', NULL, 0, '69420', 1, b'0'),
(26, 4, '	Manga Yakusoku no Neverland Vol 3', 'Manga Yakusoku no Neverland Vol 3', 0000100.00, 0000300.00, 0000200.00, 'https://www.normaeditorial.com/libros_img/978846793090001_G.jpg', NULL, 0, '4', 1, b'1'),
(27, 6, 'Manga Yakusoku no Neverland Vol 5', 'Manga Yakusoku no Neverland Vol 5', 0000100.00, 0000200.00, 0000300.00, 'https://www.normaeditorial.com/libros_img/978846793402101_G.jpg', NULL, -5, '5', 1, b'1'),
(28, 7, 'Manga Yakusoku no Neverland Vol 6', 'Manga Yakusoku no Neverland Vol 6', 0000100.00, 0000200.00, 0000300.00, 'https://www.normaeditorial.com/libros_img/978846793455701_G.jpg', NULL, 0, '77', 1, b'1'),
(29, 99, 'test', 'test', 0000100.00, 0000300.00, 0000200.00, '', NULL, 0, '99', 1, b'0'),
(30, 89079087, '8907', '8907', 0007987.00, 0009087.00, 0000907.00, '', NULL, 0, '098709', 1, b'0'),
(31, 8980, 'PRUEBA 2', 'PRUEBA 2', 0000100.00, 0000200.00, 0000150.00, '', NULL, 0, '85743', 1, b'0');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `products_x_suppliers`
--

DROP TABLE IF EXISTS `products_x_suppliers`;
CREATE TABLE IF NOT EXISTS `products_x_suppliers` (
  `idProductsXSuppliers` int(11) NOT NULL AUTO_INCREMENT,
  `Products_id` int(11) NOT NULL,
  `Suppliers_id` int(11) NOT NULL,
  PRIMARY KEY (`idProductsXSuppliers`),
  KEY `fk_ProductsXSuppliers_Products_idx` (`Products_id`),
  KEY `fk_ProductsXSuppliers_Suppliers_idx` (`Suppliers_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `provinces`
--

DROP TABLE IF EXISTS `provinces`;
CREATE TABLE IF NOT EXISTS `provinces` (
  `idProvince` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`idProvince`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `provinces`
--

INSERT INTO `provinces` (`idProvince`, `Name`) VALUES
(1, 'CABA'),
(2, 'Buenos Aires');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `purchases`
--

DROP TABLE IF EXISTS `purchases`;
CREATE TABLE IF NOT EXISTS `purchases` (
  `idPurchase` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Suppliers_id` int(11) NOT NULL,
  `Users_id` int(11) DEFAULT NULL,
  `date` date NOT NULL,
  `total` float(10,2) UNSIGNED NOT NULL,
  `cond` varchar(100) NOT NULL,
  `Business_id` int(11) NOT NULL,
  PRIMARY KEY (`idPurchase`),
  KEY `fk_Purchases_Suppliers_idx` (`Suppliers_id`) USING BTREE,
  KEY `fk_Purchases_Users_id_idx` (`Users_id`) USING BTREE,
  KEY `fk_Purchases_Business_idx` (`Business_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `purchases`
--

INSERT INTO `purchases` (`idPurchase`, `Suppliers_id`, `Users_id`, `date`, `total`, `cond`, `Business_id`) VALUES
(2, 3, 27, '2019-10-25', 390.00, '', 1),
(3, 3, 27, '2019-10-25', 3520.00, '', 1),
(4, 3, 27, '2019-10-25', 15925.00, '', 1),
(5, 3, 27, '2019-10-25', 420.00, '', 1),
(6, 3, 27, '2019-10-25', 240.00, '', 1),
(7, 3, 27, '2019-10-25', 240.00, '', 1),
(8, 3, 27, '2019-10-25', 240.00, '', 1),
(9, 3, 27, '2019-10-25', 120.00, '', 1),
(10, 3, 27, '2019-10-25', 120.00, '', 1),
(11, 3, 27, '2019-10-25', 120.00, '', 1),
(12, 3, 27, '2019-10-25', 120.00, '', 1),
(13, 3, 27, '2019-11-07', 30000.00, '', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `purchases_x_products`
--

DROP TABLE IF EXISTS `purchases_x_products`;
CREATE TABLE IF NOT EXISTS `purchases_x_products` (
  `idPurchases_x_Products` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Purchases_id` int(11) UNSIGNED NOT NULL,
  `Products_id` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `Cost` float(10,2) DEFAULT '0.00',
  PRIMARY KEY (`idPurchases_x_Products`),
  KEY `fk_PurchasesXProducts_Purchases_idx` (`Purchases_id`),
  KEY `fk_PurchasesXProducts_Products_idx` (`Products_id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `purchases_x_products`
--

INSERT INTO `purchases_x_products` (`idPurchases_x_Products`, `Purchases_id`, `Products_id`, `Quantity`, `Cost`) VALUES
(40, 2, 2, 6, 50.00),
(41, 3, 2, 8, 50.00),
(42, 3, 1, 7, 500.00),
(43, 3, 3, 3, 800.00),
(44, 4, 2, 5, 50.00),
(45, 4, 3, 50, 800.00),
(46, 4, 1, 2, 500.00),
(47, 5, 2, 7, 10.00),
(48, 6, 2, 4, 10.00),
(49, 7, 2, 4, 10.00),
(50, 8, 2, 4, 10.00),
(51, 9, 2, 2, 10.00),
(52, 10, 2, 2, 10.00),
(53, 11, 2, 2, 10.00),
(54, 12, 2, 2, 10.00),
(55, 13, 2, 100, 10.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `stock_movement`
--

DROP TABLE IF EXISTS `stock_movement`;
CREATE TABLE IF NOT EXISTS `stock_movement` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` tinyint(2) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `Products_id` int(11) DEFAULT NULL,
  `dateTime` datetime DEFAULT NULL,
  `quant` mediumint(8) DEFAULT NULL,
  `Amount` float(10,2) NOT NULL DEFAULT '0.00',
  `Users_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_StockMovement_Products_idx` (`Products_id`) USING BTREE,
  KEY `fk_StockMovement_Users_idx` (`Users_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `stock_movement`
--

INSERT INTO `stock_movement` (`id`, `type`, `description`, `Products_id`, `dateTime`, `quant`, `Amount`, `Users_id`) VALUES
(2, 2, 'asffasasdfasdf', 1, '2019-10-21 04:25:53', 5, 0.00, 27),
(3, 2, 'asffasasdfasdf', 1, '2019-10-21 05:46:54', 5, 0.00, 27),
(4, 2, 'xdd', 1, '2019-10-21 02:49:01', 5, 0.00, 27),
(5, 2, 'xdd', 1, '2019-10-21 02:50:06', 5, 0.00, 27),
(6, 2, 'xdd', 1, '2019-10-21 02:51:10', 10, 0.00, 27),
(7, 2, NULL, 1, '2019-10-21 03:12:14', 15, 0.00, 27),
(8, 2, NULL, 1, '2019-10-21 03:13:50', 2, 0.00, 27),
(9, 2, NULL, 1, '2019-10-21 03:21:39', 5, 0.00, 27),
(10, 2, 'jojo', 1, '2019-10-21 03:26:12', 70, 0.00, 27),
(11, 2, 'dfgh', 1, '2019-10-22 15:26:02', 50, 0.00, 27),
(12, 2, 'sdf', 1, '2019-10-22 15:30:56', 3, 0.00, 27),
(13, 0, 'Venta de producto', 2, '2019-10-22 16:44:46', 6, 0.00, 27),
(14, 0, 'Venta de producto', 1, '2019-10-22 16:54:07', 2, 0.00, 27),
(15, 0, 'Venta de producto', 2, '2019-10-22 16:54:07', 2, 0.00, 27),
(16, 1, 'Compra de producto', 1, '2019-10-24 21:11:52', 300, 300.00, 27),
(17, 1, 'Compra de producto', 1, '2019-10-24 21:21:43', 300, 300.00, 27),
(18, 1, 'Compra de producto', 1, '2019-10-24 21:31:55', 2, 300.00, 27),
(19, 1, 'Compra de producto', 3, '2019-10-24 18:36:49', 21, 300.00, 27),
(20, 1, 'Compra de producto', 1, '2019-10-24 18:36:56', 3, 300.00, 27),
(21, 1, 'Compra de producto', 1, '2019-10-24 18:37:43', 2, 300.00, 27),
(22, 1, 'Compra de producto', 2, '2019-10-24 18:37:45', 4, 200.00, 27),
(23, 1, 'Compra de producto', 3, '2019-10-24 18:37:45', 6, 300.00, 27),
(24, 1, 'Compra de producto', 1, '2019-10-24 18:52:09', 2, 2005.00, 27),
(25, 1, 'Compra de producto', 2, '2019-10-24 18:52:09', 2, 320.00, 27),
(26, 1, 'Compra de producto', 3, '2019-10-24 18:52:09', 3, 320.00, 27),
(27, 1, 'Compra de producto', 2, '2019-10-24 19:23:50', 2, 320.00, 27),
(28, 1, 'Compra de producto', 2, '2019-10-24 19:25:43', 2, 400.00, 27),
(29, 1, 'Compra de producto', 2, '2019-10-24 19:28:14', 2, 400.00, 27),
(30, 1, 'Compra de producto', 2, '2019-10-24 19:40:13', 8, 2200.00, 27),
(31, 1, 'Compra de producto', 3, '2019-10-24 19:40:14', 2, 800.00, 27),
(32, 1, 'Compra de producto', 2, '2019-10-24 19:40:56', 8, 2200.00, 27),
(33, 1, 'Compra de producto', 3, '2019-10-24 19:40:56', 2, 800.00, 27),
(34, 1, 'Compra de producto', 2, '2019-10-24 19:41:28', 3, 1000.00, 27),
(35, 1, 'Compra de producto', 1, '2019-10-24 19:41:59', 2, 500.00, 27),
(36, 1, 'Compra de producto', 2, '2019-10-24 19:42:39', 4, 1000.00, 27),
(37, 1, 'Compra de producto', 2, '2019-10-24 19:44:18', 4, 200.00, 27),
(38, 1, 'Compra de producto', 2, '2019-10-25 08:08:08', 6, 50.00, 27),
(39, 1, 'Compra de producto', 2, '2019-10-25 08:09:20', 8, 50.00, 27),
(40, 1, 'Compra de producto', 1, '2019-10-25 08:09:20', 7, 500.00, 27),
(41, 1, 'Compra de producto', 3, '2019-10-25 08:09:20', 3, 800.00, 27),
(42, 1, 'Compra de producto', 2, '2019-10-25 09:59:51', 5, 50.00, 27),
(43, 1, 'Compra de producto', 3, '2019-10-25 09:59:51', 50, 800.00, 27),
(44, 1, 'Compra de producto', 1, '2019-10-25 09:59:51', 2, 500.00, 27),
(45, 2, 'SUPER XD', 1, '2019-10-25 10:13:12', 100, 0.00, 27),
(46, 1, 'Compra de producto', 2, '2019-10-25 10:15:03', 7, 10.00, 27),
(47, 0, 'Venta de producto', 2, '2019-10-25 10:16:48', 4, 60.00, 27),
(48, 1, 'Compra de producto', 2, '2019-10-25 10:47:38', 4, 10.00, 27),
(49, 1, 'Compra de producto', 2, '2019-10-25 10:47:52', 4, 10.00, 27),
(50, 1, 'Compra de producto', 2, '2019-10-25 10:48:04', 4, 10.00, 27),
(51, 1, 'Compra de producto', 2, '2019-10-25 10:52:22', 2, 10.00, 27),
(52, 1, 'Compra de producto', 2, '2019-10-25 10:53:49', 2, 10.00, 27),
(53, 1, 'Compra de producto', 2, '2019-10-25 10:55:09', 2, 10.00, 27),
(54, 1, 'Compra de producto', 2, '2019-10-25 10:55:32', 2, 10.00, 27),
(55, 2, 'robo', 1, '2019-10-25 11:48:40', 5, 0.00, 27),
(56, 0, 'Venta de producto', 2, '2019-11-22 10:05:51', 1, 300.00, 27),
(57, 0, 'Venta de producto', 1, '2019-11-22 10:05:51', 5, 300.00, 27);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
CREATE TABLE IF NOT EXISTS `suppliers` (
  `idSupplier` int(11) NOT NULL AUTO_INCREMENT,
  `Cuit` int(11) NOT NULL,
  `Name` varchar(50) DEFAULT NULL,
  `Surname` varchar(50) DEFAULT NULL,
  `Company` varchar(50) DEFAULT NULL,
  `Fanciful_name` varchar(100) NOT NULL,
  `Telephone` varchar(20) DEFAULT NULL,
  `Cellphone` varchar(20) NOT NULL,
  `Business_id` int(11) NOT NULL,
  `Address` varchar(200) DEFAULT NULL,
  `Mail` varchar(60) DEFAULT NULL,
  `Active` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`idSupplier`) USING BTREE,
  KEY `fk_Supplier_Business1_idx` (`Business_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `suppliers`
--

INSERT INTO `suppliers` (`idSupplier`, `Cuit`, `Name`, `Surname`, `Company`, `Fanciful_name`, `Telephone`, `Cellphone`, `Business_id`, `Address`, `Mail`, `Active`) VALUES
(0, 1, 'Sin Proveedor', 'Sin Proveedor', NULL, '', NULL, '0', 0, NULL, NULL, b'1'),
(1, 54127534, 'Presentacion de Todos', 'La Mejor', 'Tenemos un 10', 'Tenemos un 10', '2345234', '8004448375', 1, 'Av Juancho Aparte 393', 'Presentacion@Xd.com', b'1'),
(2, 44887784, 'Aquiles', 'Doy', 'yo tampoco jaja salu2', 'yo tampoco jaja salu2', '45678912', '1513317546', 1, 'viste china, bueno doblando a la izquierda', NULL, b'0'),
(3, 18484910, 'Marmol', 'Jose', 'EEEE', 'Ivera', '1', '1', 1, 'Avenida San juan bautista de lasalle 720', 'a', b'1'),
(4, 105968465, 'void', 'main', 'EEEEEEEE', 'EEEEEEEE', '1', '1', 1, 'a', 'a', b'0'),
(5, 45646548, 'Unpro', 'vedor', 'F', 'F', '15115', '14115', 2, 'Acala vuelta 0', 'correo@correo', b'1'),
(7, 79881684, 'd', 'd', 'g', 'g', '1', '1', 1, 'q', 'r', b'0'),
(11, 44444444, 'h', 'h', 'hsan', 'nk', '44445444', '44446444', 1, 'hhhhhh', 'h@h', b'0'),
(12, 43572144, 'Liu', 'Jonathan', 'HOla', 'ola k aze', '1531174589', '8104774857', 1, 'aca xdddd', 'Jonathan@gmail.com', b'1'),
(13, 198713214, 'wwww', 'w', 'zzzz', 'zzzzz', '1', '1', 1, 'a', 'a', b'0'),
(14, 43994080, 'nicolas', 'Margossian', NULL, 'Margo-tech', '44322210', '1561730659', 1, NULL, NULL, b'1'),
(15, 80000009, 'Don pepe', 'Y sus globos', 'Distribución de globos  y bombas, de Jose Globo', 'DIstribuidora de globos Don Jose', '155468794', '141234567', 1, 'Av Estado de palestina 911', 'donpepe@yahoo.com.ar', b'1'),
(16, 138794685, 'Brother', 'Jajas', 'Hasbro', 'Hasbro', '18916548', '153481', 3, 'Avenida Juanita perez 123', 'mail@hasbro', b'1'),
(17, 8009080, 'vv', 'aaa', '1aa', 'oof', '1', '1', 1, 'a', 'a', b'0');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `idUser` int(11) NOT NULL AUTO_INCREMENT,
  `Mail` varchar(45) DEFAULT NULL,
  `Password` varchar(45) DEFAULT NULL,
  `Admin` bit(1) DEFAULT NULL,
  `Name` varchar(45) DEFAULT NULL,
  `Surname` varchar(45) DEFAULT NULL,
  `Name_Second` varchar(45) DEFAULT NULL,
  `Business_id` int(11) NOT NULL,
  `Dni` varchar(45) DEFAULT NULL,
  `Active` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`idUser`) USING BTREE,
  KEY `fk_Users_Business1_idx` (`Business_id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`idUser`, `Mail`, `Password`, `Admin`, `Name`, `Surname`, `Name_Second`, `Business_id`, `Dni`, `Active`) VALUES
(27, 'admin@admin', '21232f297a57a5a743894a0e4a801fc3', b'1', 'admin', 'admin', 'admin', 1, '13', b'1'),
(28, 'nicolasmargossian@gmail.com', '7510d498f23f5815d3376ea7bad64e29', b'0', 'Nicolas', 'Margossian', 'Alejandro Anushavan', 1, '43994080', b'1'),
(32, 'bo@boa', '21232f297a57a5a743894a0e4a801fc3', b'0', 'ParaBorrar a', 'Borrar a', 'borrar a', 1, '300', b'0'),
(34, 'n@n', '21232f297a57a5a743894a0e4a801fc3', b'1', 'nico', 'margo', 'Alejandro Anushavan', 2, '43994080', b'1'),
(35, 'mati@mati', '4d186321c1a7f0f354b297e8914ab240', b'0', 'Matias', 'Santoro', 'Javier', 2, '43994857', b'1'),
(37, 'm@m', '21232f297a57a5a743894a0e4a801fc3', b'0', 'nombre modificar ', 'apellido modificar ', NULL, 2, '11111', b'1'),
(38, 'test', '7510d498f23f5815d3376ea7bad64e29', b'0', 'test', 'test', 'test', 1, '22', b'0');

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
  `Users_id` int(11) NOT NULL,
  `Cellphone` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`idUser_ExtraInfo`) USING BTREE,
  KEY `fk_User_ExtraInfo_Users_idx` (`Users_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `user_extrainfo`
--

INSERT INTO `user_extrainfo` (`idUser_ExtraInfo`, `Address`, `Tel_Father`, `Tel_Mother`, `Tel_Brother`, `Tel_User`, `Healthcare_Company`, `Sallary`, `Users_id`, `Cellphone`) VALUES
(1, 'Admin', '4444444', '333333', '5555555', '011', NULL, NULL, 27, '12'),
(2, 'Av Rivadavia 6015 13C', '01144404555', '01149607853', '01164538472', '44322210', NULL, NULL, 28, '11617306599'),
(6, 'para borrar usuario a', '889', '1000', '778', '110', NULL, NULL, 32, '200'),
(8, 'Formosa 430', '888', '999', '777', '12', NULL, NULL, 35, '13'),
(10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 37, NULL),
(11, '22', '22', '22', '22', '11', NULL, NULL, 38, '22');

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `address`
--
ALTER TABLE `address`
  ADD CONSTRAINT `fk_Address_Business1` FOREIGN KEY (`Business_id`) REFERENCES `business` (`idBusiness`),
  ADD CONSTRAINT `fk_Address_Client1` FOREIGN KEY (`Clients_id`) REFERENCES `clients` (`idClient`),
  ADD CONSTRAINT `fk_Address_Delivery1` FOREIGN KEY (`Delivery_id`) REFERENCES `delivery` (`idDelivery`),
  ADD CONSTRAINT `fk_Address_Provinces` FOREIGN KEY (`Province_id`) REFERENCES `provinces` (`idProvince`);

--
-- Filtros para la tabla `bills`
--
ALTER TABLE `bills`
  ADD CONSTRAINT `bills_ibfk_1` FOREIGN KEY (`Clients_id`) REFERENCES `clients` (`idClient`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `bills_x_products`
--
ALTER TABLE `bills_x_products`
  ADD CONSTRAINT `fk_Bills_X_Products_Bills1` FOREIGN KEY (`Bills_id`) REFERENCES `bills` (`idBill`),
  ADD CONSTRAINT `fk_Bills_X_Products_Products1` FOREIGN KEY (`Products_id`) REFERENCES `products` (`idProduct`);

--
-- Filtros para la tabla `branches`
--
ALTER TABLE `branches`
  ADD CONSTRAINT `fk_Branch_Business1` FOREIGN KEY (`Business_id`) REFERENCES `business` (`idBusiness`),
  ADD CONSTRAINT `fk_Branch_Province1` FOREIGN KEY (`Province_id`) REFERENCES `provinces` (`idProvince`);

--
-- Filtros para la tabla `clients`
--
ALTER TABLE `clients`
  ADD CONSTRAINT `fk_Clients_Business1` FOREIGN KEY (`Business_id`) REFERENCES `business` (`idBusiness`);

--
-- Filtros para la tabla `delivery`
--
ALTER TABLE `delivery`
  ADD CONSTRAINT `fk_Delivery_Business1` FOREIGN KEY (`Business_id`) REFERENCES `business` (`idBusiness`);

--
-- Filtros para la tabla `macs`
--
ALTER TABLE `macs`
  ADD CONSTRAINT `fk_Macs_Business1` FOREIGN KEY (`Business_id`) REFERENCES `business` (`idBusiness`);

--
-- Filtros para la tabla `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_Products_Business1` FOREIGN KEY (`Business_id`) REFERENCES `business` (`idBusiness`);

--
-- Filtros para la tabla `products_x_suppliers`
--
ALTER TABLE `products_x_suppliers`
  ADD CONSTRAINT `fk_ProductsXSuppliers_Products` FOREIGN KEY (`Products_id`) REFERENCES `products` (`idProduct`),
  ADD CONSTRAINT `fk_ProductsXSuppliers_Suppliers` FOREIGN KEY (`Suppliers_id`) REFERENCES `suppliers` (`idSupplier`);

--
-- Filtros para la tabla `purchases`
--
ALTER TABLE `purchases`
  ADD CONSTRAINT `fk_Purchases_Business` FOREIGN KEY (`Business_id`) REFERENCES `business` (`idBusiness`),
  ADD CONSTRAINT `fk_Purchases_Suppliers` FOREIGN KEY (`Suppliers_id`) REFERENCES `suppliers` (`idSupplier`),
  ADD CONSTRAINT `fk_Purchases_Users` FOREIGN KEY (`Users_id`) REFERENCES `users` (`idUser`);

--
-- Filtros para la tabla `purchases_x_products`
--
ALTER TABLE `purchases_x_products`
  ADD CONSTRAINT `fk_PurchasesXProducts_Products` FOREIGN KEY (`Products_id`) REFERENCES `products` (`idProduct`),
  ADD CONSTRAINT `fk_PurchasesXProducts_Purchases` FOREIGN KEY (`Purchases_id`) REFERENCES `purchases` (`idPurchase`);

--
-- Filtros para la tabla `stock_movement`
--
ALTER TABLE `stock_movement`
  ADD CONSTRAINT `fk_Stock_movement_Products` FOREIGN KEY (`Products_id`) REFERENCES `products` (`idProduct`),
  ADD CONSTRAINT `fk_Stock_movement_Users` FOREIGN KEY (`Users_id`) REFERENCES `users` (`idUser`);

--
-- Filtros para la tabla `suppliers`
--
ALTER TABLE `suppliers`
  ADD CONSTRAINT `fk_Supplier_Business` FOREIGN KEY (`Business_id`) REFERENCES `business` (`idBusiness`);

--
-- Filtros para la tabla `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_Users_Business` FOREIGN KEY (`Business_id`) REFERENCES `business` (`idBusiness`);

--
-- Filtros para la tabla `user_extrainfo`
--
ALTER TABLE `user_extrainfo`
  ADD CONSTRAINT `fk_User_ExtraInfo_Users` FOREIGN KEY (`Users_id`) REFERENCES `users` (`idUser`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
