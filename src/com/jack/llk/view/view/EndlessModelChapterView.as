package com.jack.llk.view.view
{
	import com.jack.llk.Game;
	import com.jack.llk.control.Global;
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.control.events.ViewEvent;
	import com.jack.llk.view.NumberSprite;
	import com.jack.llk.view.button.CommonButton;
	import com.jack.llk.view.button.PlayButton;
	import com.jack.llk.view.panel.SettingPanel;
	import com.jack.llk.vo.gameModel.EndlessModelVO;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class EndlessModelChapterView extends BaseView
	{
		private var dialog:Sprite;

		private var highScoreTxt:Image;

		private var diTxt:Image;

		private var levelTxt:NumberSprite;

		private var guanTxt:Image;

		private var scoreTitleTxt:Image;

		private var fenTxt:Image;

		private var scoreTxt:NumberSprite;
		
		private var inited:Boolean=false;

		public function EndlessModelChapterView()
		{
			super();

			setBackground("asset_bg_model");
		}

		override protected function onAddedToStage(event:Event):void
		{
			super.onAddedToStage(event);

			initialize1();
		}
		
		override public function prepareShow():void
		{
			super.prepareShow();
			
			updateDialog();
		}
		
		public function addChapterContainerToStage():void
		{
			if (dialog && !contains(dialog))
			{
				addChildAt(dialog, 1);
			}
		}

		private function initialize1():void
		{
			var w:Number=this.width;
			var h:Number=this.height;

			// setting panel
			var setting:SettingPanel=new SettingPanel();
			addChildScaled(setting, 370, 690);
			setting.setClipRect(370, 690);

			// back button
			var backBtn:CommonButton=new CommonButton("backbt");
			addChildScaled(backBtn, 10, 690);
			backBtn.onClick=onBackClick;
			
			
			////////////////////// init dialog ////////////////////
			// background
			var bg:Image=Assets.getImage("dialogbg");
			addChildScaled(bg, 22, 118);
			
			// title
			var title:Image=Assets.getImage("endlessbigtitle");
			addChildScaled(title, 108, 165);
			
			// play button
			var playBtn:PlayButton=new PlayButton();
			addChildScaled(playBtn, 140, 375);
			playBtn.scaleX*=197 / 220;
			playBtn.scaleY*=133 / 146;
			playBtn.onClick=onPlayClick;
			
			inited = true;
			
			// update dialog ui
			updateDialog();
		}

		private function updateDialog():void
		{
			if(!inited)	return;
			
			EndlessModelVO.getInstance().init();
			// store these variables
			var historyMaxLevel:int=EndlessModelVO.getInstance().maxLevel;
			var historyMaxScores:int=EndlessModelVO.getInstance().maxScore;
			
			// build the dialog
			refreshEndlessModelScoreDialog(historyMaxLevel, historyMaxScores);
		}

		private function refreshEndlessModelScoreDialog(maxLevel:int, maxScore:int):void
		{
			// highest level record
			var levelY:Number=260;
			
			if(!highScoreTxt)
			{
				highScoreTxt=Assets.getImage("historymaxsorce");
				addChildScaled(highScoreTxt, 65, levelY);
			}
			
			if(!diTxt)
			{
				diTxt=Assets.getImage("di");
				addChildScaled(diTxt, 245, levelY);
			}
			
			if(!levelTxt)
			{
				levelTxt=new NumberSprite(maxLevel);
				addChildScaled(levelTxt, 285, levelY);
			}
			else
			{
				levelTxt.removeFromParent(true);
				levelTxt = null;
				
				levelTxt = new NumberSprite(maxLevel);
				addChildScaled(levelTxt, 285, levelY);
			}			
			
			if(!guanTxt)
			{
				guanTxt=Assets.getImage("guan");	
				addChildScaled(guanTxt, 285 + levelTxt.width / Global.contentScaleXFactor + 5, levelY);
			}
			else
			{
				guanTxt.x = (285 + levelTxt.width / Global.contentScaleXFactor + 5)*Global.contentScaleXFactor;
			}			

			// highest score record
			var scoreY:Number=312;
			
			if(!scoreTitleTxt)
			{
				scoreTitleTxt=Assets.getImage("sorces");
				addChildScaled(scoreTitleTxt, 65, scoreY);
			}
			
			if(!scoreTxt)
			{
				scoreTxt=new NumberSprite(maxScore);
				addChildScaled(scoreTxt, 165, scoreY);
			}
			else
			{
				scoreTxt.removeFromParent(true);
				scoreTxt = null;
				
				scoreTxt=new NumberSprite(maxScore);
				addChildScaled(scoreTxt, 165, scoreY);
			}
			
			if(!fenTxt)
			{
				fenTxt=Assets.getImage("fen");
				addChildScaled(fenTxt, 165 + scoreTxt.width / Global.contentScaleXFactor + 5, scoreY);
			}
			else
			{
				fenTxt.x = (165 + scoreTxt.width / Global.contentScaleXFactor + 5)*Global.contentScaleXFactor;
			}
		}

		private function onPlayClick():void
		{
			var gameView:GameView=new GameView();
			gameView.x=Starling.current.nativeStage.fullScreenWidth;
			Game.getInstance().container.addChild(gameView);

			// endless mode always start from 1 round		
			gameView.start(30);
			gameView.visible=true;

			var t1:Tween=new Tween(gameView, 0.3);
			t1.animate("x", 0);
			Starling.juggler.add(t1);

			gameView.prepareShow();

			var t2:Tween=new Tween(this, 0.3);
			t2.animate("x", -Starling.current.nativeStage.fullScreenWidth);
			Starling.juggler.add(t2);

			this.prepareHide();
			Game.getInstance().previousView=this;
		}

		/**
		 * Back to model screen.
		 */
		private function onBackClick():void
		{
			// hide classic model screen
			this.visible=false;
			this.prepareHide();
			// show model selecte screen
			Game.getInstance().modelView.visible=true;
			Game.getInstance().modelView.prepareShow();
		}

		override protected function onGotoPreviousView(event:ViewEvent):void
		{
			super.onGotoPreviousView(event);

			onBackClick();
		}
	}
}
