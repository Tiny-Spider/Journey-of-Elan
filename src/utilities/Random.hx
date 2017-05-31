package utilities;

/**
 * Random class to provide a few randomizations
 * @author Mark
 */
class Random 
{
	public static function randomValue<T>(array:Array<T>):Null<T>
	{
		var index:Int = random(0, array.length - 1);
		
		return array[index];
	}
	
	public static function randomEnum<T>(e:Enum<T>):Null<T>
	{
		var array:Array<T> = Type.allEnums(e);
		var index:Int = random(0, array.length - 1);

		return array[index];
	}
	
	public static function randomizeArray<T>(array:Array<T>):Array<T>
	{
		for (i in 0...array.length) {
			var j:Int = random(0, array.length - 1);
			
			var objA:T = array[i];
			var objB:T = array[j];
			
			array[i] = objB;
			array[j] = objA;
		}
		
		return array;
	}

	public static function random(from:Int, to:Int):Int
	{
		return from + Math.floor(((to - from + 1) * Math.random()));
	}
}