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
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class EndlessModelChapterView extends BaseView
	{
		private var dialog:Sprite;
		
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
		
		public function addChapterContainerToStage():void
		{
			if(dialog && !contains(dialog))
			{				
				addChildAt(dialog, 1);
			}
		}
		
		private function initialize1():void
		{
			var w:Number = this.width;
			var h:Number = this.height;
			
			// init dialog
			setDialog();
			
			// setting panel
			var setting:SettingPanel = new SettingPanel();
			addChildScaled(setting, 370, 690);
			setting.setClipRect(370, 690);
			
			// back button
			var backBtn:CommonButton = new CommonButton("backbt");
			addChildScaled(backBtn, 10, 690);
			backBtn.onClick = onBackClick;
		}
		
		private function setDialog():void
		{
			var voModel:EndlessModelVO = new EndlessModelVO();
			voModel.init();
			
			//buildEndlessModelScoreDialog(voModel.maxLevel, voModel.maxScore);
			buildEndlessModelScoreDialog( Math.random()*20, Math.random()*10000000);
		}
		
		private function buildEndlessModelScoreDialog(maxLevel:int, maxScore:int):void
		{
			// background
			var bg:Image = Assets.getImage("dialogbg");
			addChildScaled(bg, 22, 118);
			
			// title
			var title:Image = Assets.getImage("endlessbigtitle");
			addChildScaled(title, 108, 165);
			
			// highest level record
			var levelY:Number = 260;
			var highScoreTxt:Image = Assets.getImage("historymaxsorce");
			var diTxt:Image = Assets.getImage("di");
			var levelTxt:NumberSprite = new NumberSprite(maxLevel);
			var guanTxt:Image = Assets.getImage("guan");
			
			addChildScaled(highScoreTxt, 65, levelY);
			addChildScaled(diTxt, 245, levelY);
			addChildScaled(levelTxt, 285, levelY);
			addChildScaled(guanTxt, 285 + levelTxt.width/Global.contentScaleXFactor + 5, levelY);
			
			// highest score record
			var scoreY:Number = 312;
			var scoreTitleTxt:Image = Assets.getImage("sorces");
			var fenTxt:Image = Assets.getImage("fen");
			var scoreTxt:NumberSprite = new NumberSprite(maxScore);
			
			addChildScaled(scoreTitleTxt, 65, scoreY);
			addChildScaled(scoreTxt, 165, scoreY);
			addChildScaled(fenTxt, 165 + scoreTxt.width/Global.contentScaleXFactor + 5, scoreY);
			
			// play button
			var playBtn:PlayButton = new PlayButton();
			addChildScaled(playBtn, 140, 375);
			playBtn.scaleX *= 197/220;
			playBtn.scaleY *= 133/146;
			playBtn.onClick = onPlayClick;
		}
		
		private function onPlayClick():void
		{
			var gameView:GameView = new GameView();		
			Game.getInstance().container.addChild(gameView);
			
			// endless mode always start from 1 round		
			gameView.start(1);
			gameView.visible = true;
			gameView.prepareShow();
			
			// hide model selecte screen
			this.visible = false;
			this.prepareHide();
		}
		
		/**
		 * Back to model screen.
		 */
		private function onBackClick():void
		{
			// hide classic model screen
			this.visible = false;
			this.prepareHide();
			// show model selecte screen
			Game.getInstance().modelView.visible = true;
			Game.getInstance().modelView.prepareShow();
		}
		
		override protected function onGotoPreviousView(event:ViewEvent):void
		{
			super.onGotoPreviousView(event);
			
			onBackClick();
		}	
	}
}