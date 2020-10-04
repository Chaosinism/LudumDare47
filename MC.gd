extends AnimatedSprite
onready var Particle = preload("res://objects/FX_Particle.tscn")
onready var MBullet = preload("res://objects/MBullet.tscn")
onready var MLaser = preload("res://objects/MLaser.tscn")
onready var MSlash = preload("res://objects/MSlash.tscn")
onready var MShock = preload("res://objects/MShock.tscn")

var state=0
var falling=false
var velocity=Vector2(0,0)
var timer=0
var speed=10


# Called when the node enters the scene tree for the first time.
func _ready():
    $AnimationPlayer.play("default")
    play('default')
    pass # Replace with function body.

func _process(delta):
    if timer>0:
        timer-=1
    
    if state!=0 and timer<1:
        state=0
        play('default')
        if len( $Foot.get_overlapping_areas() )==0:
            falling=true
 
    if modulate[2]<1:
        modulate[2]+=0.01
    if modulate[0]<1:
        modulate[0]+=0.01
       
    if state==0:
        if get_viewport().get_mouse_position()>global_position:
            scale[0]=1.2
        else:
            scale[0]=-1.2
        velocity.x*=0.5
        velocity.y*=0.5
        
        if falling==true:
            position.y+=15
            
    if state==3:
        velocity.y*=0.95

        
    position.x+=velocity.x
    position.y+=velocity.y
        

func dash(dst):
    state=1
    play('dash')
    var vec=dst-global_position
    timer=min(vec.length()/speed, 30)
    velocity=vec.normalized()
    velocity.x*=speed
    velocity.y*=speed
    if velocity.x>0:
        scale[0]=1.2
    else:
        scale[0]=-1.2

func tele(dst):
    state=2
    timer=20
    global_position=dst
    var particle=Particle.instance()
    get_parent().add_child(particle)
    particle.position=position

func hover():
    state=3
    timer=180
    velocity.y=-speed
    play('hover')
    
func shoot(dst):
    var vec=dst-global_position
    var temp=vec.normalized()
    temp.x*=15
    temp.y*=15
    var bullet=MBullet.instance()
    get_parent().add_child(bullet)
    bullet.position=position     
    bullet.velocity=temp   
    bullet.rotation=temp.angle()+PI
    
func laser(dst):
    var vec=dst-global_position
    var temp=vec.normalized()
    temp.x*=30
    temp.y*=30
    var bullet=MLaser.instance()
    get_parent().add_child(bullet)
    bullet.position=position     
    bullet.velocity=temp   
    bullet.rotation=temp.angle()
    
func shield():
    if $Shield.visible==false:
        $Shield.timer=180
        $Shield.visible=true
    
func slash(dst):
    var slash=MSlash.instance()
    get_parent().add_child(slash)
    slash.position=position    
    if dst.x>position.x:
        slash.scale[0]=-1
    slash.velocity.x=velocity.x
    slash.play('default')  
    
func shock():
    var shock=MShock.instance()
    get_parent().add_child(shock)
    shock.position=position       

func _on_Foot_area_entered(area):
    falling=false


func _on_Body_area_entered(area):
    if modulate[0]<1 or $Shield.visible==true:
        return
    var particle=Particle.instance()
    get_parent().add_child(particle)
    particle.position=position
    particle.color=Color(0,1,0,1)
    modulate[0]=0
    modulate[2]=0
    
    get_parent().MC_hit()
