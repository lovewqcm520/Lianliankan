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
		
		public static const BATTER:String = "batter";

		public function GameEvent(type:String, bubbles:Boolean=false, params:Object=null)
		{
			super(type, bubbles, params);
		}
	}
}
