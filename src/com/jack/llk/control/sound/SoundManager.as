package com.jack.llk.control.sound
{
	import com.jack.llk.control.Common;
	import com.jack.llk.control.LocalCache;

	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Dictionary;

	public class SoundManager
	{
		// sounds		
		[Embed(source="assets/sounds/THUNDER.mp3")]
		private static const THUNDER:Class;

		[Embed(source="assets/sounds/XIAO_CHU_MUSIC.mp3")]
		private static const XIAO_CHU_MUSIC:Class;

		[Embed(source="assets/sounds/SHUA_XIN_MUSIC.mp3")]
		private static const SHUA_XIN_MUSIC:Class;

		[Embed(source="assets/sounds/DAO_JU_MUSIC.mp3")]
		private static const DAO_JU_MUSIC:Class;

		[Embed(source="assets/sounds/DAO_JI_SHI_MUSIC.mp3")]
		private static const DAO_JI_SHI_MUSIC:Class;

		[Embed(source="assets/sounds/DATING_BACK_MUSIC.mp3")]
		private static const DATING_BACK_MUSIC:Class;

		[Embed(source="assets/sounds/JI_SHOU_MUSIC.mp3")]
		private static const JI_SHOU_MUSIC:Class;

		[Embed(source="assets/sounds/AN_NIU_MUSIC.mp3")]
		private static const AN_NIU_MUSIC:Class;

		[Embed(source="assets/sounds/DIAN_JI_MUSIC.mp3")]
		private static const DIAN_JI_MUSIC:Class;

		[Embed(source="assets/sounds/GAME_BACK_MUSIC.mp3")]
		private static const GAME_BACK_MUSIC:Class;

		[Embed(source="assets/sounds/ZHA_DAN_MUSIC.mp3")]
		private static const ZHA_DAN_MUSIC:Class;

		[Embed(source="assets/sounds/WIN_BACK_MUSIC.mp3")]
		private static const WIN_BACK_MUSIC:Class;

		[Embed(source="assets/sounds/READY_GO_MUSIC.mp3")]
		private static const READY_GO_MUSIC:Class;

		[Embed(source="assets/sounds/LOST_BACK_MUSIC.mp3")]
		private static const LOST_BACK_MUSIC:Class;


		private static var mSoundDic:Dictionary=new Dictionary();
		private static var lastPlayMusicName:String;
		private static var lastPlaySoundName:String;

		private static var _musicEnabled:Boolean;
		private static var _soundEnabled:Boolean;

		public static function readSettingFromCache():void
		{
			var m:*=LocalCache.getInstance().getValue(Common.CACHE_MUSIC);
			var s:*=LocalCache.getInstance().getValue(Common.CACHE_SOUND);

			m == undefined ? musicEnabled=true : musicEnabled=m;
			s == undefined ? soundEnabled=true : soundEnabled=s;
		}

		/**
		 * 播放声音
		 * @param name
		 * @param isMusic 是否是游戏背景音乐
		 * @param loop	是否循环播放
		 */
		public static function play(name:String, isMusic:Boolean=false, loop:Boolean=false):void
		{
			// testonly
			//return;

			if (!name)
				return;

			// stop old music before play a new music
			if (isMusic)
				muteMusic();

			// record the music play 
			isMusic ? lastPlayMusicName=name : lastPlaySoundName=name;

			if (mSoundDic[name] == undefined)
			{
				if (SoundManager[name])
				{
					var sound:Sound=new SoundManager[name]() as Sound;
					var vo:SoundVO=new SoundVO();
					vo.sound=sound;
				}
			}

			if (isMusic && !musicEnabled)
				return;
			if (!isMusic && !soundEnabled)
				return;

			var nLoop:int=loop ? int.MAX_VALUE : 1;

			if (sound)
			{
				var soundChannel:SoundChannel=sound.play(0, nLoop);
				vo.channel=soundChannel;
				mSoundDic[name]=vo;
			}
			else
			{
				vo=SoundVO(mSoundDic[name]);
				vo.channel=vo.sound.play(0, nLoop);
			}
		}

		public static function stop(name:String):void
		{
			if (mSoundDic[name] != undefined)
			{
				var vo:SoundVO=mSoundDic[name];
				if (vo)
				{
					vo.sound.isBuffering ? vo.sound.close() : null;
					vo.channel.stop();
				}
			}
		}

		public static function muteSound():void
		{
			var vo:SoundVO=SoundVO(mSoundDic[lastPlaySoundName]);
			if (vo)
			{
				vo.sound.isBuffering ? vo.sound.close() : null;
				vo.channel.stop();
			}
		}

		public static function muteAll():void
		{
			var vo:SoundVO;
			for each (vo in mSoundDic)
			{
				if (vo)
				{
					vo.sound.isBuffering ? vo.sound.close() : null;
					vo.channel ? vo.channel.stop() : null;
				}
			}
		}

		public static function muteMusic():void
		{
			var vo:SoundVO=SoundVO(mSoundDic[lastPlayMusicName]);
			if (vo)
			{
				vo.sound.isBuffering ? vo.sound.close() : null;
				vo.channel.stop();
			}
		}

		public static function resumeMusic():void
		{
			// only resume background music
			// play music in infinite loop			
			play(lastPlayMusicName, true, true);
		}

		public static function get musicEnabled():Boolean
		{
			return _musicEnabled;
		}

		public static function set musicEnabled(value:Boolean):void
		{
			if (_musicEnabled != value)
			{
				_musicEnabled=value;

				value ? resumeMusic() : muteMusic();
				// flush data to local shared object
				LocalCache.getInstance().addValue(Common.CACHE_MUSIC, value);
			}

			_musicEnabled=value;
		}

		public static function get soundEnabled():Boolean
		{
			return _soundEnabled;
		}

		public static function set soundEnabled(value:Boolean):void
		{
			if (_soundEnabled != value)
			{
				_soundEnabled=value;

				value ? null : muteSound();
				// flush data to local shared object
				LocalCache.getInstance().addValue(Common.CACHE_SOUND, value);
			}

			_soundEnabled=value;
		}

	}
}
import flash.media.Sound;
import flash.media.SoundChannel;


class SoundVO
{
	public var sound:Sound;
	public var channel:SoundChannel;

	public function SoundVO()
	{
	}
}
