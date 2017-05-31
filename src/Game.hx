package;

import openfl.Lib;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.events.MouseEvent;

import events.EventCard;

import enums.GameState;
import enums.Position;
import enums.ClassType;
import enums.WeaponType;

/**
 * Main part of the game, handles all game mechanics
 * @author Mark
 */
class Game extends Sprite
{
	private static var instance:Game;
	
	public var players:Array<Player>;
	public var currentTier = 0;
	private var gameState:GameState = GameState.Initalize;

	private var deck:Deck;
	private var board:Board;
	private var currentEventCard:EventCard;

	private var activateButton:Button = new Button("Attack", "img/button.png", "img/button_hover.png", 100, 50);
	private var tradeButton:Button = new Button("Done Trading", "img/button.png", "img/button_hover.png", 200, 50);
	private var textField:TextField = new TextField();

	public function new()
	{
		super();
		
		instance = this;
		
		// Create the Board and Deck (they need game instance)
		board = new Board();
		deck = new Deck();

		addChild(board);

		// Create the players
		players = [
					  new Player(Position.Left, ClassType.Cleric, WeaponType.Sword, WeaponType.Wand),
					  new Player(Position.Top, ClassType.Journeyman, WeaponType.Axe, WeaponType.Sword),
					  new Player(Position.Right, ClassType.Rogue, WeaponType.Bow, WeaponType.Axe),
					  new Player(Position.Bottom, ClassType.Wanderer, WeaponType.Wand, WeaponType.Bow)
				  ];

		for (player in players)
		{
			addChild(player);
		}

		// Start the game by switching to Initalize state
		switchGameState(GameState.Initalize);

		// Debug field
		addChild(textField);
		textField.width = 500;
		textField.textColor = 0xFFFFFF;
		
		// "Attack" button for a event card
		activateButton.addEventListener(MouseEvent.CLICK, attackEventClick);
		activateButton.x = (Main.stageWidth / 2);
		activateButton.y = (Main.stageHeight / 2) + ((Constants.eventCardOpenHeight / 2) + Constants.eventCardPadding);
		
		// Center trade button
		tradeButton.addEventListener(MouseEvent.CLICK, onStopTradeClick);
		tradeButton.x = Main.stageWidth / 2;
		tradeButton.y = Main.stageHeight / 2;
	}

	// Main handler of the game. Sets a new gamestate after which it updates all attached code
	public function switchGameState(gameState:GameState)
	{
		trace("gameState switched from " + this.gameState + " to " + gameState);
		this.gameState = gameState;

		switch (gameState)
		{
			case GameState.Initalize:

				// Initalize state, give all players the maximum cards they can have currently
				for (player in players)
				{
					for (i in 0...player.getHand().getMaxSize())
					{
						player.getHand().giveCard(deck.drawCard());
					}

					player.getHand().draw();
				}

				// Start the game by switching to World
				switchGameState(GameState.World);

			case GameState.Draw:
				
				// Give every player 1 card if their hand allows it
				for (player in players) 
				{
					if (player.getHand().getSize() < player.getHand().getMaxSize()) 
					{
						player.getHand().giveCard(deck.drawCard());
					}
					
					player.getHand().draw();
				}
				
				// Switch to trade phase
				switchGameState(GameState.Trade);
				
			case GameState.Trade:
				
				// Tell every player's hand that trading has started
				for (player in players) {
					player.getHand().startTrade();
				}
				
				addChild(tradeButton);
				
			case GameState.World:
				// Wait for player input
			case GameState.Event:
				// Open the event card
				currentEventCard.open = true;
				board.draw();
				
				// If it required cards then we wait for players to select cards
				// adding the "attack" button so players can select when to continue
				if (currentEventCard.requireCards) {
					addChild(activateButton);
				} else {
					currentEventCard.activate(null);
				}
		}

		// Update debug text
		textField.text = toString();
	}

	// Set the minimum tier, will not go lower than currentTier
	public function setMinTier(tier:Int)
	{
		if (tier > currentTier)
		{
			currentTier = tier;
		}
	}

	// Click event listener for the attack button
	public function attackEventClick(event:Event)
	{
		// Get all the cards from the players
		var cards:List<WeaponCard> = new List();
		
		for (player in players) {
			cards = Lambda.concat(cards, player.getHand().takeSelectedCards());
		}
		
		// Activate the current event with these cards
		currentEventCard.activate(cards);
		removeChild(activateButton);
 	}
	
	// Called when eventcard failes (missing cards)
	public function onEventCardFailed(eventCard:EventCard) {
		eventCard.open = false;
		
		board.draw();
		currentEventCard = null;
		
		trace('onEventCardFailed: (eventCard=$eventCard)');
		switchGameState(GameState.Draw);
	}
	
	// Called when eventcard succeeds (all cards or does not require cards)
	public function onEventCardComplete(eventCard:EventCard) {
		eventCard.open = false;
		
		board.removeCard(eventCard);
		board.draw();
		currentEventCard = null;
		
		trace('onEventCardComplete: (eventCard=$eventCard)');
		switchGameState(GameState.Draw);
	}

	// Click event listener for the event cards on the board
	public function onEventCardClick(event:Event)
	{
		// Won't do anything if the gameState is wrong or tier is too high
		if (gameState != GameState.World || currentEventCard != null)
		{
			return;
		}

		var eventCard:EventCard = cast(event.currentTarget, EventCard);

		trace('onEventCardClick: (eventCard=$eventCard)');

		if (eventCard.tier > currentTier)
		{
			return;
		}

		// Set it as current event card and switch to event gamestate
		currentEventCard = eventCard;
		switchGameState(GameState.Event);
	}

	// Click event listener for "done trading" button
	public function onStopTradeClick(event:Event)
	{
		// Tell all hands to stop trading
		for (player in players) {
			player.getHand().stopTrade();
		}
		
		// Remove the button and switch to world gamestate
		removeChild(tradeButton);
		switchGameState(GameState.World);
	}

	// Returns current gameState
	public function getGameState():GameState
	{
		return gameState;
	}

	// Returns current event card
	public function getCurrentEventCard():EventCard
	{
		return currentEventCard;
	}

	// Returns board
	public function getBoard():Board
	{
		return board;
	}

	// Returns deck
	public function getDeck():Deck
	{
		return deck;
	}

	// Returns instance of this
	public static function getInstance():Game
	{
		return instance;
	}

	// Debug purposes
	public override function toString():String
	{
		return '(currentTier=$currentTier, gameState=$gameState)';
	}
}