import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.display.Button;
import starling.animation.Transitions;
import starling.events.Event;
import starling.core.Starling;
import starling.display.Image;
import starling.display.DisplayObject;
import Tilemap;

class Game extends Sprite {

	var tileMap:Tilemap;

	public function new() {
		super();
	}

	public createMap() {
		tileMap = new Tilemap(Root.assets, "map");
		addChild(tm);
	}
}