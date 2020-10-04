extends Node2D
onready var Card = preload("res://objects/Card.tscn")

var state=1
var max_health=3
var card_id_list=[]
var card_list=[]
var new_cards=[]
var discarded_pos=[]

func _ready():
    background()
    $Health/AnimationPlayer.play("default")
    new_cards.append(randi()%3+1)
    new_cards.append(randi()%6+4)
    new_cards.append(randi()%6+4)
    
    #initialize(3,[1,2,3,4,5,6,7,8])


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

func initialize(hp,cards):
    max_health=hp
    card_id_list=cards
    
    var ratio=min( 7.5/len(cards), 0.75)
    for i in range(len(cards)):
        var card=Card.instance()
        add_child(card)
        card.assign(cards[i])
        card.scale=Vector2(ratio,ratio)
        card.pos=i
        card.listener=self
        card.position.x=$Spawn.position.x+95*i*ratio+5*i
        card.position.y=$Spawn.position.y
        card.get_node("Description").rect_scale=Vector2(1/ratio,1/ratio)
        card_list.append(card)    
        
    for i in range(len(new_cards)):
        var card=Card.instance()
        add_child(card)
        card.assign(new_cards[i])
        card.scale=Vector2(.75,.75)
        card.pos=i+1000
        card.listener=self
        card.position.x=$Spawn2.position.x+95*i*.75+5*i
        card.position.y=$Spawn2.position.y
        card.get_node("Description").rect_scale=Vector2(1/.75,1/.75)
        card_list.append(card)        
    

func next_state():
    state+=1
    get_parent().get_node("SE_Reward").playing=true
    $State.text=str(state)+' / 2'
    
    if state>2:
        var upgraded_card_id_list=[]
        for i in range(len(card_id_list)):
            if discarded_pos.find(i)==-1:
                upgraded_card_id_list.append(card_id_list[i])
        queue_free()
        get_parent().upgraded(max_health,upgraded_card_id_list)

func _on_KinematicBody2D_input_event(_viewport, event, _shape_idx):
    if event is InputEventMouseButton and event.pressed:
        match event.button_index:
            BUTTON_LEFT:
                max_health+=1
                $Health.visible=false
                next_state()

func card_clicked(card):
    if card.pos<500:
        discarded_pos.append(card.pos)
    else:
        card_id_list.append(card.id)
    card.visible=false
    next_state()
