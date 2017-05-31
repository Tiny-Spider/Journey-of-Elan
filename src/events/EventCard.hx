package events;

import openfl.geom.Point;
import openfl.text.TextField;
import utilities.Random;
import enums.EventType;
import openfl.display.Sprite;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.MouseEvent;
import enums.*;
import motion.Actuate;

/**
 * Class that manages everything a event card can do
 * @author Mark
 */
class EventCard extends Sprite
{
	public var type:EventType;
	public var tier:Int;
	public var lane:Int;
	public var requireCards:Bool = false;
	public var open:Bool = false;

	private var requiredCards:Array<WeaponCard>;
	private var attacks:Array<ClassType>;
	private var trapType:TrapType;
	private var chestType:ChestType;
	public var explored:Bool = false;
	public var first:Bool = true;
	public var wasOpen:Bool = false;

	private var game:Game;

	// Images of the card
	private var cardBack:Bitmap = new Bitmap(Assets.getBitmapData("img/events/card_back.png"));
	private var cardBackground:Bitmap;
	private var cardOverlay:Bitmap;
	
	private var titleField:TextField = new TextField();
	private var descriptionField:TextField = new TextField();

	public function new(type:EventType, tier:Int)
	{
		super();

		this.type = type;
		this.tier = tier;

		game = Game.getInstance();
		generateEvent();
		
		// Set title field varibles
		titleField.width = Constants.eventCardOpenWidth;
		titleField.height = Constants.eventCardOpenHeight / 4;
		titleField.selectable = false;
		titleField.defaultTextFormat = Main.titleTextFormat;
		titleField.y = -Constants.eventCardOpenHeight / 2;
		titleField.x = -Constants.eventCardOpenWidth / 2;
		
		// Set description field varibles
		descriptionField.width = Constants.eventCardOpenWidth;
		descriptionField.height = Constants.eventCardOpenHeight / 4;
		descriptionField.selectable = false;
		descriptionField.y = Constants.eventCardOpenHeight / 2 - 40;
		descriptionField.x = -Constants.eventCardOpenWidth / 2;
		descriptionField.defaultTextFormat = Main.descriptionTextFormat;
	}

	// Generate all required data based on EvenType
	private function generateEvent()
	{	
		switch (type)
		{
			case EventType.Battle:

				titleField.text = "Battle";
				
				requireCards = true;
				requiredCards = [];
				attacks = [];
				
				cardBackground = new Bitmap(Assets.getBitmapData(Random.randomValue(["img/events/advance_path.png", "img/events/desert.png", "img/events/lava.png", "img/events/mystic_forest.png"])));
				cardOverlay = new Bitmap(Assets.getBitmapData("img/events/enemies/" + Random.random(1, 6) + ".png"));

				// Add increasingly more difficult enemies
				switch (tier)
				{
					case 0:
						requiredCards.push(new WeaponCard(Random.randomEnum(WeaponType), Random.randomValue([Color.Red, Color.Blue, Color.Yellow])));
						requiredCards.push(new WeaponCard(Random.randomEnum(WeaponType), Random.randomValue([Color.Red, Color.Blue, Color.Yellow])));
						attacks.push(Random.randomEnum(ClassType));
					case 1:
						requiredCards.push(new WeaponCard(Random.randomEnum(WeaponType), Random.randomValue([Color.Red, Color.Blue, Color.Yellow])));
						requiredCards.push(new WeaponCard(Random.randomEnum(WeaponType), Random.randomEnum(Color)));
						attacks.push(Random.randomEnum(ClassType));
						attacks.push(Random.randomEnum(ClassType));
					case 2:
						requiredCards.push(new WeaponCard(Random.randomEnum(WeaponType), Random.randomValue([Color.Red, Color.Blue, Color.Yellow])));
						requiredCards.push(new WeaponCard(Random.randomEnum(WeaponType), Random.randomEnum(Color)));
						requiredCards.push(new WeaponCard(Random.randomEnum(WeaponType), Random.randomEnum(Color)));
						attacks.push(Random.randomEnum(ClassType));
						attacks.push(Random.randomEnum(ClassType));
					default:
						requiredCards.push(new WeaponCard(WeaponType.Sword, Color.Red));
						attacks.push(Random.randomEnum(ClassType));
				}
				
				descriptionField.text = "Enemy will attack " + attacks + " for 1 damage!";
				
			case EventType.Chest:

				titleField.text = "Treasure";
				
				chestType = Random.randomEnum(ChestType);
				cardBackground = new Bitmap(Assets.getBitmapData(Random.randomValue(["img/events/advance_path.png", "img/events/desert.png", "img/events/lava.png", "img/events/mystic_forest.png"])));
				cardOverlay = new Bitmap(Assets.getBitmapData("img/events/chest.png"));
				
				// Show right text based on ChestType
				switch(chestType) {
					case ChestType.Health:
						descriptionField.text = "All players gain +1 health";
				}

			case EventType.Trap:

				titleField.text = "Trap";

				trapType = Random.randomEnum(TrapType);
				cardBackground = new Bitmap(Assets.getBitmapData(Random.randomValue(["img/events/advance_path.png", "img/events/desert.png", "img/events/lava.png", "img/events/mystic_forest.png"])));
				cardOverlay = new Bitmap(Assets.getBitmapData("img/events/trap.png"));
				
				// Show right text based on TrapType
				switch(trapType) {
					case TrapType.LoseCard:
						descriptionField.text = "All players lose 1 card";
					case TrapType.Shuffle:
						descriptionField.text = "All cards are shuffeled";
				}

			case EventType.Advance:

				titleField.text = "Advance";
				descriptionField.text = "You advance forward: tier +1";
				
				cardBackground = new Bitmap(Assets.getBitmapData(Random.randomValue(["img/events/advance_path.png", "img/events/desert.png", "img/events/lava.png", "img/events/mystic_forest.png"])));

			case EventType.Obstacle:

				titleField.text = "Obstacle";
				descriptionField.text = "Something is blocking your way";

				requireCards = true;
				requiredCards = [];
				
				cardBackground = new Bitmap(Assets.getBitmapData(Random.randomValue(["img/events/advance_path.png", "img/events/desert.png", "img/events/lava.png", "img/events/mystic_forest.png"])));
				cardOverlay = new Bitmap(Assets.getBitmapData("img/events/obstacles/" + Random.random(1, 3) + ".png"));

				// Increasingly more requirements based on tier
				switch (tier)
				{
					case 0:
						requiredCards.push(new WeaponCard(Random.randomEnum(WeaponType), Random.randomValue([Color.Red, Color.Blue, Color.Yellow])));
						requiredCards.push(new WeaponCard(Random.randomEnum(WeaponType), Random.randomValue([Color.Red, Color.Blue, Color.Yellow])));
					case 1:
						requiredCards.push(new WeaponCard(Random.randomEnum(WeaponType), Random.randomValue([Color.Red, Color.Blue, Color.Yellow])));
						requiredCards.push(new WeaponCard(Random.randomEnum(WeaponType), Random.randomEnum(Color)));
					case 2:
						requiredCards.push(new WeaponCard(Random.randomEnum(WeaponType), Random.randomValue([Color.Red, Color.Blue, Color.Yellow])));
						requiredCards.push(new WeaponCard(Random.randomEnum(WeaponType), Random.randomValue([Color.Red, Color.Blue, Color.Yellow])));
						requiredCards.push(new WeaponCard(Random.randomEnum(WeaponType), Random.randomValue([Color.Green, Color.Orange, Color.Purple])));
					default:
						requiredCards.push(new WeaponCard(WeaponType.Sword, Color.Red));
				}
			case EventType.Nothing:

				titleField.text = "Camping Spot";
				descriptionField.text = "Time to get some rest";
				
				cardBackground = new Bitmap(Assets.getBitmapData(Random.randomValue(["img/events/advance_path.png", "img/events/desert.png", "img/events/lava.png", "img/events/mystic_forest.png"])));
				cardOverlay = new Bitmap(Assets.getBitmapData("img/events/rest.png"));
				
			default:

				titleField.text = "Unknown";
				descriptionField.text = "How the fuck did you get this one";
				
				cardBackground = new Bitmap(Assets.getBitmapData(Random.randomValue(["img/events/advance_path.png", "img/events/desert.png", "img/events/lava.png", "img/events/mystic_forest.png"])));
		}
	}

	// Active the event card, takes a list as cards players have played for this (can be null)
	public function activate(cards:List<WeaponCard>)
	{
		explored = true;

		switch (type)
		{
			case EventType.Battle:

				// If all required cards are provided
				if (!checkRequiredCards(cards))
				{
					// Damage each player defined by ClassType in attacks
					for (attack in attacks)
					{
						Lambda.find(game.players, function(player) { return player.getClassType() == attack; }).damage(1);
					}

					// Wait a second before returning to game (failing)
					Actuate.timer(1).onComplete(game.onEventCardFailed, [this]);
					return;
				}
				
				// Wait 1 second and fade out and call complete function
				Actuate.tween(this, 0.5, {__alpha:0}).delay(1).onComplete(game.onEventCardComplete, [this]);
				return;

			case EventType.Obstacle:

				// If all required cards are provided
				if (!checkRequiredCards(cards))
				{
					// Wait a second before returning to game (failing)
					Actuate.timer(1).onComplete(game.onEventCardFailed, [this]);
					return;
				}
				
				// Wait 1 second and fade out and call complete function
				Actuate.tween(this, 0.5, {__alpha:0}).delay(1).onComplete(game.onEventCardComplete, [this]);
				return;

			case EventType.Chest:

				switch (chestType)
				{
					case ChestType.Health:
						// Heal all players by one
						for (player in game.players) {
							player.heal(1);
						}
						
					default:
				}

			case EventType.Trap:

				switch (trapType)
				{
					case TrapType.Shuffle:

						// Array that will contain all cards from all players
						var allCards:Array<WeaponCard> = new Array();

						for (player in game.players)
						{
							// Take all the players their cards and merge them with existing allCards array
							allCards = Lambda.array(Lambda.concat(allCards, player.getHand().takeAllCards()));
						}

						// Shuffle array
						allCards = Random.randomizeArray(allCards);

						// Deal cards evenly to all players
						for (i in 0...allCards.length)
						{
							var player:Player = game.players[i % 4];
							player.getHand().giveCard(allCards[i]);
						}

						// Make sure their hand is updated
						for (player in game.players)
						{
							player.getHand().draw();
						}

					case TrapType.LoseCard:

						for (player in game.players)
						{
							// Pick a random value from all cards of the player
							var card:WeaponCard = Random.randomValue(Lambda.array(player.getHand().getCards()));
							
							// Remove card and update hand
							player.getHand().removeCard(card);
							player.getHand().draw();
						}

					default:
				}

			case EventType.Advance:

				// Advance one tier
				game.setMinTier(tier + 1);

			default:

		}

		// Wait 4 seconds and fade out card and call complete function
		Actuate.tween(this, 0.5, {__alpha:0}).delay(4).onComplete(game.onEventCardComplete, [this]);
	}

	private function checkRequiredCards(weaponCards:List<WeaponCard>)
	{
		var totalRequiredCards:List<WeaponCard> = new List();
		
		// Break down mixed color cards into base color ones
		for (requiredCard in requiredCards)
		{
			switch(requiredCard.getColor()) {
				case Color.Orange:
					totalRequiredCards.add(new WeaponCard(requiredCard.getWeaponType(), Color.Yellow));
					totalRequiredCards.add(new WeaponCard(requiredCard.getWeaponType(), Color.Red));
				case Color.Purple:
					totalRequiredCards.add(new WeaponCard(requiredCard.getWeaponType(), Color.Blue));
					totalRequiredCards.add(new WeaponCard(requiredCard.getWeaponType(), Color.Red));
				case Color.Green:
					totalRequiredCards.add(new WeaponCard(requiredCard.getWeaponType(), Color.Yellow));
					totalRequiredCards.add(new WeaponCard(requiredCard.getWeaponType(), Color.Blue));
				default:
					totalRequiredCards.add(new WeaponCard(requiredCard.getWeaponType(), requiredCard.getColor()));
			}
		}
		
		// Try and remove all cards from totalRequiredCards
		for (requiredCard in totalRequiredCards)
		{
			for (weaponCard in weaponCards)
			{
				if (weaponCard.equals(requiredCard))
				{
					weaponCards.remove(weaponCard);
					totalRequiredCards.remove(requiredCard);
					break;
				}
			}
		}

		// If there still cards left then we couldn't remove them all so it's failed attack
		return totalRequiredCards.length <= 0;
	}

	public function draw()
	{
		// Clear children and reset alpha
		removeChildren();
		__alpha = 1;

		// We need to show what's on the card
		if (open || explored)
		{
			// Animate the card to open position
			if (open)
			{	
				cardBackground.scaleX = 0;
				cardBackground.scaleY = 0;
				addChild(cardBackground);
				
				Actuate.tween(cardBackground, Constants.animationSpeed,
				{
					scaleX:Constants.eventCardOpenWidth / cardBackground.bitmapData.width,
					scaleY:Constants.eventCardOpenHeight / cardBackground.bitmapData.height,
					x:-Constants.eventCardOpenWidth / 2,
					y:-Constants.eventCardOpenHeight / 2
					
				}, false).onComplete(drawOpenCard);
				
				if (cardOverlay != null) {
					cardOverlay.scaleX = 0;
					cardOverlay.scaleY = 0;
					addChild(cardOverlay);
				
					Actuate.tween(cardOverlay, Constants.animationSpeed,
					{
						scaleX:Constants.eventCardOpenWidth / cardOverlay.bitmapData.width,
						scaleY:Constants.eventCardOpenHeight / cardOverlay.bitmapData.height,
						x:-Constants.eventCardOpenWidth / 2,
						y:-Constants.eventCardOpenHeight / 2
						
					}, false);
				}
			}
			else
			{
				// Animate the card to base position but show contents
				addChild(cardBackground);
				Actuate.tween(cardBackground, Constants.animationSpeed,
				{
					scaleX:Constants.eventCardWidth / cardBackground.bitmapData.width,
					scaleY:Constants.eventCardHeight / cardBackground.bitmapData.height,
					x:-Constants.eventCardWidth / 2,
					y:-Constants.eventCardHeight / 2
					
				}, false);
				
				if (cardOverlay != null) {
					addChild(cardOverlay);
				
					Actuate.tween(cardOverlay, Constants.animationSpeed,
					{
						scaleX:Constants.eventCardWidth / cardOverlay.bitmapData.width,
						scaleY:Constants.eventCardHeight / cardOverlay.bitmapData.height,
						x:-Constants.eventCardWidth / 2,
						y:-Constants.eventCardHeight / 2
						
					}, false);
				}
			}
		}
		else
		{
			// Draw card back on normal position
			cardBack.scaleX = Constants.eventCardWidth / cardBack.bitmapData.width;
			cardBack.scaleY = Constants.eventCardHeight / cardBack.bitmapData.height;
			cardBack.x = -Constants.eventCardWidth / 2;
			cardBack.y = -Constants.eventCardHeight / 2;
			
			if (tier > game.currentTier)
			{
				__alpha = Constants.disabledAlpha;
			}

			addChild(cardBack);
		}

		// DEBUG
		/*
		var textField:TextField = new TextField();
		textField.text = toString();
		textField.width = Constants.eventCardWidth;
		textField.x = 0;
		textField.y = 0;
		textField.multiline = true;
		textField.wordWrap = true;
		textField.textColor = 0xFF0000;
		addChild(textField);
		*/
	}

	// Draw the small details on the card, such as title, description and required cards
	private function drawOpenCard()
	{
		addChild(titleField);
		addChild(descriptionField);
		
		// Since there is no falltrough switches in haxe it is a bit of double code
		switch (type)
		{
			case EventType.Battle:
				
				var offsetX = -(Constants.weaponIconWidth * requiredCards.length) / 2;

				// Draw each required card
				for (i in 0...requiredCards.length)
				{
					var requiredCard:WeaponCard = requiredCards[i];

					requiredCard.x = offsetX + (i * Constants.weaponIconWidth);
					requiredCard.y = (Constants.eventCardOpenHeight / 2) - Constants.weaponCardHeight;

					requiredCard.draw(Constants.weaponIconWidth, Constants.weaponIconHeight);

					addChild(requiredCard);
				}

			case EventType.Obstacle:
				
				var offsetX = -(Constants.weaponIconWidth * requiredCards.length) / 2;

				// Draw each required card
				for (i in 0...requiredCards.length)
				{
					var requiredCard:WeaponCard = requiredCards[i];

					requiredCard.x = offsetX + (i * Constants.weaponIconWidth);
					requiredCard.y = (Constants.eventCardOpenHeight / 2) - Constants.weaponCardHeight;

					requiredCard.draw(Constants.weaponIconWidth, Constants.weaponIconHeight);

					addChild(requiredCard);
				}

			default:
		}
	}

	// Return debug info for card
	public override function toString():String
	{
		return '(eventType=$type, tier=$tier, requireCards=$requireCards, requiredCards=$requiredCards, attacks=$attacks, trapType=$trapType, chestType=$chestType, open=$open, explored=$explored)';
	}
}