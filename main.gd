extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	get_tree().call_group('mobs', 'queue_free')
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message('Get Ready')
	$Music.play()
	get_tree().call_group('mobs', 'queue_free')


func _on_mob_timer_timeout():
	# Crea la instancia del la scena del mob
	var mob = mob_scene.instantiate()
	
	# Elige una ubicaion ramdom del Path2D
	var mob_spawn_location = get_node('MobPath/MobSpawnLocation')
	mob_spawn_location.progress_ratio = randf()
	
	# Establece la direcion del mob perpendicular a la direcion del camino
	var direction = mob_spawn_location.rotation + PI /2
	
	# Establece la posicion del mob en un lugar random
	mob.position = mob_spawn_location.position
	
	# Agrega algo de direcion random
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Elige la velocidad para el enemigo
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Reaparece el mob agregandolo a la escena principal
	add_child(mob)


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
