package com.jack.llk.view.panel
{
	import com.jack.llk.control.Global;
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.control.events.EventController;
	import com.jack.llk.control.events.SoundEvent;
	import com.jack.llk.control.sound.SoundManager;
	import com.jack.llk.view.BaseMovieClip;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class SettingBackground extends Sprite
	{
		private var mcMusic:BaseMovieClip;
		private var mcSound:BaseMovieClip;
		private var bg:Image;

		private var _musicEnabled:Boolean;
		private var _soundEnabled:Boolean;

		public function SettingBackground()
		{
			super();

			_musicEnabled=true;
			_soundEnabled=true;

			initialize();
		}

		////////// public function ///////////////


		///////// private function //////////////
		private function initialize():void
		{
			addBg();
			addMusicBtn();
			addSoundBtn();

			restoreSettingFromCache();

			// add event listener
			EventController.e.addEventListener(SoundEvent.MUSIC_OFF, onMusicOff);
			EventController.e.addEventListener(SoundEvent.MUSIC_ON, onMusicOn);
			EventController.e.addEventListener(SoundEvent.SOUND_OFF, onSoundOff);
			EventController.e.addEventListener(SoundEvent.SOUND_ON, onSoundOn);
		}

		private function restoreSettingFromCache():void
		{
			soundEnabled=SoundManager.soundEnabled;
			musicEnabled=SoundManager.musicEnabled;
		}

		private function onSoundOn(event:SoundEvent=null):void
		{
			soundEnabled=true;
		}

		private function onSoundOff(event:SoundEvent=null):void
		{
			soundEnabled=false;
		}

		private function onMusicOn(event:SoundEvent=null):void
		{
			musicEnabled=true;
		}

		private function onMusicOff(event:SoundEvent=null):void
		{
			musicEnabled=false;
		}

		private function addMusicBtn():void
		{
			var t:Vector.<Texture>=new Vector.<Texture>();
			t[0]=Assets.getTexture("music");
			t[1]=Assets.getTexture("music_no");
			mcMusic=new BaseMovieClip(t);
			mcMusic.stop();
			mcMusic.x=0;
			mcMusic.y=0;
			addChild(mcMusic);

			mcMusic.onClick=onMusicTriggered;
		}

		private function onMusicTriggered():void
		{
			musicEnabled=!musicEnabled;
		}

		private function addSoundBtn():void
		{
			var t:Vector.<Texture>=new Vector.<Texture>();
			t[0]=Assets.getTexture("sound");
			t[1]=Assets.getTexture("sound_no");
			mcSound=new BaseMovieClip(t);
			mcSound.stop();
			mcSound.x=0;
			mcSound.y=112;
			addChild(mcSound);

			mcSound.onClick=onSoundTriggered;
		}

		private function onSoundTriggered():void
		{
			soundEnabled=!soundEnabled;
		}

		private function addBg():void
		{
			bg=Assets.getImage("soundbg");
			addChild(bg);
		}

		override public function dispose():void
		{
			EventController.e.removeEventListener(SoundEvent.MUSIC_OFF, onMusicOff);
			EventController.e.removeEventListener(SoundEvent.MUSIC_ON, onMusicOn);
			EventController.e.removeEventListener(SoundEvent.SOUND_OFF, onSoundOff);
			EventController.e.removeEventListener(SoundEvent.SOUND_ON, onSoundOn);

			mcMusic.removeEventListener(Event.TRIGGERED, onMusicTriggered);
			mcSound.removeEventListener(Event.TRIGGERED, onSoundTriggered);

			super.dispose();
		}

		private function get musicEnabled():Boolean
		{
			return _musicEnabled;
		}

		private function set musicEnabled(value:Boolean):void
		{
			if (_musicEnabled != value)
			{
				_musicEnabled=value;
				SoundManager.musicEnabled=value;
				// update the button 
				value ? mcMusic.currentFrame=0 : mcMusic.currentFrame=1;
			}
		}

		private function get soundEnabled():Boolean
		{
			return _soundEnabled;
		}

		private function set soundEnabled(value:Boolean):void
		{
			if (_soundEnabled != value)
			{
				_soundEnabled=value;
				SoundManager.soundEnabled=value;
				// update the button 
				value ? mcSound.currentFrame=0 : mcSound.currentFrame=1;
			}
		}
	}
}
