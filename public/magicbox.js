const PlayStates = Object.freeze({
    Screensaver: 'Screensaver',
    Magicbox: 'Magicbox',
});

let state;
document.addEventListener('readystatechange', initMagicbox);

function initMagicbox() {
    if (!state) {
        const screensaver = document.getElementById('screensaver');
        const magicbox = document.getElementById('magicbox');
        state = {
            screensaver,
            magicbox,
            playstate: PlayStates.Screensaver,
        };
        document.body.addEventListener('mousedown', playMagicbox);
        document.body.addEventListener('keydown', playMagicbox);
        document.body.addEventListener('touchstart', playMagicbox);
        magicbox.addEventListener('ended', playScreensaver);
        playScreensaver();
    }
}

function playMagicbox() {
    if (state.playstate !== PlayStates.Magicbox) {
        state.playstate = PlayStates.Magicbox;
        state.magicbox.style.display = 'block';
        state.magicbox.currentTime = 0;
        state.magicbox.play();
        state.screensaver.style.display = 'none';
        state.screensaver.pause();
    }
}

function playScreensaver() {
    state.playstate = PlayStates.Screensaver;
    state.screensaver.style.display = 'block';
    state.screensaver.currentTime = 0;
    state.screensaver.play();
    state.magicbox.style.display = 'none';
    state.magicbox.pause();
}
