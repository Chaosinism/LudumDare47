extends Node2D

var database_name=['','DASH','SHOOT','SLASH','SHIELD','TELE','LASER','SHOCK','HOVER','FREEZE']
var database_desc=['',
    'Move along any direction.',
    'Shoot a bullet.',
    'Attack and block bullets.',
    'Block attacks for 3 second.',
    'Teleport to any position.',
    'Weapon that reflects horizontally.',
    'Damage all surrounding enemies.',
    'Float in midair for 3 second.',
    'Click an enemy to freeze it.']

var id=0
var pos=null
var listener=null

func _ready():
    $AnimationPlayer.play("card_anim")
    
    assign(7)

func assign(num):
    id=num
    $Name.text=database_name[id]
    $AnimatedSprite.animation=str(id)
    $Description.bbcode_text='[b]'+database_name[id]+'[/b]'+'\n'+database_desc[id]


func _on_KinematicBody2D_input_event(_viewport, event, _shape_idx):
    if event is InputEventMouseButton and event.pressed:
        match event.button_index:
            BUTTON_LEFT:
                if listener!=null:
                    listener.card_clicked(self)


func _on_KinematicBody2D_mouse_entered():
    $Description.visible=true


func _on_KinematicBody2D_mouse_exited():
    $Description.visible=false
