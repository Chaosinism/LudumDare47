extends AnimatedSprite


var timer=150

func _ready():
    play('default')
    
func _process(_delta):
    timer-=1
    if timer<1:
        queue_free()


