package com.jack.llk.vo.model
{
	import com.jack.llk.control.Constant;
	import com.jack.llk.control.LocalCache;
	import com.jack.llk.vo.EndlessModelRecordVO;

	public class EndlessModelVO
	{
		private var voRecord:EndlessModelRecordVO;
		private static var _instance:EndlessModelVO;	
		
		private var allLevelScors:int=0;
		private var curMaxLevel:int=0;
		private var tmpLevel:int=-1;
		private var tmpScore:int=-1;
		
		public function EndlessModelVO()
		{

		}
		
		public static function getInstance():EndlessModelVO
		{
			if(!_instance)
				_instance = new EndlessModelVO();
			
			return _instance;
		}
		
		/**
		 * Run this init function when user choose some model type game.
		 */
		public function init():void
		{
			allLevelScors = 0;
			// first read from cache, if cache has nothing, init manually
			if (initFromCache() == false)
			{
				initChapterList();
			}
		}

		/**
		 * Flush the data to local shared object
		 */
		public function flushToCache():void
		{
			// flush the data to local shared object
			voRecord.maxScore = allLevelScors > voRecord.maxScore ? allLevelScors : voRecord.maxScore;
			voRecord.maxLevel = curMaxLevel > voRecord.maxLevel ? curMaxLevel : voRecord.maxLevel;
			LocalCache.getInstance().addValue(Constant.CACHE_ENDLESS_MODEL, voRecord);
		}

		public function get maxLevel():int
		{
			return voRecord.maxLevel;
		}

		public function get maxScore():int
		{
			return voRecord.maxScore;
		}
		
		public function set maxLevel(value:int):void
		{
			curMaxLevel = value;
		}
		
		public function addScores(level:int, score:int):void
		{
			if(tmpLevel != level)
			{
				allLevelScors += score;
				tmpLevel = level;
			}
			else
			{
				allLevelScors -= tmpScore;
				allLevelScors += Math.max(tmpScore, score);
			}
			
			tmpScore = score;
		}

		private function initChapterList():void
		{
			voRecord=new EndlessModelRecordVO();
		}

		private function initFromCache():Boolean
		{
			var v:EndlessModelRecordVO=LocalCache.getInstance().getValue(Constant.CACHE_ENDLESS_MODEL) as EndlessModelRecordVO;

			if (v)
			{
				voRecord=v;
				return true;
			}

			return false;
		}
	}
}
