package com.jack.llk.view.view
{
	import com.jack.llk.control.factors.SoundFactors;
	import com.jack.llk.control.sound.SoundManager;
	import com.jack.llk.log.Log;
	import com.jack.llk.util.ArrayUtil;
	import com.jack.llk.view.BaseSprite;
	import com.jack.llk.view.ItemMovieClip;
	import com.jack.llk.view.component.chain.ThunderChain;
	import com.jack.llk.vo.map.ItemVO;
	import com.jack.llk.vo.map.Map;
	
	import de.polygonal.ds.Array2;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	public class GameContainer extends BaseSprite
	{
		private var canvas:BaseSprite;
		private var map:Map;		
		private var items:Array2;
		
		public static const INTERVAL_RANDOM_ANIMATE_ITEM:int = 10000;
		private var animateItems:Vector.<ItemVO>;
		
		private var p:Point=new Point(-1, -1);
		private var numActivate:int=0;
		private var numAnimate:int = 10;
		private var itemW:Number;
		private var itemH:Number;
		private var gapX:Number;
		private var gapY:Number;
		private var tempLastTime:int=0;	
		private var nRandomItems:int = 5;
		
		public function GameContainer()
		{
			super();
			
			initGameCenter();
		}
		
		private function initGameCenter():void
		{
			var oldTime:Number = getTimer();
			
			var col:int = 10;
			var row:int = 10;
			
			if(!map)
			{
				map = new Map(col, row, 100, 10);
			}
			
			itemW = 36;
			itemH = 38;
	
			gapX = 2;
			gapY = 2;
			
			// reset some data
			p.x = -1;
			p.y = -1;
			numActivate = 0;
			if(canvas)
			{
				canvas.removeFromParent(true);
				canvas = null;
				items = null;
			}
			
			// new some data
			canvas = new BaseSprite();			
			items = new Array2(col+2, row+2);
			for (var i:int = 1; i <= col; i++) 
			{
				for (var j:int = 1; j <= row; j++) 
				{
					var itemIndex:int = int(map.map.get(i, j));
					if(itemIndex != Map.EMPTY)
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
							trace("initGameCenter wrong", itemIndex);
						}
					}
				}				
			}
			
			addChild(canvas);
			
			Log.traced("initGameCenter takes", getTimer()-oldTime, "ms.");
		}
		
		private function onItemInactivate(i:int, j:int):void
		{
			// reset some flag
			numActivate = 0;
			p.x = -1;
			p.y = -1;
		}	
		
		private function onItemActivate(i:int, j:int):void
		{
			trace("onGameClick", i, j);
			
			if(numActivate != 0 && p.x != i || p.y != j)
			{
				// test 2 item
				var t:Point = new Point(i, j);
				if(map.test(p, t))
				{					
					// dispose the two items that matched
					dispose2Items(p, t)
					
					// reset some flag
					numActivate = 0;
					p.x = -1;
					p.y = -1;
					
					return;
				}					
				else
				{
					// set previous item to small status
					var item:ItemMovieClip = items.get(p.x, p.y) as ItemMovieClip;
					if(item)
					{
						item.activated = false;
					}
				}
			}			
			
			p.x = i;
			p.y = j;
			numActivate = 1;
		}
		
		private function dispose2Items(a:Point, b:Point):void
		{
			var aItem:ItemMovieClip = items.get(a.x, a.y) as ItemMovieClip;
			var bItem:ItemMovieClip = items.get(b.x, b.y) as ItemMovieClip;
			
			// draw explosion and lines
			drawLines(map.result.list);
			
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
			map.earse(a, b);
			// delete from items
			items.set(a.x, a.y, null);
			items.set(b.x, b.y, null);
		}
		
		public function refreshMap():void
		{
			// refresh the map data
			map.refresh();
			
			// refresh the items
			initGameCenter();
			
			SoundManager.play(SoundFactors.SHUA_XIN_MUSIC);
		}
		
		public function bomb2Items():void
		{
			// find 2 items
			var arr:Array = map.autoFindItem();
			if(arr && arr.length == 2)
			{
				trace(arr.toString());
				// dispose 2 items
				dispose2Items(arr[0], arr[1]);
				
				// play bomb sound
				SoundManager.play(SoundFactors.ZHA_DAN_MUSIC);
			}
		}
		
		public function autoFindLine():void
		{
			// find 2 items
			var arr:Array = map.autoFindItem();
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
				var remain:int = map.count;							
				animateItems = ArrayUtil.getRandomElements(map.items, nRandomItems);
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
				
				trace("showItemDefAnimation");
			}
		}
		
		private function drawLines(list:Array):void
		{
			var chain:ThunderChain = new ThunderChain();			
			canvas.addChild(chain);
			chain.initialize(list, itemW, itemH);
		}
	}
}