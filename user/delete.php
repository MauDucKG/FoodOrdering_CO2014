<?php
require_once('db_connnection.php');
$tenDangNhap = $_POST['tenDangNhap'];

$conn = OpenCon();
$query = "CALL Delete_khach_hang('$tenDangNhap')";

if ($conn->query($query) === TRUE) {
    echo "Successfully";
    header('Location: index.php');
} else {
    echo "Error: " . $query . "<br>" . $conn->error;
    header('Location: index.php?err=' . $conn->error);
}
