const materializeWaves = () => {
    document.addEventListener("DOMContentLoaded", function() {
        var elems = document.querySelectorAll(".tooltipped");
        var instances = M.Tooltip.init(elems);
    });
};

export { materializeWaves };