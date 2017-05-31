package;

import enums.ClassType;
import enums.Position;
import enums.WeaponType;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.MouseEvent;
import openfl.display.SimpleButton;
import openfl.text.TextField;

/**
 * Player class for the game
 * @author Bogdan
 */
class Player extends Sprite
{
	public var position:Position;

	private var hand:Hand;
	private var classType:ClassType;
	private var primaryType:WeaponType;
	private var secondaryType:WeaponType;

	private var game:Game;
	private var health:Int = Constants.playerMaxHealth;
	private var textField:TextField = new TextField();
	private var nameTextField:TextField = new TextField();
	
	private var heart1:Bitmap;
	private var heart2:Bitmap;
	private var heart3:Bitmap;

	public function new(position:Position, classType:ClassType, primaryType:WeaponType, secondaryType:WeaponType)
	{
		super();
		game = Game.getInstance();

		this.position = position;
		this.classType = classType;
		this.primaryType = primaryType;
		this.secondaryType = secondaryType;

		nameTextField.defaultTextFormat = Main.playerTextFormat;
		
		// Calculate and positon myself
		calculatePostion();

		// Hand
		hand = new Hand(this);
		hand.y = -Constants.weaponCardHeight;
		addChild(hand);

		// Player Image
		var offset:Int = Math.round((Constants.weaponCardWidth * Constants.maxCardAmount) / 2.0);
		var playerImage:Bitmap = new Bitmap(Assets.getBitmapData("img/characters/" + Std.string(classType).toLowerCase() + ".png"));

		playerImage.width = Constants.playerIconSize;
		playerImage.height = Constants.playerIconSize;

		playerImage.x = offset;
		playerImage.y = -(Constants.playerIconSize + Constants.weaponIconHeight);

		addChild(playerImage);

		// Type background
		var playerBackground:Bitmap = new Bitmap(Assets.getBitmapData("img/player_types.png"));

		playerBackground.width = Constants.playerIconSize;
		playerBackground.height = Constants.weaponIconHeight;

		playerBackground.x = offset;
		playerBackground.y = -Constants.weaponIconHeight;

		addChild(playerBackground);

		// Primary
		var primaryImage:Bitmap = new Bitmap(Assets.getBitmapData("img/weapon/" + Std.string(primaryType).toLowerCase() + ".png"));

		primaryImage.width = Constants.playerWeaponIconWidth;
		primaryImage.height = Constants.playerWeaponIconHeight;

		primaryImage.x = offset;
		primaryImage.y = -Constants.playerWeaponIconHeight;

		addChild(primaryImage);

		// Primary
		var secondaryImage:Bitmap = new Bitmap(Assets.getBitmapData("img/weapon/" + Std.string(secondaryType).toLowerCase() + ".png"));

		secondaryImage.width = Constants.playerWeaponIconWidth;
		secondaryImage.height = Constants.playerWeaponIconHeight;

		secondaryImage.x = offset + Constants.playerWeaponIconWidth;
		secondaryImage.y = -Constants.playerWeaponIconHeight;

		addChild(secondaryImage);

		// Hearts
		heart1 = new Bitmap(Assets.getBitmapData("img/heart.png"));
		heart2 = new Bitmap(Assets.getBitmapData("img/heart.png"));
		heart3 = new Bitmap(Assets.getBitmapData("img/heart.png"));
		
		heart1.width = Constants.playerHeartSize;
		heart2.width = Constants.playerHeartSize;
		heart3.width = Constants.playerHeartSize;
		heart1.height = Constants.playerHeartSize;
		heart2.height = Constants.playerHeartSize;
		heart3.height = Constants.playerHeartSize;
		
		heart1.x = offset + Constants.playerIconSize;
		heart2.x = offset + Constants.playerIconSize;
		heart3.x = offset + Constants.playerIconSize;
		
		heart1.y = -(Constants.playerHeartSize * 1);
		heart2.y = -(Constants.playerHeartSize * 2);
		heart3.y = -(Constants.playerHeartSize * 3);
		
		addChild(heart1);
		addChild(heart2);
		addChild(heart3);
		
		nameTextField.width = 300;
		nameTextField.x = offset;
		nameTextField.y = -(Constants.playerIconSize + Constants.weaponIconHeight + 30); 
		nameTextField.text = Std.string(classType);
		
		addChild(nameTextField);
		
		// DEBUG
		/*
		textField.text = toString();
		textField.width = Constants.playerIconSize;
		textField.y = playerImage.y;
		textField.x = playerImage.x;
		textField.multiline = true;
		textField.wordWrap = true;
		textField.textColor = 0xFFFFFF;
		addChild(textField);
		*/
	}

	// Calculates the position and rotation ingame based on Postion
	private function calculatePostion()
	{
		switch (position)
		{
			case Position.Top:
				x = Math.round(Main.stageWidth / 2);
				y = 0;
				rotation = 180;
			case Position.Bottom:
				x = Math.round(Main.stageWidth / 2);
				y = Main.stageHeight;
				rotation = 0;
			case Position.Left:
				x = 0;
				y = Math.round(Main.stageHeight / 2);
				rotation = 90;
			case Position.Right:
				x = Main.stageWidth;
				y = Math.round(Main.stageHeight / 2);
				rotation = 270;
		}
	}

	// Damage the player
	public function damage(amount:Int)
	{
		if (health > 0) {
			health -= amount;
			drawHearts();
			textField.text = toString();
		}
	}

	// Heal the player
	public function heal(amount:Int)
	{
		if (health < Constants.playerMaxHealth)
		{
			health += amount;
			drawHearts();
			textField.text = toString();
		}
	}
	
	// Update the hearts show next to the player
	private function drawHearts() {
		removeChild(heart1);
		removeChild(heart2);
		removeChild(heart3);
		
		if (health >= 1) {
			addChild(heart1);
		}
		if (health >= 2) {
			addChild(heart2);
		}
		if (health >= 3) {
			addChild(heart3);
		}
	}

	// Returns true if player is dead and cannot play any cards
	public function isDead():Bool
	{
		return health <= 0;
	}

	// Returns classType
	public function getClassType():ClassType
	{
		return classType;
	}

	// Returns the primary weaponType
	public function getPrimaryType():WeaponType
	{
		return primaryType;
	}

	// Returns the secondary weaponType
	public function getSecondaryType():WeaponType
	{
		return secondaryType;
	}

	// Returns this player's hand
	public function getHand():Hand
	{
		return hand;
	}

	// debug stuff
	public override function toString():String
	{
		return '(position=$position, classType=$classType, primaryType=$primaryType, secondaryType=$secondaryType, health=$health)';
	}
}