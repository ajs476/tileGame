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

class Raptor extends Sprite {

	public var image:Image;
	var animation:MovieClipPlus;
	var direction = "down";
	public var speed = .25;
	public var col:Int;
	public var row:Int;
	public var moving = false;
	public var route:Array<Array<Int>>;
	public var currentNode = 0;
	private var flag = false;

	public function new() {
		super();
		image = new Image(Root.assets.getTexture("raptor_down"));
		image.width = 64;
		image.height = 64;
		addChild(image);
		addEventListener("moveFinished", patrol);
	}

	public function patrol() {
		if(currentNode == route.length - 1) {
			currentNode = 0;
		} else {
			currentNode++;
		}
		var newLocation = route[currentNode];
		var dX = (newLocation[0] - col);
		var dY = (newLocation[1] - row);
		col = newLocation[0];
		row = newLocation[1];
		move(dX, dY);
	}

	public function move(dX:Int, dY:Int) {
		if(!moving) {
			removeChild(image);
	    	var direction = "";
	    	if(dX > 0) direction = "right";
	    	if(dX < 0) direction = "left";
	    	if(dY > 0) direction = "down";
	    	if(dY < 0) direction = "up";
	    	this.direction = direction;
	    	var atlas = Root.assets.getTextureAtlas("assets");
			animation = new MovieClipPlus(atlas.getTextures("raptor_walking_" + direction), 8);
			animation.loop = true;
			addChild(animation);
			animation.play();
			Starling.juggler.add(animation);
			moving = true;
			col += Std.int(dX / 64);
			row += Std.int(dY / 64);
			Starling.juggler.tween(this, Math.abs((dX + dY) * speed), {
	            delay: 0.0,
	            x: this.x + (dX * 64), 
	            y: this.y + (dY * 64),
	            onComplete: function() {
	            	removeChild(animation);
	            	moving = false;
	            	image = new Image(Root.assets.getTexture("raptor_" + direction));
	            	addChild(image);
	            	dispatchEvent(new Event("moveFinished"));
	            }
			});
		}
	}
}

class RaptorHandler {

	public function new(game:Game) {
		var raptor = new Raptor();
		raptor.speed = .4;
		raptor.col = 72;
		raptor.row = 81;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[72,81], [77, 81], [77, 78], [77, 81]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .4;
		raptor.col = 72;
		raptor.row = 72;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[72,72], [79, 72]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .4;
		raptor.col = 86;
		raptor.row = 68;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [86, 72]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .4;
		raptor.col = 81;
		raptor.row = 68;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [81, 72]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .4;
		raptor.col = 82;
		raptor.row = 63;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [82, 56], [87, 56], [82, 56]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .3;
		raptor.col = 79;
		raptor.row = 52;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [79, 45]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .3;
		raptor.col = 83;
		raptor.row = 42;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [83, 48]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .3;
		raptor.col = 42;
		raptor.row = 49;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [46, 49]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .3;
		raptor.col = 37;
		raptor.row = 57;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [53, 57]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .3;
		raptor.col = 53;
		raptor.row = 59;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [53, 64]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .3;
		raptor.col = 35;
		raptor.row = 61;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [42, 61], [42, 63], [35, 63]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .3;
		raptor.col = 40;
		raptor.row = 66;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [47, 66]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .3;
		raptor.col = 31;
		raptor.row = 85;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [37, 85]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .3;
		raptor.col = 34;
		raptor.row = 78;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [34, 83]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .3;
		raptor.col = 26;
		raptor.row = 69;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [32, 69]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .3;
		raptor.col = 32;
		raptor.row = 71;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [26, 71]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .3;
		raptor.col = 41;
		raptor.row = 71;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [41, 76], [43, 76], [43, 71]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .3;
		raptor.col = 56;
		raptor.row = 71;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [56, 75], [61, 75], [61, 71]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .3;
		raptor.col = 50;
		raptor.row = 76;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [54, 76]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .3;
		raptor.col = 37;
		raptor.row = 17;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [37, 20], [47, 20], [37, 20]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .25;
		raptor.col = 11;
		raptor.row = 10;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [13, 10], [13, 12], [13, 10]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .3;
		raptor.col = 52;
		raptor.row = 15;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [60, 15]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .3;
		raptor.col = 68;
		raptor.row = 24;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [68, 28], [66, 28], [68, 28]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .3;
		raptor.col = 79;
		raptor.row = 23;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [70, 23]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .2;
		raptor.col = 73;
		raptor.row = 11;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [80, 11], [80, 9], [80, 11]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .3;
		raptor.col = 31;
		raptor.row = 38;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [31, 42], [35, 42], [35, 38]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .3;
		raptor.col = 15;
		raptor.row = 81;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [21, 81], [21, 83], [15, 83]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .3;
		raptor.col = 15;
		raptor.row = 36;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [15, 42]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .3;
		raptor.col = 12;
		raptor.row = 87;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [14, 87], [14, 86], [17, 86], [14, 86], [14, 87]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();

		raptor = new Raptor();
		raptor.speed = .2;
		raptor.col = 17;
		raptor.row = 63;
		raptor.x = 64 * raptor.col;
		raptor.y = 64 * raptor.row;
		raptor.route = [[raptor.col,raptor.row], [22, 63]];
		game.raptors.push(raptor);
		game.addChild(raptor);
		raptor.patrol();
	}
}