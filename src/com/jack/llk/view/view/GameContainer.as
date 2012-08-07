package com.jack.llk.view.view
{
	import com.jack.llk.Game;
	import com.jack.llk.control.events.EventController;
	import com.jack.llk.control.events.GameEvent;
	import com.jack.llk.control.factors.SoundFactors;
	import com.jack.llk.control.sound.SoundManager;
	import com.jack.llk.log.Log;
	import com.jack.llk.util.ArrayUtil;
	import com.jack.llk.view.BaseSprite;
	import com.jack.llk.view.ItemMovieClip;
	import com.jack.llk.view.component.chain.ThunderChain;
	import com.jack.llk.vo.RoundVO;
	import com.jack.llk.vo.map.ItemVO;
	import com.jack.llk.vo.map.MapVO;
	
	import de.polygonal.ds.Array2;
	
	import flash.geom.Point;
	import flash.utils.getTimer;

	public class GameContainer extends BaseSprite
	{
		public static const INTERVAL_RANDOM_ANIMATE_ITEM:int=15000;

		private var canvas:BaseSprite;
		private var round:RoundVO;
		private var items:Array2;
		private var animateItems:Vector.<ItemVO>;

		private var lastPoint:Point=new Point(-1, -1);
		private var tmpLastTime:int=0;
		private var numActivate:int;
		private var _curCombo:int=0;
		private var tmpLastBatterTime:Number=Number.MAX_VALUE;

		public function GameContainer()
		{
			super();
		}

		override public function dispose():void
		{
			round=null;
			items=null;
			animateItems=null;
			lastPoint=null;
			
			super.dispose();
			
			Game.getInstance().gameCanvas=null;
		}

		public function reset():void
		{

		}

		public function init(roundData:RoundVO):void
		{
			this.round=roundData;
			//initGameRoundParameters();
			initGameCenter();
		}

		// init some necessary parameters for this round
		private function initGameRoundParameters():void
		{
		}

		private function resetData():void
		{
			lastPoint.x=-1;
			lastPoint.y=-1;
			numActivate=0;
			curCombo=0;
			tmpLastBatterTime=Number.MAX_VALUE;
		}
		
		// init the game visual
		private function initGameCenter():void
		{
			// reset some data
			resetData();
			if (canvas)
			{
				canvas.removeFromParent(true);
				canvas=null;
				items=null;
				animateItems=null;
			}

			// new some data
			var itemW:Number=round.nTileWidth;
			var itemH:Number=round.nTileHeight;
			var gapX:Number=round.nGapHorizontal;
			var gapY:Number=round.nGapVertical;
			var col:int=round.col;
			var row:int=round.row;

			// draw the items
			canvas=new BaseSprite();
			items=new Array2(round.actualCol, round.actualRow);
			for (var i:int=1; i <= col; i++)
			{
				for (var j:int=1; j <= row; j++)
				{
					var itemIndex:int=int(round.getItemIndex(i, j));
					if (itemIndex != MapVO.EMPTY_ITEM)
					{
						var item:ItemMovieClip=new ItemMovieClip(itemIndex, i, j);
						if (item)
						{
							item.x=(i - 1) * (itemW + gapX);
							item.y=(j - 1) * (itemH + gapY);
							item.onActivate(onItemActivate, i, j);
							item.onInactivate(onItemInactivate, i, j);
							canvas.addChild(item);
							items.set(i, j, item);
						}
						else
						{
							Log.error("initGameCenter wrong", itemIndex);
						}
					}
				}
			}
			addChild(canvas);
		}

		private function onItemInactivate(i:int, j:int):void
		{
			// reset some flag
			numActivate=0;
			lastPoint.x=-1;
			lastPoint.y=-1;
		}

		private function onItemActivate(i:int, j:int):void
		{
			if (numActivate != 0 && (lastPoint.x != i || lastPoint.y != j))
			{
				// test 2 item
				var t:Point=new Point(i, j);
				if (round.test2Items(lastPoint, t))
				{
					// increase the combo
					curCombo++;

					// dispose the two items that matched
					dispose2Items(lastPoint, t)

					// reset some flag
					numActivate=0;
					lastPoint.x=-1;
					lastPoint.y=-1;
					return;
				}
				else
				{
					// reset the nCurCombo to 0 if missed
					curCombo=0;

					// set previous item to small status
					var item:ItemMovieClip=items.get(lastPoint.x, lastPoint.y) as ItemMovieClip;
					if (item)
					{
						item.activated=false;
					}
				}
			}

			lastPoint.x=i;
			lastPoint.y=j;
			numActivate=1;
		}

		/**
		 * Dispose 2 items and clear the data.
		 * @param a
		 * @param b
		 */
		private function dispose2Items(a:Point, b:Point):void
		{
			var aItem:ItemMovieClip=items.get(a.x, a.y) as ItemMovieClip;
			var bItem:ItemMovieClip=items.get(b.x, b.y) as ItemMovieClip;

			// draw explosion and lines
			drawLines(round.matchedRouteList);

			// dispose items
			if (aItem)
			{
				aItem.disappear();
				aItem=null;
			}
			if (bItem)
			{
				bItem.disappear();
				bItem=null;
			}

			// delete from map
			round.erase2Items(a, b);
			// delete from items
			items.set(a.x, a.y, null);
			items.set(b.x, b.y, null);

			// check whether the game was over
			if (round.isMapEmpty())
			{
				// game over
				var e:GameEvent=new GameEvent(GameEvent.GAME_WIN);
				EventController.e.dispatchEvent(e);
			}
		}

		public function refreshMap(useTool:Boolean=true):Boolean
		{
			if(useTool && round.nRefreshTool <= 0)
				return false;
			
			// refresh the map data
			var isOK:Boolean = round.refreshMap();

			if(isOK)
			{
				// refresh the items
				initGameCenter();
				
				SoundManager.play(SoundFactors.SHUA_XIN_MUSIC);
				
				if(useTool)
					round.nRefreshTool--;
			}
			
			return isOK;
		}

		public function bomb2Items(useTool:Boolean=true):void
		{
			if(useTool && round.nBombTool <= 0)
				return;
			
			// find 2 items
			var arr:Array=round.find2Items();
			if (arr && arr.length == 2)
			{
				// increase the combo
				curCombo++;

				// dispose 2 items
				dispose2Items(arr[0], arr[1]);

				// play bomb sound
				SoundManager.play(SoundFactors.ZHA_DAN_MUSIC);
				
				if(useTool)
					round.nBombTool--;
			}
		}

		public function findLine(useTool:Boolean=true):void
		{
			if(useTool && round.nFindTool <= 0)
				return;
			
			// find 2 items
			var arr:Array=round.find2Items();
			if (arr && arr.length == 2)
			{
				var aItem:ItemMovieClip=items.get(arr[0].x, arr[0].y) as ItemMovieClip;
				var bItem:ItemMovieClip=items.get(arr[1].x, arr[1].y) as ItemMovieClip;

				if (aItem)
				{
					aItem.showFindAnimation();
				}

				if (bItem)
				{
					bItem.showFindAnimation();
				}

				// play the find match items sound
				SoundManager.play(SoundFactors.DAO_JU_MUSIC);
				
				if(useTool)
					round.nFindTool--;
			}
		}

		public function showItemIdleAnimation():void
		{
			var t:int=getTimer();
			if (t - tmpLastTime >= INTERVAL_RANDOM_ANIMATE_ITEM)
			{
				tmpLastTime=t;

				var voItem:ItemVO;
				var item:ItemMovieClip;

				var i:int;
				// stop old animation first
				if (animateItems && animateItems.length > 0)
				{

					for (i=0; i < animateItems.length; i++)
					{
						voItem=animateItems[i];
						item=items.get(voItem.x, voItem.y) as ItemMovieClip;
						if (item)
						{
							item.stopSmallAnimation();
						}
					}
				}

				// play new animation then
				var remain:int=round.nAvailableItems;
				var nRandomItems:int=round.nFlicker;
				animateItems=ArrayUtil.getRandomElements(round.availableItemVector, nRandomItems);
				if (animateItems && animateItems.length >= nRandomItems)
				{
					for (i=0; i < nRandomItems; i++)
					{
						voItem=animateItems[i];
						item=items.get(voItem.x, voItem.y) as ItemMovieClip;
						if (item)
						{
							item.playSmallAnimation();
						}
					}
				}
			}
		}

		// draw lines between 2 available items
		private function drawLines(list:Array):void
		{
			var chain:ThunderChain=new ThunderChain();
			canvas.addChild(chain);
			chain.initialize(list, round.nTileWidth, round.nTileHeight, round.nGapHorizontal, round.nGapVertical);
		}

		public function get curCombo():int
		{
			return _curCombo;
		}

		public function set curCombo(value:int):void
		{
			var newBatterTime:Number = getTimer();
			if(newBatterTime - tmpLastBatterTime <= round.batterInterval)
			{
				_curCombo = value;
				
				if(value >= 2)
				{
					round.comboCur = value - 1;
				}
			}		
			else
			{
				_curCombo = 1;
			}
			
			tmpLastBatterTime = newBatterTime;
		}

	}
}
