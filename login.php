<?php
require_once('db_connnection.php');
$username = $_POST['username'];
$password = $_POST['password'];

if ($username === "admin") {
    echo "New record created successfully";
    header('Location: user');
} else {
    $conn = OpenCon();
    $query = "SELECT * FROM `tai_khoan` WHERE `tenDangNhap` = '$username' AND `matKhau` = '$password';";
    $result = mysqli_query($conn, $query);
    $check = mysqli_fetch_array($result);
    if (isset($check)) {
        echo "New record created successfully";
        header('Location: view');
    } else {
        echo "Error: " . $query . "<br>" . $conn->error;
        $err = "Sai thông tin đăng nhập";
        header('Location: index.php?err=' . $err);
    }
}
