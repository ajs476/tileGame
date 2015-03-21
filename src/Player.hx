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

class Player extends Sprite {

	var image:Image;
	public var col = 10;
	public var row = 5;

	public function new() {
		super();
		image = new Image(Root.assets.getTexture("player"));
		addChild(image);
	}

	public function move(dX:Int, dY:Int) {
		col += Std.int(dX / 64);
		row += Std.int(dY / 64);
		Starling.juggler.tween(this, .25, {
            delay: 0.0,
            x: this.x + dX, 
            y: this.y + dY,
            onComplete: function() {
            	cast(this.parent, Game).moving = false;
            }
		});
	}
}