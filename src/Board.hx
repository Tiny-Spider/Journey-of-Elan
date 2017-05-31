package;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import events.EventCard;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;
import openfl.geom.Point;
import events.EventCardGenerator;
import motion.Actuate;
import enums.*;

/**
 * Class that manages how the board looks and orders the cards
 * @author Svetoslav
 */
class Board extends Sprite
{
	// [x][y][index]
	private var eventCards:Array<Array<Array<EventCard>>>;
	private var game:Game;

	public function new()
	{
		super();

		game = Game.getInstance();

		createBoard();
		draw();
	}

	// Gets the required cards for the board
	public function createBoard()
	{
		// Initalize array
		eventCards = [for (x in 0...Constants.boardWidth) [for (y in 0...Constants.boardHeight) []]];

		for (tier in 0...Constants.boardWidth)
		{
			// Get deck for this tier
			var tierCards:Array<EventCard> = EventCardGenerator.createTierCards(tier);

			for (i in 0...tierCards.length)
			{
				var eventCard:EventCard = tierCards[i];

				// Devide the cards evenly over all lanes
				eventCard.lane = i % Constants.boardHeight;
				eventCards[tier][i % Constants.boardHeight].push(eventCard);
			}
		}
	}

	// Remove card from board
	public function removeCard(eventCard:EventCard)
	{
		var tier:Int = eventCard.tier;
		var lane:Int = eventCard.lane;

		eventCards[tier][lane].pop();

		// If this was last card then we advance 1 tier
		if (eventCards[tier][lane].length <= 0)
		{
			game.setMinTier(tier + 1);
		}
	}

	// Draw the entire board
	public function draw()
	{
		// Center board in middle of screen
		x = Math.round(Main.stageWidth / 2);
		y = Math.round(Main.stageHeight / 2);

		// Remove children
		removeChildren();

		// Calc the width of board and devide by 2 in the negative so we get upper left position
		var offsetX:Int = -Math.round(((Constants.eventCardWidth + Constants.eventCardPadding) * (Constants.boardWidth - 1)) / 2.0);
		var offsetY:Int = -Math.round(((Constants.eventCardHeight + Constants.eventCardPadding) * (Constants.boardHeight - 1)) / 2.0);
		
		var openCard:EventCard = null;

		for (tier in 0...Constants.boardWidth)
		{
			for (lane in 0...Constants.boardHeight)
			{
				// Get cards for this pile on board
				var eventCards:Array<EventCard> = this.eventCards[tier][lane];

				// If it is empty we continue to next lane
				if (eventCards == null || eventCards.length <= 0)
				{
					continue;
				}

				var eventCard:EventCard = eventCards[eventCards.length - 1];

				// Calc the center position of the card
				var eventCardX:Int = offsetX + ((Constants.eventCardWidth + Constants.eventCardPadding) * tier);
				var eventCardY:Int = offsetY + ((Constants.eventCardHeight + Constants.eventCardPadding) * lane);

				// If it is open we set it as current event card, and draw a dummy one behind it
				if (eventCard.open)
				{
					openCard = eventCard;
					openCard.wasOpen = true;
					openCard.removeEventListener(MouseEvent.CLICK, game.onEventCardClick);

					// Draw dummy card back
					var cardBack:Bitmap = new Bitmap(Assets.getBitmapData("img/events/card_back.png"));
					
					cardBack.scaleX = Constants.eventCardWidth / cardBack.bitmapData.width;
					cardBack.scaleY = Constants.eventCardHeight / cardBack.bitmapData.height;
					cardBack.x = (-Constants.eventCardWidth / 2) + eventCardX;
					cardBack.y = (-Constants.eventCardHeight / 2) + eventCardY;
					
					addChild(cardBack);

					continue;
				}

				// If the eventcard was open we move it back to original position
				// otherwise just set it position directly
				if (eventCard.wasOpen)
				{
					Actuate.tween(eventCard, Constants.animationSpeed, { x:eventCardX, y:eventCardY }, false);
					eventCard.wasOpen = false;
				}
				else
				{
					eventCard.x = eventCardX;
					eventCard.y = eventCardY;
				}

				// Add click event
				eventCard.addEventListener(MouseEvent.CLICK, game.onEventCardClick);
				eventCard.draw();

				addChild(eventCard);
			}
		}

		// Animate the open card to center of screen
		if (openCard != null)
		{
			Actuate.tween(openCard, Constants.animationSpeed, { x:0, y:0 }, false);
			openCard.draw();

			addChild(openCard);
		}
	}
}