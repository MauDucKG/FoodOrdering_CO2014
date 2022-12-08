<!doctype html>
<html lang='en'>

<head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>Trang chi tiết món ăn</title>
    <link href='cover.css' rel='stylesheet'>
    <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css' rel='stylesheet' integrity='sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65' crossorigin='anonymous'>
</head>

<body class=''>
    <main class='main-content w-100 m-auto'>
        <?php
        if (isset($_GET['maMonAn'])) {
            require_once('db_connnection.php');

            $conn = OpenCon();
            $maMonAn = $_GET['maMonAn'];
            $query = "SELECT * FROM `mon_an` WHERE maMonAn = '$maMonAn';";

            $result = $conn->query($query);

            if ($result->num_rows > 0) {
                // OUTPUT DATA OF EACH ROW
                while ($row = $result->fetch_assoc()) {
                    $maMonAn = $row['maMonAn'];
                    $query = "SELECT * FROM `mon_an_thuoc_nhom` WHERE maMonAn = '$maMonAn';";

                    $result1 = $conn->query($query);
                    $result2 = $result1->fetch_assoc()['maNhomMonAn'];

                    $query1 = "SELECT * FROM `nhom_mon_an` WHERE maNhomMonAn = '$result2';";
                    $result3 = $conn->query($query1);
                    $result4 = $result3->fetch_assoc()['tenNhomMonAn'];
                    $result3 = $conn->query($query1);
                    $result5 = $result3->fetch_assoc()['moTaNhomMonAn'];

                    echo "<div>
                    <h3>$result4</h3>
                    <p>$result5</p>
                </div>";
                }
            }
        }
        ?>
        <?php
        if (isset($_GET['maMonAn'])) {
            require_once('db_connnection.php');

            $conn = OpenCon();
            $maMonAn = $_GET['maMonAn'];
            $query = "SELECT * FROM `mon_an` WHERE maMonAn = '$maMonAn';";

            $result = $conn->query($query);

            if ($result->num_rows > 0) {
                // OUTPUT DATA OF EACH ROW
                while ($row = $result->fetch_assoc()) {
                    $maMonAn = $row['maMonAn'];
                    $tenMonAn = $row['tenMonAn'];
                    $moTaMonan = $row['moTaMonan'];
                    $giaNiemYet = $row['giaNiemYet'];
                    $query = "SELECT * FROM `anh_mon_an` WHERE maMonAn = '$maMonAn';";

                    $result1 = $conn->query($query);
                    $result2 = $result1->fetch_assoc()['anhMonAn'];

                    echo "<div class='card'>
                <img src='$result2' class='card-img-top' alt=''>
                <div class='card-body'>
                    <h5 class='card-title'>$tenMonAn</h5>
                    <p class='card-text'>$moTaMonan</p>
                    <a href='../' class='btn btn-primary'>Trở về trang danh sách sản phẩm</a>
                </div>
            </div>";
                }
            }
        }
        ?>
    </main>
</body>

</html>