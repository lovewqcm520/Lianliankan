package com.jack.llk.view.panel
{
	import com.jack.llk.control.Common;
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.control.events.EventController;
	import com.jack.llk.control.events.GameEvent;
	import com.jack.llk.control.events.ViewEvent;
	import com.jack.llk.view.BaseSprite;
	import com.jack.llk.view.button.CommonButton;
	
	import starling.display.Image;

	public class RewardPanel extends BaseSprite
	{
		protected var isWin:Boolean;
		protected var blackBg:Image;
		protected var bg:Image;
		protected var topIcon:Image;

		private var nextBtn:CommonButton;

		public function RewardPanel()
		{
			super();
		}

		override public function dispose():void
		{
			super.dispose();
		}
		
		public function showWinTheFinalChapter():void
		{
			this.isWin=true;
			initialize();
			
			nextBtn.visible = false;
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

		protected function initialize():void
		{
			// draw the black alpha bg
			drawFullScreenBg();

			// set background dialog
			bg=Assets.getImage("dialogbg");
			//bg.scaleX = bg.scaleY = 0.82;
			bg.x=blackBg.x + (blackBg.width - bg.width) / 2;
			bg.y=blackBg.y + (blackBg.height - bg.height) / 2;
			addChild(bg);

			// set win or lose character icon
			topIcon=isWin ? Assets.getImage("winicon") : Assets.getImage("loseicon");
			topIcon.x=bg.x + (bg.width - topIcon.width) / 2;
			topIcon.y=bg.y - topIcon.height / 2;
			addChild(topIcon);

			// init back and restart button
			// back button
			var backBtn:CommonButton=new CommonButton("backbt");
			backBtn.onClick=onBack;
			// restart button
			var restartBtn:CommonButton=new CommonButton("restartbtn");
			restartBtn.onClick=onRestart;

			var btnGap:Number=10;
			var btnY:Number=bg.y + bg.height - backBtn.height * 0.7;
			var btnX:Number;
			// if win
			if (isWin)
			{
				// set buttons				
				// next level button
				nextBtn=new CommonButton("nextbtn");
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
				blackBg.width=Common.DEFAULT_WIDTH;
				blackBg.height=Common.DEFAULT_HEIGHT;
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
