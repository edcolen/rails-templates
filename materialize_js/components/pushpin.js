const materializePushpin = () => {
    document.addEventListener("DOMContentLoaded", function() {
        var elems = document.querySelectorAll(".pushpin");
        var instances = M.Pushpin.init(elems);
    });
};

export { materializePushpin };