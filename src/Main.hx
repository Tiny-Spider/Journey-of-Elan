package;

import openfl.Lib;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.media.Sound;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

import openfl.events.Event;
import utilities.Fonts;

import enums.Position;

/**
 * Main startup class for the game
 * Handles all dynamic varibles
 * @author Mark
 */
class Main extends Sprite
{
	public static var stageWidth:Int;
	public static var stageHeight:Int;
	
	public static var defaultTextFormat:TextFormat;
	public static var titleTextFormat:TextFormat;
	public static var descriptionTextFormat:TextFormat;
	public static var playerTextFormat:TextFormat;

	private var background:BitmapData = Assets.getBitmapData("img/background.png");
	
	private var game:Game;
	
	public function new()
	{
		super();
		
		Fonts.init();
		
		// Text formats from the text in the game
		defaultTextFormat = new TextFormat(Fonts.CALIBRI, 20, 0xFFFFFF);
		titleTextFormat = new TextFormat(Fonts.CALIBRI, 60, 0xFFFFFF, true, false, false, TextFormatAlign.CENTER);
		descriptionTextFormat = new TextFormat(Fonts.CALIBRI, 25, 0xFFFFFF, false, true, false, TextFormatAlign.CENTER);
		playerTextFormat = new TextFormat(Fonts.CALIBRI, 20, 0xFFFFFF, false, true, false, TextFormatAlign.CENTER);
		
		// Resize event
		onResize(null);
		Lib.current.stage.addEventListener(Event.RESIZE, onResize);
		
		// Add game
		game = new Game();
		addChild(game);
		
		// Start background music
		var sound:Sound = Assets.getSound("audio/music.wav");
		sound.play(0.0, 1000000);
	}
	
	// Resize event listener
	private function onResize(event:Event)
	{
		stageWidth = Lib.current.stage.stageWidth;
		stageHeight = Lib.current.stage.stageHeight;
		
		drawBackground();
	}
	
	// Draw a tiling background
	private function drawBackground() {
		graphics.clear();
		graphics.beginBitmapFill(background, null, true, true);
		graphics.drawRect(0, 0, stageWidth, stageHeight);
		graphics.endFill();
	}
}
