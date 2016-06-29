package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.scaleModes.PixelPerfectScaleMode;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxDestroyUtil;
import openfl.display.StageQuality;

enum RACERS {
	GOVE; 
	BORIS;
	MAY;
}

class PlayState extends FlxState
{
	var currentFunds:Float = 300;
	var currentFundsTextField:FlxText;
	var betMayButton:FlxButton;
	var betBorisButton:FlxButton;
	var betGoveButton:FlxButton;
	var bg:FlxSprite;
	var gove:Racer;
	var boris:Racer;
	var may:Racer;
	
	var racers:Array<Racer> = new Array();
	var isRunning:Bool = false;
	var gameOver:Bool = false;
	var wallet:Float = 10;
	var winner:EnumValue;
	var bettedOn:EnumValue;
	var winnerTextField:FlxText;
	var replayButton:FlxButton;
	var bettingButtons:Array<FlxButton>;
	var counter:Float;
	
	override public function create():Void
	{
		super.create();
		
		FlxG.cameras.bgColor = 0xff555555;
		FlxG.scaleMode = new PixelPerfectScaleMode();
		FlxG.stage.quality = StageQuality.BEST;
		
		this.init();
		this.addBg();
		this.addCharacters();
		this.addLabel();
		this.addButtons();
	}
	
	function init() 
	{
		if (FlxG.save.data.currentFunds == null) {
			FlxG.save.data.currentFunds = this.currentFunds;
		} else {
			this.currentFunds = FlxG.save.data.currentFunds;
		}
		
		this.counter = 0;
	}
	
	function addBg() 
	{
		bg = new FlxSprite(0, 0);
		bg.loadGraphic('assets/images/bg.jpg');
		add(bg);
	}
	
	function addCharacters() 
	{
		may = new Racer(17, 60, RACERS.MAY);
		may.loadGraphic('assets/images/may.png');
		add(may);

		boris = new Racer(17, 144, RACERS.BORIS);
		boris.loadGraphic('assets/images/boris.png');
		add(boris);

		gove = new Racer(17, 231, RACERS.GOVE);
		gove.loadGraphic('assets/images/gove.png');
		add(gove);
		
		racers.push(may);
		racers.push(boris);
		racers.push(gove);}
	
	function addLabel() 
	{
		currentFundsTextField = new FlxText(10, 450, 0);
		currentFundsTextField.setFormat("Font", 24, 0xffe1cac2, "center", FlxTextBorderStyle.SHADOW, 0xff1b1b1c);
		this.setFundsDisplay(this.currentFunds);
		add(currentFundsTextField);
	}
	
	function setFundsDisplay(funds:Float) {
		this.currentFundsTextField.text = 'Wallet: ' + funds;
	}
	
	function addButtons() 
	{
		var decisonMade = function() {
			this.isRunning = true;
			this.currentFunds -= 20;
			this.save();
			this.setFundsDisplay(this.currentFunds);
			FlxG.sound.playMusic("assets/music/cancan.ogg");
			
			bettingButtons.map(function(button:FlxButton) {
				this.remove(button);
				button.destroy();
			});
		};
		
		bettingButtons = new Array();
		
		betMayButton = new FlxButton(0, 0, 'THERESA MAY', function() {
			bettedOn = RACERS.MAY;
			decisonMade();
		});
		betMayButton.makeGraphic(100, 20, 0xFFCCCCCC);
		betMayButton.x = FlxG.width - betMayButton.width;
		betMayButton.y = FlxG.height - betMayButton.height;
		add(betMayButton);
		
		betBorisButton = new FlxButton(0, 0, 'BORIS JOHNSON', function() {
			bettedOn = RACERS.BORIS;
			decisonMade();
		});
		betBorisButton.makeGraphic(100, 20, 0xFFCCCCCC);
		betBorisButton.x = FlxG.width - (betBorisButton.width * 2);
		betBorisButton.y = FlxG.height - betBorisButton.height;
		add(betBorisButton);
		
		betGoveButton = new FlxButton(0, 0, 'MICHAEL GOVE', function() {
			bettedOn = RACERS.GOVE;
			decisonMade();
		});
		betGoveButton.makeGraphic(100, 20, 0xFFCCCCCC);
		betGoveButton.x = FlxG.width - (betGoveButton.width * 3);
		betGoveButton.y = FlxG.height - betGoveButton.height;
		add(betGoveButton);
		
		bettingButtons.push(betBorisButton);
		bettingButtons.push(betMayButton);
		bettingButtons.push(betGoveButton);
	}

	inline function getSpeed()
	{
		var speed:Float = 0;
		this.counter++;

		if (counter == 10) {
			counter = 0;
			speed = FlxG.random.float(0.1, 10);
			trace('changing speed to ' + speed);
		}

		return speed;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (isRunning && !gameOver) {
			
			racers.map(function(racer:Racer) {

				var speed:Float = this.getSpeed();

				if (speed > 0) {
					racer.x += speed;
					if (racer.x > (FlxG.width - racer.width)) {
						gameOver = true;
						winner = racer.getName();
					}
				}
			});
		}
		
		if (isRunning && gameOver) {
			isRunning = false;
			concludeResult();
		}
	}
	
	function save() {
		FlxG.save.data.currentFunds = this.currentFunds;
		FlxG.save.flush();
	}
	
	/**
	 * Save result
	 */
	function concludeResult() 
	{
		if (winner == bettedOn) {
			this.currentFunds += 100;
			this.save();			
		}
		
		this.setFundsDisplay(this.currentFunds);
		
		this.showWinner();
		this.addReplay();
	}
	
	function addReplay() 
	{
		replayButton = new FlxButton(0, 0, 'REPLAY', function() {
			FlxG.switchState(new PlayState());
		});
		replayButton.makeGraphic(100, 20, 0xFFCCCCCC);
		replayButton.x = FlxG.width / 2 - (this.replayButton.width / 2);
		replayButton.y = FlxG.height - 300;
		add(replayButton);
	}
	
	function showWinner() 
	{
		winnerTextField = new FlxText(
			0, FlxG.height / 2, FlxG.width, 
			this.didWin() + 'The winner is:\n ' + this.determineWinner().toUpperCase()
		);
		winnerTextField.setFormat("Font", 24, 0xffffffff, "center", FlxTextBorderStyle.NONE);
		add(winnerTextField);
	}
	
	function didWin():String
	{
		if (winner == bettedOn) {
			return 'YOU WON!\n';
		}
		
		return 'YOU LOST!\n';
	}
	
	function determineWinner():String
	{
		switch (winner)
		{
			case RACERS.BORIS:
				return 'Boris Johnson';
			case RACERS.GOVE:
				return 'Michael Gove';
			case RACERS.MAY:
				return 'Theresa May';
		}
		
		return 'No-one';
	}
	
	override public function destroy():Void 
	{
		FlxG.sound.pause();
		
		FlxDestroyUtil.destroy(currentFundsTextField);
		FlxDestroyUtil.destroy(betMayButton);
		FlxDestroyUtil.destroy(betBorisButton);
		FlxDestroyUtil.destroy(betGoveButton);
		FlxDestroyUtil.destroy(bg);
		FlxDestroyUtil.destroy(gove);
		FlxDestroyUtil.destroy(boris);
		FlxDestroyUtil.destroy(may);
		
		super.destroy();
	}
}
