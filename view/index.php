<!doctype html>
<html lang='en'>

<head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>Bootstrap demo</title>
    <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css' rel='stylesheet' integrity='sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65' crossorigin='anonymous'>
</head>

<body>
    <main>

        <section class='py-5 text-center container'>
            <div class='row py-lg-5'>
                <div class='col-lg-6 col-md-8 mx-auto'>
                    <h1 class='fw-light'>Trang bán hàng chính</h1>
                    <p class='lead text-muted'>Ở đây sẽ liệt kê các sản phẩm chính của trang web, bao gồm cả ảnh vào nhà hàng đang chế biến nó</p>
                    <p>
                        <a href='#' class='btn btn-primary my-2'>Đến giỏ hàng</a>
                        <a href='../' class='btn btn-secondary my-2'>Trở lại đăng nhập</a>
                    </p>
                </div>
            </div>
        </section>

        <div class='album py-5 bg-light'>
            <div class='container'>

                <div class='row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3'>
                    <?php
                    require_once('db_connnection.php');

                    $conn = OpenCon();
                    $query = "SELECT * FROM `mon_an`;";

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
                            
                            echo "<div class='col'>
                        <div class='card shadow-sm'>
                            <img src='$result2' alt=''>

                            <div class='card-body'>
                                <h4 class='card-title'>$tenMonAn</h4>
                                <p class='card-text'>$moTaMonan</p>
                                <div class='d-flex justify-content-between align-items-center'>
                                    <div class='btn-group'>
                                        <button type='button' class='btn btn-outline-secondary'><a href='view_detail/index.php?maMonAn=$maMonAn'>View</a></button>
                                    </div>
                                    <div class='text-muted text-bold align-middle'>Giá: $giaNiemYet Đ</div>
                                </div>
                            </div>
                        </div>
                    </div>";
                        }
                    }
                    ?>
                </div>
            </div>
        </div>

    </main>
    <script src='https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js' integrity='sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4' crossorigin='anonymous'></script>
</body>

</html>