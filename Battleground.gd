extends Node2D
onready var Particle = preload("res://objects/FX_Particle.tscn")
onready var Warning = preload("res://objects/Warning.tscn")
onready var Enemy1 = preload("res://objects/Enemy1.tscn")
onready var Enemy2 = preload("res://objects/Enemy2.tscn")
onready var Enemy3 = preload("res://objects/Enemy3.tscn")
onready var Enemy4 = preload("res://objects/Enemy4.tscn")

var input_interval=0
var score=0
var spawn_rate=[.25,.25,.25,.25]
var timer=150
var level=0
var objective=1000
var health=3

func _ready():
    $AnimationPlayer.play("bg")
    background()
    #$CardQueue.initialize([1,2,3,4,5,6,7,8,9])
    #allocate_health(3)

func initialize(hp,queue,lv,obj,difficulty):
    allocate_health(hp)
    $CardQueue.initialize(queue)
    level=lv
    objective=obj
    spawn_rate=difficulty
    $Level.text='LEVEL '+str(lv)
    $Score.text=str(score)+' / '+str(objective)

func allocate_health(hp):
    health=hp
    for i in range(hp):
        get_node('Health/'+str(i)).visible=true

func _process(delta):
    if input_interval>0:
        input_interval-=1
    if $MC.position.y>480:
        $MC.position.y=480
        
    timer-=1
    if timer<1:
        timer=150
        for i in [-50,1010]:
            var j=490
            if randf()<spawn_rate[0]:
                var enemy=Enemy2.instance()
                add_child(enemy)
                enemy.position=Vector2(i,j)
                enemy.add_to_group('Enemies')
                var warning=Warning.instance()
                add_child(warning)
                warning.position.y=j
                if i<0:
                    warning.position.x=30
                else:
                    warning.position.x=930
                    warning.scale.x=-1
                    
            if randf()<spawn_rate[1]:
                var enemy=Enemy3.instance()
                add_child(enemy)
                enemy.position=Vector2(i,j)
                enemy.add_to_group('Enemies')
                var warning=Warning.instance()
                add_child(warning)
                warning.position.y=j
                if i<0:
                    warning.position.x=30
                else:
                    warning.position.x=930
                    warning.scale.x=-1
                    
            if randf()<spawn_rate[2]:
                j=rand_range(50,300)
                var enemy=Enemy1.instance()
                add_child(enemy)
                enemy.position=Vector2(i,j)
                enemy.add_to_group('Enemies')
                var warning=Warning.instance()
                add_child(warning)
                warning.position.y=j
                if i<0:
                    warning.position.x=30
                else:
                    warning.position.x=930
                    warning.scale.x=-1
                    
            if randf()<spawn_rate[3]:
                j=rand_range(50,300)
                var enemy=Enemy4.instance()
                add_child(enemy)
                enemy.position=Vector2(i,j)
                enemy.add_to_group('Enemies')
                var warning=Warning.instance()
                add_child(warning)
                warning.position.y=j
                if i<0:
                    warning.position.x=30
                else:
                    warning.position.x=930
                    warning.scale.x=-1     
                
func _input(event):
    var action=null
    if event is InputEventMouseButton and event.pressed:
        if input_interval<1:
            match event.button_index:
                BUTTON_LEFT:
                    action=$CardQueue.use(0)
                    input_interval=10  

            match event.button_index:
                BUTTON_RIGHT:
                    action=$CardQueue.use(1)
                    input_interval=10   
    if action!=null:
        var dst=event.position
        if dst.y>480:
            dst.y=480
        if action==1:
            get_parent().get_node("SE_Dash").playing=true
            $MC.dash(dst)
        if action==2:
            get_parent().get_node("SE_Shoot").playing=true
            $MC.shoot(dst)
        if action==3:
            get_parent().get_node("SE_Slash").playing=true
            $MC.slash(dst)
        if action==4:
            get_parent().get_node("SE_Special").playing=true
            $MC.shield()
        if action==5:
            get_parent().get_node("SE_Special").playing=true
            $MC.tele(dst)
        if action==6:
            get_parent().get_node("SE_Shoot").playing=true
            $MC.laser(dst)
        if action==7:
            get_parent().get_node("SE_Slash").playing=true
            $MC.shock()
        if action==8:
            get_parent().get_node("SE_Dash").playing=true
            $MC.hover()
        if action==9:
            get_parent().get_node("SE_Reward").playing=true
            var dist=10000
            var target=null
            for obj in get_children():
                if obj.is_in_group("Enemies") and is_instance_valid(obj):
                    var temp=obj.position.distance_to(dst)
                    if dist>temp:
                        dist=temp
                        target=obj
            if target!=null:
                target.frozen()
                var particle=Particle.instance()
                get_parent().add_child(particle)
                particle.color=Color(0,0,1,1)
                particle.position=target.position

func background():
    var viewport = get_node("Viewport")
    var sprite = get_node("Sprite")
    var viewport_sprite = get_node("Viewport_Sprite")

    # Assign the sprite's texture to the viewport texture
    viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
    # Let two frames pass to make sure the screen was captured
    yield(get_tree(), "idle_frame")
    yield(get_tree(), "idle_frame")
    viewport_sprite.texture = viewport.get_texture()
    
func enemy_killed():
    get_parent().get_node("SE_Reward").playing=true
    score+=1
    $Score.text=str(score)+' / '+str(objective)
    if score>=objective and health>0:
        get_parent().level_clear()
        queue_free()
    
func MC_hit():
    get_parent().get_node("SE_Hit").playing=true
    health-=1
    if health>-1:
        get_node('Health/'+str(health)).visible=false
    if health<1:
        queue_free()
        get_parent().failed()
