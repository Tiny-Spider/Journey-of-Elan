package events;

import events.EventCard;
import enums.*;
import utilities.Random;

/**
 * Simple static class to generate a deck for a tier
 * @author Mark
 */
class EventCardGenerator 
{

	// Returns a array of 15 EventCards with right tier assigned
	public static function createTierCards(tier:Int):Array<EventCard>
	{
		//return [for (i in 0...15) new EventCard(EventType.Trap, tier)];
		// TODO: make higher tiers have more battles etc
		
		var cards:Array<EventCard> = new Array();
		
		// 1
		cards.push(new EventCard(EventType.Advance, tier));
		
		// 3
		for (i in 0...2) {
			cards.push(new EventCard(EventType.Nothing, tier));
		}
		
		// 5
		for (i in 0...2) {
			cards.push(new EventCard(EventType.Chest, tier));
		}
		
		// 8
		for (i in 0...3) {
			cards.push(new EventCard(EventType.Trap, tier));
		}
		
		// 11
		for (i in 0...3) {
			cards.push(new EventCard(EventType.Obstacle, tier));
		}
		
		// 15
		for (i in 0...4) {
			cards.push(new EventCard(EventType.Battle, tier));
		}
		
		// Shuffle
		cards = Random.randomizeArray(cards);
		
		return cards;
	}
}