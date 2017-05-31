package utilities;

import openfl.text.Font;
import openfl.Assets;

/**
 * Class to manage fonts within the game, all thanks to:
 * http://publicvar.wikidot.com/post:embedding-fonts-in-haxe-openfl
 * @author Mark
 */
class Fonts
{
	public static var CALIBRI(default, null):String;

	public static function init():Void
	{
		#if js
			CALIBRI = Assets.getFont("font/calibri.ttf").fontName;
		#else
			Font.registerFont(Calibri);
			CALIBRI = (new Calibri()).fontName;
		#end
	}
}

@:font("assets/font/calibri.ttf")
private class Calibri extends Font {}