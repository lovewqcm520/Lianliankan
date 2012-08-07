package com.jack.llk.control.events
{

	public class GameEvent extends MyStarlingEvent
	{
		public static const GAME_RESUME:String="game_resume";

		public static const GAME_PAUSE:String="game_pause";

		public static const GAME_RESTART:String="game_restart";

		public static const GAME_NEXT:String="game_next";

		public static const GAME_WIN:String="game_win";

		public static const GAME_LOSE:String="game_lose";
		
		public static const GAME_REFRESH_MAP:String="game_refresh_map";
		
		public static const BATTER:String = "batter";
		
		
		public static const GET_TOOL_TIME:String = 		"get_tool_time";		
		public static const GET_TOOL_EGG:String = 		"get_tool_egg";		
		public static const GET_TOOL_FIND:String = 		"get_tool_find";		
		public static const GET_TOOL_REFRESH:String = 	"get_tool_refresh";		
		public static const GET_TOOL_BOMB:String = 		"get_tool_bomb";
		
		public static const USE_TOOL_FIND:String = 		"use_tool_find";		
		public static const USE_TOOL_REFRESH:String = 	"use_tool_refresh";		
		public static const USE_TOOL_BOMB:String = 		"use_tool_bomb";

		public function GameEvent(type:String, bubbles:Boolean=false, params:Object=null)
		{
			super(type, bubbles, params);
		}
	}
}
