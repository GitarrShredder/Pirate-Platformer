extends Node
@onready var interactive_music: AudioStreamPlayer = $InteractiveMusic

@onready var stream : AudioStreamInteractive
var clip_index = [] 

func play_music():
	interactive_music.play() 

func roam_to_fight():
	stream.switch_to_clip(1)
