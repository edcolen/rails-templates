const materializeCharactercounter = () => {
    document.addEventListener("DOMContentLoaded", function() {
        var textNeedCount = document.querySelectorAll("#text_counter");
        M.CharacterCounter.init(textNeedCount);
    });
};

export { materializeCharactercounter };