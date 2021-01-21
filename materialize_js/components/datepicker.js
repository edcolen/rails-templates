const materializeDatePicker = () => {
    document.addEventListener("DOMContentLoaded", function() {
        var elems = document.querySelectorAll(".datepicker");
        var instances = M.Datepicker.init(elems);
    });
};

export { materializeDatePicker };