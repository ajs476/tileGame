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
import flash.geom.Rectangle;


class Player extends Sprite {

	public var image:Image;
	var animation:MovieClipPlus;
	var direction = "down";
	var player = "player";
	public var col = 79;
	public var row = 94;
	public var moving = false;
	public var inventory:Array<String>;
	public var health:Int;

	public function new(player="player") {
		super();
		this.player = player;
		inventory = new Array<String>();
		image = new Image(Root.assets.getTexture(player + "_down"));
		image.width = 64;
		image.height = 64;
		addChild(image);
	}

	public function move(dX:Int, dY:Int, d="") {
		removeChild(image);
    	var direction = d;
	var i:Int = 0;
    	if(dX > 0) direction = "right";
    	if(dX < 0) direction = "left";
    	if(dY > 0) direction = "down";
    	if(dY < 0) direction = "up";
    	this.direction = direction;
    	var atlas = Root.assets.getTextureAtlas("assets");
		animation = new MovieClipPlus(atlas.getTextures(player +"_walking_" + direction), 18);
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
            	image = new Image(Root.assets.getTexture(player + "_" + direction));
            	addChild(image);
            }
		});
	}
}
