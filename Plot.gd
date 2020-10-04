extends Node2D


var state=0

func _ready():
    $Page.play("1")
    


func _on_Button_pressed():
    if state==0:
        state=1
        $Page.play("2")
    elif state==1:
        state=2
        $Page.play("3")
    else:
        queue_free()
        get_parent().plot_finished()
