package com.jack.llk.view.panel
{
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.view.BaseSprite;
	import com.jack.llk.view.NumberSprite;
	import com.jack.llk.view.button.CommonButton;
	
	import starling.display.Image;
	
	public class RewardPanel extends BaseSprite
	{
		private var isWin:Boolean;
		
		// for both win and lose
		private var curScores:int = 70;
		
		// lose only
		private var highestHistoryScores:int=3105;
		
		// win only
		private var usedTime:int=30;
		private var maxCombo:int=17;
		
		public function RewardPanel()
		{
			super();
		}
		
		public function showWin():void
		{
			this.isWin = true;
			
			
			initialize();
		}
		
		public function showLose():void
		{
			this.isWin = false;
			
			
			initialize();
		}
		
		private function initialize():void
		{
			// set background dialog
			var bg:Image = Assets.getImage("dialogbg");
			//bg.scaleX = bg.scaleY = 0.82;
			bg.x = 0;
			bg.y = 0;
			addChild(bg);
			
			// set win or lose character icon
			var topIcon:Image = isWin ? Assets.getImage("winicon"): Assets.getImage("loseicon");
			topIcon.x = bg.x + (bg.width - topIcon.width)/2;
			topIcon.y = -topIcon.height/2;
			addChild(topIcon);
			
			// init cur level max scores
			var curScoreTitle:Image = Assets.getImage("nowscore");
			var curScoreSprite:NumberSprite = new NumberSprite(curScores);
			var curScoreFen:Image = Assets.getImage("fen");
			
			// init back and restart button
			// back button
			var backBtn:CommonButton = new CommonButton("backbt");
			backBtn.onClick = onBack;			
			// restart button
			var restartBtn:CommonButton = new CommonButton("restartbtn");
			restartBtn.onClick = onRestart;			
			
			var firstLineY:Number;
			var firstLineX:Number;
			var secondLineY:Number;
			var secondLineX:Number;
			var btnGap:Number = 10;
			var btnY:Number = bg.y + bg.height - backBtn.height*0.7;
			var btnX:Number;
			// if win
			if(isWin)
			{
				// set cur level used time
				firstLineY = topIcon.y + topIcon.height + 10;
				
				var usedTimeTitle:Image = Assets.getImage("thislevelsorce");
				var usedTimeSprite:NumberSprite = new NumberSprite(usedTime);
				var miao:Image = Assets.getImage("time_s");
				
				firstLineX = bg.x + (bg.width-usedTimeTitle.width-usedTimeSprite.width-miao.width-10)/2;
				
				usedTimeTitle.x = firstLineX;
				usedTimeTitle.y = firstLineY;
				usedTimeSprite.x = usedTimeTitle.x + usedTimeTitle.width + 5;
				usedTimeSprite.y = firstLineY;
				miao.x = usedTimeSprite.x + usedTimeSprite.width + 5;
				miao.y = firstLineY;
				
				addChild(usedTimeTitle);
				addChild(usedTimeSprite);
				addChild(miao);
				
				// set cur level max combo
				secondLineY = usedTimeTitle.y + usedTimeTitle.height + 10;
				
				var maxComboTitle:Image = Assets.getImage("maxcombo");
				var maxComboSprite:NumberSprite = new NumberSprite(maxCombo);
				
				secondLineX = bg.x + (bg.width-maxComboTitle.width-maxComboSprite.width-10)/2;
			
				maxComboTitle.x = secondLineX;
				maxComboTitle.y = secondLineY;
				maxComboSprite.x = maxComboTitle.x + maxComboTitle.width + 10;
				maxComboSprite.y = secondLineY;
				
				addChild(maxComboTitle);
				addChild(maxComboSprite);
				
				// set cur level max scores
				var thirdLineY:Number = maxComboTitle.y + maxComboTitle.height + 10;
				var thirdLineX:Number = bg.x + (bg.width-curScoreTitle.width-curScoreSprite.width-curScoreFen.width-10)/2;
				
				curScoreTitle.x = thirdLineX;
				curScoreTitle.y = thirdLineY;
				curScoreSprite.x = curScoreTitle.x + curScoreTitle.width + 5;
				curScoreSprite.y = thirdLineY;
				curScoreFen.x = curScoreSprite.x + curScoreSprite.width + 5;
				curScoreFen.y = thirdLineY;
				
				addChild(curScoreTitle);
				addChild(curScoreSprite);
				addChild(curScoreFen);
				
				// set buttons				
				// next level button
				var nextBtn:CommonButton = new CommonButton("nextbtn");
				nextBtn.onClick = onNext;	
				
				btnX = bg.x + (bg.width-backBtn.width-restartBtn.width-nextBtn.width-2*btnGap)/2;
				
				backBtn.x = btnX;
				backBtn.y = btnY;
				addChild(backBtn);
				
				restartBtn.x = backBtn.x + backBtn.width + btnGap;
				restartBtn.y = btnY;
				addChild(restartBtn);
				
				nextBtn.x = restartBtn.x + restartBtn.width + btnGap;
				nextBtn.y = btnY;
				addChild(nextBtn);
			}
			// if lose
			else
			{
				// set cur level max scores
				firstLineY = topIcon.y + topIcon.height + 10;
				firstLineX = bg.x + (bg.width-curScoreTitle.width-curScoreSprite.width-curScoreFen.width-10)/2;
				
				curScoreTitle.x = firstLineX;
				curScoreTitle.y = firstLineY;
				curScoreSprite.x = curScoreTitle.x + curScoreTitle.width + 5;
				curScoreSprite.y = firstLineY;
				curScoreFen.x = curScoreSprite.x + curScoreSprite.width + 5;
				curScoreFen.y = firstLineY;
				
				addChild(curScoreTitle);
				addChild(curScoreSprite);
				addChild(curScoreFen);
				
				// set history highest score
				secondLineY = curScoreTitle.y + curScoreTitle.height + 10;
				
				var historyTitle:Image = Assets.getImage("historymaxsorce");
				var historySprite:NumberSprite = new NumberSprite(highestHistoryScores);
				var historyFen:Image = Assets.getImage("fen");
				
				secondLineX = bg.x + (bg.width-historyTitle.width-historySprite.width-historyFen.width-10)/2;
				
				historyTitle.x = secondLineX;
				historyTitle.y = secondLineY;
				historySprite.x = historyTitle.x + historyTitle.width + 5;
				historySprite.y = secondLineY;
				historyFen.x = historySprite.x + historySprite.width + 5;
				historyFen.y = secondLineY;
				
				addChild(historyTitle);
				addChild(historySprite);
				addChild(historyFen);
				
				// set buttons				
				// next level button
				
				btnX = bg.x + (bg.width-backBtn.width-restartBtn.width-1*btnGap)/2;
				
				backBtn.x = btnX;
				backBtn.y = btnY;
				addChild(backBtn);
				
				restartBtn.x = backBtn.x + backBtn.width + btnGap;
				restartBtn.y = btnY;
				addChild(restartBtn);
			}
		}
		
		private function onNext():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function onRestart():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function onBack():void
		{
			// TODO Auto Generated method stub
			
		}
	}
}