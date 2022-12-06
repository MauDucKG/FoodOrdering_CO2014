<?php
require_once('db_connnection.php');
$name = $_POST['name'];
$description = $_POST['description'];
$price = $_POST['price'];


$conn = OpenCon();
$query = "UPDATE `products` SET description = '" . $description . "', price = '" . $price . "' WHERE name = '" . $name . "';";
if ($conn->query($query) === TRUE) {
    echo "Successfully";
    header('Location: index.php');
} else {
    echo "Error: " . $query . "<br>" . $conn->error;
}
