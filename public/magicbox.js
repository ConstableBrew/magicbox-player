const PlayStates = Object.freeze({
    Screensaver: 'Screensaver',
});

let state;
document.addEventListener('readystatechange', init);

function init() {
    console.log('init')
    if (!state) {
        const screensaver = document.getElementById('screensaver');
        state = {
            screensaver,
            playstate: PlayStates.Screensaver,
        };
        document.body.addEventListener('mousedown', playScreensaver);
        document.body.addEventListener('keydown', playScreensaver);
        document.body.addEventListener('touchstart', playScreensaver);
        screensaver.addEventListener('ended', playScreensaver);
        playScreensaver();
    }
}

function playScreensaver() {
    console.log('play')
    state.playstate = PlayStates.Screensaver;
    state.screensaver.style.display = 'block';
    state.screensaver.currentTime = 0;
    state.screensaver.play();
}
