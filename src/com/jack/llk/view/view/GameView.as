package com.jack.llk.view.view
{
	import com.jack.llk.Game;
	import com.jack.llk.control.Constant;
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.control.events.ViewEvent;
	import com.jack.llk.view.CountDownSprite;
	import com.jack.llk.view.NumberSprite;
	import com.jack.llk.view.button.BaseButton;
	import com.jack.llk.view.panel.PausePanel;
	import com.jack.llk.view.panel.RewardPanel;
	import com.jack.llk.vo.MapFactory;
	import com.jack.llk.vo.RoundVO;
	
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
		private var round:RoundVO;
		private var level:int;

		private var spTop:Sprite;
		private var levelNumBg:Image;
		private var spLevel:NumberSprite;
		private var topBg:Image;
		private var npRefresh:NumberSprite;
		private var npBomb:NumberSprite;
		private var npFind:NumberSprite;
		private var refreshBtn:BaseButton;
		private var bombBtn:BaseButton;
		private var searchBtn:BaseButton;

		private var pausePanel:PausePanel;

		public function GameView()
		{
			super();
		}
		
		override protected function onAddedToStage(event:Event):void
		{
			super.onAddedToStage(event);
			
			setBackground("asset_bg_game");			
		}
		
		public function reset(nLevel:int):void
		{
			this.level = nLevel;
			this.round = MapFactory.getInstance().createGameRound(level);
			
			initGameCenter();
			updateUis();
			
			refreshBtn.onClick = gameCanvas.refreshMap;
			bombBtn.onClick = gameCanvas.bomb2Items;
			searchBtn.onClick = gameCanvas.findLine;
		}
		
		public function start(nLevel:int):void
		{
			this.level = nLevel;
			this.round = MapFactory.getInstance().createGameRound(level);
			
			initialize();
			initGameCenter();
			setTools();
			updateUis();
		}
		
		private function initGameCenter():void
		{
			if(gameCanvas)
			{
				gameCanvas.removeFromParent(true);
				gameCanvas = null;
				Game.getInstance().gameCanvas = null;
			}
			
			gameCanvas = new GameContainer();
			gameCanvas.init(round);
			gameCanvas.scaleX = gameCanvas.scaleY = 1.25;
			addChildScaled(gameCanvas);
			gameCanvas.x = (width-gameCanvas.width)/2;
			gameCanvas.y = (height-gameCanvas.height)/2;
			
			Game.getInstance().gameCanvas = gameCanvas;
		}
		
		private function initialize():void
		{
			var w:Number = this.width;
			var h:Number = this.height;
			
			spTop = new Sprite();			
			// set the game_board
			topBg = Assets.getImage("game_board");
			topBg.width = Constant.DEFAULT_WIDTH;
			topBg.scaleY = topBg.scaleX;
			spTop.addChild(topBg);
			
			// set level text and level number
			var levelTitle:Image = Assets.getImage("levelfont");
			levelTitle.x=110;
			levelTitle.y=25;
			spTop.addChild(levelTitle);
			levelNumBg = Assets.getImage("levelnumberbg");
			levelNumBg.x=248;
			levelNumBg.y=25;
			spTop.addChild(levelNumBg);
			
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
			pauseBtn.onClick = onPause;
		}		
		
		/**
		 * Open the pause panel and pause the game.
		 */
		private function onPause():void
		{
			// testonly
			//this.reset(++level);
			
			var rewardPanel:RewardPanel = new RewardPanel();
			rewardPanel.showLose();
			addChildScaled(rewardPanel, 65, 100);
			
			// open the pause menu
//			if(!pausePanel)
//			{
//				pausePanel = new PausePanel();
//				addChildScaled(pausePanel, 65, 580);
//			}
//			else
//			{
//				
//			}
			
			// pause the game
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
		
		private function setTools():void
		{
			var toolY:Number = 700;
			var gapX:Number = 120;
			var firstX:Number = 80;
			
			// set refresh tool
			var upState:Texture = Assets.getTexture("reset_n");
			var text:String="";
			var downState:Texture = Assets.getTexture("reset_p");	
			refreshBtn = new BaseButton(upState, text, downState);
			addChildScaled(refreshBtn, firstX, toolY);
			refreshBtn.onClick = gameCanvas.refreshMap;
			
			// set bomb tool
			var upState1:Texture = Assets.getTexture("bomb_n");
			var text1:String="";
			var downState1:Texture = Assets.getTexture("bomb_p");	
			bombBtn = new BaseButton(upState1, text1, downState1);
			addChildScaled(bombBtn, firstX+gapX*1, toolY);
			bombBtn.onClick = gameCanvas.bomb2Items;
			
			// set search tool
			var upState2:Texture = Assets.getTexture("find_n");
			var text2:String="";
			var downState2:Texture = Assets.getTexture("find_p");	
			searchBtn = new BaseButton(upState2, text2, downState2);
			addChildScaled(searchBtn, firstX+gapX*2, toolY);
			searchBtn.onClick = gameCanvas.findLine;
		}
	
		//////////////////  write functions for update some local ui /////////////////////////
		
		private function updateUis():void
		{
			// update level
			updateLevelUi();
			
			// set count down
			updateCountDownUi();
			
			// update refresh tool num tip
			updateToolRefresh();
			
			// update bomb tool num tip
			updateToolBomb();
			
			// update find tool num tip
			updateToolFind();
		}
		
		private function updateLevelUi():void
		{
			if(spLevel)
				spLevel.removeFromParent(true);
			
			var strLevel:String = level.toString();
			strLevel.length == 1 ? (strLevel = "00" + strLevel) : strLevel;
			strLevel.length == 2 ? (strLevel = "0" + strLevel) : strLevel;
			
			spLevel = new NumberSprite(strLevel);
			spLevel.x = levelNumBg.x + (levelNumBg.width - spLevel.width)/2;
			spLevel.y = levelNumBg.y + (levelNumBg.height - spLevel.height)/2;
			spTop.addChild(spLevel);
		}
		
		private function updateCountDownUi():void
		{
			if(!countDown)
			{
				countDown = new CountDownSprite(round.totalTime, round.warningTime);
				countDown.x=60;
				countDown.y=topBg.height- 25;
				spTop.addChild(countDown);
			}
			else
			{
				countDown.reset(round.totalTime, round.warningTime);
			}
		}
		
		private function updateToolRefresh():void
		{
			if(npRefresh)
				npRefresh.removeFromParent(true);
			
			var nRefreshTool:String = round.nRefreshTool.toString();
			
			npRefresh = new NumberSprite(nRefreshTool);
			npRefresh.scaleX = npRefresh.scaleY = 0.5;
			addChildScaled(npRefresh, 163, 745);
		}
		
		private function updateToolBomb():void
		{
			if(npBomb)
				npBomb.removeFromParent(true);
			
			var npBombTool:String = round.nBombTool.toString();
			
			npBomb = new NumberSprite(npBombTool);
			npBomb.scaleX = npBomb.scaleY = 0.5;
			addChildScaled(npBomb, 285, 745);
		}
		
		private function updateToolFind():void
		{
			if(npFind)
				npFind.removeFromParent(true);
			
			var nFindTool:String = round.nFindTool.toString();
			
			npFind = new NumberSprite(nFindTool);
			npFind.scaleX = npFind.scaleY = 0.5;
			addChildScaled(npFind, 385, 745);
		}
	}
}