# import RPi.GPIO as GPIO

# buttonPin = 3
# GPIO.setmode(GPIO.BOARD)
# GPIO.setup(buttonPin, GPIO.IN, pull_up_down=GPIO.PUD_UP)
# # GPIO.setup(buttonPin, GPIO.OUT)
#
# while True:
#     buttonState = GPIO.input(buttonPin)
#     if buttonState == True:
#         print('button released')
#     else:
#         print('button pressed')


from gpiozero import Button
from signal import pause

#
# button = Button(2)
#
# while True:
#     if button.is_pressed:
#         print("Button is pressed")
#     else:
#         print("Button is not pressed")


button = Button(2)

def say_hello():
    print("Hello!")


button.when_released = say_hello

pause()


# from gpiozero import Button
#
# button = Button(3)
#
# while True:
#     if button.is_pressed:
#         print("Button is pressed")
#     else:
#         print("Button is not pressed")