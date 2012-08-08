package com.jack.llk.view.module.endless
{
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.view.NumberSprite;
	
	import starling.display.Image;
	import com.jack.llk.view.panel.RewardPanel;

	public class EndlessModelRewardPanel extends RewardPanel
	{
		// for both win and lose
		public var curScores:int;
		
		// lose only
		public var highestHistoryScores:int;
		
		// win only
		public var usedTime:int;
		public var maxCombo:int;
		
		public function EndlessModelRewardPanel()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			// init cur level max scores
			var curScoreTitle:Image=Assets.getImage("nowscore");
			var curScoreSprite:NumberSprite=new NumberSprite(curScores);
			var curScoreFen:Image=Assets.getImage("fen");
			
			var firstLineY:Number;
			var firstLineX:Number;
			var secondLineY:Number;
			var secondLineX:Number;
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
			}
		}
		
		
	}
}