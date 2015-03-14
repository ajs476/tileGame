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
import Tilemap;

class Game extends Sprite {

	var tileMap:Tilemap;

	public function new() {
		super();
		createMap();
		Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, moveCamera);
	}

	public function createMap() {
		tileMap = new Tilemap(Root.assets, "map");
		addChild(tileMap);
	}

	public function moveCamera(event:KeyboardEvent) {
		if(event.keyCode == 68) {
			if(this.x - 64 <= 0) {
				this.x -= 64;
			}
		}
		if(event.keyCode == 87) {
			if(this.y + 64 <= 0) {
				this.y += 64;
			}
		}
		if(event.keyCode == 65) {
			if(this.x + 64 <= 0) {
				this.x += 64;
			}
		}
		if(event.keyCode == 83) {
			if(this.y - 64 <= 0) {
				this.y -= 64;
			}
		}
	}
}