CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_BringOneClient`(id int)
BEGIN
select * from clients where idClients = id;
END