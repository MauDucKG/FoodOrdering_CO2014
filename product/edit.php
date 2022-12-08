<?php
require_once('db_connnection.php');
$tenMonAn = $_POST['tenMonAn'];
$maMonAn = $_POST['maMonAn'];
$moTaMonan = $_POST['moTaMonan'];
$giaNiemYet = $_POST['giaNiemYet'];

$conn = OpenCon();
$query = "CALL Update_mon_an('$tenMonAn', '$maMonAn', '$moTaMonan', '$giaNiemYet');";
if ($conn->query($query) === TRUE) {
    echo "Successfully";
    header('Location: index.php');
} else {
    echo "Error: " . $query . "<br>" . $conn->error;
    header('Location: index.php?err=' . $conn->error);
}
