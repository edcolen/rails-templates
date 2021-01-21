const materializeAutocomplete = () => {
    document.addEventListener("DOMContentLoaded", function() {
        var elems = document.querySelectorAll(".autocomplete");
        var instances = M.Autocomplete.init(elems);
    });
};

export { materializeAutocomplete };