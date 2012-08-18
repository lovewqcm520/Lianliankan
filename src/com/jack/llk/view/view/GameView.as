package com.jack.llk.view.view
{
	import com.jack.llk.Game;
	import com.jack.llk.control.Common;
	import com.jack.llk.control.Global;
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.control.asset.Maps;
	import com.jack.llk.control.events.EventController;
	import com.jack.llk.control.events.GameEvent;
	import com.jack.llk.control.events.ViewEvent;
	import com.jack.llk.control.factors.GameStatusFactors;
	import com.jack.llk.control.factors.SoundFactors;
	import com.jack.llk.control.sound.SoundManager;
	import com.jack.llk.util.Delay;
	import com.jack.llk.util.GameUtil;
	import com.jack.llk.view.BaseMovieClip;
	import com.jack.llk.view.BaseSprite;
	import com.jack.llk.view.BatterTip;
	import com.jack.llk.view.CountDownSprite;
	import com.jack.llk.view.NumberSprite;
	import com.jack.llk.view.button.BaseButton;
	import com.jack.llk.view.module.classic.ClassicModelChapterView;
	import com.jack.llk.view.module.classic.ClassicModelRewardPanel;
	import com.jack.llk.view.module.endless.EndlessModelRewardPanel;
	import com.jack.llk.view.module.time.TimeModelChapterView;
	import com.jack.llk.view.panel.PausePanel;
	import com.jack.llk.view.panel.RewardPanel;
	import com.jack.llk.vo.RoundVO;
	import com.jack.llk.vo.map.MapVO;
	import com.jack.llk.vo.model.ClassicModelVO;
	import com.jack.llk.vo.model.EndlessModelVO;
	import com.jack.llk.vo.model.TimeModelVO;
	
	import flash.desktop.NativeApplication;
	import flash.events.StatusEvent;
	import flash.geom.Point;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;

	public class GameView extends BaseView
	{
		private var countDown:CountDownSprite;
		private var gameCanvas:GameContainer;
		private var round:RoundVO;

		private var spTop:BaseSprite;
		private var levelNumBg:Image;
		private var spLevel:NumberSprite;
		private var topBg:Image;
		private var npRefresh:NumberSprite;
		private var npBomb:NumberSprite;
		private var npFind:NumberSprite;
		private var refreshBtn:BaseButton;
		private var bombBtn:BaseButton;
		private var findBtn:BaseButton;
		private var pausePanel:PausePanel;
		private var pauseBtn:BaseButton;

		private var model:int;
		// these data will update on every different level
		// 当局游戏等级
		private var level:int;
		// 当局游戏积分
		private var curScores:int;
		// 当局游戏用时
		private var usedTime:int;
		// 当局游戏最大连击数
		private var maxBatter:int;
		// 当局游戏win时得到多少star
		private var stars:int;
		
		private var gameover:Boolean;

		public function GameView(model:int)
		{
			this.model = model;
			super();
		}
		
		//////////////////  write functions for add and remove event /////////////////////////
		
		private function addEvents():void
		{
			// add event listener
			EventController.e.addEventListener(GameEvent.GAME_RESUME, onGameResume);
			EventController.e.addEventListener(GameEvent.GAME_PAUSE, onGamePause);
			EventController.e.addEventListener(GameEvent.GAME_RESTART, onGameRestart);
			EventController.e.addEventListener(GameEvent.GAME_NEXT, onGameNext);
			EventController.e.addEventListener(GameEvent.GAME_WIN, onGameWin);
			EventController.e.addEventListener(GameEvent.GAME_LOSE, onGameLose);
			EventController.e.addEventListener(GameEvent.BATTER, onBatter);
			EventController.e.addEventListener(GameEvent.XIAOCHU, onXiaochu);
			EventController.e.addEventListener(GameEvent.GAME_REFRESH_MAP, onGameRefreshMap);
			
			EventController.e.addEventListener(GameEvent.GET_TOOL_BOMB, onGetToolBomb);
			EventController.e.addEventListener(GameEvent.GET_TOOL_EGG, onGetToolEgg);
			EventController.e.addEventListener(GameEvent.GET_TOOL_FIND, onGetToolFind);
			EventController.e.addEventListener(GameEvent.GET_TOOL_REFRESH, onGetToolRefresh);
			EventController.e.addEventListener(GameEvent.GET_TOOL_TIME, onGetToolTime);
			
			EventController.e.addEventListener(GameEvent.USE_TOOL_FIND, onUseToolFind);
			EventController.e.addEventListener(GameEvent.USE_TOOL_REFRESH, onUseToolRefresh);
			EventController.e.addEventListener(GameEvent.USE_TOOL_BOMB, onUseToolBomb);
		}
		
		private function removeEvents():void
		{
			// remove event listener
			EventController.e.removeEventListener(GameEvent.GAME_RESUME, onGameResume);
			EventController.e.removeEventListener(GameEvent.GAME_PAUSE, onGamePause);
			EventController.e.removeEventListener(GameEvent.GAME_RESTART, onGameRestart);
			EventController.e.removeEventListener(GameEvent.GAME_NEXT, onGameNext);
			EventController.e.removeEventListener(GameEvent.GAME_WIN, onGameWin);
			EventController.e.removeEventListener(GameEvent.GAME_LOSE, onGameLose);
			EventController.e.removeEventListener(GameEvent.BATTER, onBatter);
			EventController.e.removeEventListener(GameEvent.XIAOCHU, onXiaochu);
			EventController.e.removeEventListener(GameEvent.GAME_REFRESH_MAP, onGameRefreshMap);
			
			EventController.e.removeEventListener(GameEvent.GET_TOOL_BOMB, onGetToolBomb);
			EventController.e.removeEventListener(GameEvent.GET_TOOL_EGG, onGetToolEgg);
			EventController.e.removeEventListener(GameEvent.GET_TOOL_FIND, onGetToolFind);
			EventController.e.removeEventListener(GameEvent.GET_TOOL_REFRESH, onGetToolRefresh);
			EventController.e.removeEventListener(GameEvent.GET_TOOL_TIME, onGetToolTime);
			
			EventController.e.removeEventListener(GameEvent.USE_TOOL_FIND, onUseToolFind);
			EventController.e.removeEventListener(GameEvent.USE_TOOL_REFRESH, onUseToolRefresh);
			EventController.e.removeEventListener(GameEvent.USE_TOOL_BOMB, onUseToolBomb);
		}
		
		private function onRemoveFromStage(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			
			// remove event listener
			removeEvents();
		}
		
		override protected function onAddedToStage(event:Event):void
		{
			super.onAddedToStage(event);

			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			setBackground("asset_bg_game");

			// add event listener
			addEvents();
		}
		
		public function reset(nLevel:int):void
		{
			this.level=nLevel;
			EndlessModelVO.getInstance().maxLevel = this.level;

			this.round = getRoundAt(nLevel);

			resetData();
			initGameCenter();
			updateUis();

			refreshBtn.onClick=gameCanvas.refreshMap;
			bombBtn.onClick=gameCanvas.bomb2Items;
			findBtn.onClick=gameCanvas.findLine;

			// set the game status
			Game.getInstance().gameStatus=GameStatusFactors.STATUS_PLAYING;
		}

		public function start(nLevel:int):void
		{
			this.level=nLevel;
			EndlessModelVO.getInstance().maxLevel = this.level;
			
			this.round = getRoundAt(nLevel);

			resetData();
			initialize();
			initGameCenter();
			initTools();
			updateUis();

			// set the game status
			Game.getInstance().gameStatus=GameStatusFactors.STATUS_PLAYING;
		}

		private function resetData():void
		{
			curScores=0;
			usedTime=0;
			maxBatter=0;
			stars=0;
			gameover=false;
		}

		private function initGameCenter():void
		{
			var oldIndex:int = -1;
			if (gameCanvas)
			{
				oldIndex = getChildIndex(gameCanvas);
				gameCanvas.removeFromParent(true);
				gameCanvas=null;
				Game.getInstance().gameCanvas=null;
			}

			gameCanvas=new GameContainer();
			gameCanvas.init(round);
			var tx:Number = (Common.DEFAULT_WIDTH - gameCanvas.width) / 2;
			var ty:Number = (Common.DEFAULT_HEIGHT - gameCanvas.height) / 2;
			addChildScaled(gameCanvas, tx, ty);				

			Game.getInstance().gameCanvas=gameCanvas;
			
			setChildIndex(gameCanvas, oldIndex);
		}

		private function initialize():void
		{
			var w:Number=this.width;
			var h:Number=this.height;

			spTop=new BaseSprite();
			// set the game_board
			topBg=Assets.getImage("game_board");
			topBg.width=Common.DEFAULT_WIDTH;
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
			topOverlay.width=Common.DEFAULT_WIDTH;
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
			gameCanvas.refreshMap(false);

			// set the game status
			Game.getInstance().gameStatus=GameStatusFactors.STATUS_PLAYING;
		}

		/**
		 * Goto next level game.
		 */
		private function onNext():void
		{
			var nOldRefreshTools:int = round.numRefreshTool;
			var nOldBombTools:int = round.numBombTool;
			var nOldFindTools:int = round.numFindTool;
			
			// goto next level and reset game
			this.reset(++level);

			if(model == Common.GAME_MODEL_TIME || model == Common.GAME_MODEL_ENDLESS)
			{
				// remain the tools 
				round.numRefreshTool = nOldRefreshTools;
				round.numBombTool = nOldBombTools;
				round.numFindTool = nOldFindTools;
			}
			
			// set the game status
			Game.getInstance().gameStatus=GameStatusFactors.STATUS_PLAYING;
		}
		
		private function pauseGame():void
		{
			//  pause the count time timer
			countDown.pause();
			// disable mouse 
			this.touchable=false;
		}
		
		private function resumeGame():void
		{
			//  resume the count time timer
			countDown.resume();
			// enable mouse 
			this.touchable=true;
		}

		/**
		 * When game over and user win.
		 */
		private function onWin():void
		{
			resumeGame();
			
			gameover=true;
			// play sound
			SoundManager.play(SoundFactors.WIN_BACK_MUSIC);
			
			//  pause the count time timer
			countDown.pause();

			// get use time
			round.timeUsed = usedTime = countDown.usedTime;
			// get the max combo
			maxBatter=round.comboMax;
			// get final scores
			curScores=round.scores;
			curScores+= Common.BATTER_SCORE*maxBatter + 
				Common.BATTER_SCORE*(round.totalTime + (round.nAvailableItems + round.numToolItems)/2 - round.timeUsed);

			// show the win reward panel
			var reward:RewardPanel;
			if(model == Common.GAME_MODEL_ENDLESS)
			{ 
				reward=new EndlessModelRewardPanel();
				EndlessModelRewardPanel(reward).curScores=curScores;
				EndlessModelRewardPanel(reward).usedTime=usedTime;
				EndlessModelRewardPanel(reward).maxCombo=maxBatter;
				
				// flush data to local shared object
				EndlessModelVO.getInstance().addScores(level, curScores);
				EndlessModelVO.getInstance().flushToCache();
			}
			else if(model == Common.GAME_MODEL_CLASSIC)
			{
				stars = calculateRating();
				reward=new ClassicModelRewardPanel();
				ClassicModelRewardPanel(reward).stars = stars;
				ClassicModelRewardPanel(reward).usedTime=usedTime;
				ClassicModelRewardPanel(reward).maxCombo=maxBatter;
				
				// flush data to local shared object
				ClassicModelVO.getInstance().flushAt(level, stars);
			}
			else if(model == Common.GAME_MODEL_TIME)
			{
				stars = calculateRating();
				reward=new ClassicModelRewardPanel();
				ClassicModelRewardPanel(reward).stars = stars;
				ClassicModelRewardPanel(reward).usedTime=usedTime;
				ClassicModelRewardPanel(reward).maxCombo=maxBatter;
				
				// flush data to local shared object
				TimeModelVO.getInstance().flushAt(level, stars);
			}
			reward.showWin();
			reward.scaleX*=0.75;
			reward.scaleY*=0.75;
			addChildScaled(reward, 0, 0);
			// set reward ui on top
			setChildIndex(reward, this.numChildren - 1);

			// set the game status
			Game.getInstance().gameStatus=GameStatusFactors.STATUS_OVER;
		}

		/**
		 * When game over and user lose.
		 */
		private function onLose():void
		{
			resumeGame();
			
			gameover=true;
			// play sound
			SoundManager.play(SoundFactors.LOST_BACK_MUSIC);
			
			//  pause the count time timer
			countDown.pause();
			
			// get the max combo
			maxBatter=round.comboMax;
			
			// get final scores
			curScores = round.scores;
			if(model == Common.GAME_MODEL_ENDLESS)
			{
				curScores += (Common.BATTER_SCORE*maxBatter);
			}

			// show the lose reward panel
			var reward:RewardPanel;
			if(model == Common.GAME_MODEL_ENDLESS)
			{ 
				reward=new EndlessModelRewardPanel();
				EndlessModelRewardPanel(reward).highestHistoryScores=EndlessModelVO.getInstance().maxScore;
				EndlessModelRewardPanel(reward).curScores=curScores;
				
				// flush data to local shared object
				EndlessModelVO.getInstance().addScores(level, curScores);
				EndlessModelVO.getInstance().flushToCache();
			}
			else if(model == Common.GAME_MODEL_CLASSIC)
			{
				reward=new ClassicModelRewardPanel();
			}
			else if(model == Common.GAME_MODEL_TIME)
			{
				reward=new ClassicModelRewardPanel();
			}
			reward.showLose();
			reward.scaleX*=0.75;
			reward.scaleY*=0.75;
			addChildScaled(reward, 0, 0);
			// set reward ui on top
			setChildIndex(reward, this.numChildren - 1);

			// set the game status
			Game.getInstance().gameStatus=GameStatusFactors.STATUS_OVER;
		}

		/**
		 * Hide the pause panel and resume the game.
		 */
		private function onResume():void
		{
			if(!gameover)
			{
				// resume the game
				
				// show the pause button
				pauseBtn.visible=true;
				//  pause the count time timer
				countDown.resume();
				// show the game canvas sprite
				gameCanvas.visible=true;
				
				// set the game status
				Game.getInstance().gameStatus=GameStatusFactors.STATUS_PLAYING;
			}
			// start the hide animation
			pausePanel.hide();
		}

		/**
		 * Open the pause panel and pause the game.
		 */
		private function onPause():void
		{
			if(gameover)
				return;
			
			// open the pause menu
			if (!pausePanel)
			{
				pausePanel=new PausePanel();
				addChildScaled(pausePanel, 65, Common.DEFAULT_HEIGHT);
				pausePanel.y=Common.DEFAULT_HEIGHT;
				setChildIndex(pausePanel, numChildren-1);
			}
			else
			{
				setChildIndex(pausePanel, numChildren-1);
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
		
		private function onRefreshMap():void
		{
			gameCanvas.refreshMap(false);
		}

		private function onBackClick():void
		{
			// hide current view
			var t1:Tween=new Tween(this, 0.3);
			t1.animate("x", Starling.current.nativeStage.fullScreenWidth);
			t1.onComplete=onMoveToHideComplete;
			Starling.juggler.add(t1);
			this.prepareHide();

			// show previous view
			var t2:Tween=new Tween(Game.getInstance().previousView, 0.3);
			t2.animate("x", 0);
			if(model == Common.GAME_MODEL_CLASSIC || model == Common.GAME_MODEL_TIME)
			{
				t2.onUpdate=onPreviousViewMoveUpdate;
			}
			Starling.juggler.add(t2);
			Game.getInstance().previousView.visible=true;
			Game.getInstance().previousView.prepareShow();
		}
		
		private function onPreviousViewMoveUpdate():void
		{
			if(Starling.current.nativeStage.fullScreenWidth - Math.abs(Game.getInstance().previousView.x) >= 10)
			{
				if(model == Common.GAME_MODEL_CLASSIC)
					(Game.getInstance().previousView as ClassicModelChapterView).recoverChapterContainer();
				else if(model == Common.GAME_MODEL_TIME)
					(Game.getInstance().previousView as TimeModelChapterView).recoverChapterContainer();
			}
		}
		
		private function onMoveToHideComplete():void
		{
			this.removeFromParent(true);
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

		private function initTools():void
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
			findBtn=new BaseButton(upState2, text2, downState2);
			addChildScaled(findBtn, firstX + gapX * 2, toolY);
			findBtn.onClick=gameCanvas.findLine;
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
			// delay 1s to show the win reward panel
			pauseGame();
			Delay.doIt(1000, onWin);
		}

		private function onGameLose(event:GameEvent):void
		{
			// delay 0.5s to show the lose reward panel
			pauseGame();
			Delay.doIt(500, onLose);
		}
		
		private function onBatter(event:GameEvent):void
		{
			onBatterShow();
		}
		
		private function onXiaochu(event:GameEvent):void
		{
			addTime();
		}
		
		private function onGameRefreshMap(event:GameEvent):void
		{
			Delay.doIt(1000, onRefreshMap);
		}
		
		private function onGetToolTime(event:GameEvent):void
		{
			if(!round)	return;
			
			// update the count down timer
			if(countDown)
			{
				var newCurTime:int = countDown.currentTime - Common.TOOL_TIME_ADD;
				newCurTime = newCurTime < 0 ? 0 : newCurTime;
				countDown.updateCurTime(newCurTime);
			}
			
			////////////////////// to be continued ///////////////////
			//  show some animation or tip?
		}
		
		private function onGetToolRefresh(event:GameEvent):void
		{
			// start animation move a refresh tool from last point to the static refresh icon
			var p:Point = event.params as Point;
			if(!p)	
			{
				// update refresh tool num tip
				if(round)
					updateToolRefresh();
				return;
			}
			
			// new a refresh tool
			var item:BaseMovieClip=GameUtil.getSmallItemAt(MapVO.REFRESH_ITEM, 3);
			item.loop=true;
			item.play();
			var itemX:Number=gameCanvas.x/Global.contentScaleXFactor + ((p.x - 1) * (round.nItemWidth + round.nGapHorizontal));
			var itemY:Number=gameCanvas.y/Global.contentScaleYFactor + ((p.y - 1) * (round.nItemHeight + round.nGapVertical));
			addChildScaled(item, itemX, itemY);
			
			var t:Tween = new Tween(item, 0.5);
			t.animate("x", refreshBtn.x);
			t.animate("y", refreshBtn.y);
			t.animate("width", refreshBtn.width);
			t.animate("height", refreshBtn.height);
			t.onComplete=onToolMoveComplete;
			t.onCompleteArgs=[item, MapVO.REFRESH_ITEM];
			
			Starling.juggler.add(t);
		}
		
		private function onGetToolFind(event:GameEvent):void
		{
			// start animation move a find tool from last point to the static find icon
			var p:Point = event.params as Point;
			if(!p)	
			{
				// update find tool num tip
				if(round)
					updateToolFind();
				return;
			}
			
			// new a find tool
			var item:BaseMovieClip=GameUtil.getSmallItemAt(MapVO.FIND_ITEM, 3);
			item.loop=true;
			item.play();
			var itemX:Number=gameCanvas.x/Global.contentScaleXFactor + ((p.x - 1) * (round.nItemWidth + round.nGapHorizontal));
			var itemY:Number=gameCanvas.y/Global.contentScaleYFactor + ((p.y - 1) * (round.nItemHeight + round.nGapVertical));
			addChildScaled(item, itemX, itemY);
			
			var t:Tween = new Tween(item, 0.5);
			t.animate("x", findBtn.x);
			t.animate("y", findBtn.y);
			t.animate("width", findBtn.width);
			t.animate("height", findBtn.height);
			t.onComplete=onToolMoveComplete;
			t.onCompleteArgs=[item, MapVO.FIND_ITEM];
			
			Starling.juggler.add(t);
		}
		
		// 彩蛋触发后随即产生一种效果
		private function onGetToolEgg(event:GameEvent):void
		{
			var r:Number = Math.random();
			var probability:Number = 1/6;
			
			if(r <= probability)
			{
				// add a refresh tool
				round.numRefreshTool++;	
			}
			else if(r <= probability*2)
			{
				// add a bomb tool
				round.numBombTool++;	
			}
			else if(r <= probability*3)
			{
				// add a find tool
				round.numFindTool++;	
			}
			else if(r <= probability*4)
			{
				// auto refresh the map
				gameCanvas.refreshMap(false);
			}
			else if(r <= probability*5)
			{
				// auto add some random matched items at random position
				gameCanvas.addRandomPoker();
			}
			else if(r <= 1)
			{
				// auto bomb 2 matched items
				gameCanvas.bomb2Items(false);
			}
		}
		
		private function onGetToolBomb(event:GameEvent):void
		{
			// start animation move a bomb tool from last point to the static bomb icon
			var p:Point = event.params as Point;
			if(!p)	
			{
				// update bomb tool num tip
				if(round)
					updateToolBomb();
				return;
			}
			
			// new a bomb tool
			var item:BaseMovieClip=GameUtil.getSmallItemAt(MapVO.BOMB_ITEM, 3);
			item.loop=true;
			item.play();
			var itemX:Number=gameCanvas.x/Global.contentScaleXFactor + ((p.x - 1) * (round.nItemWidth + round.nGapHorizontal));
			var itemY:Number=gameCanvas.y/Global.contentScaleYFactor + ((p.y - 1) * (round.nItemHeight + round.nGapVertical));
			addChildScaled(item, itemX, itemY);
			
			var t:Tween = new Tween(item, 0.5);
			t.animate("x", bombBtn.x);
			t.animate("y", bombBtn.y);
			t.animate("width", bombBtn.width);
			t.animate("height", bombBtn.height);
			t.onComplete=onToolMoveComplete;
			t.onCompleteArgs=[item, MapVO.BOMB_ITEM];
			
			Starling.juggler.add(t);
		}
		
		private function onToolMoveComplete(item:BaseMovieClip, itemType:int):void
		{
			item.removeFromParent(true);
			item = null;
			
			if(itemType == MapVO.BOMB_ITEM)
				updateToolBomb();
			else if(itemType == MapVO.FIND_ITEM)
				updateToolFind();
			else if(itemType == MapVO.REFRESH_ITEM)
				updateToolRefresh();
		}		
		
		private function onUseToolBomb(event:GameEvent):void
		{
			// update bomb tool num tip
			if(round)
				updateToolBomb();
		}
		
		private function onUseToolRefresh(event:GameEvent):void
		{
			// update refresh tool num tip
			if(round)
				updateToolRefresh();
		}
		
		private function onUseToolFind(event:GameEvent):void
		{
			// update find tool num tip
			if(round)
				updateToolFind();
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

			var nRefreshTool:String=round.numRefreshTool.toString();

			npRefresh=new NumberSprite(nRefreshTool);
			npRefresh.scaleX=npRefresh.scaleY=0.5;
			addChildScaled(npRefresh, 163, 745, getChildIndex(refreshBtn));
		}

		private function updateToolBomb():void
		{
			if (npBomb)
				npBomb.removeFromParent(true);

			var npBombTool:String=round.numBombTool.toString();

			npBomb=new NumberSprite(npBombTool);
			npBomb.scaleX=npBomb.scaleY=0.5;
			addChildScaled(npBomb, 285, 745, getChildIndex(bombBtn));
		}

		private function updateToolFind():void
		{
			if (npFind)
				npFind.removeFromParent(true);

			var nFindTool:String=round.numFindTool.toString();

			npFind=new NumberSprite(nFindTool);
			npFind.scaleX=npFind.scaleY=0.5;
			addChildScaled(npFind, 385, 745, getChildIndex(findBtn));
		}

		//////////////////  write functions for calculate scores /////////////////////////

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
		
		// calculate how many stars user get after win this level
		private function calculateRating():int
		{
			var pokerNumber:int = round.nAvailableItems + round.numToolItems;
			var f:Number;
			
			if(model == Common.GAME_MODEL_CLASSIC)
			{
				f = 0.4*(2.0*maxBatter/pokerNumber) + 
				0.6*((round.totalTime-round.timeUsed)/(round.totalTime - pokerNumber/4));
			}
			else if(model == Common.GAME_MODEL_TIME)
			{
				f = 0.4*(2.0*maxBatter/pokerNumber) + 
				0.6*((round.totalTime+pokerNumber/2-round.timeUsed)/(round.totalTime+pokerNumber/4));
			}
				
			var n:int;
			if(f > 0.6666667)
			{
				n = 3;
			}
			else if(f > 0.3333333)
			{
				n = 2;
			}
			else
			{
				n = 1;
			}
			
			return n;
		}
		
		private function getRoundAt(level:int):RoundVO
		{
			if(model == Common.GAME_MODEL_CLASSIC)
			{ 
				return Maps.getClassicRoundAt(level);
			}
			else if(model == Common.GAME_MODEL_TIME)
			{ 
				return Maps.getTimeRoundAt(level);
			}
			else if(model == Common.GAME_MODEL_ENDLESS)
			{ 
				return Maps.getEndlessRoundAt(level);
			}	
			
			return null;
		}
		
		// at time model game, add time after dispose on pair of items
		private function addTime():void
		{
			if(model == Common.GAME_MODEL_TIME || model == Common.GAME_MODEL_ENDLESS)
			{
				// update the count down timer
				if(countDown)
				{
					var newCurTime:int = countDown.currentTime - Common.TIME_ADD_TIME;
					newCurTime = newCurTime < 0 ? 0 : newCurTime;
					countDown.updateCurTime(newCurTime);
				}
			}
		}
		
		//////////////////  dispose function  /////////////////////////
		
		override public function dispose():void
		{
			removeEvents();
			round = null;
			
			super.dispose();
		}
	}
}
