<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login</title>
    <link href="signin.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
</head>

<body class="text-center">
    <main class="form-signin w-100 m-auto">
        <form action="login.php" method="post">
            <img class="mb-4" src="./team_logo.png" alt="" width="72" height="72">
            <h1 class="h3 mb-3 fw-normal">Please sign in</h1>
            <?php
            if (isset($_GET['err'])) {
                echo "<div class=\"alert alert-warning alert-dismissible fade show\" role=\"alert\">";
                echo "<strong>Error: </strong>" . $_GET['err'];
                echo "<button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"alert\" aria-label=\"Close\"></button>";
                echo "</div>";
            }
            ?>
            <div class="form-floating">
                <input type="username" name="username" class="form-control" id="floatingInput" placeholder="username">
                <label for="floatingInput">Tài khoản</label>
            </div>
            <div class="form-floating">
                <input type="password" name="password" class="form-control" id="floatingPassword" placeholder="Password">
                <label for="floatingPassword">Mật khẩu</label>
            </div>
            <button class="w-100 btn btn-lg btn-primary" type="submit">Sign in</button>
            <p class="mt-5 mb-3 text-muted">&copy; Lemon team</p>
        </form>
    </main>
</body>

</html>