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
	public var music1:SoundChannel;
	public var menuSound = null;
	// using to grab in Game.hx instead of passing to constuctor or passing Root
	public static var current_player = "";

	public function new() {
		super();
	}

	public function start(startup:Startup) {

		assets = new AssetManager();
		assets.enqueue("assets/map.tmx");
		assets.enqueue("assets/lcTitle.png");
		assets.enqueue("assets/playerselect.png");
		assets.enqueue("assets/credits.png");
		assets.enqueue("assets/gameOver.png");
		
		assets.enqueue("assets/menuselect.mp3");
		assets.enqueue("assets/font.png");
		assets.enqueue("assets/font.fnt");
		assets.enqueue("assets/basicFont.png");
		assets.enqueue("assets/basicFont.fnt");
		assets.enqueue("assets/music1.mp3");
		assets.enqueue("assets/roar.mp3");
		assets.enqueue("assets/menu.mp3");
		assets.enqueue("assets/pickup.mp3");

		assets.enqueue("assets/assets.png");
		assets.enqueue("assets/assets.xml");
        
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
		if (menuSound == null) menuSound = assets.playSound("menu", 0, 1000);
		//Tween in menu
		Starling.juggler.tween(menu, 0.25, {
                    transition: Transitions.EASE_IN,
                        delay: 0.0,
                        alpha: 1.0
        });
	}
	
	public function addContinue(){
	
		var cScreen = new ContinueScreen();
		cScreen.alpha = 0;
		addChild(cScreen);
	}

	public function menuButtonClicked(event:Event) {
		var button = cast(event.target, Button);
		var menuSelect:SoundChannel = Root.assets.playSound("menuselect");
		menuSelect;
		if(button.name == "start") {
			selectPlayer();
		} 
		else if (button.name == "player2" || button.name == "player") {
			menuSound.stop();
		    assets.playSound("music1", 0, 10000);
			current_player = button.name;
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

	public function selectPlayer() {
		//Tween out menu
		Starling.juggler.tween(getChildAt(0), 0.25, {
				    transition: Transitions.EASE_OUT,
						delay: 0.0,
						alpha: 0.0,
						onComplete: function() {
					        removeChildAt(0);
						}
		});
		var playerSelect = new PlayerSelect();
		playerSelect.alpha = 0;
		addChild(playerSelect);
		//Tween in player selection screen
		Starling.juggler.tween(playerSelect, 0.25, {
					transition: Transitions.EASE_IN,
						delay: .25,
						alpha: 1.0
		});
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

		var menu = new Image(Root.assets.getTexture("lcTitle"));
		addChild(menu);

		startButton = new Button(Root.assets.getTexture("startbutton"));
		startButton.name = "start";
		startButton.x = 150;
		startButton.y = 150;
		startButton.downState = startButton.overState = Root.assets.getTexture("startbuttonhover");
		this.addChild(startButton);

		/*tutorialButton = new Button(Root.assets.getTexture("tutorialbutton"));
		tutorialButton.x = 250;
		tutorialButton.y = 300;
		tutorialButton.name = "tutorial";
		this.addChild(tutorialButton);*/

		creditsButton = new Button(Root.assets.getTexture("creditsbutton"));
		creditsButton.x = 150;
		creditsButton.y = 250;
		creditsButton.name = "credits";
		creditsButton.downState = creditsButton.overState = Root.assets.getTexture("creditsbuttonhover");
		this.addChild(creditsButton);
	}
}

class ContinueScreen extends Sprite {
	public var background:Image;
	public var nextButton: Button;

	public function  new() {
		super();

		background = new Image(Root.assets.getTexture("gameOver"));
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

		backButton.x = 570;
		backButton.y = 465;
		backButton.overState = Root.assets.getTexture("backbuttonhover");
		backButton.downState = Root.assets.getTexture("backbuttonhover");
	}
}

class PlayerSelect extends Sprite {

	public var bg:Image;
	public var backButton:Button;
	public var virginia:Button;
	public var samuel:Button;

	public function new() {
		super();

		backButton = new Button(Root.assets.getTexture("backbutton"));
		backButton.name = "back";
		virginia = new Button(Root.assets.getTexture("virginiabutton"));
		virginia.name = "player2";
		samuel = new Button(Root.assets.getTexture("samuelbutton"));
		samuel.name = "player";

		bg = new Image(Root.assets.getTexture("playerselect"));
		addChild(bg);
		this.addChild(backButton);
		this.addChild(virginia);
		this.addChild(samuel);

		backButton.x = 570;
		backButton.y = 465;
		backButton.overState = Root.assets.getTexture("backbuttonhover");
		backButton.downState = Root.assets.getTexture("backbuttonhover");

		virginia.x = 510;
		samuel.x = 690;
		virginia.y = samuel.y = 180;
		virginia.overState = virginia.downState = Root.assets.getTexture("virginiabuttonhover");
		samuel.overState = samuel.downState = Root.assets.getTexture("samuelbuttonhover");
	}
}
