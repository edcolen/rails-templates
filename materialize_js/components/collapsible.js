const materializeCollapsible = () => {
    document.addEventListener("DOMContentLoaded", function() {
        var elems = document.querySelectorAll(".collapsible");
        var instances = M.Collapsible.init(elems);
    });
};

export { materializeCollapsible };