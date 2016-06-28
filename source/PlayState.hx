package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.scaleModes.PixelPerfectScaleMode;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import openfl.display.StageQuality;

enum RACERS = {
	GOVE, BORIS, MAY
}

class PlayState extends FlxState
{
	var currentFunds:FlxText;
	var betButton:FlxButton;
	var bg:FlxSprite;
	var gove:FlxSprite;
	var boris:FlxSprite;
	var may:FlxSprite;
	var racers:Array<FlxSprite> = new Array();
	
	var isRunning:Bool = false;
	var gameOver:Bool = false;
	var wallet:Float = 10;
	var winner:String = '';
	
	override public function create():Void
	{
		super.create();
		
		FlxG.cameras.bgColor = 0xff555555;
		FlxG.scaleMode = new PixelPerfectScaleMode();
		FlxG.stage.quality = StageQuality.BEST;
		
		this.addBg();
		this.addCharacters();
		this.addLabel();
		this.addButton();
	
	}
	
	function addBg() 
	{
		bg = new FlxSprite(0, 0);
		bg.loadGraphic('assets/images/bg.jpg');
		add(bg);
	}
	
	function addCharacters() 
	{
		may = new FlxSprite(17, 60);
		may.loadGraphic('assets/images/may.png');
		add(may);

		boris = new FlxSprite(17, 144);
		boris.loadGraphic('assets/images/boris.png');
		add(boris);

		gove = new FlxSprite(17, 231);
		gove.loadGraphic('assets/images/gove.png');
		add(gove);
		
		racers.push(may);
		racers.push(boris);
		racers.push(gove);}
	
	function addLabel() 
	{
		currentFunds = new FlxText(10, FlxG.height, 0, "PLACE YOUR BETS ON THE NEW PRIME MINISTER");
		currentFunds.setFormat("Font", 24, 0xffe1cac2, "center", FlxTextBorderStyle.SHADOW, 0xff1b1b1c);
		add(currentFunds);
	}
	
	function addButton() 
	{
		betButton = new FlxButton(0, 0, 'BET', function() {
			isRunning = true;
		});
		betButton.x = FlxG.width - betButton.width;
		betButton.y = FlxG.height - betButton.height;
		add(betButton);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (isRunning && !gameOver) {
			
			racers.map(function(racer) {
				racer.x += FlxG.random.float(0.1, 5);
				if (racer.x > (FlxG.width - racer.width)) {
					gameOver = true;
				}
			}
		});
	}
}
