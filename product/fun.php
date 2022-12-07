<?php
require_once('db_connnection.php');
$gia = $_POST['gia'];

$conn = OpenCon();
$query = "CALL count_mon_an($gia);";

if ($conn->query($query)) {
    echo "New record created successfully";
    header('Location: fun/index.php?gia=' . $gia);
} else {
    echo "Error: " . $query . "<br>" . $conn->error;
    header('Location: index.php?err=' . $conn->error);
}
