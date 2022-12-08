<?php
require_once('db_connnection.php');
$maMonAn = $_POST['maMonAn'];

$conn = OpenCon();
$query = "CALL Delete_mon_an('$maMonAn')";

if ($conn->query($query) === TRUE) {
    echo "Successfully";
    header('Location: index.php');
} else {
    echo "Error: " . $query . "<br>" . $conn->error;
    header('Location: index.php?err=' . $conn->error);
}
