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
import Player;

class Game extends Sprite {

	var tileMap:Tilemap;
	public var moving = false;
	var player:Player;
	var cols = 25;
	var rows = 20;

	public function new() {
		super();
		createMap();
		player = new Player();
		player.x = 64 * 10;
		player.y = 64 * 5;
		addChild(player);
		//Move camera on keyboard event
		Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, moveCamera);
	}

	public function createMap() {
		tileMap = new Tilemap(Root.assets, "map");
		tileMap.y = 32;
		addChild(tileMap);
	}

	public function moveCamera(event:KeyboardEvent) {
		if(moving) {
			return;
		}
		//Uses WASD to move the camera
		if(event.keyCode == 68 && player.col < cols - 1 && tileMap._layers[1].data[player.row][player.col + 1] == null) { //D Right
			if(this.x - 64 <= 0 && this.x + (64 * cols) > Starling.current.stage.stageWidth && player.col >= 10) {
				moving = true;
				Starling.juggler.tween(this, .25, {
                        delay: 0.0,
                        x: this.x - 64,
                        onComplete: function() {
                        	moving = false;
        				}
        		});
			}
			if(player.col < cols - 1) {
				moving = true;
				player.move(64, 0);
			}
		}
		if(event.keyCode == 87 && player.row > 0 && tileMap._layers[1].data[player.row - 1][player.col] == null) { //W Up
			if(this.y + 64 <= 0 && this.y + (64 * rows) >= Starling.current.stage.stageHeight && player.row <= rows - 6) {
				moving = true;
				Starling.juggler.tween(this, .25, {
                        delay: 0.0,
                        y: this.y + 64,
                        onComplete: function() {
                        	moving = false;
        				}
        		});
			}
			if(player.row > 0) {
				moving = true;
				player.move(0, -64);
			}
		}
		if(event.keyCode == 65 && player.col > 0 && tileMap._layers[1].data[player.row][player.col - 1] == null) { //A Left
			if(this.x + 64 <= 0  && this.x + (64 * cols) >= Starling.current.stage.stageWidth && player.col <= cols - 10) {
				moving = true;
				Starling.juggler.tween(this, .25, {
                        delay: 0.0,
                        x: this.x + 64,
                        onComplete: function() {
                        	moving = false;
        				}
        		});
			}
			if(player.col > 0) {
				moving = true;
				player.move(-64, 0);
			}
		}
		if(event.keyCode == 83 && player.row < rows - 1 && tileMap._layers[1].data[player.row + 1][player.col] == null) { //S Down
			if(this.y - 64 <= 0 && this.y + (64 * rows) > Starling.current.stage.stageHeight && player.row >= 5) {
				moving = true;
				Starling.juggler.tween(this, .25, {
                        delay: 0.0,
                        y: this.y - 64,
                        onComplete: function() {
                        	moving = false;
        				}
        		});
			}
			if(player.row < rows - 1) {
				moving = true;
				player.move(0, 64);
			}
		}
	}
}