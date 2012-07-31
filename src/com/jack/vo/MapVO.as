package com.jack.vo
{
	import com.jack.util.ArrayUtil;
	import com.jack.util.NumberUtil;
	
	import de.polygonal.ds.Array2;

	public class MapVO
	{
		/**
		 * 地图的可见宽度
		 */
		public var width:int;
		
		
		/**
		 * 地图的可见高度
		 */
		public var height:int;
		
		/**
		 * 地图是否采用扩大边界.
		 * EG: 假如地图大小是10x8, isExpendEdge=true,则地图变成12x10.
		 * 两个相同物品的连线可以从边界外算起.
		 * 
		 * 默认为true.
		 */
		public var isExpendEdge:Boolean;
		
		private static const NULL_TILE:int = -1;
		private static const FULL_TILE:int = 1;
		
		private var originMapData:*;
		private var array:Array2;
		private var originiItems:Array;
		
		public function MapVO(col:int, row:int, isExpendEdge:Boolean = true)
		{
			this.width = col;
			this.height = row;
			this.isExpendEdge = isExpendEdge;
			
			array = new Array2(col, row);
		}
		
		public function importFromString(str:String):void
		{
			originMapData = str;
			
			var arr:Array = str.split("\n"); 
			// trace the map data
			for (var k:int = 0; k < arr.length; k++) 
			{
				trace(arr[k]);
			}
			
			// get the map dimension
			var dimension:String = arr[0];
			var w:int = int(dimension.substring(0, dimension.indexOf("x")));
			var h:int = int(dimension.substring(dimension.indexOf("x")+1));
			if(w <=0 || h <= 0)
			{
				return;
			}
			// get each position data
			arr.shift();
			var tmp:String = arr.join("");
			arr = tmp.split(",");
			
			width = w;
			height = h;
			array = new Array2(width, height);
			// default value was -1;
			for (var i:int = 0; i < height; i++) 
			{
				for (var j:int = 0; j < width; j++) 
				{
					array.set(j, i, int(arr[i*width + j]));
				}				
			}		
		}
		
		/**
		 * Reset the map region, and refresh the map data.
		 * @param col
		 * @param row
		 * @param isExpendEdge
		 */
		public function resetMapRegion(col:int, row:int, isExpendEdge:Boolean = true):void
		{
			this.width = col;
			this.height = row;
			this.isExpendEdge = isExpendEdge;
			
			array = new Array2(col, row);
			// update the map data
			update();
		}
		
		public function getItem(x:int, y:int):int
		{
			if(x >=0 && x < width && y >= 0 && y < height)
			{
				return int(array.get(x, y));
			}
			
			return -2;
		}
		
		public function updateItem(x:int, y:int, value:int):void
		{
			if(x >=0 && x < width && y >= 0 && y < height)
			{
				array.set(x, y, value);
			}
		}
		
		public function random():void
		{
			var nRandoms:int = width*height;
			if(!NumberUtil.isEven(nRandoms) || nRandoms < 2)
			{
				return;
			}
			
			var tmp:int = nRandoms;
			var arr:Array=[];
			while(tmp > 0)
			{
				arr.push(FULL_TILE);
				arr.push(FULL_TILE);
				tmp -= 2;
			}
			// shuffle the items
			ArrayUtil.shuffle(arr);
			
			for (var i:int = 0; i < width; i++) 
			{
				for (var j:int = 0; j < height; j++) 
				{
					array.set(i, j, arr[i*height+j]);
				}				
			}			
		}
		
		public function shuffleMap():void
		{
			
		}		
		
		private function update():void
		{
			
		}
		
		
	}
}