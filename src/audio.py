import os, time
from pygame import mixer


def playSoundWithPyGame():
    # Initialize pygame mixer
    mixer.init()
    # Load the sounds
    sound = mixer.music.load('files/piano2.wav')
    # play sounds
    mixer.music.play()
    # sound.play()
    # wait for sound to finish playing
    time.sleep(3)


def playM4AwithMplayer():
    from mplayer import Player

    # player = Player()
    # player.loadfile('files/piano2.wav')

    # player = Player()
    abspath = '/home/pi/raspibox/files/dieter_wiesenmann_matthias/12 Pfuus Guet.m4a'
    # player.loadfile(abspath)

    from subprocess import Popen, PIPE

    pipes = dict(stdin=PIPE, stdout=PIPE, stderr=PIPE)
    mplayer = Popen(["mplayer", abspath], **pipes)
    #
    # # to control u can use Popen.communicate
    # mplayer.communicate(input=b">")
    # sys.stdout.flush()

if __name__ == '__main__':
    while (True):
        # playSoundWithPyGame()
        playM4AwithMplayer()
        time.sleep(10)
