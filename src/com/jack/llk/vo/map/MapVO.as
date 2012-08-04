package com.jack.llk.vo.map
{
	import com.jack.llk.log.Log;
	import com.jack.llk.util.ArrayUtil;
	import com.jack.llk.util.NumberUtil;

	import de.polygonal.ds.Array2;

	import flash.geom.Point;

	public class MapVO
	{
		public static const EMPTY:int=-1;

		private var _level:int; //游戏关卡对应的项目数量
		private var _restBlock:int=0; //剩余的项目数量
		private var _countOfPerItem:int; //每个项目出现的次数(偶数)
		private var _result:MatchResult; //暂存符合条件的结果

		public var actualCol:int;
		public var actualRow:int;
		public var col:int;
		public var row:int;
		public var nAvailableItems:int;
		public var nItemTypes:int;

		public var map:Array2;

		private var _array:Array; //辅助的一维数组
		private var _lines:Vector.<Line>; //保存符合条件线段的地方
		private var _items:Vector.<ItemVO>; // 保存当前存在的所有item的坐标和idex		

		public function MapVO()
		{

		}

		public function init():void
		{
			map=new Array2(actualCol, actualRow);
			_array=new Array(col * row);
			_lines=new Vector.<Line>();
			_result=new MatchResult();
			_items=new Vector.<ItemVO>();
			this.level=nItemTypes;
		}

		public function get result():MatchResult
		{
			return _result;
		}

		/********************** getter & setter **********************/

		public function set level(value:uint):void
		{
			_level=value;
			//取得一个尽量大的偶数值
			_countOfPerItem=NumberUtil.getFloorEven(nAvailableItems / _level);
			//_countOfPerItem = int(availableItem / _level);
			_restBlock=nAvailableItems;

			_initMap();
		}

		////////////////  public function  ////////////////////////////////

		public function findLine():MatchResult
		{
			var a:Point=_findRestPointA();
			if (!a)
				return null;

			var b:Point=_findRestPointB(a);
			if (!b)
				return null;

			var ignoreA:Array=[];
			var ignoreB:Array=[];

			while (!this.test(a, b))
			{
				ignoreB.push(b);

				b=_findRestPointB(a, ignoreB);

				//基于A没有可以连通的点了, 换一个A试试
				if (!b)
				{
					ignoreB=[];
					ignoreA.push(a);

					var tempMap:Array2=ArrayUtil.cloneArray2(map);
					tempMap.set(a.x, a.y, EMPTY);

					if (ignoreA.length)
						for each (var p:Point in ignoreA)
							tempMap.set(p.x, p.y, EMPTY);

					a=_findRestPointA(tempMap);
					b=_findRestPointB(a);
				}
			}

			//找不到可以连通的B点
			if (!b)
				return null;

			return _result.clone();
		}

		public function find2Items():Array
		{
			var a:Point=_findRestPointA();
			if (!a)
				return null;

			var b:Point=_findRestPointB(a);
			if (!b)
				return null;

			var ignoreA:Array=[];
			var ignoreB:Array=[];

			while (a && b && !this.test(a, b))
			{
				ignoreB.push(b);

				b=_findRestPointB(a, ignoreB);

				//基于A没有可以连通的点了, 换一个A试试
				if (!b)
				{
					ignoreB=[];
					ignoreA.push(a);

					var tempMap:Array2=ArrayUtil.cloneArray2(map);
					tempMap.set(a.x, a.y, EMPTY);

					if (ignoreA.length)
						for each (var p:Point in ignoreA)
							tempMap.set(p.x, p.y, EMPTY);

					a=_findRestPointA(tempMap);
					b=_findRestPointB(a);
				}
			}

			//找不到可以连通的B点
			if (!b)
				return null;

			return [a, b];
		}

		public function erase(a:Point, b:Point):void
		{
			map.set(a.x, a.y, EMPTY);
			map.set(b.x, b.y, EMPTY);
			_restBlock-=2;

			updateItemLayout();
		}

		public function get count():int
		{
			return _restBlock <= 0 ? 0 : _restBlock;
		}

		public function refresh():void
		{
			var num:uint=this.count;
			if (num <= 0)
				return;

			_array=ArrayUtil.random(ArrayUtil.getWarppedMapArray(map));
			ArrayUtil.drawWrappedMap(_array, map);

			updateItemLayout();
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
			_result=new MatchResult();

			if (map.get(a.x, a.y) != map.get(b.x, b.y))
				return false;

			if (a.y == b.y && hTest(a, b))
				return true;

			if (a.x == b.x && vTest(a, b))
				return true;

			if (oneCornerTest(a, b))
				return true;
			else if (twoCornerTest(a, b))
				return true;
			else
				return false;
		}

		////////////////  private function  ////////////////////////////////

		private function _initMap():void
		{
			// 初始化全部为空
			for (var a:int=0; a < actualCol; a++)
			{
				for (var m:int=0; m < actualRow; m++)
				{
					map.set(a, m, EMPTY);
				}
			}


			//一维数组初始化和乱序
			for (var n:uint=0; n < _array.length; n++)
				_array[n]=EMPTY;

			for (var i:uint=0; i < _level; i++)
			{
				for (var j:uint=0; j < _countOfPerItem; j++)
				{
					_array[i * _countOfPerItem + j]=i + 1;
				}
			}

			var start:int=_level * _countOfPerItem;
			var left:int=nAvailableItems - start;

			for (var k:int=start; k < nAvailableItems; k+=2)
			{
				var flag:int=Math.ceil(Math.random() * _level);
				_array[k]=flag;
				_array[k + 1]=flag;
			}

			_array=ArrayUtil.random(_array);
			ArrayUtil.drawWrappedMap(_array, map);
			updateItemLayout();

			Log.traced("init map", nAvailableItems, items.length);
		}

		private function updateItemLayout():void
		{
			//get the items vo
			for (var i:uint=1; i <= col; i++)
			{
				for (var j:uint=1; j <= row; j++)
				{
					var index:int=int(map.get(i, j));
					if (index != EMPTY)
					{
						_items.push(new ItemVO(i, j, index));
					}
				}
			}
		}

		private function hTest(a:Point, b:Point):MatchResult
		{
			//如果点击的是同一个图案，直接返回false  
			if (a.x == b.x && a.y == b.y)
				return null;

			var startX:uint=a.x <= b.x ? a.x : b.x;
			var endX:uint=a.x <= b.x ? b.x : a.x;

			for (var x:uint=startX + 1; x < endX; x++)
			{
				//只要一个不是-1，直接返回false 
				if (map.get(x, a.y) != EMPTY)
					return null;
			}

			_result.fill(a.clone(), b.clone());
			return _result;
		}

		private function vTest(a:Point, b:Point):MatchResult
		{
			//如果点击的是同一个图案，直接返回false  
			if (a.x == b.x && a.y == b.y)
				return null;

			var startY:uint=a.y <= b.y ? a.y : b.y;
			var endY:uint=a.y <= b.y ? b.y : a.y;

			for (var y:uint=startY + 1; y < endY; y++)
			{
				//只要一个不是-1，直接返回false 
				if (map.get(a.x, y) != EMPTY)
					return null;
			}

			_result.fill(a.clone(), b.clone());
			return _result;
		}

		private function oneCornerTest(a:Point, b:Point):MatchResult
		{
			var c:Point=new Point(a.x, b.y);
			var d:Point=new Point(b.x, a.y);

			var matched:Boolean=false;

			if (map.get(c.x, c.y) == EMPTY) //C 点上必须没有障碍
			{
				matched=(hTest(b, c) && vTest(a, c));
				if (matched)
				{
					_result.clear();
					_result.fill(a.clone(), c.clone(), b.clone());
					return _result;
				}
			}

			if (map.get(d.x, d.y) == EMPTY) //D 点上必须没有障碍
			{
				matched=(hTest(a, d) && vTest(b, d));
				if (matched)
				{
					_result.clear();
					_result.fill(a.clone(), d.clone(), b.clone());
					return _result;
				}
			}

			return null;
		}

		/**
		 * 扫描两点决定的矩形范围内有没有完整的空白线段
		 * @param        a
		 * @param        b
		 * @return
		 */
		private function scanLines(a:Point, b:Point):Vector.<Line>
		{
			var v:Vector.<Line>=new Vector.<Line>();

			var x:int;
			var y:int;

			// 从 a, c 连线向 b 扫描，扫描竖线

			// 扫描 A 点左边的所有线
			for (x=a.x; x >= 0; x--)
			{
				// 存在完整路线 -- c,d点为零且纵向连通
				if (map.get(x, a.y) == -1 && map.get(x, b.y) == -1 && vTest(new Point(x, a.y), new Point(x, b.y)))
				{
					v.push(new Line(Line.VERTICAL, new Point(x, a.y), new Point(x, b.y)));
				}
			}

			// 扫描 A 点右边的所有线
			for (x=a.x; x < actualCol; x++)
			{
				if (map.get(x, a.y) == -1 && map.get(x, b.y) == -1 && vTest(new Point(x, a.y), new Point(x, b.y)))
				{
					v.push(new Line(Line.VERTICAL, new Point(x, a.y), new Point(x, b.y)));
				}
			}

			// 从 a, d 连线向 b 扫描，扫描横线

			// 扫描 A 点上面的所有线
			for (y=a.y; y >= 0; y--)
			{
				if (map.get(a.x, y) == -1 && map.get(b.x, y) == -1 && hTest(new Point(a.x, y), new Point(b.x, y)))
				{
					v.push(new Line(Line.HORIZONTAL, new Point(a.x, y), new Point(b.x, y)));
				}
			}

			// 扫描 A 点下面的所有线
			for (y=a.y; y < actualRow; y++)
			{
				if (map.get(a.x, y) == -1 && map.get(b.x, y) == -1 && hTest(new Point(a.x, y), new Point(b.x, y)))
				{
					v.push(new Line(Line.HORIZONTAL, new Point(a.x, y), new Point(b.x, y)));
				}
			}

			return v;
		}

		private function twoCornerTest(a:Point, b:Point):MatchResult
		{
			_lines=scanLines(a, b);

			//没有完整的空白线段，无解 
			if (_lines.length == 0)
				return null;

			var len:int=_lines.length;
			var line:Line;
			for (var i:int=0; i < len; i++)
			{
				line=_lines[i];
				if (line.direct == Line.VERTICAL)
				{
					if (hTest(a, line.a) && hTest(b, line.b))
					{
						_result.clear();
						_result.fill(a.clone(), line.a.clone(), line.b.clone(), b.clone());
						return _result;
					}
				}
				else
				{
					if (vTest(a, line.a) && vTest(b, line.b))
					{
						_result.clear();
						_result.fill(a.clone(), line.a.clone(), line.b.clone(), b.clone());
						return _result;
					}
				}
			}

			return null;
		}

		private function _findRestPointA(tmpMap:Array2=null):Point
		{
			var m:Array2=tmpMap || map;

			var w:int=m.getW();
			var h:int=m.getH();

			if (w >= h)
			{
				for (var col:Number=0; col < w; col++)
				{
					var max_y:Number=Math.min(col + 1, h);

					for (var y1:Number=0; y1 < max_y; y1++)
					{
						if (m.get(col, y1) != EMPTY)
							return new Point(col, y1);
					}

					for (var x1:Number=0; x1 < col; x1++)
					{
						if (m.get(x1, max_y - 1) != EMPTY)
							return new Point(x1, max_y - 1);
					}
				}
			}
			else
			{
				for (var row:Number=0; row < h; row++)
				{
					var max_x:Number=Math.min(row + 1, w);

					for (var x2:Number=0; x2 < max_x; x2++)
					{
						if (m.get(x2, row) != EMPTY)
							return new Point(x2, row);
					}

					for (var y2:Number=0; y2 < row; y2++)
					{
						if (m.get(max_x - 1, y2) != EMPTY)
							return new Point(max_x - 1, y2);
					}
				}
			}
			return null;
		}

		private function _findRestPointB(a:Point, ignore_b_arr:Array=null):Point
		{
			if (!a)
				return null;

			var tempMap:Array2=ArrayUtil.cloneArray2(map);

			tempMap.set(a.x, a.y, EMPTY);

			if (ignore_b_arr && ignore_b_arr.length)
			{
				for each (var bb:Point in ignore_b_arr)
					tempMap.set(bb.x, bb.y, EMPTY);
			}

			var b:Point=_findRestPointA(tempMap);

			if (!b)
				return null;

			while (map.get(a.x, a.y) != map.get(b.x, b.y))
			{
				tempMap.set(b.x, b.y, EMPTY);

				b=_findRestPointA(tempMap);

				if (!b)
					return null;
			}

			return b;
		}

		public function get items():Vector.<ItemVO>
		{
			return _items;
		}

	}
}


import flash.geom.Point;

class Line
{
	public var a:Point;
	public var b:Point;
	public var direct:int;

	public static const HORIZONTAL:int=0;
	public static const VERTICAL:int=1;

	public function Line(direct:int, a:Point, b:Point)
	{
		this.direct=direct;
		this.a=a;
		this.b=b;
	}
}
