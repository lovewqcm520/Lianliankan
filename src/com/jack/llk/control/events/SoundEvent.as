package com.jack.llk.control.events
{

	public class SoundEvent extends MyStarlingEvent
	{
		public static const MUSIC_ON:String="music_on";
		public static const MUSIC_OFF:String="music_off";
		public static const SOUND_ON:String="sound_on";
		public static const SOUND_OFF:String="sound_off";

		public function SoundEvent(type:String, params:Object=null, bubbles:Boolean=false)
		{
			super(type, params, bubbles);
		}
	}
}
