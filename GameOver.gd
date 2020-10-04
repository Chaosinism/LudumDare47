extends Node2D

func _ready():
    $AnimatedSprite.play('default')
    $AnimatedSprite2.play('default')
    $AnimationPlayer.play("default")


func _on_Restart_pressed():
    queue_free()
    get_parent().game_over(1)


func _on_Return_pressed():
    queue_free()
    get_parent().game_over(0)
