extends Node2D




func _on_Return_pressed():
    queue_free()
    get_parent().game_over(0)
