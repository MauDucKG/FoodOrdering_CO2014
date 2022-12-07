<?php
require_once('db_connnection.php');
$tenDangNhap = $_POST['tenDangNhap'];
$tenKhachHang = $_POST['tenKhachHang'];
$diaChi = $_POST['diaChi'];
$sdt = $_POST['sdt'];
$diemTichLuy = $_POST['diemTichLuy'];
$anhDaiDien = $_POST['anhDaiDien'];
// Photo
$target_dir = "img/";
$path = $_FILES['fileToUpload1']['name'];
$ext = pathinfo($path, PATHINFO_EXTENSION);
echo $ext;
$id = (string)date("Y_m_d_h_i_sa");
$fileuploadname = (string)$id;
$fileuploadname .= ".";
$fileuploadname .= $ext;
$target_file = $target_dir . basename($fileuploadname);
if (file_exists($target_file)) {
    echo "Sorry, file already exists.";
}
$fileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));
// Allow certain file formats
if (
    $fileType != "jpg" && $fileType != "png" && $fileType != "jpeg"
    && $fileType != "gif"
) {
    echo "Sorry, only JPG, JPEG, PNG & GIF files are allowed.";
    $upload_ok = 0;
    $target_file = $anhDaiDien;
}
if ($_FILES["fileToUpload1"]["size"] > 500000) {
    echo "Sorry, your file is too large.";
}

move_uploaded_file($_FILES["fileToUpload1"]["tmp_name"], $target_file);

$conn = OpenCon();
$query = "CALL Update_khach_hang('$tenDangNhap', '$tenKhachHang', '$diaChi', '$sdt', '$target_file', '$diemTichLuy');";
if ($conn->query($query) === TRUE) {
    echo "Successfully";
    header('Location: index.php');
} else {
    echo "Error: " . $query . "<br>" . $conn->error;
    header('Location: index.php?err=' . $conn->error);
}
