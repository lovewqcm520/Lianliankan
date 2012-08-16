package com.jack.llk.control.asset
{
	import com.jack.llk.control.Common;
	import com.jack.llk.vo.RoundVO;
	
	import flash.utils.Dictionary;

	public class Maps
	{
		// map data
		[Embed(source="assets/data/MapProject.xml", mimeType="application/octet-stream")]
		private static const classicMapXml:Class;
		
		private static const dicClassicMapXmls:Dictionary = new Dictionary();
		public static var totalClassicMaps:int;
		
		private static const dicTimeMapXmls:Dictionary = new Dictionary();
		public static var totalTimeMaps:int;
		
		
		public function Maps()
		{
			
		}
		
		public static function init():void
		{
			var xmlList:XMLList;
			// init the classic model map data
			
			var classicXml:XML=XML(new classicMapXml());			
			// get the project base info
			totalClassicMaps = classicXml.attribute("totalMaps");
			// parse the project xml
			xmlList = classicXml.children();				
			for each (var x:XML in xmlList) 
			{
				dicClassicMapXmls[int(x.attribute("level"))] = x;
			}				
			
			// init the time model map data
			
			var timeXml:XML=XML(new classicMapXml());			
			// get the project base info
			totalTimeMaps = timeXml.attribute("totalMaps");
			// parse the project xml
			xmlList = timeXml.children();				
			for each (var x1:XML in xmlList) 
			{
				dicTimeMapXmls[int(x1.attribute("level"))] = x1;
			}	
		}
		
		public static function getClassicRoundAt(level:int):RoundVO
		{
			if(dicClassicMapXmls[level])
			{
				var xml:XML = dicClassicMapXmls[level];
				if(xml)
				{
					var r:RoundVO = new RoundVO(Common.GAME_MODEL_CLASSIC);
					r.importFromXML(xml);
					
					return r;
				}
			}
			
			return null;
		}
		
		public static function getTimeRoundAt(level:int):RoundVO
		{
			if(dicTimeMapXmls[level])
			{
				var xml:XML = dicTimeMapXmls[level];
				if(xml)
				{
					var r:RoundVO = new RoundVO(Common.GAME_MODEL_TIME);
					r.importFromXML(xml);
					
					return r;
				}
			}
			
			return null;
		}
		
		public static function getEndlessRoundAt(level:int):RoundVO
		{
			if(dicTimeMapXmls[level])
			{
				var xml:XML = dicTimeMapXmls[level];
				if(xml)
				{
					var r:RoundVO = new RoundVO(Common.GAME_MODEL_ENDLESS);
					r.importFromXML(xml);
					
					return r;
				}
			}
			
			return null;
		}
	}
}