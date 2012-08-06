package com.jack.llk.vo
{
	import com.jack.llk.control.events.EventController;
	import com.jack.llk.control.events.GameEvent;
	import com.jack.llk.vo.map.ItemVO;
	import com.jack.llk.vo.map.MapVO;
	import com.jack.llk.vo.map.MatchResult;
	
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
		public var nLevel:int;
		public var nStar:int;
		public var totalTime:Number;
		public var warningTime:Number;
		public var timeUsed:Number;
		public var batterInterval:Number;

		// how many different type items are using
		public var nItemTypes:int;

		// map layout
		public var nTileWidth:Number;
		public var nTileHeight:Number;
		public var nGapHorizontal:Number;
		public var nGapVertical:Number;
		public var nPaddingTop:Number;
		public var nPaddingBottom:Number;
		public var nPaddingLeft:Number;
		public var nPaddingRight:Number;

		// map size
		public var col:int;
		public var row:int;
		public var actualCol:int;
		public var actualRow:int;

		// available item
		public var nAvailableItems:int;
		// max combo
		public var comboMax:int;
		// cur combo
		private var _comboCur:int;

		// other functional item (like stone, block or something)
		public var nStoneItems:int;
		public var nPaintedEggs:int;

		public var nFlicker:int;

		// tools
		public var nRefreshTool:int;
		public var nBombTool:int;
		public var nFindTool:int;

		/**
		 *
		 * @param nLevel
		 * @param col
		 * @param row
		 * @param nAvailableItems
		 * @param nItemTypes
		 */
		public function RoundVO(nLevel:int, col:int, row:int, nAvailableItems:int, nItemTypes:int)
		{
			this.nLevel=nLevel;
			this.col=col;
			this.row=row;
			this.nAvailableItems=nAvailableItems;
			this.nItemTypes=nItemTypes;

			this.actualCol=col + 2;
			this.actualRow=row + 2;
		}

		/**
		 *
		 */
		public function init():void
		{
			voMap=new MapVO();

			voMap.col=col;
			voMap.row=row;
			voMap.actualCol=actualCol;
			voMap.actualRow=actualRow;
			voMap.nAvailableItems=nAvailableItems;
			voMap.nItemTypes=nItemTypes;
			voMap.nStones=nStoneItems;

			voMap.init();
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
			map.set(x, y, itemIndex);
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
			voMap.erase(a, b);
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
		public function findLine():MatchResult
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

	}
}
