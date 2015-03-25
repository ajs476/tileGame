import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.display.Button;
import starling.animation.Transitions;
import starling.events.Event;
import starling.core.Starling;
import starling.display.Image;
import starling.display.DisplayObject;
import starling.events.KeyboardEvent;
import starling.animation.Tween;
import MovieClipPlus;

class Raptor extends Sprite {

	public var image:Image;
	var animation:MovieClipPlus;
	var direction = "down";
	public var speed:Int;
	public var col:Int;
	public var row:Int;
	public var moving = false;
	public var route:Array<Array<Int>>;
	public var currentNode = 0;
	private var flag = false;

	public function new() {
		super();
		image = new Image(Root.assets.getTexture("player_down"));
		image.width = 64;
		image.height = 64;
		addChild(image);
		addEventListener("moveFinished", patrol);
	}

	public function patrol() {
		if(currentNode == route.length - 1) {
			currentNode = 0;
		} else {
			currentNode++;
		}
		var newLocation = route[currentNode];
		var dX = (newLocation[0] - col);
		var dY = (newLocation[1] - row);
		col = newLocation[0];
		row = newLocation[1];
		move(dX, dY);
	}

	public function move(dX:Int, dY:Int) {
		if(!moving) {
			removeChild(image);
	    	var direction = "";
	    	if(dX > 0) direction = "right";
	    	if(dX < 0) direction = "left";
	    	if(dY > 0) direction = "down";
	    	if(dY < 0) direction = "up";
	    	this.direction = direction;
	    	var atlas = Root.assets.getTextureAtlas("player");
			animation = new MovieClipPlus(atlas.getTextures("player_walking_" + direction), 8);
			animation.loop = true;
			addChild(animation);
			animation.play();
			Starling.juggler.add(animation);
			moving = true;
			col += Std.int(dX / 64);
			row += Std.int(dY / 64);
			Starling.juggler.tween(this, Math.abs((dX + dY) * .25), {
	            delay: 0.0,
	            x: this.x + (dX * 64), 
	            y: this.y + (dY * 64),
	            onComplete: function() {
	            	removeChild(animation);
	            	moving = false;
	            	image = new Image(Root.assets.getTexture("player_" + direction));
	            	addChild(image);
	            	dispatchEvent(new Event("moveFinished"));
	            }
			});
		}
	}
}