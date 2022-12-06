<?php
require_once('db_connnection.php');
$name = $_POST['name'];
$description = $_POST['description'];
$price = $_POST['price'];


$conn = OpenCon();
$query = "INSERT INTO `products` (name, description, price) VALUES ('" . $name . "', '" . $description . "', " . $price . ")";

if ($conn->query($query) === TRUE) {
    echo "New record created successfully";
    header('Location: index.php');
} else {
    echo "Error: " . $query . "<br>" . $conn->error;
}
