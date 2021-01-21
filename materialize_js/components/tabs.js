const materializeTabs = () => {
    document.addEventListener("DOMContentLoaded", function() {
        var elem = document.querySelectorAll(".tabs");
        var instance = M.Tabs.init(elem);
    });
};

export { materializeTabs };