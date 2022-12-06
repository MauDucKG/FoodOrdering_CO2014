$(".btn-edit").click(function (e) {
    const name = this.getAttribute('data-bs-name')
    $("#Edit input[name='name']").val(name);
    const description = this.getAttribute('data-bs-description')
    $("#Edit textarea[name='description']").val(description);
    const price = this.getAttribute('data-bs-price')
    $("#Edit input[name='price']").val(price);
    $('#Edit').modal('show');
});

$(".btn-delete").click(function (e) {
    const name = this.getAttribute('data-bs-name')
    //console.log(username);
    $("#Delete input[name='name']").val(name);
    $('#Delete').modal('show');
});