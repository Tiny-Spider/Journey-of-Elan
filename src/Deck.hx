package;

import openfl.display.Sprite;
import enums.WeaponType;
import enums.Color;

/**
 * Simple deck class that repesents the cards you can draw
 * @author Octavian
 */
class Deck
{
	private var cards:List<WeaponCard> = new List();

	public function new()
	{
		createDeck();
	}

	// Create all cards we can draw, excluding mixed colors
	private function createDeck()
	{
		for (i in 0...Constants.deckDuplicates)
		{
			for (weaponType in Type.allEnums(WeaponType))
			{
				for (color in [Color.Red, Color.Yellow, Color.Blue])
				{
					var card:WeaponCard = new WeaponCard(weaponType, color);
					cards.add(card);
				}
			}
		}
	}

	// Draw a card from the deck
	public function drawCard():WeaponCard
	{
		return cards.pop();
	}

	// Return a card to the deck
	public function returnCard(card:WeaponCard)
	{
		cards.add(card);
	}
}