package com.jack.llk.view.view
{
	import com.jack.llk.control.Constant;
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.control.events.ViewEvent;
	import com.jack.llk.view.CountDownSprite;
	import com.jack.llk.view.button.BaseButton;
	
	import flash.desktop.NativeApplication;
	import flash.events.StatusEvent;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class GameView extends BaseView
	{
		private var modelScreen:ModelView;
		private var aboutScreen:AboutView;

		private var countDown:CountDownSprite;
		private var gameCanvas:GameContainer;

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
			setTools();
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
			gameCanvas = new GameContainer();
			gameCanvas.scaleX = gameCanvas.scaleY = 1.2;
			addChildScaled(gameCanvas);
			gameCanvas.x = (width-gameCanvas.width)/2;
			gameCanvas.y = (height-gameCanvas.height)/2;
		}
		
		private function setTools():void
		{
			var toolY:Number = 700;
			var gapX:Number = 120;
			var firstX:Number = 90;
			
			// set refresh tool
			var upState:Texture = Assets.getTexture("reset_n");
			var text:String="";
			var downState:Texture = Assets.getTexture("reset_p");	
			var refreshBtn:BaseButton = new BaseButton(upState, text, downState);
			addChildScaled(refreshBtn, firstX, toolY);
			refreshBtn.onClick = gameCanvas.refreshMap;
			
			// set bomb tool
			var upState1:Texture = Assets.getTexture("bomb_n");
			var text1:String="";
			var downState1:Texture = Assets.getTexture("bomb_p");	
			var bombBtn:BaseButton = new BaseButton(upState1, text1, downState1);
			addChildScaled(bombBtn, firstX+gapX*1, toolY);
			bombBtn.onClick = gameCanvas.bomb2Items;
			
			// set search tool
			var upState2:Texture = Assets.getTexture("find_n");
			var text2:String="";
			var downState2:Texture = Assets.getTexture("find_p");	
			var searchBtn:BaseButton = new BaseButton(upState2, text2, downState2);
			addChildScaled(searchBtn, firstX+gapX*2, toolY);
			searchBtn.onClick = gameCanvas.autoFindLine;
		}
	
	}
}