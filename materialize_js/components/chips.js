const materializeChips = () => {
    document.addEventListener("DOMContentLoaded", function() {
        var elems = document.querySelectorAll(".chips");
        var instances = M.Chips.init(elems);
    });
};

export { materializeChips };