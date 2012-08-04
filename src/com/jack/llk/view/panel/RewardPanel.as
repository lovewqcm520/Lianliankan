package com.jack.llk.view.panel
{
	import com.jack.llk.control.Constant;
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.control.events.EventController;
	import com.jack.llk.control.events.GameEvent;
	import com.jack.llk.control.events.ViewEvent;
	import com.jack.llk.view.BaseSprite;
	import com.jack.llk.view.NumberSprite;
	import com.jack.llk.view.button.CommonButton;

	import starling.display.Image;

	public class RewardPanel extends BaseSprite
	{
		private var isWin:Boolean;

		// for both win and lose
		public var curScores:int;

		// lose only
		public var highestHistoryScores:int;

		// win only
		public var usedTime:int;
		public var maxCombo:int;

		private var blackBg:Image;

		public function RewardPanel()
		{
			super();
		}

		override public function dispose():void
		{
			super.dispose();
		}

		public function showWin():void
		{
			this.isWin=true;

			initialize();
		}

		public function showLose():void
		{
			this.isWin=false;

			initialize();
		}

		private function initialize():void
		{
			// draw the black alpha bg
			drawFullScreenBg();

			// set background dialog
			var bg:Image=Assets.getImage("dialogbg");
			//bg.scaleX = bg.scaleY = 0.82;
			bg.x=blackBg.x + (blackBg.width - bg.width) / 2;
			bg.y=blackBg.y + (blackBg.height - bg.height) / 2;
			addChild(bg);

			// set win or lose character icon
			var topIcon:Image=isWin ? Assets.getImage("winicon") : Assets.getImage("loseicon");
			topIcon.x=bg.x + (bg.width - topIcon.width) / 2;
			topIcon.y=bg.y - topIcon.height / 2;
			addChild(topIcon);

			// init cur level max scores
			var curScoreTitle:Image=Assets.getImage("nowscore");
			var curScoreSprite:NumberSprite=new NumberSprite(curScores);
			var curScoreFen:Image=Assets.getImage("fen");

			// init back and restart button
			// back button
			var backBtn:CommonButton=new CommonButton("backbt");
			backBtn.onClick=onBack;
			// restart button
			var restartBtn:CommonButton=new CommonButton("restartbtn");
			restartBtn.onClick=onRestart;

			var firstLineY:Number;
			var firstLineX:Number;
			var secondLineY:Number;
			var secondLineX:Number;
			var btnGap:Number=10;
			var btnY:Number=bg.y + bg.height - backBtn.height * 0.7;
			var btnX:Number;
			// if win
			if (isWin)
			{
				// set cur level used time
				firstLineY=topIcon.y + topIcon.height + 10;

				var usedTimeTitle:Image=Assets.getImage("thislevelsorce");
				var usedTimeSprite:NumberSprite=new NumberSprite(usedTime);
				var miao:Image=Assets.getImage("time_s");

				firstLineX=bg.x + (bg.width - usedTimeTitle.width - usedTimeSprite.width - miao.width - 10) / 2;

				usedTimeTitle.x=firstLineX;
				usedTimeTitle.y=firstLineY;
				usedTimeSprite.x=usedTimeTitle.x + usedTimeTitle.width + 5;
				usedTimeSprite.y=firstLineY;
				miao.x=usedTimeSprite.x + usedTimeSprite.width + 5;
				miao.y=firstLineY;

				addChild(usedTimeTitle);
				addChild(usedTimeSprite);
				addChild(miao);

				// set cur level max combo
				secondLineY=usedTimeTitle.y + usedTimeTitle.height + 10;

				var maxComboTitle:Image=Assets.getImage("maxcombo");
				var maxComboSprite:NumberSprite=new NumberSprite(maxCombo);

				secondLineX=bg.x + (bg.width - maxComboTitle.width - maxComboSprite.width - 10) / 2;

				maxComboTitle.x=secondLineX;
				maxComboTitle.y=secondLineY;
				maxComboSprite.x=maxComboTitle.x + maxComboTitle.width + 10;
				maxComboSprite.y=secondLineY;

				addChild(maxComboTitle);
				addChild(maxComboSprite);

				// set cur level max scores
				var thirdLineY:Number=maxComboTitle.y + maxComboTitle.height + 10;
				var thirdLineX:Number=bg.x + (bg.width - curScoreTitle.width - curScoreSprite.width - curScoreFen.width - 10) / 2;

				curScoreTitle.x=thirdLineX;
				curScoreTitle.y=thirdLineY;
				curScoreSprite.x=curScoreTitle.x + curScoreTitle.width + 5;
				curScoreSprite.y=thirdLineY;
				curScoreFen.x=curScoreSprite.x + curScoreSprite.width + 5;
				curScoreFen.y=thirdLineY;

				addChild(curScoreTitle);
				addChild(curScoreSprite);
				addChild(curScoreFen);

				// set buttons				
				// next level button
				var nextBtn:CommonButton=new CommonButton("nextbtn");
				nextBtn.onClick=onNext;

				btnX=bg.x + (bg.width - backBtn.width - restartBtn.width - nextBtn.width - 2 * btnGap) / 2;

				backBtn.x=btnX;
				backBtn.y=btnY;
				addChild(backBtn);

				restartBtn.x=backBtn.x + backBtn.width + btnGap;
				restartBtn.y=btnY;
				addChild(restartBtn);

				nextBtn.x=restartBtn.x + restartBtn.width + btnGap;
				nextBtn.y=btnY;
				addChild(nextBtn);
			}
			// if lose
			else
			{
				// set cur level max scores
				firstLineY=topIcon.y + topIcon.height + 10;
				firstLineX=bg.x + (bg.width - curScoreTitle.width - curScoreSprite.width - curScoreFen.width - 10) / 2;

				curScoreTitle.x=firstLineX;
				curScoreTitle.y=firstLineY;
				curScoreSprite.x=curScoreTitle.x + curScoreTitle.width + 5;
				curScoreSprite.y=firstLineY;
				curScoreFen.x=curScoreSprite.x + curScoreSprite.width + 5;
				curScoreFen.y=firstLineY;

				addChild(curScoreTitle);
				addChild(curScoreSprite);
				addChild(curScoreFen);

				// set history highest score
				secondLineY=curScoreTitle.y + curScoreTitle.height + 10;

				var historyTitle:Image=Assets.getImage("historymaxsorce");
				var historySprite:NumberSprite=new NumberSprite(highestHistoryScores);
				var historyFen:Image=Assets.getImage("fen");

				secondLineX=bg.x + (bg.width - historyTitle.width - historySprite.width - historyFen.width - 10) / 2;

				historyTitle.x=secondLineX;
				historyTitle.y=secondLineY;
				historySprite.x=historyTitle.x + historyTitle.width + 5;
				historySprite.y=secondLineY;
				historyFen.x=historySprite.x + historySprite.width + 5;
				historyFen.y=secondLineY;

				addChild(historyTitle);
				addChild(historySprite);
				addChild(historyFen);

				// set buttons				
				// next level button

				btnX=bg.x + (bg.width - backBtn.width - restartBtn.width - 1 * btnGap) / 2;

				backBtn.x=btnX;
				backBtn.y=btnY;
				addChild(backBtn);

				restartBtn.x=backBtn.x + backBtn.width + btnGap;
				restartBtn.y=btnY;
				addChild(restartBtn);
			}
		}

		private function drawFullScreenBg():void
		{
			blackBg=Assets.getImage("bg_line0000");
			if (blackBg)
			{
				blackBg.width=Constant.DEFAULT_WIDTH;
				blackBg.height=Constant.DEFAULT_HEIGHT;
				blackBg.scaleX/=0.75;
				blackBg.scaleY/=0.75;
				addChildAt(blackBg, 0);
			}
		}

		private function onNext():void
		{
			var e:GameEvent=new GameEvent(GameEvent.GAME_NEXT);
			EventController.e.dispatchEvent(e);

			this.removeFromParent(true);
		}

		private function onRestart():void
		{
			var e:GameEvent=new GameEvent(GameEvent.GAME_RESTART);
			EventController.e.dispatchEvent(e);

			this.removeFromParent(true);
		}

		private function onBack():void
		{
			var e:ViewEvent=new ViewEvent(ViewEvent.GOTO_PREVIOUS_VIEW);
			EventController.e.dispatchEvent(e);

			this.removeFromParent(true);
		}
	}
}
