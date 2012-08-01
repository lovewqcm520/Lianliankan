package com.jack.llk.view.view
{
	import com.jack.llk.control.Constant;
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.control.events.ViewEvent;
	import com.jack.llk.log.Log;
	import com.jack.llk.util.GameUtil;
	import com.jack.llk.view.CountDownSprite;
	import com.jack.llk.view.ItemMovieClip;
	import com.jack.llk.view.button.BaseButton;
	import com.jack.llk.vo.map.Map;
	
	import flash.desktop.NativeApplication;
	import flash.events.StatusEvent;
	import flash.utils.getTimer;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class GameView extends BaseView
	{
		private var modelScreen:ModelView;
		private var aboutScreen:AboutView;

		private var countDown:CountDownSprite;
		private var gameCanvas:Sprite;

		public function GameView()
		{
			super();
		}
		
		override protected function onAddedToStage(event:Event):void
		{
			super.onAddedToStage(event);
			
			setBackground("asset_bg_game");			
			initialize();
		}
		
		public function start():void
		{
			initGameCenter();
		}
		
		private function initialize():void
		{
			var w:Number = this.width;
			var h:Number = this.height;
			
			var spTop:Sprite = new Sprite();
			
			// set the game_board
			var topBg:Image = Assets.getImage("game_board");
			topBg.width = Constant.DEFAULT_WIDTH;
			topBg.scaleY = topBg.scaleX;
			spTop.addChild(topBg);
			
			// set level text and level number
			var levelTitle:Image = Assets.getImage("levelfont");
			levelTitle.x=110;
			levelTitle.y=25;
			spTop.addChild(levelTitle);
			var levelNumBg:Image = Assets.getImage("levelnumberbg");
			levelNumBg.x=248;
			levelNumBg.y=25;
			spTop.addChild(levelNumBg);
			
			// set count down
			countDown = new CountDownSprite();
			countDown.x=60;
			countDown.y=topBg.height- 25;
			spTop.addChild(countDown);
			
			spTop.scaleX = 0.85;
			addChildScaled(spTop, 0, 0);
			
			// set the top banner overlay
			var topOverlay:Image = Assets.getImage("game_closerange");		
			topOverlay.width = Constant.DEFAULT_WIDTH;
			topOverlay.scaleY = topOverlay.scaleX;
			addChildScaled(topOverlay, 0, 0);
			
			// set pause button
			var upState:Texture = Assets.getTexture("pausebt");
			var text:String="";
			var downState:Texture = Assets.getTexture("pausebted");	
			var pauseBtn:BaseButton = new BaseButton(upState, text, downState);
			addChildScaled(pauseBtn, 0, 0);
		}		

		private function onBackClick():void
		{

		}
		
		protected function onStatusEvent(event:StatusEvent):void
		{
			if(event.level == "ok")
			{
				NativeApplication.nativeApplication.exit();
			}
		} 
		
		override protected function onGotoPreviousView(event:ViewEvent):void
		{
			super.onGotoPreviousView(event);
			
			onBackClick();
		}
		
		private function initGameCenter():void
		{
			var oldTime:Number = getTimer();
			
			var map:Map = new Map(10, 10);
			
			var itemW:Number = 36;
			var itemH:Number = 38;
			
			var col:int = 10;
			var row:int = 10;
			var gapX:Number = 0;
			var gapY:Number = 0;
			
			gameCanvas = new Sprite();
			
			for (var i:int = 0; i < col; i++) 
			{
				for (var j:int = 0; j < row; j++) 
				{
					var itemIndex:int = int(map.map.get(i, j));
					if(itemIndex != Map.EMPTY)
					{
						var item:ItemMovieClip = GameUtil.getSmallItemAt(itemIndex);
						if(item)
						{
							item.loop = true;
							//item.stop();
							item.x = i*(itemW+gapX);
							item.y = j*(itemH+gapY);
							gameCanvas.addChild(item);
							Starling.juggler.add(item);
						}
						else
						{
							trace("initGameCenter wrong", itemIndex);
						}
					}
				}				
			}
			
			addChildScaled(gameCanvas);
			gameCanvas.x = (width-gameCanvas.width)/2;
			gameCanvas.y = (height-gameCanvas.height)/2;
			
			Log.traced("initGameCenter takes", getTimer()-oldTime, "ms.");
		}
	}
}