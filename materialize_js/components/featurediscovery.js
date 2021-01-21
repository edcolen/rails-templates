const materializeFeatureDiscovery = () => {
    document.addEventListener("DOMContentLoaded", function() {
        var elems = document.querySelectorAll(".tap-target");
        var instances = M.TapTarget.init(elems);
    });
};

export { materializeFeatureDiscovery };