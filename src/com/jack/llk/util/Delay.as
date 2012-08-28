package com.jack.llk.util
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class Delay
	{
		public static function doIt(delayInMillisecond:int, closureFunc:Function, ...args):void
		{
			var t:uint;
			if(args && args.length > 0)
				t = setTimeout(closureFunc, delayInMillisecond, args);
			else
				t = setTimeout(closureFunc, delayInMillisecond);
			var t1:uint = setTimeout(removeTimeout, delayInMillisecond, t);
			
			trace("SetTimeout id = " + t.toString());
			trace("SetTimeout id = " + t1.toString());
		}
		
		private static function removeTimeout(id:uint):void
		{
			clearTimeout(id);
			clearTimeout(id+1);
			
			trace("ClearTimeout id = " + id.toString());
			trace("ClearTimeout id = " + (id+1).toString());
		}
	}
}