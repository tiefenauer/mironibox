from os import listdir
from os.path import isfile, join
from datetime import datetime, timedelta
from pygame import mixer
from signal import pause

from Buttons import Buttons


class Player:
    is_paused = False

    def __init__(self, playlist=[]):
        self.playlist = playlist
        self.current_track_numer = 0
        mixer.init()
        print('Player initialized')

    def set_playlist(self, name):
        path = f'./files/{name}/'
        print(f'Creating playlist for {path}')
        self.playlist = sorted([join(path, f) for f in listdir(path) if isfile(join(path, f))])
        print(f'got {len(self.playlist)} files')
        self.play_playlist()

    def play_playlist(self):
        self.current_track_number = 0
        self.play_track()

    def play_track(self, track_number=None):
        if track_number is None:
            track_number = self.current_track_number
        filename = self.playlist[track_number]
        print(f'playing {filename}')
        mixer.music.load(filename)
        mixer.music.play()
        self.current_track_number = track_number

    def on_play(self):
        print('on_play')
        if self.is_paused:
            print("play/resume!")
            mixer.music.unpause()
            self.is_paused = False
        else:
            print("pause!")
            mixer.music.pause()
            self.is_paused = True

    def on_prev(self):
        print('on_prev')
        self.play_track(self.current_track_number - 1)

    def on_rewind(self):
        print('on_rewind')
        mixer.music.rewind()

    def on_next(self):
        print('on_next')
        self.play_track(self.current_track_number + 1)
