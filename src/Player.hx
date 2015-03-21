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

class Player extends Sprite {

	var image:Image;
	var animation:MovieClipPlus;
	public var col = 10;
	public var row = 5;
	public var moving = false;
	public var inventory:Array<String>;
	public var health:Int;

	public function new() {
		super();
		image = new Image(Root.assets.getTexture("player_down"));
		addChild(image);
	}

	public function move(dX:Int, dY:Int) {
		removeChild(image);
    	var direction = "";
    	if(dX > 0) direction = "right";
    	if(dX < 0) direction = "left";
    	if(dY > 0) direction = "down";
    	if(dY < 0) direction = "up";
    	var atlas = Root.assets.getTextureAtlas("player");
		animation = new MovieClipPlus(atlas.getTextures("player_walking_" + direction), 8);
		animation.loop = true;
		addChild(animation);
		animation.play();
		Starling.juggler.add(animation);
		moving = true;
		col += Std.int(dX / 64);
		row += Std.int(dY / 64);
		Starling.juggler.tween(this, .25, {
            delay: 0.0,
            x: this.x + dX, 
            y: this.y + dY,
            onComplete: function() {
            	removeChild(animation);
            	moving = false;
            	image = new Image(Root.assets.getTexture("player_" + direction));
            	addChild(image);
            }
		});
	}
}