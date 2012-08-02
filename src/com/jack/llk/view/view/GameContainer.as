package com.jack.llk.view.view
{
	import com.jack.llk.control.Constant;
	import com.jack.llk.control.factors.SoundFactors;
	import com.jack.llk.control.sound.SoundManager;
	import com.jack.llk.log.Log;
	import com.jack.llk.view.BaseSprite;
	import com.jack.llk.view.ItemMovieClip;
	import com.jack.llk.view.component.chain.ThunderChain;
	import com.jack.llk.vo.map.Map;
	import com.jack.llk.vo.map.MatchResult;
	
	import de.polygonal.ds.Array2;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	public class GameContainer extends BaseSprite
	{
		private var canvas:BaseSprite;
		private var map:Map;		
		private var items:Array2;
		
		private var a:Point=new Point(-1, -1);
		private var b:Point=new Point(-1, -1);
		private var numActivate:int=0;
		private var numAnimate:int = 10;
		private var itemW:Number;
		private var itemH:Number;
		private var gapX:Number;
		private var gapY:Number;
		private var tempLastTime:int=0;
		
		public static const INTERVAL_RANDOM_ANIMATE_ITEM:int = 5000;
		
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
				map = new Map(col, row, 26, 10);
			}
			
			itemW = 36;
			itemH = 38;
	
			gapX = 2;
			gapY = 2;
			
			// reset some data
			a.x = -1;
			a.y = -1;
			b.x = -1;
			b.y = -1;
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
			b.x = -1;
			b.y = -1;
		}	
		
		private function onItemActivate(i:int, j:int):void
		{
			trace("onGameClick", i, j);
			
			if(numActivate != 0 && b.x != i || b.y != j)
			{
				// test 2 item
				var p:Point = new Point(i, j);
				if(map.test(b, p))
				{									
					var aItem:ItemMovieClip = items.get(b.x, b.y) as ItemMovieClip;
					var bItem:ItemMovieClip = items.get(i, j) as ItemMovieClip;
					
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
					map.earse(b, p);
					// delete from items
					items.set(b.x, b.y, null);
					items.set(i, j, null);
					
					// reset some flag
					numActivate = 0;
					b.x = -1;
					b.y = -1;
					
					return;
				}					
				else
				{
					// set previous item to small status
					var item:ItemMovieClip = items.get(b.x, b.y) as ItemMovieClip;
					if(item)
					{
						item.activated = false;
					}
				}
			}			
			
			b.x = i;
			b.y = j;
			numActivate = 1;
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
			var match:MatchResult = map.autoFindLine();
			if(match)
			{
				trace(match.list.toString());
				
				SoundManager.play(SoundFactors.ZHA_DAN_MUSIC);
			}
		}
		
		public function autoFindLine():void
		{
			// find 2 items
			var match:MatchResult = map.autoFindLine();
			if(match)
			{
				trace(match.list.toString());
				
				// play the find match items sound
				SoundManager.play(SoundFactors.DAO_JU_MUSIC);
			}
		}
		
		public function showItemDefAnimation():void
		{
			var t:int = getTimer();
			if(t - tempLastTime >= INTERVAL_RANDOM_ANIMATE_ITEM)
			{
				tempLastTime = t;
				
				var remain:int = map.count;
				
				var arr:Array=[];
				var item:ItemMovieClip;
				for (var i:int = 1; i <= width; i++) 
				{
					for (var j:int = 1; j <= height; j++) 
					{
						item = items.get(i, j) as ItemMovieClip;
						if(item)
						{
						}
					}
				}
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