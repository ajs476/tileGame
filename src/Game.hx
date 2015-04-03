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
import Raptor;
import Dialog;


class Game extends Sprite {

	var tileMap:Tilemap;
	var player:Player;
	public var raptors = new Array<Raptor>();
	var items:Array<Image>;
	var cols = 99;
	var rows = 99;
	var eventFlags = [false, false, false, false, false, false, false, false, false, false, false];
	public var dialogBuffer:DialogBuffer;
	var playerHealth = 3;
	var gunpowderAmount = 0;

	var delay:IAnimatable;
	var healthBar1:Image;
	var healthBar2:Image;
	var healthBar3:Image;
	var healthBar4:Image;
	var raptorQueen:Image;
	var bones:Image;

	public function new() {
		super();
		createMap();
		items = new Array<Image>();

		player = new Player(Root.current_player);
		player.x = 64 * player.col;
		player.y = 64 * player.row;
		this.x = -64 * (player.col - 10);
		this.y = -64 * (player.row - 5);
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

		set_raptors();

		dialogBuffer = new DialogBuffer();
		addChild(dialogBuffer);
		

		//Add items
		var barrel = new Image(Root.assets.getTexture("barrel"));
		items.push(barrel);
		barrel.x = 64 * 90;
		barrel.y = 64 * 72;
		tileMap._layers[1].data[73][91] = new Tile();
		addChild(barrel);

		barrel = new Image(Root.assets.getTexture("barrel"));
		items.push(barrel);
		barrel.x = 64 * 82;
		barrel.y = 64 * 19;
		tileMap._layers[1].data[19][82] = new Tile();
		addChild(barrel);

		barrel = new Image(Root.assets.getTexture("barrel"));
		items.push(barrel);
		barrel.x = 64 * 10;
		barrel.y = 64 * 9;
		tileMap._layers[1].data[9][10] = new Tile();
		addChild(barrel);

		var note = new Image(Root.assets.getTexture("note"));
		items.push(note);
		note.x = 64 * 71;
		note.y = 64 * 76;
		tileMap._layers[1].data[76][71] = new Tile();
		addChild(note);

		var lighter = new Image(Root.assets.getTexture("lighter"));
		items.push(lighter);
		lighter.x = 64 * 37;
		lighter.y = 64 * 89;
		tileMap._layers[1].data[89][37] = new Tile();
		addChild(lighter);

		var boat = new Image(Root.assets.getTexture("boat"));
		boat.x = 64 * 79;
		boat.y = 64 * 96;
		addChild(boat);

		raptorQueen = new Image(Root.assets.getTexture("raptor_queen"));
		raptorQueen.x = 64 * 43;
		raptorQueen.y = 64 * 44;
		addChild(raptorQueen);

		bones = new Image(Root.assets.getTexture("bones"));
		bones.x = 64 * 42;
		bones.y = 64 * 56;
		addChild(bones);

		bones = new Image(Root.assets.getTexture("bones"));
		bones.x = 64 * 75;
		bones.y = 64 * 76;
		addChild(bones);

		triggerEvent();

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
			removeChildren();
			removeEventListeners();
			gameOver();
		}
		playerHealth -= 1;
		checkHealth();
		delay = Starling.juggler.delayCall(addCollision, 2);
		
	}

	function gameOver() {
		var gameOver = new Image(Root.assets.getTexture("gameOver"));
		cast(this.parent, Root).addChild(gameOver);
		cast(this.parent, Root).removeChild(this);
	}

	function checkCollision(event:EnterFrameEvent) {
		var playerBounds:Rectangle = player.bounds;
		for(i in 0...raptors.length){
			var raptorBounds:Rectangle = raptors[i].bounds;
			if (playerBounds.intersects(raptorBounds)){
				Root.assets.playSound("roar", 0, 0);
				Starling.current.stage.removeEventListener(Event.ENTER_FRAME, checkCollision);
				checkHealth();
				DelayedCall();
			}
		}
	}
	
	function set_raptors() {
		var raptorHandler = new RaptorHandler(this);
	}

	public function createMap() {
		tileMap = new Tilemap(Root.assets, "map");
		tileMap.y = 64;
		addChild(tileMap);
	}

	public function createDialog(text:Array<String>, ?onComplete:String->Void, ?onCompleteParameter:String) {
		removeEventListeners();
		var dialog = new Dialog(this, text, onComplete, onCompleteParameter);
		dialogBuffer.push(dialog);
	}

	public function createSelection(options:Array<String>, functions:Array<String->Void>) {
		removeEventListeners();
		var selection = new Selection(this, options, functions);
		dialogBuffer.push(selection);
	}

	public function triggerEvent() {

		//Events are triggered by a condition of some kind
		//Dialog and Selection screens should then be created in reverse order, as they are added to a stack
		if(((player.row == 72 && player.col == 89)) && eventFlags[0] == false) {
			//Selections take an array of options and an array of functions to run for each option
			createSelection(["Pick up the gunpowder", "Walk away"], [function (str:String) { createDialog(["You pick up the gunpowder."]); removeChild(items[0]); tileMap._layers[1].data[73][91] = null; player.inventory.push(str); eventFlags[0] = true; gunpowderAmount++; Root.assets.playSound("pickup"); playerHealth++; checkHealth(); }, function (str:String) { createDialog(["You walk away."]); }]);
			//Dialogs take an array of strings to display, a function to run on completion, and a string parameter to be passed to that function
			createDialog(["Its a barrel of gunpowder."]);
			//Pop the first thing off the buffer to start the dialog sequence
			dialogBuffer.pop();
		}

		//Second Barrel
		if(((player.row == 20 && player.col == 81)) && eventFlags[1] == false) {
			createSelection(["Pick up the gunpowder", "Walk away"], [function (str:String) { createDialog(["You pick up the gunpowder."]); removeChild(items[1]); tileMap._layers[1].data[19][82] = null; player.inventory.push(str); eventFlags[1] = true; gunpowderAmount++; Root.assets.playSound("pickup"); playerHealth++; checkHealth(); }, function (str:String) { createDialog(["You walk away."]); }]);
			createDialog(["Its a barrel of gunpowder."]);
			dialogBuffer.pop();
		}

		//Third Barrel
		if(((player.row == 9 && player.col == 11) ||  (player.row == 10 && player.col == 11) ||  
			(player.row == 10  && player.col == 10)) && eventFlags[2] == false) {
			createSelection(["Pick up the gunpowder", "Walk away"], [function (str:String) { createDialog(["You pick up the gunpowder."]); removeChild(items[2]); tileMap._layers[1].data[9][10] = null; player.inventory.push(str); eventFlags[2] = true; gunpowderAmount++; Root.assets.playSound("pickup"); playerHealth++; checkHealth(); }, function (str:String) { createDialog(["You walk away."]); }]);
			createDialog(["Its a barrel of gunpowder."]);
			dialogBuffer.pop();
		}

		//Lighter
		if(((player.row == 89 && player.col == 36) ||  (player.row == 88 && player.col == 36) ||  
			(player.row == 88  && player.col == 37)) && eventFlags[2] == false) {
			createSelection(["Pick up the lighter", "Walk away"], [function (str:String) { createDialog(["You pick up the lighter."]); removeChild(items[4]); tileMap._layers[1].data[89][37] = null; player.inventory.push("lighter"); eventFlags[10] = true; Root.assets.playSound("pickup"); playerHealth++; checkHealth();}, function (str:String) { createDialog(["You walk away."]); }]);
			createDialog(["Its a colonial era lighter."]);
			dialogBuffer.pop();
		}

		//Raptor Queen's Lair
		if(((player.row == 56 && player.col == 45) ||  (player.row == 56 && player.col == 46)) && eventFlags[3] == false) {
			if(gunpowderAmount == 3 && player.inventory.indexOf("lighter") != -1) {
				tileMap._layers[1].data[45][55] = null;
				tileMap._layers[1].data[46][55] = null;
				createSelection(["Go back.", "Continue Ahead."], [function (str:String) { }, function (str:String) { }]);
				createDialog(["This path leads to the raptor queen's lair.", "Are you ready to face her?"]);
				eventFlags[3] = true;

			} else {
				createSelection(["Go back."], [function (str:String) { tileMap._layers[1].data[55][46] = new Tile(); tileMap._layers[1].data[55][46] = new Tile(); }]);
				createDialog(["This path leads to the raptor queen's lair.", "You don't look ready to face the raptor queen, perhaps you should wait until you are better prepared."]);
			}
			dialogBuffer.pop();
		}

		//Raptor Appearance
		if(((player.row == 85 && player.col == 78) ||  (player.row == 85 && player.col == 79)) && eventFlags[4] == false) {
			createDialog(["Is that a velociraptor! What is a velociraptor doing on Roanoke Island.", "Perhaps it has something to do with the missing colonists."]);
			eventFlags[4] = true;
			dialogBuffer.pop();
		}

		//Intro Scene
		if(eventFlags[5] == false) {
			createDialog(["The year is fifteen eighty seven...\nYou are a member of John White's expedition to the colony on Roanoke Island.", "Three years ago, a colony was established on this island.\nSince then all contact with the colonists has been lost.", "It's up to you to discover the truth of Roanoke Island and find out what happened to the colonists."]);
			eventFlags[5] = true;
			dialogBuffer.pop();
		}

		//Note
		if(((player.row == 77 && player.col == 72) ||  (player.row == 75 && player.col == 72) ||  
			(player.row == 76 && player.col == 72)) && eventFlags[6] == false) {
			createSelection(["Read the note.", "Leave it alone."], [function (str:String) { eventFlags[6] = true; createDialog(["The note reads:\nTo anyone who finds this, you must flee. The island has been over run by velociraptors.", "I don't have much time. We won't be able to hold them off for much longer. If anyone finds this note, it is probable that we have all been eaten.", "While it may be too late to save us, you could still defeat the raptor queen. The queen's lair is at the center of the island. You should be able to find some weapons to defeat her around the island."]); removeChild(items[3]); }, function (str:String) { }]);
			createDialog(["It's a note!"]);
			dialogBuffer.pop();
		}

		//Place barrel 1
		if(((player.row == 46 && player.col == 46) || (player.row == 45 && player.col == 47)) && eventFlags[7] == false) {
			var barrel = new Image(Root.assets.getTexture("barrel"));
			barrel.x = 64 * 47;
			barrel.y = 64 * 46;
			addChild(barrel);
			eventFlags[7] = true;
		}

		//Place barrel 2
		if(((player.row == 44 && player.col == 46) || (player.row == 45 && player.col == 47) || (player.row == 43 && player.col == 45)) && eventFlags[8] == false) {
			var barrel = new Image(Root.assets.getTexture("barrel"));
			barrel.x = 64 * 46;
			barrel.y = 64 * 43;
			addChild(barrel);
			eventFlags[8] = true;
		}

		//Place barrel 3
		if(((player.row == 46 && player.col == 42)  || (player.row == 45 && player.col == 43)  || (player.row == 44 && player.col == 42)) && eventFlags[9] == false) {
			var barrel = new Image(Root.assets.getTexture("barrel"));
			barrel.x = 64 * 42;
			barrel.y = 64 * 45;
			addChild(barrel);
			eventFlags[9] = true;
		}

		//Defeat raptor Queen
		if(eventFlags[7] && eventFlags[8] && eventFlags[9]) {
			//Raptor Queen dies
			var atlas = Root.assets.getTextureAtlas("assets");
			var animation1 = new MovieClipPlus(atlas.getTextures("explosion"), 5);
			animation1.x = 64 * 46;
			animation1.y = 64 * 43;
			animation1.loop = false;
			addChild(animation1);

			var animation2 = new MovieClipPlus(atlas.getTextures("explosion"), 5);
			animation2.x = 64 * 47;
			animation2.y = 64 * 46;
			animation2.loop = false;
			addChild(animation2);

			var animation3 = new MovieClipPlus(atlas.getTextures("explosion"), 5);
			animation3.x = 64 * 42;
			animation3.y = 64 * 45;
			animation3.loop = false;
			addChild(animation3);


			animation1.play();
			Starling.juggler.add(animation1);
			animation2.play();
			Starling.juggler.add(animation2);
			animation3.play();
			Starling.juggler.add(animation3);

			Starling.juggler.delayCall(win, 2);			
		}
	}

	public function win() {
		removeEventListeners();
		createDialog(["You killed the raptor queen! "]);
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
			triggerEvent();
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
			triggerEvent();
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
			triggerEvent();
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
			triggerEvent();
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
			triggerEvent();
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
			triggerEvent();
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
			triggerEvent();
		}
	}
}
