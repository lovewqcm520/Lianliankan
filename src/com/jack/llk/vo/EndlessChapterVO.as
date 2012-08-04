package com.jack.llk.vo
{
	import com.jack.llk.vo.map.EndlessModeMapVO;

	public class EndlessChapterVO
	{
		public var level:int;
		public var chapterTime:Number;
		public var refreshTool:int;
		public var bombTool:int;
		public var findTool:int;
		public var finalScores:int;
		public var finalBatter:int;
		public var useTime:Number;
		public var isWin:Boolean;
		public var isFinished:Boolean;

		public var voMap:EndlessModeMapVO;

		public function EndlessChapterVO()
		{
		}

		public function importFrom():void
		{

		}


	}
}
