package com.jack.llk.util
{
	import de.polygonal.ds.Array2;

	/**
	 * ...
	 * @author Jack
	 */
	public class ArrayUtil
	{

		public function ArrayUtil()
		{

		}

		public static function isEmpty(array:Array):Boolean
		{
			return (array == null || array.length == 0) ? true : false;
		}

		/**
		 * Shuffles the position of the elements of the given <code>array</code>.
		 * <p>This method modifies the original array.</p>
		 *
		 * @example
		 *
		 * <listing version="3.0">
		 * import com.jack.util.ArrayUtil;
		 *
		 * var arr:Array = ["abc", "def", 123, 1, 2, 3, "abc", 7];
		 *
		 * ArrayUtil.shuffle(arr)    // [123,abc,2,def,abc,7,3,1]
		 * </listing>
		 *
		 * @param  	array 	the array to shuffle. May be <code>null</code>.
		 * @return 	the modified array.
		 */
		public static function random(array:Array):Array
		{
			return array.sort(randomFunction);
		}

		private static function randomFunction(n1:*, n2:*):int
		{
			return (Math.random() < 0.5) ? -1 : 1;
		}
		
		public static function getWarppedMapArray(map:Array2):Array
		{
			var arr:Array=[];

			var w:int=map.width - 2;
			var h:int=map.height - 2;

			for (var i:int=1; i <= w; i++)
			{
				for (var j:int=1; j <= h; j++)
				{
					arr.push(map.get(i, j));
				}
			}

			return arr;
		}

		public static function drawWrappedMap(arr:Array, map:Array2):void
		{
			var n:int=arr.length;
			var w:int=map.width - 2;
			var h:int=map.height - 2;

			for (var y:int=1; y <= h; y++)
			{
				for (var x:int=1; x <= w; x++)
				{
					map.set(x, y, arr[(y - 1) * w + (x - 1)]);
				}
			}
		}

		public static function shuffleMultiDemensionArray():Array
		{
			return [];
		}

		public static function cloneArray2(map:Array2):Array2
		{
			return map.clone() as Array2;
		}

		/**
		 * get random elements from a arr.
		 * ex:	 getRandomElements([1,2,3,4,5,6,7], 3) = [2, 4, 5];
		 * @param arr
		 * @param n
		 * @return
		 *
		 */
		public static function getRandomElements(arr:*, n:int):*
		{
			if (n >= arr.length)
			{
				return arr;
			}

			if (n <= 0)
			{
				if(arr is Array)
					return [];
				
				return null;
			}

			return RandomUtil.chooseMuti(arr, n);
		}
	}

}
