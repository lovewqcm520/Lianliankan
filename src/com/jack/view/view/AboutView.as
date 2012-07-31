package com.jack.view.view
{
	import com.jack.Game;
	import com.jack.control.asset.Assets;
	import com.jack.control.events.ViewEvent;
	import com.jack.view.button.CommonButton;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	
	public class AboutView extends BaseView
	{		
		public function AboutView()
		{
			super();
			
			setBackground("asset_bg_about");			
		}
		
		override protected function onAddedToStage(event:Event):void
		{
			super.onAddedToStage(event);
			
			initialize1();
		}		
		
		private function initialize1():void
		{
			var w:Number = this.width;
			var h:Number = this.height;

			// back button
			var backBtn:CommonButton = new CommonButton("backbt");
			addChildScaled(backBtn, 10, 690);
			backBtn.onClick = onBackClick;
			
			// help banner
			var bannerBg:Image = Assets.getImage("top_bg");
			addChildScaled(bannerBg, 0, 0);
			
			// help text
			var helpTxt:Image = Assets.getImage("help");
			addChildScaled(helpTxt, 166, 14);
			
			// about help content
			var helpContent:Image = Assets.getImage("helpcontent");
			addChildScaled(helpContent, 58, 204);		
		}		
		
		/**
		 * Back to init screen.
		 */
		private function onBackClick():void
		{
			// start moving
			var t1:Tween = new Tween(this, 0.3);
			t1.animate("x", Starling.current.nativeStage.fullScreenWidth);
			Starling.juggler.add(t1);
			
			this.prepareHide();
			
			var t2:Tween = new Tween(Game.getInstance().initView, 0.3);
			t2.animate("x", 0);
			Starling.juggler.add(t2);
			
			Game.getInstance().initView.prepareShow();
		}
		
		override protected function onGotoPreviousView(event:ViewEvent):void
		{
			super.onGotoPreviousView(event);
			
			onBackClick();
		}	
		
	}
}