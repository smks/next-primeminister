package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * @author Shaun Stone
 */
class Racer extends FlxSprite
{
	var name:EnumValue;

	public function new(X:Float, Y:Float, name:EnumValue) 
	{
		this.name = name;
		super(X, Y);
	}
	
	public function getName():EnumValue
	{
		return this.name;
	}
	
}