import flash.media.Sound;
import flash.media.SoundChannel;
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
import starling.text.BitmapFont;
import starling.textures.Texture;
import flash.xml.XML;
import flash.ui.Keyboard;

class Root extends Sprite {

	public static var assets:AssetManager;
	public var game:Game;

	public function new() {
		super();
	}

	public function start(startup:Startup) {

		assets = new AssetManager();
		assets.enqueue("assets/startbutton.png");
		assets.enqueue("assets/continueButton.png");
		assets.enqueue("assets/tutorialbutton.png");
		assets.enqueue("assets/credits.png");
		assets.enqueue("assets/backbutton.png");
		assets.enqueue("assets/creditsbutton.png");
		assets.enqueue("assets/menu.png");
		assets.enqueue("assets/menubutton.png");
		assets.enqueue("assets/menuselect.mp3");
		assets.enqueue("assets/tutorialBackground.png");
		assets.enqueue("assets/gameover.png");
		assets.enqueue("assets/win.png");

		assets.loadQueue(function onProgress(ratio:Float) {
			
            if (ratio == 1) {

                Starling.juggler.tween(startup.loadingBitmap, 2.0, {
                    transition: Transitions.EASE_OUT,
                        delay: 1.0,
                        alpha: 0,
                        onComplete: function() {
                        	startup.removeChild(startup.loadingBitmap);
                        	addMenu();
                        	addEventListener(Event.TRIGGERED, menuButtonClicked);
               			}

                });
            }

        });
	}

	public function addMenu() {

		var menu = new Menu();
		menu.alpha = 0;
		addChild(menu);
		//Tween in menu
		Starling.juggler.tween(menu, 0.25, {
                    transition: Transitions.EASE_IN,
                        delay: 0.0,
                        alpha: 1.0
        });
	}

	public function menuButtonClicked(event:Event) {
		var button = cast(event.target, Button);
		var menuSelect:SoundChannel = Root.assets.playSound("menuselect");
		menuSelect;
		if(button.name == "start") {
			startGame();
		} 
		else if(button.name == "tutorial") {
			showTutorial();
		 }
		else if(button.name == "credits") {
			showCredits();
		} 
		else if(button.name == "next") {
		 	Starling.current.stage.removeEventListeners();
			removeChildAt(1);
		} 
		else if(button.name == "back") {
			Starling.juggler.tween(getChildAt(0), .25, {
                    transition: Transitions.EASE_OUT,
                        delay: 0.0,
                        alpha: 0.0,
                        onComplete: function() {
                        	removeChildAt(0);
        					}
        
        	});
			addMenu();
		}
		else if(button.name == "return"){
        	removeChildren();
        	addMenu();
        }
	}

	public function startGame() {
		//Tween out menu
		Starling.juggler.tween(getChildAt(0), 0.25, {
                    transition: Transitions.EASE_OUT,
                        delay: 0.0,
                        alpha: 0.0,
                        onComplete: function() {
                        	removeChildAt(0);
                        }
        });
		removeEventListeners();
		game = new Game();
		addChild(game);
	}

	public function showTutorial() {
		//Tween out the menu
		Starling.juggler.tween(getChildAt(0), 0.25, {
                    transition: Transitions.EASE_OUT,
                        delay: 0.0,
                        alpha: 0.0,
                        onComplete: function() {
                        	removeChildAt(0);
                        }
        });
		var tutorial = new Tutorial();
		tutorial.alpha = 0;
		addChild(tutorial);
		//Tween in tutorial screen
		Starling.juggler.tween(tutorial, 0.25, {
                    transition: Transitions.EASE_IN,
                        delay: .25,
                        alpha: 1.0
        });
	}

	public function showCredits() {
		//Tween out the menu
		Starling.juggler.tween(getChildAt(0), 0.25, {
                    transition: Transitions.EASE_OUT,
                        delay: 0.0,
                        alpha: 0.0,
                        onComplete: function() {
                        	removeChildAt(0);
                        }
        });
		var credits = new Credits();
		credits.alpha = 0;
		addChild(credits);
		//Tween in tutorial screen
		Starling.juggler.tween(credits, 0.25, {
                    transition: Transitions.EASE_IN,
                        delay: .25,
                        alpha: 1.0
        });
	}
}

class Menu extends Sprite {

	public var background:Image;
	public var startButton:Button;
	public var tutorialButton:Button;
	public var creditsButton:Button;

	public function new() {
		super();

		var menu = new Image(Root.assets.getTexture("menu"));
		addChild(menu);

		startButton = new Button(Root.assets.getTexture("startbutton"));
		startButton.name = "start";
		startButton.x = 250;
		startButton.y = 200;
		this.addChild(startButton);

		tutorialButton = new Button(Root.assets.getTexture("tutorialbutton"));
		tutorialButton.x = 250;
		tutorialButton.y = 300;
		tutorialButton.name = "tutorial";
		this.addChild(tutorialButton);

		creditsButton = new Button(Root.assets.getTexture("creditsbutton"));
		creditsButton.x = 250;
		creditsButton.y = 400;
		creditsButton.name = "credits";
		this.addChild(creditsButton);
	}
}

class ContinueScreen extends Sprite {
	public var background:Image;
	public var nextButton: Button;

	public function  new() {
		super();

		background = new Image(Root.assets.getTexture("continue"));
		addChild(background);

		nextButton = new Button(Root.assets.getTexture("continueButton"));
		nextButton.name = "next";
		nextButton.x = 250;
		nextButton.y = 300;
		this.addChild(nextButton);
	}
}

class Tutorial extends Sprite {

	public var background:Image;
	public var backButton:Button;
	public var tutorialBackground:Image;

	public function new() {
		super();

		backButton = new Button(Root.assets.getTexture("backbutton"));
		backButton.name = "back";
		tutorialBackground = new Image(Root.assets.getTexture("tutorialBackground"));
		addChild(tutorialBackground);
		this.addChild(backButton);

		backButton.x = 50;
		backButton.y = 520;
	}
}

class Credits extends Sprite {

	public var background:Image;
	public var backButton:Button;
	public var creditsBackground:Image;

	public function new() {
		super();

		backButton = new Button(Root.assets.getTexture("backbutton"));
		backButton.name = "back";
		creditsBackground = new Image(Root.assets.getTexture("credits"));
		addChild(creditsBackground);
		this.addChild(backButton);

		backButton.x = 50;
		backButton.y = 520;
	}
}

class GameOver extends Sprite {
	public var background:Image;
	public var returnButton:Button;

	public function new() {
		super();
	}
}