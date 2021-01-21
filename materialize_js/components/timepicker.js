const materializeTimePicker = () => {
    document.addEventListener("DOMContentLoaded", function() {
        var elems = document.querySelectorAll(".timepicker");
        var instances = M.Timepicker.init(elems);
    });
};

export { materializeTimePicker };