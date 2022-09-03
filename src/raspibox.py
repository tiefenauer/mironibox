# This is a sample Python script.
import simpleaudio as sa
import RPi.GPIO as GPIO
from mfrc522 import SimpleMFRC522
import threading

# Press Alt+Shift+X to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.

reader = SimpleMFRC522()
play_obj = None


def foreground():
    print('Waiting for RFID input')


def play_file(name):
    global play_obj
    filename = f'files/{name}.wav'
    wave_obj = None
    if play_obj is not None:
        play_obj.stop()
    try:
        wave_obj = sa.WaveObject.from_wave_file(filename)
    except FileNotFoundError:
        print(f'file `{filename}` not found')

    if wave_obj is not None:
        play_obj = wave_obj.play()


def rfid_input():
    while (True):
        id, text = reader.read()
        print(f'read RFID id={id}: {text}')
        play_file(text.strip())


def run():
    b = threading.Thread(name='background', target=rfid_input)
    f = threading.Thread(name='foreground', target=foreground)
    b.start()
    f.start()
    GPIO.cleanup()


def print_hi(name):
    # Use a breakpoint in the code line below to debug your script.
    print(f'Hi, {name}')  # Press Ctrl+Shift+B to toggle the breakpoint.
    wave_obj = sa.WaveObject.from_wave_file('piano2.wav')
    play_obj = wave_obj.play()
    play_obj.wait_done()


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    run()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
