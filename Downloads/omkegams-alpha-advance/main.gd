extends Node

@export var mob_scene: PackedScene
var score

const ICON_PAUSE = preload("res://pause.png")
const ICON_PLAY = preload("res://play.png")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#new_game()
	$HUD/PauseButton.pressed.connect(_on_pause_button_pressed)
	$HUD/PauseButton.icon = ICON_PAUSE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#----------------------------------------------------------
func game_over() -> void:
	$ScoreTimer.stop() # Replace with function body.
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

	
	
#-----------------------------------------------------------
	"""untuk mengatur saat game di-restart"""
	
func new_game():
	score = 0
	$player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()
	$HUD.update_health($player.health)
	
	
	
#-------------------------------------------------------------------------------

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate() # Replace with function body.
	var mob_spawn_location = $Path2D/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	var direction = mob_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
	
#------------------------------------------------------------------

func _on_score_timer_timeout() -> void:
	score += 1 # Replace with function body.
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start() # Replace with function body.
	$ScoreTimer.start()
	$HUD/PauseButton.show()

func _on_pause_button_pressed():
	get_tree().paused = !get_tree().paused
	
	if get_tree().paused:
		$HUD/PauseButton.icon = ICON_PLAY
		$HUD/BlurOverlay.visible = true
		print("Game Paused (icon -> PLAY)")
		
		
	else:
		$HUD/PauseButton.icon = ICON_PAUSE
		$HUD/BlurOverlay.visible = false
		print("Game Resumed (icon -> PAUSE)")
		
