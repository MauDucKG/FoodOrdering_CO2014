$(".btn-edit").click(function (e) {
    const tenMonAn = this.getAttribute('data-bs-tenMonAn')
    $("#Edit input[name='tenMonAn']").val(tenMonAn);
    const maMonAn = this.getAttribute('data-bs-maMonAn')
    $("#Edit input[name='maMonAn']").val(maMonAn);
    const moTaMonan = this.getAttribute('data-bs-moTaMonan')
    $("#Edit textarea[name='moTaMonan']").val(moTaMonan);
    const giaNiemYet = this.getAttribute('data-bs-giaNiemYet')
    $("#Edit input[name='giaNiemYet']").val(giaNiemYet);
    $('#Edit').modal('show');
});

$(".btn-delete").click(function (e) {
    const tenMonAn = this.getAttribute('data-bs-tenMonAn')
    //console.log(username);
    $("#Delete input[name='tenMonAn']").val(tenMonAn);
    $('#Delete').modal('show');
});
$(document).ready(function () {
    $('#tab-product').DataTable();
});