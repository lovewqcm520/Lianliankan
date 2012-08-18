package com.jack.llk.vo.map
{
	import com.jack.llk.control.Common;
	import com.jack.llk.control.events.EventController;
	import com.jack.llk.control.events.GameEvent;
	import com.jack.llk.util.ArrayUtil;
	import com.jack.llk.util.NumberUtil;
	import com.jack.llk.util.RandomUtil;
	
	import de.polygonal.ds.Array2;
	
	import flash.geom.Point;
	import flash.utils.getTimer;

	public class MapVO
	{
		public static const EMPTY_ITEM:int=-1;
		public static const STONE_ITEM:int = -2;
		
		// random choose on tool to add to user's tool chest or just use it when get
		public static const EGG_ITEM:int = 30;
		// add some time
		public static const TIME_ITEM:int = 31;
		// increase the number of find tools user have
		public static const FIND_ITEM:int = 32;
		// increase the number of refresh tools user have
		public static const REFRESH_ITEM:int = 33;
		// increase the number of bomb tools user have
		public static const BOMB_ITEM:int = 34;
		
		public static const TOP:int = 1;
		public static const BOTTOM:int = 2;
		public static const LEFT:int = 3;
		public static const RIGHT:int = 4;		
		
		public static const LIST:Array = [EMPTY_ITEM, STONE_ITEM];
		public static const TOOLS:Array = [EGG_ITEM, TIME_ITEM, FIND_ITEM, REFRESH_ITEM, BOMB_ITEM];

		private var _nDiffItems:int; //游戏关卡对应的项目数量
		private var _restBlock:int=0; //剩余的项目数量
		private var _countOfPerItem:int; //每个项目出现的次数(偶数)
		private var _result:PathMatchResultVO; //暂存符合条件的结果

		public var actualWidth:int;
		public var actualHeight:int;
		public var width:int;
		public var height:int;
		public var nAvailableItems:int;
		public var numTotalItems:int;
		public var nItemTypes:int;
		public var nStoneItems:int;	// 阻塞石头的数量
		public var nToolItems:int;	// tool items

		public var map:Array2;
		public var refreshList:Array;
		public var moveList:Array;

		private var _array:Array; //辅助的一维数组
		private var _lines:Vector.<Line>; //保存符合条件线段的地方
		private var _items:Vector.<ItemVO>; // 保存当前存在的所有item的坐标和index	
		private var _allItemIndexs:Array; // 保存当前存在的所有可以消除的item的index	
		private var _emptyItems:Array; // 保存当前是空位empty的item的坐标	
		private var gameMode:int;
		
		private var minX:int=int.MAX_VALUE;
		private var minY:int=int.MAX_VALUE;
		private var maxX:int=0;
		private var maxY:int=0;
		
		public function MapVO()
		{

		}

		public function init(data:String, gameMode:int):void
		{
			this.gameMode = gameMode;
			map=new Array2(actualWidth, actualHeight);
			_array=new Array(width * height);
			_lines=new Vector.<Line>();
			_result=new PathMatchResultVO();
			_items=new Vector.<ItemVO>();
			_emptyItems=[];
			_allItemIndexs=[];
			refreshList=[];
			moveList=[];
			this.nDiffItems=nItemTypes;
			
			//取得一个尽量大的偶数值
			_countOfPerItem=NumberUtil.getFloorEven(nAvailableItems / _nDiffItems);
			//_countOfPerItem = int(availableItem / _nDiffItems);
			_restBlock=nAvailableItems+nToolItems;
			
			initMap(data);
		}

		public function get result():PathMatchResultVO
		{
			return _result;
		}

		/********************** getter & setter **********************/

		public function set nDiffItems(value:uint):void
		{
			_nDiffItems=value;
		}

		////////////////  public function  ////////////////////////////////

		public static function isToolItem(index:int):Boolean
		{
			return TOOLS.indexOf(index) != -1;
		}
		
		/**
		 * Get the item's type index from map data.
		 * @param x
		 * @param y
		 * @return
		 */
		public function getItemIndex(x:int, y:int):*
		{
			return map.get(x, y);
		}
		
		/**
		 * Update the item's type index to map data.
		 * @param x
		 * @param y
		 * @param itemIndex
		 */
		public function setItemIndex(x:int, y:int, itemIndex:int):void
		{
			if(map.get(x, y) == EMPTY_ITEM)
			{
				// add a new item
				_restBlock++;
			}
			map.set(x, y, itemIndex);
			updateItemLayout();
		}
		
		public function findLine():PathMatchResultVO
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
					tempMap.set(a.x, a.y, EMPTY_ITEM);

					if (ignoreA.length)
						for each (var p:Point in ignoreA)
							tempMap.set(p.x, p.y, EMPTY_ITEM);

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
			var oldTime:Number=getTimer();
			
			var len:int = _items.length;
			var a:Point=new Point();
			var b:Point=new Point();
			var tmp:Vector.<ItemVO> = RandomUtil.randomArray(_items);
			for (var i:int = 0; i < len; i++) 
			{
				a.x = tmp[i].x;
				a.y = tmp[i].y;
				for (var j:int = i+1; j < len; j++) 
				{
					b.x = tmp[j].x;
					b.y = tmp[j].y;
					if(test(a, b))
					{
						return [a, b];
					}
				}	
			}			
			
			return null;
		}

		public function erase(a:Point, b:Point):void
		{
			// set 2 point to empty
			map.set(a.x, a.y, EMPTY_ITEM);
			map.set(b.x, b.y, EMPTY_ITEM);
			_restBlock -= 2;

			// testonly
			// choose the item move style
			moveList.length=0;
	
			if(Math.random() <= 0.333)
			{
				moveToTop(a);
				moveToTop(b);
			}
			else if(Math.random() <= 0.666)
			{
				moveToLeft(a);
				moveToLeft(b);
			}
			else 
			{
				moveToRight(a);
				moveToRight(b);
			}

			
			// update data
			updateItemLayout();
			validateMap();
		}

		public function get count():int
		{
			return _restBlock <= 0 ? 0 : _restBlock;
		}

		public function refresh():Boolean
		{
			var num:uint=this.count;
			if (num <= 0)
				return false;

			var flag:int=0;
			var index:int;
			var i:int;
			// random 
			_allItemIndexs = ArrayUtil.random(_allItemIndexs);			
			// random map with same position, just change item index
			var len:int = _items.length;
			var a:ItemVO;
			var b:ItemVO;
			refreshList.length=0;
			var x:int;
			var y:int;
			for (i = 0; i < len; i+=2) 
			{
				x = RandomUtil.integer(0, len, false);
				y = RandomUtil.integer(0, len, false);
				a = _items[x];
				b = _items[y];
				refreshList.push(a);
				refreshList.push(b);
				map.set(a.x, a.y, b.index);
				map.set(b.x, b.y, a.index);
			}
			// 清除随机数历史记录。重新开始取数。
			RandomUtil.clearHistory();

			// update item layout
			updateItemLayout();
			
			// check map
			if(!isMapHasMatchedItems())
			{
				var e:GameEvent = new GameEvent(GameEvent.GAME_REFRESH_MAP);
				EventController.e.dispatchEvent(e);
				
				trace("refresh", GameEvent.GAME_REFRESH_MAP);
				return false;
			}
			
			return true;
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
			_result=new PathMatchResultVO();

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

		/**
		 * Init the map data.
		 */
		private function initMap(data:String):void
		{
			if(gameMode == Common.GAME_MODEL_CLASSIC)
			{
				initClassicModelMap(data);
			}
			else if(gameMode == Common.GAME_MODEL_TIME)
			{
				initTimeModelMap(data);
			}
			else if(gameMode == Common.GAME_MODEL_ENDLESS)
			{
				initEndlessModelMap(data);
			}
		}
		
		private function initClassicModelMap(data:String):void
		{
			var i:int;
			var j:int;
			
			var tmp:Array=new Array(nAvailableItems+nToolItems);
			for (i=0; i < _nDiffItems; i++)
			{
				for (j=0; j < _countOfPerItem; j++)
				{
					tmp[i * _countOfPerItem + j]=i + 1;
				}
			}
			
			var start:int=_nDiffItems * _countOfPerItem;
			for (i=start; i < nAvailableItems; i+=2)
			{
				tmp[i]=Math.ceil(Math.random() * _nDiffItems);
				tmp[i + 1]=tmp[i];
			}
			
			var nCurAll:int = nAvailableItems;
			
			// add one pair eggs or time
			tmp[nAvailableItems-2]= RandomUtil.isEnabledOnProbability(0.5) ? TIME_ITEM : EGG_ITEM;
			tmp[nAvailableItems-1]= tmp[nAvailableItems-2];
			// add tool items
			var m:int = int(nToolItems/6);
			var n:int = nToolItems - m*6;
			if(m > 0)
			{
				for (i = 0; i < m; i++) 
				{
					tmp[nCurAll] = REFRESH_ITEM;
					tmp[++nCurAll] = REFRESH_ITEM;
					
					tmp[++nCurAll] = BOMB_ITEM;
					tmp[++nCurAll] = BOMB_ITEM;
					
					tmp[++nCurAll] = FIND_ITEM;
					tmp[++nCurAll] = FIND_ITEM;
				}				
			}
			if(n > 0)
			{
				for (i=nCurAll; i < nCurAll + nToolItems; i+=2)
				{
					tmp[i]=RandomUtil.randomGet(TOOLS);
					tmp[i + 1]=tmp[i];
				}
			}
			
			// shuffle the array
			tmp=ArrayUtil.random(tmp);
			
			// set map data
			var arr:Array = data.split(",");
			var index:int;
			var flag:int=0;
			for (i=0; i < actualHeight; i++) 
			{
				for (j= 0; j < actualWidth; j++) 
				{
					index = int(arr[i*actualWidth + j]);
					if(isAvailableItem(index))
					{
						index = tmp[flag];
						flag++;
						map.set(j, i, index);
						
						// get horizontal info
						minX = Math.min(minX, j);
						maxX = Math.max(maxX, j);
						// get vertical info
						minY = Math.min(minY, i);
						maxY = Math.max(maxY, i);
					}
					else
					{
						map.set(j, i, EMPTY_ITEM);
					}
				}				
			}	
			
			updateItemLayout();
			validateMap();	
		}
		
		private function initTimeModelMap(data:String):void
		{
			// testonly 
			nAvailableItems = nAvailableItems + nToolItems - 2;
			nToolItems = 2;
			
			var allItems:int = nAvailableItems+nToolItems+nStoneItems;
			var i:int;
			var j:int;
			
			var tmp:Array=new Array(nAvailableItems+nToolItems);
			for (i=0; i < _nDiffItems; i++)
			{
				for (j=0; j < _countOfPerItem; j++)
				{
					tmp[i * _countOfPerItem + j]=i + 1;
				}
			}
			
			var start:int=_nDiffItems * _countOfPerItem;
			for (i=start; i < nAvailableItems; i+=2)
			{
				tmp[i]=Math.ceil(Math.random() * _nDiffItems);
				tmp[i + 1]=tmp[i];
			}
			
			var nCurAll:int = nAvailableItems;
			
			// add eggs
			for (i=nCurAll; i < nCurAll + nToolItems; i+=2)
			{
				tmp[i]=EGG_ITEM;
				tmp[i + 1]=EGG_ITEM;
			}
			
			// shuffle the array
			tmp=ArrayUtil.random(tmp);
			
			// set map data
			var arr:Array = data.split(",");
			var index:int;
			var flag:int=0;
			for (i=0; i < actualHeight; i++) 
			{
				for (j= 0; j < actualWidth; j++) 
				{
					index = int(arr[i*actualWidth + j]);
					if(index != EMPTY_ITEM)
					{
						if(index != STONE_ITEM)
						{
							index = tmp[flag];
							flag++;
						}		
						
						// get horizontal info
						minX = Math.min(minX, j);
						maxX = Math.max(maxX, j);
						// get vertical info
						minY = Math.min(minY, i);
						maxY = Math.max(maxY, i);
					}
					map.set(j, i, index);
				}				
			}	
			
			updateItemLayout();
			validateMap();	
		}
		
		private function initEndlessModelMap(data:String):void
		{
			// testonly 
			nAvailableItems = nAvailableItems + nToolItems - 2;
			nToolItems = 2;
			
			var allItems:int = nAvailableItems+nToolItems+nStoneItems;
			var i:int;
			var j:int;
			
			var tmp:Array=new Array(nAvailableItems+nToolItems);
			for (i=0; i < _nDiffItems; i++)
			{
				for (j=0; j < _countOfPerItem; j++)
				{
					tmp[i * _countOfPerItem + j]=i + 1;
				}
			}
			
			var start:int=_nDiffItems * _countOfPerItem;
			for (i=start; i < nAvailableItems; i+=2)
			{
				tmp[i]=Math.ceil(Math.random() * _nDiffItems);
				tmp[i + 1]=tmp[i];
			}
			
			var nCurAll:int = nAvailableItems;
			
			// add eggs
			for (i=nCurAll; i < nCurAll + nToolItems; i+=2)
			{
				tmp[i]=EGG_ITEM;
				tmp[i + 1]=EGG_ITEM;
			}
			
			// shuffle the array
			tmp=ArrayUtil.random(tmp);
			
			// set map data
			var arr:Array = data.split(",");
			var index:int;
			var flag:int=0;
			for (i=0; i < actualHeight; i++) 
			{
				for (j= 0; j < actualWidth; j++) 
				{
					index = int(arr[i*actualWidth + j]);
					if(index != EMPTY_ITEM)
					{
						if(index != STONE_ITEM)
						{
							index = tmp[flag];
							flag++;
						}		
						
						// get horizontal info
						minX = Math.min(minX, j);
						maxX = Math.max(maxX, j);
						// get vertical info
						minY = Math.min(minY, i);
						maxY = Math.max(maxY, i);
					}
					map.set(j, i, index);
				}				
			}	
			
			updateItemLayout();
			validateMap();	
		}
		
		private function validateMap():void
		{
			// check map
			if(!isMapHasMatchedItems())
			{
				var e:GameEvent = new GameEvent(GameEvent.GAME_REFRESH_MAP);
				EventController.e.dispatchEvent(e);
			}
		}
		
		/**
		 * 判断当前游戏地图是否至少有一对item可以消除.
		 * @return 
		 */
		private function isMapHasMatchedItems():Boolean
		{
			var len:int = _items.length;
			var a:Point=new Point();
			var b:Point=new Point();
			for (var i:int = 0; i < len; i++) 
			{
				a.x = _items[i].x;
				a.y = _items[i].y;
				for (var j:int = i+1; j < len; j++) 
				{
					b.x = _items[j].x;
					b.y = _items[j].y;
					if(test(a, b))
					{
						return true;
					}
				}	
			}			
			
			return false;
		}

		private function updateItemLayout():void
		{
			_items.length = 0;
			_allItemIndexs.length = 0;
			_emptyItems.length = 0;
			
			var index:int;
			//get the items vo
			for (var x:uint=1; x <= width; x++)
			{
				for (var y:uint=1; y <= height; y++)
				{
					index=int(map.get(x, y));
					if (index != EMPTY_ITEM)		
					{
						if (index != STONE_ITEM)
						{
							_allItemIndexs.push(index);
							_items.push(new ItemVO(x, y, index));
						}
					}	
					else
					{
						_emptyItems.push(new Point(x, y))
					}
				}
			}
		}
		
		private function isAvailableItem(index:int):Boolean
		{
			return LIST.indexOf(index) == -1;
		}

		private function hTest(a:Point, b:Point):PathMatchResultVO
		{
			//如果点击的是同一个图案，直接返回false  
			if (a.x == b.x && a.y == b.y)
				return null;

			var startX:uint=a.x <= b.x ? a.x : b.x;
			var endX:uint=a.x <= b.x ? b.x : a.x;

			for (var x:uint=startX + 1; x < endX; x++)
			{
				//只要一个不是-1，直接返回false 
				if (map.get(x, a.y) != EMPTY_ITEM)
					return null;
			}

			_result.fill(a.clone(), b.clone());
			return _result;
		}

		private function vTest(a:Point, b:Point):PathMatchResultVO
		{
			//如果点击的是同一个图案，直接返回false  
			if (a.x == b.x && a.y == b.y)
				return null;

			var startY:uint=a.y <= b.y ? a.y : b.y;
			var endY:uint=a.y <= b.y ? b.y : a.y;

			for (var y:uint=startY + 1; y < endY; y++)
			{
				//只要一个不是-1，直接返回false 
				if (map.get(a.x, y) != EMPTY_ITEM)
					return null;
			}

			_result.fill(a.clone(), b.clone());
			return _result;
		}

		private function oneCornerTest(a:Point, b:Point):PathMatchResultVO
		{
			var c:Point=new Point(a.x, b.y);
			var d:Point=new Point(b.x, a.y);

			var matched:Boolean=false;

			if (map.get(c.x, c.y) == EMPTY_ITEM) //C 点上必须没有障碍
			{
				matched=(hTest(b, c) && vTest(a, c));
				if (matched)
				{
					_result.clear();
					_result.fill(a.clone(), c.clone(), b.clone());
					return _result;
				}
			}

			if (map.get(d.x, d.y) == EMPTY_ITEM) //D 点上必须没有障碍
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
			for (x=a.x; x < actualWidth; x++)
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
			for (y=a.y; y < actualHeight; y++)
			{
				if (map.get(a.x, y) == -1 && map.get(b.x, y) == -1 && hTest(new Point(a.x, y), new Point(b.x, y)))
				{
					v.push(new Line(Line.HORIZONTAL, new Point(a.x, y), new Point(b.x, y)));
				}
			}

			return v;
		}

		private function twoCornerTest(a:Point, b:Point):PathMatchResultVO
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

			var w:int=m.width;
			var h:int=m.height;
			var index:int;

			if (w >= h)
			{
				for (var col:Number=0; col < w; col++)
				{
					var max_y:Number=Math.min(col + 1, h);

					for (var y1:Number=0; y1 < max_y; y1++)
					{
						index = int(m.get(col, y1));
						if (isAvailableItem(index))
							return new Point(col, y1);
					}

					for (var x1:Number=0; x1 < col; x1++)
					{
						index = int(m.get(x1, max_y - 1));
						if (isAvailableItem(index))
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
						index = int(m.get(x2, row));
						if (isAvailableItem(index))
							return new Point(x2, row);
					}

					for (var y2:Number=0; y2 < row; y2++)
					{
						index = int(m.get(max_x - 1, y2));
						if (isAvailableItem(index))
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

			var tmpMap:Array2=ArrayUtil.cloneArray2(map);

			tmpMap.set(a.x, a.y, EMPTY_ITEM);

			if (ignore_b_arr && ignore_b_arr.length)
			{
				for each (var bb:Point in ignore_b_arr)
					tmpMap.set(bb.x, bb.y, EMPTY_ITEM);
			}

			var b:Point=_findRestPointA(tmpMap);

			if (!b)
				return null;

			while (map.get(a.x, a.y) != map.get(b.x, b.y))
			{
				tmpMap.set(b.x, b.y, EMPTY_ITEM);

				b=_findRestPointA(tmpMap);

				if (!b)
					return null;
			}

			return b;
		}

		public function get items():Vector.<ItemVO>
		{
			return _items;
		}

		public function get emptyItems():Array
		{
			return _emptyItems;
		}

		/////////////////////////////////////////////////////////////////////////////////////////////////////
		//  Aug 18, 2012 by Jack, Code for move item at 4 directions when other items are disposed.
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Move all the items align right by the "p" to left.
		 * @param p
		 */
		private function moveToLeft(p:Point):void
		{
			var i:int;
			var j:int;
			var index:int;
			var distance:int;
			if(p.x < maxX)
			{
				for (i = p.x+1; i <= maxX; i++) 
				{
					index = map.get(i, p.y);
					if(isAvailableItem(index))
					{
						distance=0;
						// move item to left as far as possible, stop when meet a item or stone
						for (j = i-1; j >= minX; j--) 
						{
							if(map.get(j, p.y) == EMPTY_ITEM)
								distance++;
							else
								break;
						}
						if(distance > 0)
						{
							// set empty spot to item
							map.set(i-distance, p.y, index);
							// set item to empty spot
							map.set(i, p.y, EMPTY_ITEM);
							// add to the move item list
							moveList.push(new MoveItemVO(new Point(i, p.y), new Point(i-distance, p.y)));							
						}
					}
				}				
			}
		}
		
		/**
		 * Move all the items align left by the "p" to right.
		 * @param p
		 */
		private function moveToRight(p:Point):void
		{
			var i:int;
			var j:int;
			var index:int;
			var distance:int;
			if(p.x <= maxX)
			{
				for (i = p.x-1; i >= minX; i--) 
				{
					index = map.get(i, p.y);
					if(isAvailableItem(index))
					{
						distance=0;
						// move item to left as far as possible, stop when meet a item or stone
						for (j = i+1; j <= maxX; j++) 
						{
							if(map.get(j, p.y) == EMPTY_ITEM)
								distance++;
							else
								break;
						}
						if(distance > 0)
						{
							// set empty spot to item
							map.set(i+distance, p.y, index);
							// set item to empty spot
							map.set(i, p.y, EMPTY_ITEM);
							// add to the move item list
							moveList.push(new MoveItemVO(new Point(i, p.y), new Point(i+distance, p.y)));							
						}
					}
				}				
			}
		}
		
		/**
		 * Move all the items align bottom by the "p" to top.
		 * @param p
		 */
		private function moveToTop(p:Point):void
		{
			var i:int;
			var j:int;
			var index:int;
			var distance:int;
			
			for (i = p.y+1; i <= maxY; i++) 
			{
				index = map.get(p.x, i);
				if(isAvailableItem(index))
				{
					distance=0;
					// move item to left as far as possible, stop when meet a item or stone
					for (j = i-1; j >= minY; j--) 
					{
						if(map.get(p.x, j) == EMPTY_ITEM)
							distance++;
						else
							break;
					}
					if(distance > 0)
					{
						// set empty spot to item
						map.set(p.x, i-distance, index);
						// set item to empty spot
						map.set(p.x, i, EMPTY_ITEM);
						// add to the move item list
						moveList.push(new MoveItemVO(new Point(p.x, i), new Point(p.x, i-distance)));							
					}
				}
			}		
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
