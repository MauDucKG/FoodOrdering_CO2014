<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap demo</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
</head>

<body>
    <div class="container">
        <h1 class="mt-3">Read Products</h1>

        <hr>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#add">Create New Product</button>
        <div class="modal fade" id="add" tabindex="-1" role="dialog" aria-labelledby="add" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Thêm mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="add.php" method="post">
                        <div class="modal-body">
                            <div class="form-group">
                                <label>Name</label>
                                <input class="form-control my-2" type="text" placeholder="Tên sản phẩm" name="name" />
                            </div>
                            <div class="form-group">
                                <label>Description</label>
                                <textarea class="form-control my-2" placeholder="Mô tả" name="description" style="height: 100px"></textarea>
                            </div>
                            <div class="form-group">
                                <label>Price</label>
                                <input class="form-control my-2" type="number" placeholder="Giá" name="price" />
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-secondary" type="button" data-dismiss="modal">Đóng lại</button>
                            <button class="btn btn-primary" type="submit">Thêm mới</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <table class="table table-striped mt-2">
            <thead>
                <tr>
                    <th scope="col">ID</th>
                    <th scope="col">Name</th>
                    <th scope="col">Description</th>
                    <th scope="col">Price</th>
                    <th scope="col">Action</th>
                </tr>
            </thead>
            <tbody>
                <?php
                require_once('db_connnection.php');

                $conn = OpenCon();
                $query = "SELECT * FROM `products`;";

                $result = $conn->query($query);

                if ($result->num_rows > 0) {
                    // OUTPUT DATA OF EACH ROW
                    while ($row = $result->fetch_assoc()) {
                ?>
                        <tr class="justify-content-center">
                            <th class='align-middle' scope="row"><?php echo $row['id'] ?></th>
                            <td class='align-middle'><?php echo $row['name'] ?></td>
                            <td class='align-middle'><?php echo $row['description'] ?></td>
                            <td class='align-middle'><?php echo $row['price'] ?></td>
                            <td class='align-middle'>
                                <div class="d-inline-flex">
                                    <button class="btn btn-secondary m-1">Read</button>
                                    <button type='button' class='btn-edit btn btn-primary m-1' data-bs-name='<?php echo $row['name'] ?>' data-bs-description='<?php echo $row['description'] ?>' data-bs-price='<?php echo $row['price'] ?>' data-bs-target='#Edit' data-bs-toggle='modal'>Edit</button>
                                    <button type='button' class='btn-delete btn btn-danger m-1' data-bs-name='<?php echo $row['name'] ?>' data-bs-target='#Delete' data-bs-toggle='modal'>Delete</button>
                                </div>
                            </td>
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
                    </div>
                    <form action="edit.php" method="post">
                        <div class="modal-body">
                            <div class="form-group">
                                <label>Name</label>
                                <input class="form-control my-2" type="text" placeholder="Tên sản phẩm" name="name" readonly />
                            </div>
                            <div class="form-group">
                                <label>Description</label>
                                <textarea class="form-control my-2" placeholder="Mô tả" name="description" style="height: 100px"></textarea>
                            </div>
                            <div class="form-group">
                                <label>Price</label>
                                <input class="form-control my-2" type="number" placeholder="Giá" name="price" />
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
                            <input type="hidden" name="name" />
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
    <script src="index.js"></script>
</body>

</html>