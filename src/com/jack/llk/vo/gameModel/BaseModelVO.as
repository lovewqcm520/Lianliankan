package com.jack.llk.vo.gameModel
{
	import com.jack.llk.control.LocalCache;
	import com.jack.llk.vo.ChapterVO;
	
	public class BaseModelVO
	{
		protected var model_type:String;
		public var nLevel:int;		
		public var chapterList:Vector.<ChapterVO>;
		
		public function BaseModelVO(type:String, nLevels:int)
		{
			model_type = type;
			nLevel = nLevels;
		}
		
		/**
		 * Run this init function when user choose some model type game.
		 */
		public function init():void
		{
			// first read from cache, if cache has nothing, init manually
			if(initChapterListFromCache() == false)
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
			if(chapterList && chapterList.length > 0)
				LocalCache.getInstance().addValue(model_type, chapterList);
		}
		
		/**
		 * Call this function when user finish some chaptor under this model to record.
		 * @param level
		 * @param voChapter
		 */
		public function updateAt(level:int, voChapter:ChapterVO):void
		{
			if(chapterList[level-1] != undefined)
			{
				chapterList[level-1] = voChapter;
				// update the sharedobject
				flushToCache();
			}
		}
		
		private function initChapterList():void
		{
			chapterList = new Vector.<ChapterVO>();
			
			var c:ChapterVO;
			for (var i:int = 0; i < nLevel; i++) 
			{
				c = new ChapterVO();
				c.level = i + 1;
//				c.star = 0;
//				// init only first chapter was unlocked
//				c.locked = (i == 0 ? false : true);
				
				// testonly
				c.star = Math.floor(Math.random()*4);
				c.locked = (Math.random() > 0.5);
				chapterList.push(c);				
			}		
			
			flushToCache();
		}
		
		private function initChapterListFromCache():Boolean
		{
			var arr:Vector.<ChapterVO> = LocalCache.getInstance().getValue(model_type) as Vector.<ChapterVO>;
			
			if(arr && arr.length > 0)
			{
				chapterList = arr.concat();
				return true;
			}
			
			return false;
		}
		
	}
}