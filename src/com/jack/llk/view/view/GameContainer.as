package com.jack.llk.view.view
{
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.control.factors.SoundFactors;
	import com.jack.llk.control.sound.SoundManager;
	import com.jack.llk.log.Log;
	import com.jack.llk.view.BaseSprite;
	import com.jack.llk.view.ItemMovieClip;
	import com.jack.llk.view.button.BaseButton;
	import com.jack.llk.vo.map.Map;
	
	import de.polygonal.ds.Array2;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import starling.textures.Texture;
	
	public class GameContainer extends BaseSprite
	{
		private var gameCanvas:BaseSprite;
		private var map:Map;
		
		private var items:Array2;
		private var a:Point=new Point(-1, -1);
		private var b:Point=new Point(-1, -1);
		private var numActivate:int=0;
		
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
				map = new Map(col, row, 10);
			}
			
			var itemW:Number = 36;
			var itemH:Number = 38;
			
	
			var gapX:Number = 2;
			var gapY:Number = 2;
			
			// reset some data
			a.x = -1;
			a.y = -1;
			b.x = -1;
			b.y = -1;
			numActivate = 0;
			if(gameCanvas)
			{
				gameCanvas.removeFromParent(true);
				gameCanvas = null;
				items = null;
			}
			
			// new some data
			gameCanvas = new BaseSprite();			
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
							gameCanvas.addChild(item);
							
							items.set(i, j, item);
						}
						else
						{
							trace("initGameCenter wrong", itemIndex);
						}
					}
				}				
			}
			
			addChild(gameCanvas);
	
			
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
					// play the sound
					SoundManager.play(SoundFactors.XIAO_CHU_MUSIC);
					
					var aItem:ItemMovieClip = items.get(b.x, b.y) as ItemMovieClip;
					var bItem:ItemMovieClip = items.get(i, j) as ItemMovieClip;
					
					// draw explosion and lines
					drawLines();
					
					// dispose items
					if(aItem)
					{
						aItem.removeFromParent(true);
						aItem = null;
					}
					if(bItem)
					{
						bItem.removeFromParent(true);
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
		
		private function drawLines():void
		{
			
		}
		
		public function refreshMap():void
		{
			// refresh the map data
			map.refresh();
			
			// refresh the items
			initGameCenter();
		}
		
		public function bomb2Items():void
		{
			
		}
		
		public function autoFindLine():void
		{
			
		}
		
		
	}
}