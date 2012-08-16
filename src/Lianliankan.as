package
{
	import com.jack.llk.Game;
	import com.jack.llk.control.Common;
	import com.jack.llk.control.Global;
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.log.Log;
	import com.jack.llk.view.view.Splash;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.ResizeEvent;

	[SWF(width="320", height="480", frameRate="30", backgroundColor="#000000")]
	public class Lianliankan extends Sprite
	{
		private var mStarling:Starling;

		public function Lianliankan()
		{
			super();

			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;

			addEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(ResizeEvent.RESIZE, onResize);

			// init the Common
			Common.init();
			
			// show the splash view
			var splash:Splash=new Splash(Assets.getBitmap("asset_bg_splash"), Game.getInstance().showGame, 2000, Splash.SCALE_MODE_STRETCH);
			stage.addChild(splash);
		}

		protected function onAddedToStage(event:flash.events.Event):void
		{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);

			Starling.handleLostContext=true;
			Starling.multitouchEnabled=false;

			var viewPort:Rectangle=new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
			mStarling=new Starling(Startup, stage, viewPort, null, "auto");

			mStarling.enableErrorChecking=true;
			mStarling.showStats=true;

			mStarling.start();

			Global.contentScaleXFactor=stage.fullScreenWidth / Common.DEFAULT_WIDTH;
			Global.contentScaleYFactor=stage.fullScreenHeight / Common.DEFAULT_HEIGHT;
			
			Starling.current.addEventListener(starling.events.Event.CONTEXT3D_CREATE, onContextCreated);
		}
		
		private function onContextCreated(e:starling.events.Event):void
		{
			trace("onContextCreated");
		}
		
		protected function onResize(event:flash.events.Event):void
		{
//			var viewPort:Rectangle = new Rectangle();
//			
//			viewPort.width = stage.stageWidth;
//			viewPort.height = stage.stageHeight;				
//			Starling.current.viewPort = viewPort;
//			mStarling.nativeStage.stageWidth = viewPort.width*Starling.current.contentScaleFactor;
//			mStarling.nativeStage.stageHeight = viewPort.height*Starling.current.contentScaleFactor;

//			if(stage.stageWidth > stage.stageHeight)
//			{
//				viewPort.width = stage.stageWidth;
//				viewPort.height = stage.stageHeight;				
//				Starling.current.viewPort = viewPort;
//				mStarling.nativeStage.stageWidth = viewPort.width*Starling.current.contentScaleFactor;
//				mStarling.nativeStage.stageHeight = viewPort.height*Starling.current.contentScaleFactor;
//			}
//			else
//			{
//				viewPort.width = stage.stageHeight;
//				viewPort.height = stage.stageWidth;				
//				Starling.current.viewPort = viewPort;
//				mStarling.nativeStage.stageWidth = viewPort.height*Starling.current.contentScaleFactor;
//				mStarling.nativeStage.stageHeight = viewPort.width*Starling.current.contentScaleFactor;
//			}

			Log.traced("onResize Stage size", Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight, Starling.current.stage.stageWidth, Starling.current.stage.stageHeight, Starling.current.nativeStage.fullScreenWidth, Starling.current.nativeStage.fullScreenHeight);
		}


	}
}
