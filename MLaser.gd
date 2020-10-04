extends AnimatedSprite


var velocity=Vector2(0,0)
var life=4
var timer=600


func _process(delta):
    position+=velocity
    timer-=1
    if timer<1:
        queue_free()


func _on_Area2D_area_entered(area):
    if life<1:
        queue_free()
    else:
        life-=1
        velocity.x=-velocity.x
        rotation=velocity.angle()
