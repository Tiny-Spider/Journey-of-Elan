package;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

import openfl.Assets;

import openfl.events.MouseEvent;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

/**
 * Custom button class that displays images and text
 * @author Mark
 */
class Button  extends Sprite
{
	private var imageNormal:BitmapData;
	private var imageHover:BitmapData;

	private var buttonWidth:Int;
	private var buttonHeight:Int;
	
	private var image:Bitmap;
	private var messageField:TextField = new TextField();

	public function new(text:String, imageFile:String, imageFileHover:String, buttonWidth:Int, buttonHeight:Int, ?messageFormat:TextFormat)
	{
		super();

		this.buttonWidth = buttonWidth;
		this.buttonHeight = buttonHeight;
		
		if (messageFormat == null) 
		{
			messageFormat = Main.defaultTextFormat.clone();
			messageFormat.align = TextFormatAlign.CENTER;
		}

		imageNormal = Assets.getBitmapData(imageFile);
		imageHover = Assets.getBitmapData(imageFileHover);
		image = new Bitmap(imageNormal);
		
		image.width = buttonWidth;
		image.height = buttonHeight;
		image.x = -(buttonWidth / 2);
		image.y = -(buttonHeight / 2);

		addChild(image);

		messageField.width = buttonWidth;
		messageField.height = buttonHeight;
		messageField.x = -(buttonWidth / 2);
		messageField.y = -(buttonHeight / 2) / 2;

		messageField.defaultTextFormat = messageFormat;
		messageField.selectable = false;
		messageField.text = text;

		addChild(messageField);

		addEventListener(MouseEvent.MOUSE_OVER, onMouseEnter);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseExit);
	}

	private function onMouseEnter(event:MouseEvent)
	{
		image.bitmapData = imageHover;
		image.width = buttonWidth;
		image.height = buttonHeight;
	}

	private function onMouseExit(event:MouseEvent)
	{
		image.bitmapData = imageNormal;
		image.width = buttonWidth;
		image.height = buttonHeight;
	}
	
	public function getText():String
	{
		return messageField.text;
	}

	public function setText(text:String)
	{
		messageField.text = text;
	}
}