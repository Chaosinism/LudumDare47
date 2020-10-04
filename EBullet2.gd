extends AnimatedSprite


var velocity=Vector2(0,0)

func _ready():
    play('default')


func _process(delta):
    position+=velocity
    velocity.y+=0.5
    rotation_degrees+=2


func _on_Area2D_area_entered(area):
    queue_free()
