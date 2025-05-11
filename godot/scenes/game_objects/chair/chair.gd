extends Sprite2D
class_name Chair

var is_taken := false

func set_is_taken(_v: bool):
	is_taken = _v

func get_is_taken():
	return is_taken
