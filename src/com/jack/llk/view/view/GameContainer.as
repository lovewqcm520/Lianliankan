package com.jack.llk.view.view
{
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
		public static const INTERVAL_RANDOM_ANIMATE_ITEM:int = 15000;
		
		private var canvas:BaseSprite;
		private var round:RoundVO;
		private var items:Array2;
		private var animateItems:Vector.<ItemVO>;
		
		private var lastPoint:Point=new Point(-1, -1);
		private var tempLastTime:int=0;	
		private var numActivate:int;
		
		public function GameContainer()
		{
			super();
			

		}
		
		override public function dispose():void
		{
			round = null;
			items = null;
			animateItems = null;
			lastPoint = null;
			
			super.dispose();
		}
		
		public function reset():void
		{
			
		}
		
		public function init(roundData:RoundVO):void
		{
			this.round = roundData;
			//initGameRoundParameters();
			initGameCenter();
		}
		
		// init some necessary parameters for this round
		private function initGameRoundParameters():void
		{
		}
		
		// init the game visual
		private function initGameCenter():void
		{
			// reset some data
			lastPoint.x = -1;
			lastPoint.y = -1;
			numActivate = 0;
			if(canvas)
			{
				canvas.removeFromParent(true);
				canvas = null;
				items = null;
				animateItems = null;
			}
			
			// new some data
			var itemW:Number = round.nTileWidth;
			var itemH:Number = round.nTileHeight;
			var gapX:Number = round.nGapHorizontal;
			var gapY:Number = round.nGapVertical;
			var col:int = round.col;
			var row:int = round.row;
			
			// draw the items
			canvas = new BaseSprite();			
			items = new Array2(round.actualCol, round.actualRow);
			for (var i:int = 1; i <= col; i++) 
			{
				for (var j:int = 1; j <= row; j++) 
				{
					var itemIndex:int = int(round.getItemIndex(i, j));
					if(itemIndex != MapVO.EMPTY)
					{
						var item:ItemMovieClip = new ItemMovieClip(itemIndex, i, j);
						if(item)
						{
							item.x = (i-1)*(itemW+gapX);
							item.y = (j-1)*(itemH+gapY);
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
			numActivate = 0;
			lastPoint.x = -1;
			lastPoint.y = -1;
		}	
		
		private function onItemActivate(i:int, j:int):void
		{
			if(numActivate != 0 && lastPoint.x != i || lastPoint.y != j)
			{
				// test 2 item
				var t:Point = new Point(i, j);
				if(round.test2Items(lastPoint, t))
				{					
					// dispose the two items that matched
					dispose2Items(lastPoint, t)
					
					// reset some flag
					numActivate = 0;
					lastPoint.x = -1;
					lastPoint.y = -1;
					
					return;
				}					
				else
				{
					// set previous item to small status
					var item:ItemMovieClip = items.get(lastPoint.x, lastPoint.y) as ItemMovieClip;
					if(item)
					{
						item.activated = false;
					}
				}
			}			
			
			lastPoint.x = i;
			lastPoint.y = j;
			numActivate = 1;
		}
		
		private function dispose2Items(a:Point, b:Point):void
		{
			var aItem:ItemMovieClip = items.get(a.x, a.y) as ItemMovieClip;
			var bItem:ItemMovieClip = items.get(b.x, b.y) as ItemMovieClip;
			
			// draw explosion and lines
			drawLines(round.matchedRouteList);
			
			// dispose items
			if(aItem)
			{
				aItem.disappear();
				aItem = null;
			}
			if(bItem)
			{
				bItem.disappear();
				bItem = null;
			}
			
			// delete from map
			round.erase2Items(a, b);
			// delete from items
			items.set(a.x, a.y, null);
			items.set(b.x, b.y, null);
		}
		
		public function refreshMap():void
		{
			// refresh the map data
			round.refreshMap();
			
			// refresh the items
			initGameCenter();
			
			SoundManager.play(SoundFactors.SHUA_XIN_MUSIC);
		}
		
		public function bomb2Items():void
		{
			// find 2 items
			var arr:Array = round.find2Items();
			if(arr && arr.length == 2)
			{
				trace(arr.toString());
				// dispose 2 items
				dispose2Items(arr[0], arr[1]);
				
				// play bomb sound
				SoundManager.play(SoundFactors.ZHA_DAN_MUSIC);
			}
		}
		
		public function findLine():void
		{
			// find 2 items
			var arr:Array = round.find2Items();
			if(arr && arr.length == 2)
			{
				trace(arr.toString());
				var aItem:ItemMovieClip = items.get(arr[0].x, arr[0].y) as ItemMovieClip;
				var bItem:ItemMovieClip = items.get(arr[1].x, arr[1].y) as ItemMovieClip;
				
				if(aItem)
				{
					aItem.showFindAnimation();
				}
				
				if(bItem)
				{
					bItem.showFindAnimation();
				}
				
				// play the find match items sound
				SoundManager.play(SoundFactors.DAO_JU_MUSIC);
			}
		}
		
		public function showItemIdleAnimation():void
		{
			var t:int = getTimer();
			if(t - tempLastTime >= INTERVAL_RANDOM_ANIMATE_ITEM)
			{
				tempLastTime = t;
				
				var voItem:ItemVO;
				var item:ItemMovieClip;
				
				var i:int;
				// stop old animation first
				if(animateItems && animateItems.length > 0)
				{
					
					for (i = 0; i <animateItems.length; i++) 
					{
						voItem = animateItems[i];
						item = items.get(voItem.x, voItem.y) as ItemMovieClip;
						if(item)
						{
							item.stopSmallAnimation();
						}
					}
				}
				
				// play new animation then
				var remain:int = round.nAvailableItems;		
				var nRandomItems:int = round.nFlicker;
				animateItems = ArrayUtil.getRandomElements(round.availableItemVector, nRandomItems);
				if(animateItems && animateItems.length > 0)
				{
					for (i = 0; i <nRandomItems; i++) 
					{
						voItem = animateItems[i];
						item = items.get(voItem.x, voItem.y) as ItemMovieClip;
						if(item)
						{
							item.playSmallAnimation();
						}
					}
				}
				
				Log.log("showItemDefAnimation");
			}
		}
		
		// draw lines between 2 available items
		private function drawLines(list:Array):void
		{
			var chain:ThunderChain = new ThunderChain();			
			canvas.addChild(chain);
			chain.initialize(list, round.nTileWidth, round.nTileHeight, round.nGapHorizontal, round.nGapVertical);
		}
	}
}