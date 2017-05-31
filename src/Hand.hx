package;

import enums.Color;
import enums.WeaponType;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import utilities.Random;
import enums.*;
import openfl.events.Event;

/**
 * Hand of a player class, manages the weaponcards a player has
 * @author Bogdan
 */
class Hand extends Sprite
{
	private var weaponCards:List<WeaponCard> = new List();
	private var game:Game;
	private var player:Player;

	private var allowTrade:Bool = false;
	private var tradeButtons:Sprite = new Sprite();

	public function new(player:Player)
	{
		super();

		this.player = player;

		game = Game.getInstance();

		// Add trade buttons for each ClassType
		var offsetX:Float = -(Constants.tradeButtonWidth * (Type.allEnums(ClassType).length - 1)) / 2;
		var index:Int = 0;

		for (classType in Type.allEnums(ClassType))
		{
			// Skip own trade button
			if (classType == player.getClassType())
			{
				continue;
			}

			// Add button with correct name
			var button:Button = new Button(Std.string(classType), "img/button.png", "img/button_hover.png", Constants.tradeButtonWidth, Constants.tradeButtonHeight);
			
			// Simple event listener that calls trade(classType)
			button.addEventListener(MouseEvent.CLICK, function(event:Event) { trade(classType); } );
			button.x = offsetX + (Constants.tradeButtonWidth * index);

			tradeButtons.addChild(button);

			index++;
		}

		tradeButtons.x = 0;
		tradeButtons.y = (-Constants.tradeButtonHeight / 2) - Constants.weaponCardSelectedOffset;
	}

	// Draw the hand for the player with all the weapon cards
	public function draw()
	{
		removeChildren();

		// Calculate the x offset
		var offset:Int = -Math.round((Constants.weaponCardWidth * weaponCards.length) / 2.0);
		var i:Int = 0;

		// Add all weaponCards
		for (weaponCard in weaponCards)
		{
			weaponCard.x = offset + Constants.weaponCardWidth * i;
			weaponCard.y = weaponCard.selected ? -Constants.weaponCardSelectedOffset : 0;

			weaponCard.draw(Constants.weaponCardWidth, Constants.weaponCardHeight);
			weaponCard.addEventListener(MouseEvent.CLICK, onCardClick);

			weaponCard.alpha = player.isDead() ? Constants.disabledAlpha : 1;

			addChild(weaponCard);

			i++;
		}

		// If allowed to trade add the trade buttons
		if (allowTrade)
		{
			addChild(tradeButtons);
		}
	}

	// Will take all selected cards from the player
	// If it is primary it will return two of it
	// Secondary one, and if it's not a primary or secondary return nothing
	public function takeSelectedCards():List<WeaponCard>
	{
		var cards:List<WeaponCard> = new List();
		var finalCards:List<WeaponCard> = new List();

		// Get all selected cards
		for (weaponCard in weaponCards)
		{
			if (weaponCard.selected)
			{
				cards.add(weaponCard);
			}
		}

		// Remove them from hand
		for (card in cards)
		{
			removeCard(card);
		}

		// Primary and secondary checking
		for (card in cards)
		{
			var weaponType:WeaponType = card.getWeaponType();

			// If primary, add it double
			if (weaponType == player.getPrimaryType())
			{
				finalCards.add(card);
				finalCards.add(card);
			}
			// If secondary, add it once
			else if (weaponType == player.getSecondaryType())
			{
				finalCards.add(card);
			}
		}

		draw();

		return finalCards;
	}

	// Weaponcard click listener
	private function onCardClick(event:MouseEvent)
	{
		// Can only click during active event
		if (!player.isDead() && game.getGameState() == GameState.Event && game.getCurrentEventCard().requireCards)
		{
			var weaponCard:WeaponCard = cast(event.target, WeaponCard);

			weaponCard.selected = !weaponCard.selected;
			draw();
		}
		// Or click it during trade event
		else if (game.getGameState() == GameState.Trade && allowTrade)
		{
			var weaponCard:WeaponCard = cast(event.target, WeaponCard);

			// Inverse selected
			weaponCard.selected = !weaponCard.selected;
			
			// If selected unselect all others
			if (weaponCard.selected) {
				unselectAll();
				weaponCard.selected = true;
			}
			
			draw();
		}
	}

	// Unselect all weaponcards (automaticly draws hand too)
	public function unselectAll()
	{
		for (weaponCard in weaponCards)
		{
			weaponCard.selected = false;
		}

		draw();
	}

	// Return max size of the hand
	public function getMaxSize():Int
	{
		return Constants.startHandSize + game.currentTier;
	}

	// Returns current size of the hand
	public function getSize():Int
	{
		return weaponCards.length;
	}

	// Returns all cards in the hand
	public function getCards():List<WeaponCard>
	{
		return weaponCards;
	}

	// Take all cards from the hand (used for shuffle trap)
	public function takeAllCards():List<WeaponCard>
	{
		// Unselect and remove eventListeners
		for (weaponCard in weaponCards)
		{
			weaponCard.selected = false;
			weaponCard.removeEventListener(MouseEvent.CLICK, onCardClick);
		}

		// Copy the weaponcards and clear them from hand
		var cards:List<WeaponCard> = Lambda.list(weaponCards);
		weaponCards.clear();

		return cards;
	}

	// Remove a card from this players hand (does not draw automaticly)
	public function removeCard(card:WeaponCard)
	{
		card.selected = false;
		card.removeEventListener(MouseEvent.CLICK, onCardClick);
		weaponCards.remove(card);
		game.getDeck().returnCard(card);
	}

	// Give the player a card
	// Used for trading and drawing turn
	public function giveCard(card:WeaponCard)
	{
		card.selected = false;

		// Limit hand size, disabled during trade messing up
		/*
		if (getSize() + 1 > getMaxSize())
		{
			game.getDeck().returnCard(card);
			return;
		}
		*/

		weaponCards.add(card);
	}

	// Start the trading sequence
	public function startTrade()
	{
		allowTrade = true;
		draw();
	}

	// Stop the trading sequence
	public function stopTrade()
	{
		allowTrade = false;
		unselectAll();
	}

	// Trade listener classType is the player who will recieve the card
	private function trade(classType:ClassType)
	{
		// Find the selected weaponcard
		var selectedCard:WeaponCard = Lambda.find(weaponCards, function(weaponCard):Bool { return weaponCard.selected; });

		// If it is not null then continue the trade
		if (selectedCard != null)
		{
			// Unselect and cleanup
			selectedCard.selected = false;
			selectedCard.removeEventListener(MouseEvent.CLICK, onCardClick);
			
			// Remove the card and remove the buttons
			weaponCards.remove(selectedCard);
			removeChild(tradeButtons);

			// Find who we will trade with
			var targetPlayer:Player = Lambda.find(game.players, function(player):Bool { return player.getClassType() == classType; });

			// Give them the card
			targetPlayer.getHand().giveCard(selectedCard);
			targetPlayer.getHand().draw();

			// Stop my trading
			stopTrade();
		}
	}
}