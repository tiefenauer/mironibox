#!/usr/bin/env python
import RPi.GPIO as GPIO
from mfrc522 import SimpleMFRC522

reader = SimpleMFRC522()
try:
    text = input('Tragen Sie einen Wert ein:')
    print("Halten Sie die Karte / Clip an den Sensor:")
    reader.write(text)
    print("Erfolgreich beschrieben.")
finally:
    GPIO.cleanup()