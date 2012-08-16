package com.jack.llk.control
{

	public class Common
	{
		public static const MAIN_SHAREDOBJECT:String="llkGame";
		public static const CACHE_SOUND:String="sound";
		public static const CACHE_MUSIC:String="music";
		public static const CACHE_CLASSIC_MODEL:String="classic_model";
		public static const CACHE_TIME_MODEL:String="time_model";
		public static const CACHE_ENDLESS_MODEL:String="endless_model";

		public static const DEFAULT_WIDTH:Number=480;
		public static const DEFAULT_HEIGHT:Number=800;

		public static const ITEM_SCORE:int = 10;
		public static const BATTER_SCORE:int = 5;
		
		// when get a time tool, user get more 5 seconds game time
		public static const TOOL_TIME_ADD:Number=5;
		public static const CLASSIC_ADD_TIME:Number = 1;
		public static const TIME_ADD_TIME:Number = 1;
		
		public static const GAME_MODEL_CLASSIC:int = 1;
		public static const GAME_MODEL_TIME:int = 2;
		public static const GAME_MODEL_ENDLESS:int = 3;
		
		public static const ITEM_SMALL_WIDTH:Number=54;
		public static const ITEM_SMALL_HEIGHT:Number=57;
		public static const ITEM_BIG_WIDTH:Number=81;
		public static const ITEM_BIG_HEIGHT:Number=86;
		
		public static const TIME_MODEL_TIMES:Array = [];
		public static const ENDLESS_MODEL_TIME:int = 40;
		
		public static function init():void
		{
			TIME_MODEL_TIMES[0] = 20;
			TIME_MODEL_TIMES[1] = 20;
			TIME_MODEL_TIMES[2] = 20;
			TIME_MODEL_TIMES[3] = 25;
			TIME_MODEL_TIMES[4] = 25;
			TIME_MODEL_TIMES[5] = 25;
			TIME_MODEL_TIMES[6] = 25;
			TIME_MODEL_TIMES[7] = 30;
			TIME_MODEL_TIMES[8] = 30;
			TIME_MODEL_TIMES[9] = 30;
			TIME_MODEL_TIMES[10] = 30;
			TIME_MODEL_TIMES[11] = 35;
			TIME_MODEL_TIMES[12] = 35;
			TIME_MODEL_TIMES[13] = 35;
			TIME_MODEL_TIMES[14] = 35;
			TIME_MODEL_TIMES[15] = 35;
			TIME_MODEL_TIMES[16] = 35;
			TIME_MODEL_TIMES[17] = 40;
			TIME_MODEL_TIMES[18] = 40;
			TIME_MODEL_TIMES[19] = 40;
			TIME_MODEL_TIMES[20] = 45;
			TIME_MODEL_TIMES[21] = 45;
			TIME_MODEL_TIMES[22] = 45;
			TIME_MODEL_TIMES[23] = 45;
			TIME_MODEL_TIMES[24] = 40;
			TIME_MODEL_TIMES[25] = 40;
			TIME_MODEL_TIMES[26] = 35;
			TIME_MODEL_TIMES[27] = 35;
			TIME_MODEL_TIMES[28] = 30;
			TIME_MODEL_TIMES[29] = 30;
		}
	}
}
