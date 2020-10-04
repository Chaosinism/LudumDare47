extends AnimatedSprite

var velocity=Vector2(0,0)

func _ready():
    pass

func _process(delta):
    position.x+=-5*scale[0]+velocity.x
    position.y-=2+velocity.y

func _on_MSlash_animation_finished():
    queue_free()
