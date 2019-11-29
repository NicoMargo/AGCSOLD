<?php
class DB{
    public static function Conectar(){
        $pdo = new PDO("mysql:host=127.0.0.1;dbname=flecha10","root","");
        return $pdo;
    }
}
?>