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
	var camera = 

	public function new() {
		super();
		createMap();
	}

	public function createMap() {
		tileMap = new Tilemap(Root.assets, "map");
		addChild(tileMap);
	}
}