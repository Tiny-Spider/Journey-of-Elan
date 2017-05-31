package;

import enums.Color;
import enums.WeaponType;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.events.MouseEvent;
import openfl.text.TextField;

/**
 * A holder class for the weapon card
 * Primarly holds card weaponType and color
 * @author Octavian
 */

class WeaponCard extends Sprite
{
	public var selected:Bool = false;

	private var color:Color;
	private var weaponType:WeaponType;

	public function new(weaponType:WeaponType, color:Color)
	{
		super();

		this.color = color;
		this.weaponType = weaponType;
	}

	// Returns the color
	public function getColor():Color
	{
		return color;
	}

	// Retuns the WeaponType
	public function getWeaponType():WeaponType
	{
		return weaponType;
	}

	// Draw this card with selected height and width
	public function draw(width:Int, height:Int)
	{
		var background:Bitmap;

		// Check which background to use
		switch (color)
		{
			case Color.Red:
				background = new Bitmap(Assets.getBitmapData("img/weapon/back_red.png"));
			case Color.Yellow:
				background = new Bitmap(Assets.getBitmapData("img/weapon/back_yellow.png"));
			case Color.Blue:
				background = new Bitmap(Assets.getBitmapData("img/weapon/back_blue.png"));
			case Color.Purple:
				background = new Bitmap(Assets.getBitmapData("img/weapon/back_purple.png"));
			case Color.Green:
				background = new Bitmap(Assets.getBitmapData("img/weapon/back_green.png"));
			case Color.Orange:
				background = new Bitmap(Assets.getBitmapData("img/weapon/back_orange.png"));
			default:
				background = new Bitmap(Assets.getBitmapData("img/weapon/back_gray.png"));
		}

		// Get the weapon image for this card
		var card:Bitmap = new Bitmap(Assets.getBitmapData("img/weapon/" + Std.string(weaponType).toLowerCase() + ".png"));

		// Set width & height
		card.width = width;
		card.height = height;
		
		background.width = width;
		background.height = height;
		
		// Add them
		addChild(background);
		addChild(card);
		
		// DEBUG
		/*
		var textField:TextField = new TextField();
		textField.text = toString();
		textField.width = Constants.weaponCardWidth;
		textField.y = -75;
		textField.textColor = 0xFFFFFF;
		textField.multiline = true;
		textField.wordWrap = true;
		addChild(textField);
		*/
	}
	
	// Check if two weapon cards are equal to eachother
	public function equals(weaponCard:WeaponCard):Bool
	{
		return weaponCard.color == color && weaponCard.weaponType == weaponType;
	}

	// Debug text
	public override function toString():String
	{
		return '(weaponType=$weaponType, color=$color, selected=$selected)';
	}
}