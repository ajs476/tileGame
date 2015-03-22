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

class Dialog extends Sprite {

	var image:Image;
	public var text:Array<String>;
	public var textField:TextField;
	public var currentSlide = 0;

	public function new(text:Array<String>) {
		super();

		image = new Image(Root.assets.getTexture("dialog"));
		image.y = Starling.current.stage.stageHeight - 256;
		addChild(image);

		this.text = text;

		textField = new TextField(1220, 116, text[0], "basicFont", 14, 0xFFFFFF, false);
		textField.y = Starling.current.stage.stageHeight - 186;
		textField.x = 20;
		textField.hAlign = "left";
		textField.vAlign = "top";
		addChild(textField);
	}

	public function next() {
		currentSlide++;
		textField.text = text[currentSlide];
	}
}

class Selection extends Sprite{

	public var options:Array<String>;
	public var current:Int = 0;
	public var functions:Array<String->Void>;
	public var textFields:Array<TextField>;

	public function new(options:Array<String>, functions:Array<String->Void>) {
		super();

		var image = new Image(Root.assets.getTexture("dialog"));
		image.y = Starling.current.stage.stageHeight - 256;
		addChild(image);

		this.options = options;
		this.functions = functions;

		textFields = new Array<TextField>();
		var i = 0;
		for(option in options) {
			var optionText = option;
			if(i == current) optionText = ":" + option; 
			var text = new TextField(100, 100, optionText, "basicFont", 14, 0xFFFFFF, false);
			text.x  = 120 * i + 20;
			text.y = Starling.current.stage.stageHeight - 186;
			textFields.push(text);
			addChild(text);
			i++;
		}
	}

	public function activate() {
		functions[current](options[current]);
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
			textFields[current].text = ":" + textFields[current].text;
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
			textFields[current].text = ":" + textFields[current].text;
			textFields[current].bold = true;
		}
	}
}