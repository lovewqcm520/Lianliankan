package com.jack.llk
{
	import com.jack.llk.control.events.EventController;
	import com.jack.llk.control.events.ViewEvent;
	import com.jack.llk.control.factors.FramerateFactors;
	import com.jack.llk.control.factors.GameStatusFactors;
	import com.jack.llk.control.factors.SoundFactors;
	import com.jack.llk.control.sound.SoundManager;
	import com.jack.llk.log.Log;
	import com.jack.llk.view.view.AboutView;
	import com.jack.llk.view.view.GameView;
	import com.jack.llk.view.view.InitView;
	import com.jack.llk.view.view.ModelView;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import starling.core.Starling;
	import starling.display.Sprite;

	public class Game
	{
		private static var _instance:Game = new Game();
		
		public var container:Sprite;		
		public var gameStatus:int;
		public var gameModel:int;

		public var initView:InitView;
		public var aboutView:AboutView;
		public var modelView:ModelView;
		public var gameView:GameView;
		
		public function Game()
		{
		}
		
		public static function getInstance():Game
		{
			return _instance;
		}
		
		public function initialize():void
		{			
			container = new Sprite();
			Starling.current.stage.addChild(container);
			
			initSplashScreen();
			initGame();		
			
			// add stage keyboard event
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			// When the game becomes inactive, we pause Starling; otherwise, the enter frame event
			// would report a very long 'passedTime' when the app is reactivated.			
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActivate);			
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivate);
		}	
		
		private function initSplashScreen():void
		{
//			var splash:SplashScreen = new SplashScreen();
//			container.addChild(splash);
//			splash.setBackground("asset_bg_splash");
//			splash.setTime(showGame, 3);
//			splash.start();
			
//			var splash:Splash = new Splash(Assets.getBitmap("asset_bg_splash"), showGame, 3000, Splash.SCALE_MODE_NONE);
//			Starling.current.nativeStage.addChild(splash);
		}
		
		private function initGame():void
		{
			// load assets
			// init some ui
			
			// read setting config from local shared object
			SoundManager.readSettingFromCache();
			
			initView = new InitView();
			container.addChild(initView);
		}
		
		public function showGame():void
		{
			Log.log("showGame");
			// play the waiting background music
			SoundManager.play(SoundFactors.DATING_BACK_MUSIC, true, true);
		}
		
		/**
		 * Mobile status change to deactivate.
		 * @param event
		 */
		protected function onDeactivate(event:Event):void
		{
			Log.log("onDeactivate");
			// update the framerate
			Starling.current.stop();
			Starling.current.nativeStage.frameRate = FramerateFactors.FPS_DEACTIVATE;
			// mute the music if music is on
			if(SoundManager.musicEnabled)
			{
				SoundManager.muteMusic();
			}
		}
		
		/**
		 * Mobile status change to activate. 
		 * @param event
		 */
		protected function onActivate(event:Event):void
		{
			Log.log("onActivate");
			// update the framerate
			Starling.current.start();
			// 针对不同的游戏状态更新不同的framerate
			switch(gameStatus)
			{
				case GameStatusFactors.STATUS_IDLE:
				{
					Starling.current.nativeStage.frameRate = FramerateFactors.FPS_IDLE;
					break;
				}
					
				case GameStatusFactors.STATUS_PAUSE_BY_DEACTIVATE:
				{
					Starling.current.nativeStage.frameRate = FramerateFactors.FPS_PAUSE_BY_DEACTIVATE;
					break;
				}
					
				case GameStatusFactors.STATUS_PAUSE_BY_USER:
				{
					Starling.current.nativeStage.frameRate = FramerateFactors.FPS_PAUSE_BY_USER;
					break;
				}
					
				case GameStatusFactors.STATUS_PLAYING:
				{
					Starling.current.nativeStage.frameRate = FramerateFactors.FPS_PLAYING;
					break;
				}
					
				default:
				{
					Starling.current.nativeStage.frameRate = FramerateFactors.FPS_PLAYING;
				}
			}
			
			// resume the music if music is on
			if(SoundManager.musicEnabled)
			{
				SoundManager.resumeMusic();
			}
		}
		
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.BACK:
				{
					// prevent the default event behavior
					event.preventDefault();
					// return to last screen
					var e:ViewEvent = new ViewEvent(ViewEvent.GOTO_PREVIOUS_VIEW);
					EventController.e.dispatchEvent(e);
					break;
				}
			}
		}
	}
}