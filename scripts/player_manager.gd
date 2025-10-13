extends Node

var _player: CharacterBody2D
var _initial_position: Vector2


# Record platform where to player stand. 
var _current_platform: StaticBody2D:
	set(new_platform):
		var distance: float = 0
		if new_platform == _current_platform:
			return
			
		if _current_platform != null:
			distance = max(
				0,
				_current_platform.global_position.y - new_platform.global_position.y,
			) 
		
		_current_platform = new_platform
		emit_signal('current_platform_changed', distance)


## Give distances between old & current platforms when player jump between it.
signal current_platform_changed(distance: float)

## Player fell off outside screen.
signal player_fell_off

func init(player: CharacterBody2D) -> void:
	_player = player
	_initial_position = _player.global_position


## (Re)spawn player at dedicated position
func spawn() -> void:
	_player.global_position = _initial_position
	_player.process_mode = Node.PROCESS_MODE_PAUSABLE
	_player.show()


func _on_player_screen_notifier_exited() -> void:
	if _player.global_position.y > 0:
		_player.hide()
		_player.process_mode = Node.PROCESS_MODE_DISABLED
		emit_signal('player_fell_off')

func _unhandled_input(event: InputEvent) -> void:	
	assert(_player)
	
	if event.is_action_pressed("jump"):
		_player.jump()
	if event.is_action_pressed("move_left"):
		_player.move(Vector2.LEFT)
	if event.is_action_released("move_left"):
		_player.move_stop(Vector2.LEFT)
	if event.is_action_pressed("move_right"):
		_player.move(Vector2.RIGHT)
	if event.is_action_released("move_right"):
		_player.move_stop(Vector2.RIGHT)

func _on_player_landed() -> void:
	var collission: KinematicCollision2D = _player.get_last_slide_collision()
	if collission:
		_current_platform = collission.get_collider()
