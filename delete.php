<?php
require_once('db_connnection.php');
$name = $_POST['name'];

$conn = OpenCon();
$query = "DELETE FROM `products` WHERE name = '" . $name . "';";

if ($conn->query($query) === TRUE) {
    echo "Successfully";
    header('Location: index.php');
} else {
    echo "Error: " . $query . "<br>" . $conn->error;
}
