import RPi.GPIO as GPIO
from mfrc522 import SimpleMFRC522
import threading

from pygame import mixer

reader = SimpleMFRC522()
play_obj = None
playlist = []
current_track_number = 0


def write_output():
    print('Waiting for RFID input')


def play_playlist(name):
    global playlist, current_track_number
    path = f'./files/{name}/'
    print(f'Creating playlist for {path}')
    from os import listdir
    from os.path import isfile, join
    playlist = sorted([join(path, f) for f in listdir(path) if isfile(join(path, f))])
    print(f'got {len(playlist)} files')
    print(playlist)
    current_track_number = 0
    play_track(playlist)


def play_track(playlist, track_number=current_track_number):
    global current_track_number
    filename = playlist[track_number]
    print(f'playing {filename}')
    mixer.music.load(filename)
    mixer.music.play()
    current_track_number = track_number


def read_rfid():
    while (True):
        id, text = reader.read()
        print(f'read RFID id={id}: {text}')
        play_playlist(text.strip())


def on_next_pressed():
    print("Next track!")
    play_track(playlist, current_track_number + 1)


def on_prev_pressed(btn):
    global checker
    print("previous track!", btn.pressed_time)
    from datetime import datetime, timedelta
    # from threading import Timer
    if btn.pressed_time:
        if btn.pressed_time + timedelta(seconds=0.6) > datetime.now():
            print("pressed twice")
            play_track(playlist, current_track_number - 1)
        else:
            print("too slow")  # debug
            mixer.music.rewind()
        btn.pressed_time = None
    else:
        print("pressed once")  # debug
        btn.pressed_time = datetime.now()
        mixer.music.rewind()


is_paused = False


def on_play_pause_pressed():
    global is_paused
    if is_paused:
        print("play/resume!")
        mixer.music.unpause()
        is_paused = False
    else:
        print("pause!")
        mixer.music.pause()
        is_paused = True


def read_buttons():
    print('read_buttons')
    from signal import pause
    from gpiozero import Button
    Button.pressed_time = None
    Button.pressed_num = 0
    GPIO_NEXT = 2
    GPIO_PREV = 3
    GPIO_PLAY_PAUSE = 5
    button_next = Button(GPIO_NEXT)
    button_prev = Button(GPIO_PREV)
    button_play_pause = Button(GPIO_PLAY_PAUSE)
    # button_prev.pressed_time = None
    button_next.when_released = on_next_pressed
    button_prev.when_released = on_prev_pressed
    button_play_pause.when_released = on_play_pause_pressed
    pause()


def run():
    rfid = threading.Thread(name='rfid', target=read_rfid)
    buttons = threading.Thread(name='buttons', target=read_buttons)
    output = threading.Thread(name='foreground', target=write_output)
    rfid.start()
    buttons.start()
    output.start()
    mixer.init()
    GPIO.cleanup()


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    run()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
