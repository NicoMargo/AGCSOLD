CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_BringClients`()
BEGIN
select idClients, Name, Surname, Dni,Email,Cellphone from Clients;
END