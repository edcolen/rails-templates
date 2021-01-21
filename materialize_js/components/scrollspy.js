const materializeScrollspy = () => {
    document.addEventListener("DOMContentLoaded", function() {
        var elems = document.querySelectorAll(".scrollspy");
        var instances = M.ScrollSpy.init(elems);
    });
};

export { materializeScrollspy };