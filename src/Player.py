from os import listdir
from os.path import isfile, join

from pygame import mixer


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

    def play(self):
        if self.is_paused:
            mixer.music.unpause()
            self.is_paused = False
        else:
            mixer.music.pause()
            self.is_paused = True

    def previous_track(self):
        self.play_track(self.current_track_number - 1)

    def rewind(self):
        mixer.music.rewind()

    def next_track(self):
        self.play_track(self.current_track_number + 1)
