$(".btn-edit").click(function (e) {
    const tenDangNhap = this.getAttribute('data-bs-tenDangNhap')
    $("#Edit input[name='tenDangNhap']").val(tenDangNhap);
    const tenKhachHang = this.getAttribute('data-bs-tenKhachHang')
    $("#Edit input[name='tenKhachHang']").val(tenKhachHang);
    const diaChi = this.getAttribute('data-bs-diaChi')
    $("#Edit input[name='diaChi']").val(diaChi);
    const sdt = this.getAttribute('data-bs-sdt')
    $("#Edit input[name='sdt']").val(sdt);
    const anhDaiDien = this.getAttribute('data-bs-anhDaiDien')
    $("#Edit input[name='anhDaiDien']").val(anhDaiDien);
    const diemTichLuy = this.getAttribute('data-bs-diemTichLuy')
    $("#Edit input[name='diemTichLuy']").val(diemTichLuy);
    $('#Edit').modal('show');
});

$(".btn-delete").click(function (e) {
    const tenDangNhap = this.getAttribute('data-bs-tenDangNhap')
    //console.log(username);
    $("#Delete input[name='tenDangNhap']").val(tenDangNhap);
    $('#Delete').modal('show');
});
$(document).ready(function () {
    $('#tab-user').DataTable();
});