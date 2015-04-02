import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.display.Button;
import starling.animation.Transitions;
import starling.events.Event;
import starling.events.EnterFrameEvent;
import starling.core.Starling;
import starling.display.Image;
import starling.display.DisplayObject;
import starling.events.KeyboardEvent;
import starling.animation.Tween;
import starling.animation.IAnimatable;
import flash.geom.Rectangle;
import Tilemap;
import Player;
import Dialog;


class Game extends Sprite {

	var dialog:Dialog;
	var selection:Selection;
	var tileMap:Tilemap;
	var player:Player;
	var cols = 50;
	var rows = 50;
	var raptors:Array<Raptor>;
	var playerHealth = 3;

	var delay:IAnimatable;
	var healthBar1:Image;
	var healthBar2:Image;
	var healthBar3:Image;
	var healthBar4:Image;

	public function new() {
		super();
		createMap();

		player = new Player(Root.current_player);
		player.x = 64 * 10;
		player.y = 64 * 5;
		addChild(player);

		healthBar1 = new Image(Root.assets.getTexture("health1"));
		healthBar1.x = 0;
		healthBar1.y = 0;
		Starling.current.stage.addChild(healthBar1);

		healthBar2 = new Image(Root.assets.getTexture("health2"));
		healthBar2.x = 0;
		healthBar2.y = 0;

		healthBar3 = new Image(Root.assets.getTexture("health3"));
		healthBar3.x = 0;
		healthBar3.y = 0;

		healthBar4 = new Image(Root.assets.getTexture("health4"));
		healthBar4.x = 0;
		healthBar4.y = 0;

		
		//Move camera on keyboard event
		addEventListener(KeyboardEvent.KEY_DOWN, moveCamera);

		//Add Collision Listener
		Starling.current.stage.addEventListener(Event.ENTER_FRAME, checkCollision);

		// randomly spawn a bunch of raptors. kill all raptors to win!
		var raptors:Array<Raptor> = new Array<Raptor>();
		var raptor0 = new Raptor();
		raptors[0] = raptor0;
		createRaptor(raptor0);
		var raptor1 = new Raptor();
		raptors[1] = raptor1;
		createRaptor(raptor1);
		var raptor2 = new Raptor();
		raptors[2] = raptor2;
		createRaptor(raptor2);
		var raptor3 = new Raptor();
		raptors[3] = raptor3;
		createRaptor(raptor3);
		var raptor4 = new Raptor();
		raptors[4] = raptor4;
		createRaptor(raptor4);
		var raptor5 = new Raptor();
		raptors[5] = raptor5;
		createRaptor(raptor5);
		var raptor6 = new Raptor();
		raptors[6] = raptor6;
		createRaptor(raptor6);
		var raptor7 = new Raptor();
		raptors[7] = raptor7;
		createRaptor(raptor7);
		var raptor8 = new Raptor();
		raptors[8] = raptor8;
		createRaptor(raptor8);
		var raptor9 = new Raptor();
		raptors[9] = raptor9;
		createRaptor(raptor9);
		
		
		set_raptors(raptors);
		
		// randomly spawn the same number of missles, pick up a missle to kill raptor (press space to shoot missle)
		// createMissle();
		// createMissle();
		// createMissle();
		// createMissle();
		// createMissle();
		// createMissle();
		// createMissle();
		// createMissle();
		// createMissle();
		// createMissle();
		// createMissle();
		// createMissle();
		// createMissle();
		// createMissle();

		createDialog(["Press space to continue."]);

	}

	function checkHealth(){
		if (playerHealth == 3){
			Starling.current.stage.addChild(healthBar1);
		}
		if (playerHealth == 2){
			Starling.current.stage.addChild(healthBar2);
		}
		if (playerHealth == 1){
			Starling.current.stage.addChild(healthBar3);
		}
		if (playerHealth == 0){
			Starling.current.stage.addChild(healthBar4);
			removeChildren();
			removeEventListeners();
			this.x = 0;
			this.y = 0;
			var gameOver = new Image(Root.assets.getTexture("gameOver"));
			addChild(gameOver);
		}
	}

	function addCollision(){
		Starling.current.stage.addEventListener(Event.ENTER_FRAME, checkCollision);

	}

	function DelayedCall( ){

		if(playerHealth == 3){
			Starling.current.stage.removeChild(healthBar1);
		}
		if(playerHealth == 2){
			Starling.current.stage.removeChild(healthBar2);
		}
		if(playerHealth == 1){
			Starling.current.stage.removeChild(healthBar3);
		}
		if(playerHealth == 0){
			Starling.current.stage.removeChild(healthBar4);
		}
		playerHealth -= 1;
		checkHealth();
		delay = Starling.juggler.delayCall(addCollision, 2);
		
	}

	function checkCollision(event:EnterFrameEvent) {
		


		var i:Int = 0;
		var playerBounds:Rectangle = player.bounds;
		while(i<10){
			var raptorBounds:Rectangle = raptors[i].bounds;
			if (playerBounds.intersects(raptorBounds)){
				Root.assets.playSound("roar", 0, 0);
				Starling.current.stage.removeEventListener(Event.ENTER_FRAME, checkCollision);
				checkHealth();
				DelayedCall();



				
				
			}
			i = i+1;
		}
	}
	
	function set_raptors(newX:Array<Raptor>) {
		return raptors = newX;
	}
	
	// call this to randomly spawn a raptor
	public function createRaptor(raptor:Raptor){
		var rand = Math.ceil(Math.random()*720);
		var rand2 = Math.ceil(Math.random()*480);
		
		raptor.col = 6;
		raptor.row = 6;
		raptor.x = 6 * rand;
		raptor.y = 6 * rand2;
		raptor.route = [[6, 6], [6, 11], [6, 6], [11, 6]];
		addChild(raptor);
		raptor.patrol();
	}
	
	

	public function createMap() {
		tileMap = new Tilemap(Root.assets, "map");
		tileMap.y = 32;
		addChild(tileMap);
	}

	public function createDialog(text:Array<String>, ?event:String) {
		removeEventListeners();
		dialog = new Dialog(text, event);
		addChild(dialog);
		addEventListener(KeyboardEvent.KEY_DOWN, destroyDialog);
	}

	public function createSelection(options:Array<String>, functions:Array<String->Void>, ?event:String) {
		removeEventListeners();
		selection = new Selection(options, functions, event);
		addChild(selection);
		addEventListener(KeyboardEvent.KEY_DOWN, destroySelection);
	}

	public function destroySelection(event:KeyboardEvent) {
		if(event.keyCode == 32) {
			removeEventListeners();
			selection.activate();
			removeChild(selection);
			addEventListener(KeyboardEvent.KEY_DOWN, moveCamera);
			triggerEvent(selection.eventToBeTriggered);
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
				triggerEvent(dialog.eventToBeTriggered);
			} else {
				dialog.next();
			}
		}
	}

	public function triggerEvent(?event:String) {
		if(player.row == 5 && player.col == 5 && event == null) {
			createDialog(["This is a test dialog.", "Press space to continue..."], "selection");
		}
		if(player.row == 5 && player.col == 5 && event == "selection") {
			createSelection(["Option One", "Option Two"], [function (str:String) { trace(str); }, function (str:String) { trace(str); }], "done");
		}
	}

	public function moveCamera(event:KeyboardEvent) {
		/*
		var i:Int = 0;
		var playerBounds:Rectangle = player.bounds;
		while(i<10){
			var raptorBounds:Rectangle = raptors[i].bounds;
			if (playerBounds.intersects(raptorBounds)){
				removeChildren();
				removeEventListeners();
				Root.assets.playSound("roar", 0, 1);
				// Root.addContinue();
			}
			i = i+1;
		}
		*/
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
			player.move(0, 64, "");
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
		triggerEvent();
	}
}
