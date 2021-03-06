package com.jack.llk.view.panel
{
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.control.events.EventController;
	import com.jack.llk.control.events.GameEvent;
	import com.jack.llk.control.events.ViewEvent;
	import com.jack.llk.control.sound.SoundManager;
	import com.jack.llk.view.BaseSprite;
	import com.jack.llk.view.button.BaseButton;
	import com.jack.llk.view.button.CommonButton;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;

	public class PausePanel extends BaseSprite
	{
		private var musicBtn:CommonButton;
		private var soundBtn:CommonButton;
		private var musicXIcon:Image;
		private var soundXIcon:Image;

		private var playBtn:BaseButton;

		public function PausePanel()
		{
			super();

			initialize();
		}

		override public function dispose():void
		{

			super.dispose();
		}
		
		public function updateMusicSoundEnable():void
		{
			onSwitchMusicStatus();
			onSwitchSoundStatus();
		}

		private function initialize():void
		{
			// set background dialog
			var bg:Image=Assets.getImage("dialogbg");
			bg.scaleX=bg.scaleY=0.82;
			bg.x=0;
			bg.y=0;
			addChild(bg);

			// set play button
			var upState:Texture=Assets.getTexture("startgamebt");
			var text:String="";
			var downState:Texture=Assets.getTexture("startgamebted");
			playBtn=new BaseButton(upState, text, downState);
			playBtn.x=bg.x + (bg.width - playBtn.width) / 2;
			playBtn.y=-playBtn.height / 2;
			addChild(playBtn);
			playBtn.onClick=onResume;

			// set back, restart, about, music, sound , 5 buttons
			var btnY:Number=107;
			var gap:Number=-10;
			var btnW:Number=98;
			var fx:Number=bg.x + (bg.width - 4 * (btnW + gap)) / 2;

			// back button
			var backBtn:CommonButton=new CommonButton("backbt");
			backBtn.x=fx;
			backBtn.y=btnY;
			backBtn.onClick=onBack;
			addChild(backBtn);

			// restart button
			var restartBtn:CommonButton=new CommonButton("restartbtn");
			restartBtn.x=fx + 1 * (btnW + gap);
			restartBtn.y=btnY;
			restartBtn.onClick=onRestart;
			addChild(restartBtn);

			// music button
			musicBtn=new CommonButton("music_white");
			musicBtn.x=fx + 2 * (btnW + gap);
			musicBtn.y=btnY;
			musicBtn.onClick=onSwitchMusicStatus;
			addChild(musicBtn);
			if (!SoundManager.musicEnabled)
			{
				musicXIcon=Assets.getImage("close");
				musicXIcon.x=(musicBtn.width - musicXIcon.width) / 2;
				musicXIcon.y=(musicBtn.height - musicXIcon.height) / 2;
				musicBtn.addChild(musicXIcon);
			}

			// sound button
			soundBtn=new CommonButton("sound_white");
			soundBtn.x=fx + 3 * (btnW + gap);
			soundBtn.y=btnY;
			soundBtn.onClick=onSwitchSoundStatus;
			addChild(soundBtn);
			if (!SoundManager.musicEnabled)
			{
				soundXIcon=Assets.getImage("close");
				soundXIcon.x=(soundBtn.width - soundXIcon.width) / 2;
				soundXIcon.y=(soundBtn.height - soundXIcon.height) / 2;
				soundBtn.addChild(soundXIcon);
			}
			
			// init sound music status
			updateMusicXIcon(SoundManager.musicEnabled);
			updateSoundXIcon(SoundManager.soundEnabled);
		}
		
		/**
		 * Enable or disable the sound.
		 */
		private function onSwitchSoundStatus():void
		{
			if (SoundManager.soundEnabled)
			{
				updateSoundXIcon(false);
				SoundManager.soundEnabled=false;
			}
			else
			{
				updateSoundXIcon(true);
				SoundManager.soundEnabled=true;
			}
		}
		
		private function updateSoundXIcon(soundEnable:Boolean):void
		{
			if(!soundEnable)
			{
				if (!soundXIcon)
				{
					soundXIcon=Assets.getImage("close");
					soundXIcon.x=(soundBtn.width - soundXIcon.width) / 2;
					soundXIcon.y=(soundBtn.height - soundXIcon.height) / 2;
					soundBtn.addChild(soundXIcon);
				}
				else
				{
					soundBtn.addChild(soundXIcon);
				}
			}
			else
			{
				if (soundXIcon)
					soundXIcon.removeFromParent();
			}
		}
		
		private function updateMusicXIcon(musicEnable:Boolean):void
		{
			if(!musicEnable)
			{
				if (!musicXIcon)
				{
					musicXIcon=Assets.getImage("close");
					musicXIcon.x=(musicBtn.width - musicXIcon.width) / 2;
					musicXIcon.y=(musicBtn.height - musicXIcon.height) / 2;
					musicBtn.addChild(musicXIcon);
				}
				else
				{
					musicBtn.addChild(musicXIcon);
				}
			}
			else
			{
				if (musicXIcon)
					musicXIcon.removeFromParent();
			}
		}

		/**
		 * Enable or disable the music.
		 */
		private function onSwitchMusicStatus():void
		{
			if (SoundManager.musicEnabled)
			{
				updateMusicXIcon(false);
				SoundManager.musicEnabled=false;
			}
			else
			{
				updateMusicXIcon(true);
				SoundManager.musicEnabled=true;
			}
		}

		/**
		 * Restart current mode and level game.
		 */
		private function onRestart():void
		{
			var e:GameEvent=new GameEvent(GameEvent.GAME_RESTART);
			EventController.e.dispatchEvent(e);

			hide();
		}

		/**
		 * Back to last view.
		 */
		private function onBack():void
		{
			// return to last screen
			var e:ViewEvent=new ViewEvent(ViewEvent.GOTO_PREVIOUS_VIEW);
			EventController.e.dispatchEvent(e);

			hide();
		}

		/**
		 * Resume the paused game.
		 */
		private function onResume():void
		{
			var e:GameEvent=new GameEvent(GameEvent.GAME_RESUME);
			EventController.e.dispatchEvent(e);
		}

		public function show():void
		{
			var t:Tween=new Tween(this, 0.6, Transitions.EASE_OUT_BACK);
			var ty:Number=Starling.current.stage.stageHeight - this.height * 0.5;
			t.animate("y", ty);
			Starling.juggler.add(t);
		}

		public function hide():void
		{
			var t:Tween=new Tween(this, 0.6, Transitions.EASE_IN_BACK);
			t.animate("y", Starling.current.stage.stageHeight-playBtn.bounds.y + 100);
			Starling.juggler.add(t);
		}
	}
}
