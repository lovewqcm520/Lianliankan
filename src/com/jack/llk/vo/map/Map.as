package com.jack.llk.vo.map
{
	import com.jack.llk.util.ArrayUtil;
	import com.jack.llk.util.NumberUtil;
	
	import de.polygonal.ds.Array2;
	
	import flash.geom.Point;

	public class Map
	{
		public var map:Array2;
		public static const EMPTY:int = -1;
		
		private var _level:uint; //游戏关卡对应的项目数量
		private var _array:Array; //辅助的一维数组
		private var _restBlock:uint = 0; //剩余的项目数量
		//private var _vector:DLinkedList; //保存符合条件线段的地方
		private var _countOfPerItem:uint; //每个项目出现的次数(偶数)
		//private var _result:MatchResult; //暂存符合条件的结果
		private var width:int;

		private var height:int;
		
		public function Map(w:int, h:int, level:uint = 5)
		{
			width = w+2;
			height = h+2;
			//加2是为了加一圈0
			map = new Array2( width, height );
			var tmp:int = (w)*(h);
			_array = new Array(tmp);
//			_vector = null;
//			_result = new MatchResult();
			
			//调用setter
			this.level = level;
		}
		
		/********************** getter & setter **********************/
		
		public function set level(value:uint):void
		{
			_level = value;
			//取得一个尽量大的偶数值
			_countOfPerItem = NumberUtil.getFloorEven(map.size() / _level);
			_restBlock = _level * _countOfPerItem;
			
			_initMap();
		}
		
		////////////////  public function  ////////////////////////////////
		
		public function resetMap(newMap:Array2):void
		{
			map = newMap.clone() as Array2;
		}
		
		public function autoFindLine():void
		{
			
		}
		
		public function earse(a:Point, b:Point):void
		{
			map.set(a.x, a.y, EMPTY);
			map.set(b.x, b.y, EMPTY);
			_restBlock -= 2;
		}
		
		public function get count():uint
		{
			return _restBlock <= 0 ? 0 : _restBlock;
		}
		
		public function refresh():void
		{
			var num:uint = this.count;
			if(num <= 0)	return;
			
			_array = ArrayUtil.random(ArrayUtil.getWarppedMapArray(map));
			ArrayUtil.drawWrappedMap(_array, map);
		}
		
		/**
		 * 测试两点是否可以连通
		 * @param        a
		 * @param        b
		 * @usage 判断 两点的值相同 并且 满足连通条件
		 * @return
		 */
		public function test(a:Point, b:Point):Boolean
		{
			if(map.get(a.x, a.y) != map.get(b.x, b.y))
				return false;
			
			if(a.x == b.x && hTest(a, b))
				return true;
			
			if(a.y == b.y && vTest(a, b))
				return true;
			
			if(oneCornerTest(a, b))
				return true;
			else
				return twoCornerTest(a, b);
		}
		
		////////////////  private function  ////////////////////////////////
		
		private function _initMap():void
		{
			// 初始化全部为空
			for (var k:int = 0; k < width; k++) 
			{
				for (var m:int = 0; m < height; m++) 
				{
					map.set(k, m, EMPTY);
				}				
			}
			
			
			//一维数组初始化和乱序
			for (var n:uint = 0; n < _array.length; n++)
				_array[n] = EMPTY;
			
			for (var i:uint = 0; i < _level; i++)
			{
				for (var j:uint = 0; j < _countOfPerItem; j++)
				{
					_array[i * _countOfPerItem + j] = i + 1;
				}
			}
			
			_array = ArrayUtil.random(_array);
			
			ArrayUtil.drawWrappedMap(_array, map);
		}
		
		private function hTest(a:Point, b:Point):Boolean
		{
			//如果点击的是同一个图案，直接返回false  
			if(a.x == b.x && a.y == b.y)
				return false;
			
			var startX:uint = a.x <= b.x ? a.x : b.x;
			var endX:uint = a.x <= b.x ? b.x : a.x;
			
			for (var x:uint = startX+1; x < endX; x++) 
			{
				//只要一个不是-1，直接返回false 
				if(map.get(x, a.y) != EMPTY)
					return false;
			}
			
			return true;
		}
		
		private function vTest(a:Point, b:Point):Boolean
		{
			//如果点击的是同一个图案，直接返回false  
			if(a.x == b.x && a.y == b.y)
				return false;
			
			var startY:uint = a.y <= b.y ? a.y : b.y;
			var endY:uint = a.y <= b.y ? b.y : a.y;
			
			for (var y:uint = startY+1; y < endY; y++) 
			{
				//只要一个不是-1，直接返回false 
				if(map.get(a.x, y) != EMPTY)
					return false;
			}
			
			return true;
		}
		
		private function oneCornerTest(a:Point, b:Point):Boolean
		{
			var c:Point = new Point(a.x, b.y);
			var d:Point = new Point(b.x, a.y);
			
			if(map.get(c.x, c.y) == EMPTY)
			{
				return (hTest(b, c) && vTest(a, c));
			}
			
			if(map.get(d.x, d.y) == EMPTY)
			{
				return (hTest(a, d) && vTest(b, d));
			}
			
			return false;
		}
		
		private function scan(a:Point, b:Point):Vector.<line>
		{
			var ll:Vector.<line> = new Vector.<line>();
			
			var x:int;
			var y:int;
			
			for(y = a.y; y >= 0; y--)
				if(map.get(a.x, y) == -1 && map.get(b.x, y) == -1 && hTest(new Point(a.x, y), new Point(b.x, y)))
					ll.push(new line(0, new Point(a.x, y), new Point(b.x, y)));
			
			for(y = a.y; y < map.getH(); y++)
				if(map.get(a.x, y) == -1 && map.get(b.x, y) == -1 && hTest(new Point(a.x, y), new Point(b.x, y)))
					ll.push(new line(0, new Point(a.x, y), new Point(b.x, y)));
			
			for(x = a.x; x >= 0; x--)
			{
				trace(x, a.y, map.get(x, a.y), x, b.y, map.get(x, b.y));
				if(map.get(x, a.y) == -1 && map.get(x, b.y) == -1 && vTest(new Point(x, a.y), new Point(x, b.y)))
					ll.push(new line(1, new Point(x, a.y), new Point(x, b.y)));
			}
			
			for(x = a.x; x < map.getW(); x++)
				if(map.get(x, a.y) == -1 && map.get(x, b.y) == -1 && vTest(new Point(x, a.y), new Point(x, b.y)))
					ll.push(new line(1, new Point(x, a.y), new Point(x, b.y)));
			
			return ll;
		}
		
		private function twoCornerTest(a:Point, b:Point):Boolean
		{
			var ll:Vector.<line> = scan(a, b);
			
			if(ll.length == 0)
				return false;
			
			var len:int = ll.length;
			for (var i:int = 0; i < len; i++) 
			{
				var line:line = ll[i];
				if(line.direct == 1)
				{
					if(hTest(a, line.a) && hTest(b, line.b))
						return true;
				}
				else
				{
					if(vTest(a, line.a) && vTest(b, line.b))
						return true;
				}
			}
			
			return false;
		}
		
		
		

		
	}
}


import flash.geom.Point;

class line
{
	public var a:Point;
	public var b:Point;
	public var direct:int;
	
	public function line(direct:int, a:Point, b:Point)
	{
		this.direct = direct;
		this.a = a;
		this.b = b;
	}
}