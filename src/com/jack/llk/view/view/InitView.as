package com.jack.llk.view.view
{
	import com.jack.llk.Game;
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.control.events.ViewEvent;
	import com.jack.llk.view.button.CommonButton;
	import com.jack.llk.view.button.PlayButton;
	import com.jack.llk.view.panel.SettingPanel;
	
	import flash.desktop.NativeApplication;
	import flash.events.StatusEvent;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;

	public class InitView extends BaseView
	{
		private var modelScreen:ModelView;
		private var aboutScreen:AboutView;

		public function InitView()
		{
			super();
		}

		override protected function onAddedToStage(event:Event):void
		{
			super.onAddedToStage(event);

			setBackground("asset_bg_init");
			initialize1();
		}

		private function initialize1():void
		{
			var w:Number=this.width;
			var h:Number=this.height;
			var xBlank:Number=20;
			var yBlank:Number=20;

			// setting panel
			var setting:SettingPanel=new SettingPanel();
			addChildScaled(setting, 370, 690);
			setting.setClipRect(370, 690);

			// back button
			var backBtn:CommonButton=new CommonButton("backbt");
			addChildScaled(backBtn, 10, 690);
			backBtn.onClick=onBackClick;

			// about button
			var aboutBtn:CommonButton=new CommonButton("aboutbt");
			addChildScaled(aboutBtn, 10, 590);
			aboutBtn.onClick=onAboutClick;

			// game logo
			var logo:Image=Assets.getImage("logo");
			addChildScaled(logo, 60, 60);

			// play button
			var playBtn:PlayButton=new PlayButton();
			addChildScaled(playBtn, 120, 255);
			playBtn.onClick=onPlayClick;
		}

		/**
		 * Open the model selecte screen.
		 */
		private function onPlayClick():void
		{
			if (!modelScreen)
			{
				modelScreen=new ModelView();
				Game.getInstance().modelView=modelScreen;
				modelScreen.x=Starling.current.nativeStage.fullScreenWidth;
				modelScreen.y=0;
				Game.getInstance().container.addChild(modelScreen);
			}

			// start moving
			var t1:Tween=new Tween(modelScreen, 0.3);
			t1.animate("x", 0);
			t1.onUpdate=onModelViewMoveUpdate;
			Starling.juggler.add(t1);
			modelScreen.prepareShow();

			var t2:Tween=new Tween(this, 0.3);
			t2.animate("x", -Starling.current.nativeStage.fullScreenWidth);
			Starling.juggler.add(t2);
			this.prepareHide();
		}

		private function onModelViewMoveUpdate():void
		{
			modelScreen.addModelContainerToStage();
		}

		/**
		 * Open the about screen.
		 */
		private function onAboutClick():void
		{
			if (!aboutScreen)
			{
				aboutScreen=new AboutView();
				Game.getInstance().aboutView=aboutScreen;
				aboutScreen.x=Starling.current.nativeStage.fullScreenWidth;
				aboutScreen.y=0;
				Game.getInstance().container.addChild(aboutScreen);
			}

			// start moving
			var t1:Tween=new Tween(aboutScreen, 0.3);
			t1.animate("x", 0);
			Starling.juggler.add(t1);

			aboutScreen.prepareShow();

			var t2:Tween=new Tween(this, 0.3);
			t2.animate("x", -Starling.current.nativeStage.fullScreenWidth);
			Starling.juggler.add(t2);

			this.prepareHide();
		}

		/**
		 * Quit the game.
		 */
		private function onBackClick():void
		{
//			try
//			{
//				var ane:AIR3Extension = new AIR3Extension();
//				ane.alertDialog("提示", "确定退出游戏?");
//				ane.addEventListener(StatusEvent.STATUS, onStatusEvent);
//			} 
//			catch(error:Error) 
//			{
//				trace(error.message);
//			}			
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


	}
}
