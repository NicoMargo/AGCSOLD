<?php
include_once('../model/producto.php');
include_once('../db.php');
class ProductoDao{
    public static function ObtenerTodos(){
        $pdo = DB::Conectar();
        $resultado = $pdo->query("call spTraerJuguetes();");
        $productos = $resultado->fetchAll(PDO::FETCH_CLASS, 'Producto');        
        return $productos;
    }
    public static function Agregar($producto){
        $pdo = DB::Conectar();
        $resultado = $pdo->query("call spAgregarJuguete('$producto->nombre','$producto->descripcion',$producto->precio,$producto->stock,'$producto->foto');");
    }
    public static function Borrar($id){
        $pdo = DB::Conectar();
        echo $id;
        $resultado = $pdo->query("call spBorrarJuguete($id);"); //falta hacer sp
    }
    public static function Modificar($producto){
        $pdo = DB::Conectar();
        $resultado = $pdo->query("call spModificarJuguete($producto->id,'$producto->nombre','$producto->descripcion',$producto->precio,'$producto->foto',$producto->stock);");
    }

};