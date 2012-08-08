package com.jack.llk.view.module.classic
{
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.view.NumberSprite;
	import com.jack.llk.view.component.RewardStarList;
	
	import starling.display.Image;
	import com.jack.llk.view.panel.RewardPanel;

	public class ClassicModelRewardPanel extends RewardPanel
	{
		// cur level stars user get
		public var stars:int;
		
		// win only
		public var usedTime:int;
		public var maxCombo:int;
		
		public function ClassicModelRewardPanel()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
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
				
				// set cur level max stars
				var thirdLineY:Number=maxComboTitle.y + maxComboTitle.height + 10;				
				var starList:RewardStarList = new RewardStarList(stars);
				starList.x = bg.x + (bg.width - starList.width) / 2;;
				starList.y = thirdLineY;
				addChild(starList);
			}
			// if lose
			else
			{
				// add lose text image
				var loseImage:Image=Assets.getImage("lose");
				loseImage.x=bg.x + (bg.width - loseImage.width) / 2;
				loseImage.y=bg.y + (bg.height-loseImage.height) / 2;
				addChild(loseImage);
			}
		}
		
		
	}
}