package com.jack.llk.control.events
{
	public class SoundEvent extends MyStarlingEvent
	{
		public static const MUSIC_ON:String = "music_on";
		public static const MUSIC_OFF:String = "music_off";
		public static const SOUND_ON:String = "sound_on";
		public static const SOUND_OFF:String = "sound_off";
		
		public function SoundEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}