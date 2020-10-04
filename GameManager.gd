extends Node
onready var Title = preload("res://Title.tscn")
onready var Arranger = preload("res://Arranger.tscn")
onready var Upgrade = preload("res://Upgrade.tscn")
onready var Battleground = preload("res://Battleground.tscn")
onready var GameOver = preload("res://GameOver.tscn")
onready var Ending = preload("res://Ending.tscn")
onready var Plot = preload("res://Plot.tscn")

var health=3
var card_list=[1,2,1,3,1,2,8,3,1,4]
var level=1
var objective=[null,5,15,25,30,35]
var spawn_rates=[ null,
                    [.25, 0, .1, 0],
                    [.2, .1, .2, 0], 
                    [.15, .15, .15, .1],
                    [.2, .15, .15, .15],
                    [.2, .2, .2, .2]]

func _ready():
    var scene=Title.instance()
    add_child(scene)
    $AudioStreamPlayer.play()

func game_started():
    level=1
    health=3
    var scene=Plot.instance()
    add_child(scene)

func plot_finished():
    new_level()

func new_level():
    get_node("SE_Reward").playing=true
    var scene=Arranger.instance()
    add_child(scene)
    scene.initialize(card_list,level)
    
func arranged(new_list):
    get_node("SE_Reward").playing=true
    card_list=new_list
    var scene=Battleground.instance()
    add_child(scene)
    scene.initialize(health,card_list,level,objective[level],spawn_rates[level])
    
func level_clear():
    get_node("SE_Reward").playing=true
    level+=1
    if level<6:
        var scene=Upgrade.instance()
        add_child(scene)
        scene.initialize(health,card_list)
    else:
        var scene=Ending.instance()
        add_child(scene)       
    
func upgraded(hp,new_list):
    get_node("SE_Reward").playing=true
    card_list=new_list
    health=hp
    new_level()
    
func failed():
    var scene=GameOver.instance()
    add_child(scene)  
    
func game_over(option):
    get_node("SE_Reward").playing=true
    if option==1:
        new_level()
    else:
        _ready()
