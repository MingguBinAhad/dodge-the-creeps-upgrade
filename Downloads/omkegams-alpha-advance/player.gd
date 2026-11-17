extends Area2D
signal hit()

@export var kecepatan = 400.0
var health = 3
var can_be_damaged = true
var is_immune = false

var screen_size
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size # Replace with function body.
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.

func vanish():
	$CollisionShape2D.set_deferred("disabled", true)
	hide()

# dari sini...

func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("jalan_atas"):
		velocity.y -= 1
	if Input.is_action_pressed("jalan_bawah"):
		velocity.y += 1
	if Input.is_action_pressed("jalan_kanan"):
		velocity.x += 1
	if Input.is_action_pressed("jalan_kiri"):
		velocity.x -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * kecepatan
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		
	print(health)

# ...sampai sini mengatur player movement



""" bagian ini mengatur interaksi player dengan mob """

func _on_body_entered(body: Node2D) -> void: # Replace with function body.
	
	if can_be_damaged:
		health -= 1
		get_parent().get_node("HUD").update_health(health)
		can_be_damaged = false
		is_immune = true
		
		$BlinkTimer.start()
		$ImmuneTimer.start()
		
		print("player hit!")
		print("health = ", health)
		
	
	if health <= 0:
		vanish()
		hit.emit()
		
	#18/5/2026:Menambahkan sistem health
	#19/5/2026:Menambahkan sistem immune sesaat 

func _on_immune_timer_timeout() -> void:
	can_be_damaged = true
	is_immune = false
	$BlinkTimer.stop()
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.modulate.a = 1
	
func _on_blink_timer_timeout() -> void:
	if is_immune:
		$AnimatedSprite2D.visible = !$AnimatedSprite2D.visible
		$AnimatedSprite2D.modulate.a = 0.3

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	health = 3
