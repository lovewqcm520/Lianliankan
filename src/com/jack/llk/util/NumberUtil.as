package com.jack.llk.util
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
			return ((n & 1) == 0);
		}

		public static function getFloorEven(n:Number):int
		{
			var num:int=int(n);

			if (!isEven(num))
			{
				num--;
			}

			return num >= 0 ? num : 0;
		}
	}
}
