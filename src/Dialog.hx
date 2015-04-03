import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.display.Button;
import starling.animation.Transitions;
import starling.events.Event;
import starling.core.Starling;
import starling.display.Image;
import starling.display.DisplayObject;
import starling.events.KeyboardEvent;
import starling.text.TextField;
import Game;

class DialogMaster extends Sprite {

	public var game:Game;

	 public function new() {
	 	super();
	 }
}

class Dialog extends DialogMaster {

	var image:Image;
	public var text:Array<String>;
	public var textField:TextField;
	public var currentSlide = 0;
	public var onComplete:String->Void;
	public var onCompleteParameter:String;

	public function new(game:Game, text:Array<String>, ?onComplete:String->Void, ?onCompleteParameter:String) {
		super();
		this.game = game;

		image = new Image(Root.assets.getTexture("dialog"));
		image.y = Starling.current.stage.stageHeight - 256;
		image.x = 0;
		addChild(image);

		this.text = text;
		this.onCompleteParameter = onCompleteParameter;
		this.onComplete = onComplete;

		textField = new TextField(1220, 116, text[0], "font", 20, 0xFFFFFF, false);
		textField.y = Starling.current.stage.stageHeight - 186;
		textField.x = 20;
		textField.hAlign = "left";
		textField.vAlign = "top";
		addChild(textField);


		addEventListener(KeyboardEvent.KEY_DOWN, change);
	}

	public function change(event:KeyboardEvent) {
		if(event.keyCode == 32) {
			if(this.currentSlide == this.text.length - 1) {
				destory();
			} else {
				next();
			}
		}
	}

	public function next() {
		currentSlide++;
		textField.text = text[currentSlide];
	}

	public function activate() {
		if(onCompleteParameter != null) {
			onComplete(onCompleteParameter);
		}
	}

	public function destory() {
		removeEventListeners();
		game.addEventListener(KeyboardEvent.KEY_DOWN, game.moveCamera);
		activate();
		game.dialogBuffer.pop();
		Starling.current.stage.removeChild(this);
	}
}

class Selection extends DialogMaster{

	public var options:Array<String>;
	public var current:Int = 0;
	public var functions:Array<String->Void>;
	public var textFields:Array<TextField>;

	public function new(game:Game, options:Array<String>, functions:Array<String->Void>) {
		super();
		this.game = game;

		var image = new Image(Root.assets.getTexture("dialog"));
		image.y = Starling.current.stage.stageHeight - 256;
		image.x = 0;
		addChild(image);

		this.options = options;
		this.functions = functions;

		textFields = new Array<TextField>();
		var i = 0;
		for(option in options) {
			var optionText = option;
			if(i == current) optionText = ">" + option; 
			var text = new TextField(260, 200, optionText, "font", 20, 0xFFFFFF, false);
			text.hAlign = "left";
			text.vAlign = "top";
			text.x  = 300 * i + 20;
			text.y = Starling.current.stage.stageHeight - 186;
			textFields.push(text);
			addChild(text);
			i++;
		}
		addEventListener(KeyboardEvent.KEY_DOWN, change);
	}

	public function change(event:KeyboardEvent) {
		if(event.keyCode == 32) {
			destory();
		} else if(event.keyCode == 39) {
			next();
		} else if(event.keyCode == 37) {
			previous();
		}
	}

	public function activate() {
		functions[current](options[current]);
	}

	public function destory() {
		activate();
		removeEventListeners();
		game.dialogBuffer.pop();
		game.addEventListener(KeyboardEvent.KEY_DOWN, game.moveCamera);
		Starling.current.stage.removeChild(this);
	}

	public function next() {
		if(current < options.length - 1) {
			var  i = 0;
			for(text in textFields) {
				text.bold = false;
				text.text = options[i];
				i++;
			}
			current++;
			textFields[current].text = ">" + textFields[current].text;
			textFields[current].bold = true;
		}
	}

	public function previous() {
		if(current > 0) {
			var  i = 0;
			for(text in textFields) {
				text.bold = false;
				text.text = options[i];
				i++;
			}
			current--;
			textFields[current].text = ">" + textFields[current].text;
			textFields[current].bold = true;
		}
	}
}

class DialogBuffer extends Sprite {

	public var buffer:Array<DialogMaster>;

	public function new() {
		super();
		buffer = new Array<DialogMaster>();
	}

	public function push(dialog:DialogMaster) {
		buffer.push(dialog);
	}

	public function pop() {
		var popped = buffer.pop();
		if(popped != null) {
			popped.game.removeEventListeners();
			Starling.current.stage.addChild(popped);
		}
	}
}