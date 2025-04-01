extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body is Character:
		body.enter_water(position.y)


func _on_body_exited(body: Node2D) -> void:
	if body is Character:
		if body.position.y -float(Global.ppt) / 2 <= position.y:
			body.exit_water()
		else:
			body.dive()
			
