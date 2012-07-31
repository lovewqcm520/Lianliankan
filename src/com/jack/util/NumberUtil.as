package com.jack.util
{
	public class NumberUtil
	{
		
		/**
		 * True if the integer was a even number.
		 * @param n
		 * @return 
		 */
		public static function isEven(n:int):Boolean
		{
			return ((n&1) == 0);
		}
	}
}