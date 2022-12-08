<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Food Ordering</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.1/css/dataTables.bootstrap5.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
</head>

<body>
    <div class="container">
        <a href="../../product/" class="btn btn-warning float-end mx-2">Chuyển đến màn hình quản lí sản phẩm</a>
        <a href="../../user" class="btn btn-warning float-end">Chuyển đến màn hình quản lí khách hàng</a>
        <h1 class="my-3">Manage User</h1>
        <hr>
        <h4 class="text-primary my-4">Danh sách khách hàng có điểm tích lũy lớn hơn <?php echo $_GET['soDiem']?></h4>
        <table class="table table-striped mt-2" id="tab-user">
            <thead>
                <tr>
                    <th scope="col">Tên đăng nhập</th>
                    <th scope="col">Tên khách hàng</th>
                    <th scope="col">Địa chỉ</th>
                    <th scope="col">Số điện thoại</th>
                    <th scope="col">Ảnh đại diện</th>
                    <th scope="col">Điểm tích lũy</th>
                </tr>
            </thead>
            <tbody>
                <?php
                require_once('db_connnection.php');

                $soDiem = $_GET['soDiem'];
                $conn = OpenCon();
                $query = "CALL point_khach_hang($soDiem);";

                $result = $conn->query($query);

                if ($result->num_rows > 0) {
                    // OUTPUT DATA OF EACH ROW
                    while ($row = $result->fetch_assoc()) {
                ?>
                        <tr class="justify-content-center">
                            <th class='align-middle' scope="row"><?php echo $row['tenDangNhap'] ?></th>
                            <td class='align-middle'><?php echo $row['tenKhachHang'] ?></td>
                            <td class='align-middle'><?php echo $row['diaChi'] ?></td>
                            <td class='align-middle'><?php echo $row['sdt'] ?></td>
                            <td><img src='../<?php echo $row['anhDaiDien'] ?>' class='border rounded-circle p-1' width='72' height='72'></td>
                            <td class='align-middle'><?php echo $row['diemTichLuy'] ?></td>
                        </tr>
                <?php
                    }
                }
                ?>

            </tbody>
        </table>
        <div class="modal fade" id="Edit" tabindex="-1" role="dialog" aria-labelledby="Edit" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Chỉnh sửa</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="edit.php" method="post" enctype="multipart/form-data">
                        <div class="modal-body">
                            <div class="form-group">
                                <label>Tên đăng nhập</label>
                                <input class="form-control my-2" type="text" placeholder="Tên đăng nhập" name="tenDangNhap" disabled />
                            </div>
                            <div class="form-group">
                                <label>Tên khách hàng</label>
                                <input class="form-control my-2" type="text" placeholder="Tên khách hàng" name="tenKhachHang" />
                            </div>
                            <div class="form-group">
                                <label>Địa chỉ</label>
                                <input class="form-control my-2" placeholder="Địa chỉ" name="diaChi" />
                            </div>
                            <div class="form-group">
                                <label>Số điện thoại</label>
                                <input class="form-control my-2" type="number" placeholder="Số điện thoại" name="sdt" />
                            </div>
                            <div class="form-group">
                                <label>Hình ảnh hiện tại </label>
                                <input class="form-control my-2" type="text" name="anhDaiDien" readonly />
                            </div>
                            <div class="form-group">
                                <label>Hình ảnh mới</label>
                                <input type="file" name="fileToUpload1" id="fileToUpload1" class="form-control my-2" />
                            </div>
                            <div class="form-group">
                                <label>Điểm tích lũy</label>
                                <input class="form-control my-2" type="number" placeholder="Điểm tích lũy" name="diemTichLuy" />
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-secondary" type="button" data-bs-dismiss="modal">Đóng lại</button>
                            <button class="btn btn-primary" type="submit">Cập nhật</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="modal fade" id="Delete" tabindex="-1" role="dialog" aria-labelledby="Delete" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Xóa</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="delete.php" method="post">
                        <div class="modal-body">
                            <input type="text" name="tenDangNhap" class="form-control my-2" disabled />
                            <p>Bạn chắc chưa ?</p>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-primary btn-outline-light" type="button" data-bs-dismiss="modal">Đóng lại</button>
                            <button class="btn btn-danger btn-outline-light" type="submit">Xác nhận</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.1/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.1/js/dataTables.bootstrap5.min.js"></script>
    <script src="index.js"></script>
</body>

</html>