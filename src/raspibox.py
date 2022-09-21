import threading

import RPi.GPIO as GPIO
from mfrc522 import SimpleMFRC522

reader = SimpleMFRC522()

from Player import Player

player = Player()


def write_output():
    print('Waiting for RFID input')


def read_rfid():
    while (True):
        id, text = reader.read()
        print(f'read RFID id={id}: {text}')
        player.set_playlist(text.strip())


def read_buttons():
    from Buttons import Buttons
    buttons = Buttons()
    buttons.events.on('next', lambda: player.on_next())
    buttons.events.on('prev', lambda: player.on_prev())
    buttons.events.on('rewind', lambda: player.on_rewind())
    buttons.events.on('play', lambda: player.on_play())


def run():
    rfid = threading.Thread(name='rfid', target=read_rfid)
    buttons = threading.Thread(name='buttons', target=read_buttons)
    output = threading.Thread(name='foreground', target=write_output)
    rfid.start()
    buttons.start()
    output.start()
    GPIO.cleanup()


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    run()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
