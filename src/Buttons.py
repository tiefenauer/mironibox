from datetime import datetime, timedelta

from gpiozero import Button
from pyee.base import EventEmitter


class Buttons:
    GPIO_NEXT = 5
    GPIO_PREV = 6
    GPIO_PLAY_PAUSE = 26

    events = EventEmitter()

    def __init__(self):
        self.is_paused = False
        Button.pressed_time = None
        self.button_next = Button(self.GPIO_NEXT)
        self.button_prev = Button(self.GPIO_PREV)
        self.button_play_pause = Button(self.GPIO_PLAY_PAUSE)
        self.button_play_pause.when_released = self.on_play_pause_pressed
        self.button_next.when_released = self.on_next_pressed
        self.button_prev.when_released = self.on_prev_pressed
        print('Buttons initialized')

    def on_play_pause_pressed(self):
        self.events.emit("play")

    def on_next_pressed(self):
        self.events.emit("next")

    def on_prev_pressed(self):
        if self.button_prev.pressed_time:
            if self.button_prev.pressed_time + timedelta(seconds=0.6) > datetime.now():
                self.events.emit('prev')
            else:
                self.events.emit('rewind')
            self.button_prev.pressed_time = None
        else:
            self.button_prev.pressed_time = datetime.now()
            self.events.emit('rewind')
