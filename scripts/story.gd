extends RichTextLabel

class_name Story

var TextA = [
	"Far out in the rings of a broken moon live the Blob.",
	"They have only one purpose: Flinging themselves through the interiors of asteroids.",
	"They utilize their internal power to swing around and pull themselves towards hookpoints.",
	"This blob here is taking the sacred neverending challenge.",
	"He will try to pass the infinite labyrinth.",
	"Many dangers lie ahead, plan carefully and swing accurately.",
	"[break]",
	"Currently you see the planing screen, in this mode you can place hookpoints and do other stuff (later).",
	"Move the camera with WASD. Your goal is the portal up there.",
	"To place a hookpoint, click on the button with the orange circle and then somewhere into the level.",
	"You can also see a wall blocking the way, you will need to have some power to smash through it, the redder the wall, the more power you need.",
	"You will be able to get faster if you have more space to rotate around a point.",
] as Array[String]

var TextB = [
	"Now you it is time to test your skills.",
	"Attach to the closest hookpoint by pressing space.",
	"Accelerate around it in clockwise or counterclockwise direction using A and D.",
	"Pull yourself closer with W.",
	"And detach with SPACE again to launch yourself towards victory.",
	"Should you run out of power (top left), you will splash."
] as Array[String]

var TextC = [
	"There are reasons why the endless maze is a sacred challenge.",
	"Hitting these blue spikes will disrupt the power currents in your body.",
	"Place the hookpoints so that you wont run into them.",
] as Array[String]

var TextD = [
	"After this last test stage you will enter the endless maze.",
	"Uncharted territory awaits, as you progress further and further out.",
	"The asteroids will grow bigger and bigger so make sure that you have enough power to make a stage.",
	"Good luck...",
] as Array[String]

var current_text  = [] as Array[String]
var current_index = 0

var step = 0.


func _process(delta: float) -> void:
	step += delta
	if step > 4. and current_index < current_text.size():
		step = 0.
		text += "[center]" + current_text[current_index] + "[/center]" + "\n"
		if current_text[current_index] == "[break]":
			text = ""
		current_index += 1

func reset() -> void:
	text = ""
	current_index = 0
	current_text = []

func startA() -> void:
	reset()
	current_text = TextA

func startB() -> void:
	reset()
	current_text = TextB

func startC() -> void:
	reset()
	current_text = TextC

func startD() -> void:
	reset()
	current_text = TextD
