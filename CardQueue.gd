extends Node2D
onready var Card = preload("res://objects/Card.tscn")

var card_list=[]
var idx2pos=['Slot5','Slot4','Slot3','Slot2','Slot1']
var idx2alp=[1,1,0.5,0.25,0]

func _ready():
    pass


func initialize(arr): 
    for i in range(len(arr)):
        var card=Card.instance()
        card_list.append(card)
        add_child(card)
        card.assign(arr[i])
        card.position=get_node(idx2pos[ min(4,i) ]).position
        card.modulate=Color(1,1,1,idx2alp[ min(4,i) ])
        
func use(i):
    var temp=card_list[i]
    var result=temp.id
    for j in range(i,len(card_list)-1):
        card_list[j]=card_list[j+1]
    card_list[-1]=temp
    
    for i in range(len(card_list)):
        $Tween.interpolate_property(card_list[i], "position",
        card_list[i].position, get_node(idx2pos[ min(4,i) ]).position, 0.25,
        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
        $Tween.interpolate_property(card_list[i], "modulate",
        card_list[i].modulate, Color(1,1,1,idx2alp[ min(4,i) ]), 0.25,
        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $Tween.start()
    
    return result
