extends Node2D

onready var animation: AnimationPlayer = $Transition/AnimationPlayer
var play = false
var distance = 0

func _ready():
	var current_position =  $"/root/Settings".final_position 
	match current_position:
		4:
			$Player.global_position.x = 120
		3:
			$Player.global_position.x = 470
		2:
			$Player.global_position.x = 550
		1:
			$Player.global_position.x = 590
	animation.play("fade_out")
	yield(animation, "animation_finished")
	play = !play
	$ParallaxBackground.play = play
	start_animation_group("cyclist", true)
	play_ride_bike()

func _physics_process(delta):
	if play:
		var speed_player = $ParallaxBackground.speed
		if speed_player > 500:
			if $Cyclist.position.x > 150 :
				$Cyclist.position.x -= 50 * delta
			if $Cyclist2.position.x > 180 :
				$Cyclist2.position.x -=  40 * delta
			if $Cyclist3.position.x > 250 :
				$Cyclist3.position.x -=  30 * delta
			if $Player.global_position.x < 900:
				$Player.global_position.x += 50 * delta
				if $Player.global_position.x > 900:
					$Player.global_position.x = 900
		else:
			$Cyclist.position.x +=  80 * delta
			$Cyclist2.position.x +=  100 * delta
			$Cyclist3.position.x +=  120 * delta
		$Score.setValueScore(distance, speed_player * 0.1, $Timer.time_left)
		distance += 0.01
		#print("speed ", speed_player)

func _on_Timer_timeout():
	$Timer.stop()
	start_animation_group("cyclist", false)
	if $Player.global_position.x < $Cyclist.position.x:
		$"/root/Settings".final_position = 4
	elif $Player.global_position.x < $Cyclist2.position.x:
		$"/root/Settings".final_position = 3
	elif $Player.global_position.x < $Cyclist3.position.x:
		$"/root/Settings".final_position = 2
	else:
		$"/root/Settings".final_position = 1
	#print($"/root/Settings".final_position)
	animation.play("fade_in")
	yield(animation, "animation_finished")
	get_tree().change_scene("res://src/Scene/Race/Speedway.tscn")

#func initial_position():
	
func start_animation_group(nameGroup, start):
	var nodes = get_tree().get_nodes_in_group(nameGroup)
	for x in nodes:
		x.start = start
		
func play_ride_bike():
	if $"/root/SoundConfig".enable_sound:
		$RideBike.play()
