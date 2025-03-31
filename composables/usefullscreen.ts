export function useFullscreen() {
    const toggleFullscreen = () => {
        const elem = document.documentElement;

        if (!document.fullscreenElement) {
            if (elem.requestFullscreen) {
                elem.requestFullscreen();
            }
        } else {
            if (document.exitFullscreen) {
                document.exitFullscreen();
            }
        }

        console.log("Fullscreen toggled");
    };

    return { toggleFullscreen };
}
