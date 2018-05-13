const PlayStates = {
    Screensaver: 'Screensaver',
    Magicbox: 'Magicbox',
};

const screensaver = document.getElementById('screensaver');
const magicbox = document.getElementById('magicbox');
let playState = PlayStates.Screensaver;
playScreensaver();

document.body.addEventListener('click', playMagicbox);
document.body.addEventListener('keydown', playMagicbox);
magicbox.addEventListener('ended', playScreensaver);

function playMagicbox() {
    if (playState !== PlayStates.Magicbox) {
        playState = PlayStates.Magicbox;
        magicbox.style.display = 'block';
        magicbox.currentTime = 0;
        magicbox.play();
        screensaver.style.display = 'none';
        screensaver.pause();
    }
}

function playScreensaver() {
    playState = PlayStates.Screensaver;
    screensaver.style.display = 'block';
    screensaver.currentTime = 0;
    screensaver.play();
    magicbox.style.display = 'none';
    magicbox.pause();
}