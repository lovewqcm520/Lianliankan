package com.jack.llk
{
	import com.jack.llk.control.events.EventController;
	import com.jack.llk.control.events.GameEvent;
	import com.jack.llk.control.events.ViewEvent;
	import com.jack.llk.control.factors.FramerateFactors;
	import com.jack.llk.control.factors.GameStatusFactors;
	import com.jack.llk.control.factors.SoundFactors;
	import com.jack.llk.control.sound.SoundManager;
	import com.jack.llk.log.Log;
	import com.jack.llk.view.view.AboutView;
	import com.jack.llk.view.view.BaseView;
	import com.jack.llk.view.view.GameContainer;
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
		private static var _instance:Game=new Game();

		public var container:Sprite;
		private var _gameStatus:int;
		public var gameModel:int;

		public var initView:InitView;
		public var aboutView:AboutView;
		public var modelView:ModelView;
		public var previousView:BaseView;
		public var gameCanvas:GameContainer;

		private var oldTime:Number;

		public function Game()
		{
		}

		public static function getInstance():Game
		{
			return _instance;
		}

		public function initialize():void
		{
			container=new Sprite();
			Starling.current.stage.addChild(container);

			initGame();

			// add stage keyboard event
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);

			// When the game becomes inactive, we pause Starling; otherwise, the enter frame event
			// would report a very long 'passedTime' when the app is reactivated.			
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActivate);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivate);

			// add enter_frame event
			Starling.current.nativeStage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function initGame():void
		{
			// load assets
			// init some ui

			// read setting config from local shared object
			SoundManager.readSettingFromCache();

			initView=new InitView();
			container.addChild(initView);
		}

		public function showGame():void
		{
			Log.log("showGame");
			// play the waiting background music
			//SoundManager.play(SoundFactors.DATING_BACK_MUSIC, true, true);
			gameStatus = GameStatusFactors.STATUS_IDLE;
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
			Starling.current.nativeStage.frameRate=FramerateFactors.FPS_DEACTIVATE;

			// mute all the sound and music
			SoundManager.muteAll();
			
			// dispatch game pause event
			var e:GameEvent=new GameEvent(GameEvent.GAME_PAUSE);
			EventController.e.dispatchEvent(e);
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
			switch (gameStatus)
			{
				case GameStatusFactors.STATUS_IDLE:
				{
					Starling.current.nativeStage.frameRate=FramerateFactors.FPS_IDLE;
					break;
				}

				case GameStatusFactors.STATUS_PAUSE_BY_DEACTIVATE:
				{
					Starling.current.nativeStage.frameRate=FramerateFactors.FPS_PAUSE_BY_DEACTIVATE;
					break;
				}

				case GameStatusFactors.STATUS_PAUSE_BY_USER:
				{
					Starling.current.nativeStage.frameRate=FramerateFactors.FPS_PAUSE_BY_USER;
					break;
				}

				case GameStatusFactors.STATUS_PLAYING:
				{
					Starling.current.nativeStage.frameRate=FramerateFactors.FPS_PLAYING;
					// play the play background music
					SoundManager.play(SoundFactors.GAME_BACK_MUSIC, true, true);
					break;
				}

				case GameStatusFactors.STATUS_WARNING:
				{
					Starling.current.nativeStage.frameRate=FramerateFactors.FPS_PLAYING;

					// resume play warning sound
					SoundManager.play(SoundFactors.DAO_JI_SHI_MUSIC, false, true);
					break;
				}

				case GameStatusFactors.STATUS_OVER:
				{
					break;
				}

				case GameStatusFactors.STATUS_START:
				{
					break;
				}

				default:
				{
					Starling.current.nativeStage.frameRate=FramerateFactors.FPS_PLAYING;
				}
			}

			// resume the music if music is on
			if (SoundManager.musicEnabled)
			{
				SoundManager.resumeMusic();
			}

		}

		protected function onKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.BACK:
				{
					// prevent the default event behavior
					event.preventDefault();

					// if game status was playing, then pause the game
					if (gameStatus == GameStatusFactors.STATUS_PLAYING)
					{
						var e2:GameEvent=new GameEvent(GameEvent.GAME_PAUSE);
						EventController.e.dispatchEvent(e2);
					}
					// if game status was pause, then go back to previous view
					else
					{
//						if(gameStatus == GameStatusFactors.STATUS_PAUSE_BY_DEACTIVATE || 
//							gameStatus == GameStatusFactors.STATUS_PAUSE_BY_USER)
//						{
//						}

						// return to last screen
						var e:ViewEvent=new ViewEvent(ViewEvent.GOTO_PREVIOUS_VIEW);
						EventController.e.dispatchEvent(e);
					}
					break;
				}
			}
		}

		protected function onEnterFrame(event:Event):void
		{
			if (gameCanvas && gameCanvas.stage)
			{
				gameCanvas.showItemIdleAnimation();
			}
		}

		public function get gameStatus():int
		{
			return _gameStatus;
		}

		public function set gameStatus(value:int):void
		{
			if(_gameStatus != value)
			{
				_gameStatus = value;
				
				// 针对不同的游戏状态更新不同的framerate
				switch (gameStatus)
				{
					case GameStatusFactors.STATUS_IDLE:
					{
						Starling.current.nativeStage.frameRate=FramerateFactors.FPS_IDLE;
						// resume play warning sound
						SoundManager.play(SoundFactors.DATING_BACK_MUSIC, true, true);
						break;
					}
						
					case GameStatusFactors.STATUS_PAUSE_BY_DEACTIVATE:
					{
						Starling.current.nativeStage.frameRate=FramerateFactors.FPS_PAUSE_BY_DEACTIVATE;
						break;
					}
						
					case GameStatusFactors.STATUS_PAUSE_BY_USER:
					{
						Starling.current.nativeStage.frameRate=FramerateFactors.FPS_PAUSE_BY_USER;
						break;
					}
						
					case GameStatusFactors.STATUS_PLAYING:
					{
						Starling.current.nativeStage.frameRate=FramerateFactors.FPS_PLAYING;
						// play the play background music
						SoundManager.play(SoundFactors.GAME_BACK_MUSIC, true, true);
						break;
					}
						
					case GameStatusFactors.STATUS_WARNING:
					{
						Starling.current.nativeStage.frameRate=FramerateFactors.FPS_PLAYING;
						
						// resume play warning sound
						SoundManager.play(SoundFactors.DAO_JI_SHI_MUSIC, false, true);
						break;
					}
						
					case GameStatusFactors.STATUS_OVER:
					{
						break;
					}
						
					case GameStatusFactors.STATUS_START:
					{
						break;
					}
						
					default:
					{
						Starling.current.nativeStage.frameRate=FramerateFactors.FPS_PLAYING;
					}
				}
			}
		}

	}
}
