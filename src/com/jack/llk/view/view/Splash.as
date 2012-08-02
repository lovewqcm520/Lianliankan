package com.jack.llk.view.view
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Splash extends Sprite
	{
		public static const SCALE_MODE_LETTERBOX:String   = "letterbox";
		public static const SCALE_MODE_NONE:String   = "none";
		public static const SCALE_MODE_STRETCH:String   = "stretch";
		public static const SCALE_MODE_ZOOM:String   = "zoom";
		
		private var bm:Bitmap;
		// For scaling purposes
		private var _currentHeight:Number;
		private var _currentWidth:Number;
		private var _duration:int;		
		
		// Parameter Variables		
		private var _listener:Function;
		private var _percent:Number;
		private var _scaleMode:String;
		
		// _timer for our duration
		private var _timer:Timer;
		
		// Constructor
		public function Splash(image:Bitmap, listener:Function, duration:int = 1000, scaleMode:String = Splash.SCALE_MODE_NONE)
		{
			// Set vars
			bm = image;
			_duration = duration;
			_scaleMode = scaleMode;
			_listener = listener;
			// Listen for when this is added
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function layoutBm():void
		{
			// Get and save the original width and height of the Image. 
			_currentWidth = bm.width;
			_currentHeight = bm.height;
			
			// Run which function is set in the constructor
			switch (_scaleMode)
			{
				case SCALE_MODE_NONE:
					none();
					break;
				case SCALE_MODE_ZOOM:
					zoom();
					break;
				case SCALE_MODE_LETTERBOX:
					letterbox();
					break;
				case SCALE_MODE_STRETCH:
					stretch();
					break;
				
			}
			
			// Add the image to stage
			addChild(bm);
		}
		
		
		// Places the splash image in the center of the stage
		private function imagePlacement():void
		{
			bm.x = (stage.fullScreenWidth - bm.width) * .5;
			bm.y = (stage.fullScreenHeight - bm.height) * .5;
		}
		
		
		// Init
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if(bm)
			{
				layoutBm();
			}
			// Create a _timer for how long the Splash Screen stays on screen
			_timer = new Timer(_duration, 0);
			_timer.addEventListener(TimerEvent.TIMER, removeSplashScreen);
			_timer.start();	
		}
		
		// Letterbox: scales the splash image based on the stage width
		private function letterbox():void
		{
			bm.width = stage.fullScreenWidth;
			_percent = _currentWidth / bm.width;
			bm.height = _currentHeight / _percent;
			imagePlacement();
		}
		
		// None: doesn't scale the splash image
		private function none():void
		{
			imagePlacement();
		}
				
		// Removes splash screen when _timer is done
		private function removeSplashScreen(e:TimerEvent):void
		{
			_listener.apply();
			_listener = null;
			
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, removeSplashScreen);	
			_timer = null; 			
			
			if(bm)
			{
				bm.bitmapData.dispose();
				bm = null;
			}
			parent.removeChild(this);
		}
		
		// Stretch: scales both height and width to the stage width and height
		private function stretch():void
		{
			bm.width = stage.fullScreenWidth;
			bm.height = stage.fullScreenHeight;
			imagePlacement();
		}
		
		// Zoom: scales the splash image based on the stage height
		private function zoom():void
		{
			bm.height = stage.fullScreenHeight;
			_percent = _currentHeight / bm.height;
			bm.width = _currentWidth / _percent;
			imagePlacement();			
		}
	}
}