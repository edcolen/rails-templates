const materializeSelect = () => {
    document.addEventListener("DOMContentLoaded", function() {
        var elems = document.querySelectorAll("select");
        var instances = M.FormSelect.init(elems);
    });
};

export { materializeSelect };