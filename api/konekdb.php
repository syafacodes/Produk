<?php
header('Access-Control-Allow-Origin: *');

$host = "localhost";
$user = "root";
$pass = "";
$database = "db_produk";

$konekdb = new PDO("mysql:host=$host;dbname=$database", $user, $pass);
$konekdb->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
$konekdb->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

?>