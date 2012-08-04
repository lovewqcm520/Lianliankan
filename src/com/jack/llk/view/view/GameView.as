package com.jack.llk.view.view
{
	import com.jack.llk.Game;
	import com.jack.llk.control.Constant;
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.control.events.EventController;
	import com.jack.llk.control.events.GameEvent;
	import com.jack.llk.control.events.ViewEvent;
	import com.jack.llk.control.factors.GameStatusFactors;
	import com.jack.llk.control.factors.SoundFactors;
	import com.jack.llk.control.sound.SoundManager;
	import com.jack.llk.log.Log;
	import com.jack.llk.view.BatterTip;
	import com.jack.llk.view.CountDownSprite;
	import com.jack.llk.view.NumberSprite;
	import com.jack.llk.view.button.BaseButton;
	import com.jack.llk.view.panel.PausePanel;
	import com.jack.llk.view.panel.RewardPanel;
	import com.jack.llk.vo.MapFactory;
	import com.jack.llk.vo.RoundVO;
	import com.jack.llk.vo.gameModel.EndlessModelVO;
	
	import flash.desktop.NativeApplication;
	import flash.events.StatusEvent;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class GameView extends BaseView
	{
		private var countDown:CountDownSprite;
		private var gameCanvas:GameContainer;
		private var round:RoundVO;

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
		private var pauseBtn:BaseButton;

		// these data will update on every different level
		// 当局游戏等级
		private var level:int;
		// 当局游戏积分
		private var curScores:int;
		// 当局游戏用时
		private var usedTime:int;
		// 当局游戏最大连击数
		private var maxCombo:int;

		public function GameView()
		{
			super();
		}

		override protected function onAddedToStage(event:Event):void
		{
			super.onAddedToStage(event);

			setBackground("asset_bg_game");

			// add event listener
			EventController.e.addEventListener(GameEvent.GAME_RESUME, onGameResume);
			EventController.e.addEventListener(GameEvent.GAME_PAUSE, onGamePause);
			EventController.e.addEventListener(GameEvent.GAME_RESTART, onGameRestart);
			EventController.e.addEventListener(GameEvent.GAME_NEXT, onGameNext);
			EventController.e.addEventListener(GameEvent.GAME_WIN, onGameWin);
			EventController.e.addEventListener(GameEvent.GAME_LOSE, onGameLose);
			EventController.e.addEventListener(GameEvent.BATTER, onBatter);
		}

		public function reset(nLevel:int):void
		{
			this.level=nLevel;
			EndlessModelVO.getInstance().maxLevel = this.level;
			this.round=MapFactory.getInstance().createGameRound(level);

			resetData();
			initGameCenter();
			updateUis();

			refreshBtn.onClick=gameCanvas.refreshMap;
			bombBtn.onClick=gameCanvas.bomb2Items;
			searchBtn.onClick=gameCanvas.findLine;

			// set the game status
			Game.getInstance().gameStatus=GameStatusFactors.STATUS_PLAYING;
		}

		public function start(nLevel:int):void
		{
			this.level=nLevel;
			EndlessModelVO.getInstance().maxLevel = this.level;
			this.round=MapFactory.getInstance().createGameRound(level);

			resetData();
			initialize();
			initGameCenter();
			setTools();
			updateUis();

			// set the game status
			Game.getInstance().gameStatus=GameStatusFactors.STATUS_PLAYING;
		}

		private function resetData():void
		{
			curScores=0;
			usedTime=0;
			maxCombo=0;
		}

		private function initGameCenter():void
		{
			if (gameCanvas)
			{
				gameCanvas.removeFromParent(true);
				gameCanvas=null;
				Game.getInstance().gameCanvas=null;
			}

			gameCanvas=new GameContainer();
			gameCanvas.init(round);
			gameCanvas.scaleX=gameCanvas.scaleY=1.2;
			addChildScaled(gameCanvas);
			gameCanvas.x=(width - gameCanvas.width) / 2;
			gameCanvas.y=(height - gameCanvas.height) / 2;

			Game.getInstance().gameCanvas=gameCanvas;
		}

		private function initialize():void
		{
			var w:Number=this.width;
			var h:Number=this.height;

			spTop=new Sprite();
			// set the game_board
			topBg=Assets.getImage("game_board");
			topBg.width=Constant.DEFAULT_WIDTH;
			topBg.scaleY=topBg.scaleX;
			spTop.addChild(topBg);

			// set level text and level number
			var levelTitle:Image=Assets.getImage("levelfont");
			levelTitle.x=110;
			levelTitle.y=25;
			spTop.addChild(levelTitle);
			levelNumBg=Assets.getImage("levelnumberbg");
			levelNumBg.x=248;
			levelNumBg.y=25;
			spTop.addChild(levelNumBg);

			spTop.scaleX=0.85;
			addChildScaled(spTop, 0, 0);

			// set the top banner overlay
			var topOverlay:Image=Assets.getImage("game_closerange");
			topOverlay.width=Constant.DEFAULT_WIDTH;
			topOverlay.scaleY=topOverlay.scaleX;
			addChildScaled(topOverlay, 0, 0);

			// set pause button
			var upState:Texture=Assets.getTexture("pausebt");
			var text:String="";
			var downState:Texture=Assets.getTexture("pausebted");
			pauseBtn=new BaseButton(upState, text, downState);
			addChildScaled(pauseBtn, 0, 0);
			pauseBtn.onClick=onPause;
		}

		/**
		 * Restart the cur level game.
		 */
		private function onRestart():void
		{
			reset(level);

			// show the pause button
			pauseBtn.visible=true;

			// refresh the map
			gameCanvas.refreshMap();

			// set the game status
			Game.getInstance().gameStatus=GameStatusFactors.STATUS_PLAYING;
		}

		/**
		 * Goto next level game.
		 */
		private function onNext():void
		{
			// goto next level and reset game
			this.reset(++level);

			// set the game status
			Game.getInstance().gameStatus=GameStatusFactors.STATUS_PLAYING;
		}

		/**
		 * When game over and user win.
		 */
		private function onWin():void
		{
			// play sound
			SoundManager.play(SoundFactors.WIN_BACK_MUSIC);
			
			//  pause the count time timer
			countDown.pause();

			// get use time
			usedTime=countDown.passedTime;
			// get the max combo
			maxCombo=round.comboMax;
			// get final scores
			curScores=getFinalScores();

			// show the win reward panel
			var rewardPanel:RewardPanel=new RewardPanel();
			rewardPanel.curScores=curScores;
			rewardPanel.usedTime=usedTime;
			rewardPanel.maxCombo=maxCombo;
			rewardPanel.showWin();
			rewardPanel.scaleX*=0.75;
			rewardPanel.scaleY*=0.75;
			addChildScaled(rewardPanel, 0, 0);
			// set reward ui on top
			setChildIndex(npRefresh, this.numChildren - 1);

			// set the game status
			Game.getInstance().gameStatus=GameStatusFactors.STATUS_OVER;
			
			// flush data to local shared object
			EndlessModelVO.getInstance().addScores(level, curScores);
			EndlessModelVO.getInstance().flushToCache();
		}

		/**
		 * When game over and user lose.
		 */
		private function onLose():void
		{
			// play sound
			SoundManager.play(SoundFactors.LOST_BACK_MUSIC);
			
			// get final scores
			curScores=getFinalScores();

			// show the win reward panel
			var rewardPanel:RewardPanel=new RewardPanel();
			rewardPanel.highestHistoryScores=EndlessModelVO.getInstance().maxScore;
			rewardPanel.curScores=curScores;
			rewardPanel.showLose();
			rewardPanel.scaleX*=0.75;
			rewardPanel.scaleY*=0.75;
			addChildScaled(rewardPanel, 0, 0);
			// set reward ui on top
			setChildIndex(npRefresh, this.numChildren - 1);

			// set the game status
			Game.getInstance().gameStatus=GameStatusFactors.STATUS_OVER;
			
			// flush data to local shared object
			EndlessModelVO.getInstance().addScores(level, curScores);
			EndlessModelVO.getInstance().flushToCache();
		}

		/**
		 * Hide the pause panel and resume the game.
		 */
		private function onResume():void
		{
			// hide the pause menu
			if (pausePanel)
			{

			}

			// resume the game

			// show the pause button
			pauseBtn.visible=true;
			//  pause the count time timer
			countDown.resume();
			// show the game canvas sprite
			gameCanvas.visible=true;

			// set the game status
			Game.getInstance().gameStatus=GameStatusFactors.STATUS_PLAYING;

			// start the hide animation
			pausePanel.hide();
		}

		/**
		 * Open the pause panel and pause the game.
		 */
		private function onPause():void
		{
			// open the pause menu
			if (!pausePanel)
			{
				pausePanel=new PausePanel();
				addChildScaled(pausePanel, 65, Constant.DEFAULT_HEIGHT);
				pausePanel.y=Constant.DEFAULT_HEIGHT;
			}
			else
			{

			}

			// pause the game

			// hide the pause button
			pauseBtn.visible=false;
			//  pause the count time timer
			countDown.pause();
			// hide the game canvas sprite
			gameCanvas.visible=false;

			// set the game status
			Game.getInstance().gameStatus=GameStatusFactors.STATUS_PAUSE_BY_USER;

			// start the show animation
			pausePanel.show();
		}

		private function onBatterShow():void
		{
			var curBatter:int = round.comboCur;
			var maxBatter:int = round.comboMax;
			
			var tip:BatterTip = new BatterTip(curBatter, maxBatter);
			addChildScaled(tip, 10, 100);
			
			// tween the tip
			var t:Tween = new Tween(tip, 1.25);
			t.animate("y", 0);
			t.onComplete = onBatterTipMoveStop;
			t.onCompleteArgs = [tip];
			Starling.juggler.add(t);
		}

		private function onBackClick():void
		{
			var t1:Tween=new Tween(this, 0.3);
			t1.animate("x", Starling.current.nativeStage.fullScreenWidth);
			Starling.juggler.add(t1);

			this.prepareHide();

			var t2:Tween=new Tween(Game.getInstance().previousView, 0.3);
			t2.animate("x", 0);
			Starling.juggler.add(t2);

			Game.getInstance().previousView.prepareShow();
		}

		protected function onStatusEvent(event:StatusEvent):void
		{
			if (event.level == "ok")
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
			var toolY:Number=700;
			var gapX:Number=120;
			var firstX:Number=80;

			// set refresh tool
			var upState:Texture=Assets.getTexture("reset_n");
			var text:String="";
			var downState:Texture=Assets.getTexture("reset_p");
			refreshBtn=new BaseButton(upState, text, downState);
			addChildScaled(refreshBtn, firstX, toolY);
			refreshBtn.onClick=gameCanvas.refreshMap;

			// set bomb tool
			var upState1:Texture=Assets.getTexture("bomb_n");
			var text1:String="";
			var downState1:Texture=Assets.getTexture("bomb_p");
			bombBtn=new BaseButton(upState1, text1, downState1);
			addChildScaled(bombBtn, firstX + gapX * 1, toolY);
			bombBtn.onClick=gameCanvas.bomb2Items;

			// set search tool
			var upState2:Texture=Assets.getTexture("find_n");
			var text2:String="";
			var downState2:Texture=Assets.getTexture("find_p");
			searchBtn=new BaseButton(upState2, text2, downState2);
			addChildScaled(searchBtn, firstX + gapX * 2, toolY);
			searchBtn.onClick=gameCanvas.findLine;
		}

		private function onGameResume(event:GameEvent):void
		{
			onResume();
		}

		private function onGamePause(event:GameEvent):void
		{
			onPause();
		}

		private function onGameRestart(event:GameEvent):void
		{
			onRestart();
		}

		private function onGameNext(event:GameEvent):void
		{
			onNext();
		}

		private function onGameWin(event:GameEvent):void
		{
			onWin();
		}

		private function onGameLose(event:GameEvent):void
		{
			onLose();
		}
		
		private function onBatter(event:GameEvent):void
		{
			onBatterShow();
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
			if (spLevel)
				spLevel.removeFromParent(true);

			var strLevel:String=level.toString();
			strLevel.length == 1 ? (strLevel="00" + strLevel) : strLevel;
			strLevel.length == 2 ? (strLevel="0" + strLevel) : strLevel;

			spLevel=new NumberSprite(strLevel);
			spLevel.x=levelNumBg.x + (levelNumBg.width - spLevel.width) / 2;
			spLevel.y=levelNumBg.y + (levelNumBg.height - spLevel.height) / 2;
			spTop.addChild(spLevel);
		}

		private function updateCountDownUi():void
		{
			if (!countDown)
			{
				countDown=new CountDownSprite(round.totalTime, round.warningTime);
				countDown.onFinished=onCountDownFinished;
				countDown.x=60;
				countDown.y=topBg.height - 25;
				spTop.addChild(countDown);
			}
			else
			{
				countDown.reset(round.totalTime, round.warningTime);
			}
		}

		/**
		 * When count down finish.
		 */
		private function onCountDownFinished():void
		{
			// set game status to game_over status
			Game.getInstance().gameStatus=GameStatusFactors.STATUS_OVER;

			// game lose
			var e:GameEvent=new GameEvent(GameEvent.GAME_LOSE);
			EventController.e.dispatchEvent(e);
		}

		private function updateToolRefresh():void
		{
			if (npRefresh)
				npRefresh.removeFromParent(true);

			var nRefreshTool:String=round.nRefreshTool.toString();

			npRefresh=new NumberSprite(nRefreshTool);
			npRefresh.scaleX=npRefresh.scaleY=0.5;
			addChildScaled(npRefresh, 163, 745);
		}

		private function updateToolBomb():void
		{
			if (npBomb)
				npBomb.removeFromParent(true);

			var npBombTool:String=round.nBombTool.toString();

			npBomb=new NumberSprite(npBombTool);
			npBomb.scaleX=npBomb.scaleY=0.5;
			addChildScaled(npBomb, 285, 745);
		}

		private function updateToolFind():void
		{
			if (npFind)
				npFind.removeFromParent(true);

			var nFindTool:String=round.nFindTool.toString();

			npFind=new NumberSprite(nFindTool);
			npFind.scaleX=npFind.scaleY=0.5;
			addChildScaled(npFind, 385, 745);
		}

		//////////////////  write functions for calculate scores /////////////////////////

		// calculate the final scores when game is over
		private function getFinalScores():int
		{
			var one_pair_score:int=100;
			var one_combo_max_score:int=50;

			var timeScoreFactor:Number=0.5;

			var nErasedItems:int=round.nAvailableItems - round.nRestItems;

			var baseScore:int=nErasedItems * one_pair_score;
			var comboScore:int=maxCombo * one_combo_max_score;
			var timeScore:int=(1 - usedTime / round.totalTime) * (baseScore + comboScore) * timeScoreFactor;

			var totalScore:int=baseScore + comboScore + timeScore;

			Log.traced("getFinalScores", baseScore, comboScore, timeScore);
			return totalScore;
		}

		// fade out the tip and then dipose the tip
		private function onBatterTipMoveStop(tip:BatterTip):void
		{
			if(tip)
			{
				// fade out the tip
				var t:Tween = new Tween(tip, 0.5);
				t.fadeTo(0);
				t.onComplete = onBatterTipFadeStop;
				t.onCompleteArgs = [tip];
				Starling.juggler.add(t);
			}
		}
		
		// dipose the tip after fade out complete
		private function onBatterTipFadeStop(tip:BatterTip):void
		{
			if(tip)
			{
				tip.removeFromParent(true);
				tip = null;
			}
		}
	}
}
