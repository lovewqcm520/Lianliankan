package com.jack.view.view
{
	import com.jack.control.asset.Assets;
	import com.jack.control.events.ViewEvent;
	
	import flash.desktop.NativeApplication;
	import flash.events.StatusEvent;
	
	import org.josht.starling.foxhole.controls.ProgressBar;
	import org.josht.starling.motion.GTween;
	
	import starling.display.Image;
	import starling.events.Event;

	public class GameView extends BaseView
	{
		private var modelScreen:ModelView;
		private var aboutScreen:AboutView;

		private var pt:GTween;

		private var pro:ProgressBar;

		public function GameView()
		{
			super();
		}
		
		override protected function onAddedToStage(event:Event):void
		{
			super.onAddedToStage(event);
			
			setBackground("game_bg");			
			initialize1();
		}
		
		public function start():void
		{
			pro = new ProgressBar();			
			pro.minimum = 0;
			pro.maximum = 1;
			pro.value = 0;			
			addChildScaled(pro, 10, 100);
			
			pro.onResize.add(onResize);
			pro.direction = ProgressBar.DIRECTION_HORIZONTAL;
			pro.backgroundSkin = Assets.getImage("ratebg");
			//pro.backgroundDisabledSkin = Assets.getImage("ratebg");
			var fill:Image = Assets.getImage("rateoverbg");
			fill.width = 0;
			fill.height = 0;
			pro.fillSkin = fill;
			
			pt = new GTween(pro, 10,
				{
					value: 1				
				},
				{
					repeatCount: int.MAX_VALUE
				});
		}
		
		
		private function onResize(p:ProgressBar):void
		{
			trace(p.value);
		}
		
		private function initialize1():void
		{
			var w:Number = this.width;
			var h:Number = this.height;
			
			
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
			
//			pt.paused = true;
//			pt = null;
		}
		
		protected function onStatusEvent(event:StatusEvent):void
		{
			if(event.level == "ok")
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