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
import flash.geom.Rectangle;
import Tilemap;
import Player;
import Dialog;

class Game extends Sprite {

	var dialog:Dialog;
	var selection:Selection;
	var tileMap:Tilemap;
	var player:Player;
	var raptor:Raptor;
	var cols = 50;
	var rows = 50;

	public function new() {
		super();
		createMap();

		player = new Player();
		player.x = 64 * 10;
		player.y = 64 * 5;
		addChild(player);

		//Move camera on keyboard event
		addEventListener(KeyboardEvent.KEY_DOWN, moveCamera);

		var raptor = new Raptor();
		raptor.col = 6;
		raptor.row = 6;
		raptor.x = 6 * 64;
		raptor.y = 6 * 64;
		raptor.route = [[6, 6], [6, 11], [6, 6], [11, 6]];
		addChild(raptor);
		raptor.patrol();

		createDialog(["This is a test.", "Press space to continue."]);

	}

	public function createMap() {
		tileMap = new Tilemap(Root.assets, "map");
		tileMap.y = 32;
		addChild(tileMap);
	}

	public function createDialog(text:Array<String>) {
		removeEventListeners();
		dialog = new Dialog(text);
		addChild(dialog);
		addEventListener(KeyboardEvent.KEY_DOWN, destroyDialog);
	}

	public function createSelection(options:Array<String>) {
		removeEventListeners();
		var functions = [function(str:String) { trace(str); }, function(str:String) { trace(str); }];
		selection = new Selection(options, functions);
		addChild(selection);
		addEventListener(KeyboardEvent.KEY_DOWN, destroySelection);
	}

	public function destroySelection(event:KeyboardEvent) {
		if(event.keyCode == 32) {
			removeEventListeners();
			selection.activate();
			removeChild(selection);
			addEventListener(KeyboardEvent.KEY_DOWN, moveCamera);
		} else if(event.keyCode == 39) {
			selection.next();
		} else if(event.keyCode == 37) {
			selection.previous();
		}
	}

	public function destroyDialog(event:KeyboardEvent) {
		if(event.keyCode == 32) {
			if(dialog.currentSlide == dialog.text.length - 1) {
				removeEventListeners();
				removeChild(dialog);
				addEventListener(KeyboardEvent.KEY_DOWN, moveCamera);
			} else {
				dialog.next();
			}
		}
	}

	public function moveCamera(event:KeyboardEvent) {
		if(player.moving) {
			return;
		}
		//Uses WASD to move the camera
		if(event.keyCode == 68 && player.col < cols - 1 && tileMap._layers[1].data[player.row][player.col + 1] == null) { //D Right
			if(this.x - 64 <= 0 && this.x + (64 * cols) > Starling.current.stage.stageWidth && player.col >= 10) {
				player.moving = true;
				Starling.juggler.tween(this, .25, {
                        delay: 0.0,
                        x: this.x - 64,
                        onComplete: function() {
                        	player.moving = false;
        				}
        		});
			}
			player.move(64, 0);
		}
		// D Right  -- change direction of player when hitting an obstacle
		else if (event.keyCode == 68) {
			Starling.juggler.tween(this, .25, { 
					delay: 0.0, 
					y: this.y, 
					onComplete: function() { 
						player.moving = false; 
					}
			});
			player.move(0, 0, "right");
		}
		if(event.keyCode == 87 && player.row > 0 && tileMap._layers[1].data[player.row - 1][player.col] == null) { //W Up
			if(this.y + 64 <= 0 && /*this.y + (64 * rows) >= Starling.current.stage.stageHeight &&*/ player.row <= rows - 6) { //commented section because it was causing problems with camera moving up when you are near bottom of map
				Starling.juggler.tween(this, .25, {
                        delay: 0.0,
                        y: this.y + 64,
                        onComplete: function() {
                        	player.moving = false;
        				}
        		});
			}
			player.move(0, -64);
		}
		// W Up -- change direction of player when hitting an obstacle
		else if (event.keyCode == 87) {
			Starling.juggler.tween(this, .25, { 
					delay: 0.0, 
					y: this.y, 
					onComplete: function() { 
						player.moving = false; 
					}
			});
			player.move(0, 0, "up");
		}
		if(event.keyCode == 65 && player.col > 0 && tileMap._layers[1].data[player.row][player.col - 1] == null) { //A Left
			if(this.x + 64 <= 0  && this.x + (64 * cols) >= Starling.current.stage.stageWidth && player.col <= cols - 10) {
				Starling.juggler.tween(this, .25, {
                        delay: 0.0,
                        x: this.x + 64,
                        onComplete: function() {
                        	player.moving = false;
        				}
        		});
			}
			player.move(-64, 0);
		}
		// A Left -- change direction of player when hitting an obstacle
		else if (event.keyCode == 65) {
			Starling.juggler.tween(this, .25, { 
					delay: 0.0, 
					y: this.y, 
					onComplete: function() { 
						player.moving = false; 
					}
			});
			player.move(0, 0, "left");
		}
		if(event.keyCode == 83 && player.row < rows - 1 && tileMap._layers[1].data[player.row + 1][player.col] == null) { //S Down
			if(this.y - 64 <= 0 && this.y + (64 * rows) > Starling.current.stage.stageHeight && player.row >= 5) {
				Starling.juggler.tween(this, .25, {
                        delay: 0.0,
                        y: this.y - 64,
                        onComplete: function() {
                        	player.moving = false;
        				}
        		});
			}
			player.move(0, 64);
		}
		// S Down -- change direction of player when hitting an obstacle
		else if (event.keyCode == 83) {
			Starling.juggler.tween(this, .25, { 
					delay: 0.0, 
					y: this.y, 
					onComplete: function() { 
						player.moving = false; 
					}
			});
			player.move(0, 0, "down");
		}
	}
}
