package com.jack.llk.vo
{
	import com.jack.llk.control.Common;
	import com.jack.llk.control.events.EventController;
	import com.jack.llk.control.events.GameEvent;
	import com.jack.llk.util.ArrayUtil;
	import com.jack.llk.vo.map.ItemVO;
	import com.jack.llk.vo.map.MapVO;
	import com.jack.llk.vo.map.PathMatchResultVO;
	
	import de.polygonal.ds.Array2;
	
	import flash.geom.Point;
	
	/**
	 * 
	 * @author Jack
	 */
	public class RoundVO
	{
		// Array2 map contains the map tile data
		public var voMap:MapVO;

		// game round parameter
		public var name:String;
		public var level:int;
		public var nStar:int;
		public var totalTime:Number;
		public var warningTime:Number;
		public var timeUsed:Number;
		public var batterInterval:Number=3000;

		// how many different type items are using
		public var nItemTypes:int = 24;		
		public var nFlicker:int=6;

		// map layout
		public var nItemWidth:Number=Common.ITEM_SMALL_WIDTH;
		public var nItemHeight:Number=Common.ITEM_SMALL_HEIGHT;
		public var nGapHorizontal:Number=0;
		public var nGapVertical:Number=0;
		public var nPaddingTop:Number=0;
		public var nPaddingBottom:Number=0;
		public var nPaddingLeft:Number=0;
		public var nPaddingRight:Number=0;

		// map size
		public var width:int;
		public var height:int;
		public var actualWidth:int;
		public var actualHeight:int;

		// available item
		public var nAvailableItems:int;
		public var numTotalItems:int;
		// max combo
		public var comboMax:int;
		// cur combo
		private var _comboCur:int;
		// current level user scores
		public var scores:int=0;

		// other functional item (like stone, block or something)
		public var numStoneItems:int;
		public var numToolItems:int;
		public var nPaintedEggs:int;
		public var nEggItems:int;
		
		// tools
		private var _nRefreshTool:int=0;
		private var _nBombTool:int=0;
		private var _nFindTool:int=0;

		private var lastToolItemPoint:Point;
		private var gameMode:int;

		public function RoundVO(gameMode:int)
		{
			this.gameMode = gameMode;
		}

		public function importFromXML(x:XML):void
		{
			var data:String;
			
			name = 				x.attribute("name");
			level = 			x.attribute("level");
			width = 			x.attribute("width");
			height = 			x.attribute("height");
			actualWidth = 		x.attribute("actualWidth");
			actualHeight = 		x.attribute("actualHeight");
			numTotalItems =		x.attribute("numTotalItems");
			numToolItems = 		x.attribute("numToolItems");
			numStoneItems =	 	x.attribute("numStoneItems");
			numRefreshTool = 	x.attribute("numRefreshTool");
			numBombTool = 		x.attribute("numBombTool");
			numFindTool = 		x.attribute("numFindTool");
			totalTime = 		x.attribute("totalTime");
			warningTime = 		x.attribute("warningTime");
			data = 				x.attribute("data");
			
			// testonly
			numRefreshTool = 1000;
			numBombTool = 1000;
			numFindTool = 1000;
			if(gameMode == Common.GAME_MODEL_TIME)
			{
				totalTime = Common.TIME_MODEL_TIMES[level-1];
			}
			else if(gameMode == Common.GAME_MODEL_ENDLESS)
			{
				totalTime = Common.ENDLESS_MODEL_TIME;
			}
			
			nAvailableItems = numTotalItems - numToolItems - numStoneItems;
			// init the map data
			init(data);
		}
		
		/**
		 * Return a empty point.
		 * @return 
		 */
		public function getAnRandomEmptyPoint():Point
		{
			var emptyItems:Array = ArrayUtil.random(voMap.emptyItems);
			if(emptyItems && emptyItems.length > 0)
				return emptyItems[0];
			
			return null;
		}
		
		/**
		 *
		 */
		private function init(data:String):void
		{
			voMap=new MapVO();

			voMap.width=width;
			voMap.height=height;
			voMap.actualWidth=actualWidth;
			voMap.actualHeight=actualHeight;
			voMap.nAvailableItems=nAvailableItems;
			voMap.nItemTypes=nItemTypes;
			voMap.nStoneItems=numStoneItems;
			voMap.nToolItems=numToolItems;
			voMap.numTotalItems=numTotalItems;

			voMap.init(data, gameMode);
		}

		/**
		 * Return the vector contains all the available items, element was ItemVO.
		 * @return
		 */
		public function get availableItemVector():Vector.<ItemVO>
		{
			return voMap.items;
		}

		/**
		 * Return the latest test item action route list.
		 * @return
		 */
		public function get matchedRouteList():Array
		{
			return voMap.result.list;
		}

		/**
		 * Get the item's type index from map data.
		 * @param x
		 * @param y
		 * @return
		 */
		public function getItemIndex(x:int, y:int):*
		{
			return voMap.getItemIndex(x, y);
		}

		/**
		 * Update the item's type index to map data.
		 * @param x
		 * @param y
		 * @param itemIndex
		 */
		public function setItemIndex(x:int, y:int, itemIndex:int):void
		{
			voMap.setItemIndex(x, y, itemIndex);
		}

		/**
		 * Return true if map was empty, all items are cleared.
		 * @return
		 */
		public function isMapEmpty():Boolean
		{
			return voMap.count == 0;
		}

		/**
		 * Return how many available item rest.
		 * @return
		 */
		public function get nRestItems():int
		{
			return voMap.count;
		}

		/**
		 * Return ture if 2 items are available and can be cleared.
		 * @param a
		 * @param b
		 * @return
		 */
		public function test2Items(a:Point, b:Point):Boolean
		{
			return voMap.test(a, b);
		}

		/**
		 * Erase 2 items.
		 * @param a
		 * @param b
		 */
		public function erase2Items(a:Point, b:Point):void
		{
			// 判断消除的一对item是否是特殊物品
			var aIndex:int = int(map.get(a.x, a.y));
			var bIndex:int = int(map.get(b.x, b.y));
			
			// erase 2 items
			voMap.erase(a, b);
			
			// update current level scores
			scores += Common.ITEM_SCORE;
			
			// detect the item type
			if(aIndex == bIndex)
			{
				lastToolItemPoint = b.clone();
				var e:GameEvent;
				switch(aIndex)
				{
					case MapVO.EGG_ITEM:
					{
						e = new GameEvent(GameEvent.GET_TOOL_EGG, lastToolItemPoint);
						nEggItems++;
						break;
					}
						
					case MapVO.FIND_ITEM:
					{
						numFindTool++;
						break;
					}
						
					case MapVO.BOMB_ITEM:
					{
						numBombTool++;
						break;
					}
						
					case MapVO.REFRESH_ITEM:
					{
						numRefreshTool++;
						break;
					}
						
					case MapVO.TIME_ITEM:
					{
						e = new GameEvent(GameEvent.GET_TOOL_TIME, lastToolItemPoint);
						break;
					}
				}
				// dispatch the event
				if(e)
					EventController.e.dispatchEvent(e);
			}
			
			// check whether the game was over
			if (isMapEmpty())
			{
				// game over
				var e1:GameEvent=new GameEvent(GameEvent.GAME_WIN);
				EventController.e.dispatchEvent(e1);
			}
		}

		/**
		 * Find 2 items are available and can be cleared.
		 * @return
		 */
		public function find2Items():Array
		{
			return voMap.find2Items();
		}

		/**
		 * Find 2 items are available and can be cleared.
		 * @return
		 */
		public function findLine():PathMatchResultVO
		{
			return voMap.findLine();
		}

		/**
		 * Refresh map based on current all available items.
		 */
		public function refreshMap():Boolean
		{
			return voMap.refresh();
		}

		private function get map():Array2
		{
			return voMap.map;
		}

		public function get comboCur():int
		{
			return _comboCur;
		}

		public function set comboCur(value:int):void
		{
			_comboCur=value;
			
			// update the max combo
			comboMax=Math.max(_comboCur, comboMax);
			
			// if cur combo > 0, dispatch the event
			var e:GameEvent=new GameEvent(GameEvent.BATTER);
			EventController.e.dispatchEvent(e);
		}

		public function get numRefreshTool():int
		{
			return _nRefreshTool;
		}

		public function set numRefreshTool(value:int):void
		{
			if(_nRefreshTool != value && value >= 0)
			{
				var e:GameEvent;
				if(_nRefreshTool > value)
				{
					e = new GameEvent(GameEvent.USE_TOOL_REFRESH);
				}
				else
				{
					e = new GameEvent(GameEvent.GET_TOOL_REFRESH, lastToolItemPoint);
				}
				_nRefreshTool = value;	
				EventController.e.dispatchEvent(e);
			}
		}

		public function get numBombTool():int
		{
			return _nBombTool;
		}

		public function set numBombTool(value:int):void
		{
			if(_nBombTool != value && value >= 0)
			{
				var e:GameEvent;
				if(_nBombTool > value)
				{
					e = new GameEvent(GameEvent.USE_TOOL_BOMB);
				}
				else
				{
					e = new GameEvent(GameEvent.GET_TOOL_BOMB, lastToolItemPoint);
				}
				_nBombTool = value;	
				EventController.e.dispatchEvent(e);
			}
		}

		public function get numFindTool():int
		{
			return _nFindTool;
		}

		public function set numFindTool(value:int):void
		{
			if(_nFindTool != value && value >= 0)
			{
				var e:GameEvent;
				if(_nFindTool > value)
				{
					e = new GameEvent(GameEvent.USE_TOOL_FIND);
				}
				else
				{
					e = new GameEvent(GameEvent.GET_TOOL_FIND, lastToolItemPoint);
				}
				_nFindTool = value;	
				EventController.e.dispatchEvent(e);
			}
		}


	}
}
