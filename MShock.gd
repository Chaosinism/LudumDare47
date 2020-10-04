extends AnimatedSprite


func _ready():
    pass

func _process(delta):
    modulate[3]-=0.03
    scale+=Vector2(0.3,0.3)
    if scale[0]>10:
        queue_free()
