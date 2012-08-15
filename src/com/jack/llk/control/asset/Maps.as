package com.jack.llk.control.asset
{
	import com.jack.llk.vo.RoundVO;
	
	import flash.utils.Dictionary;

	public class Maps
	{
		// map data
		[Embed(source="assets/data/MapProject.xml", mimeType="application/octet-stream")]
		private static const classicMapXml:Class;
		
		private static const dicClassicMapXmls:Dictionary = new Dictionary();
		public static var totalClassicMaps:int;
		
		private static var projectName:String;
		private static var maxMapCol:int;
		private static var maxMapRow:int;
		
		public function Maps()
		{
			
		}
		
		public static function init():void
		{
			// init the classic model map data
			
			var xml:XML=XML(new classicMapXml());			
			// get the project base info
			projectName = 		xml.attribute("name");
			totalClassicMaps = xml.attribute("totalMaps");
			maxMapCol = xml.attribute("maxMapCol");
			maxMapRow = xml.attribute("maxMapRow");			
			// parse the project xml
			var xmlList:XMLList = xml.children();				
			for each (var x:XML in xmlList) 
			{
				dicClassicMapXmls[int(x.attribute("level"))] = x;
			}				
			
			// init the time model map data
		}
		
		public static function getClassicRoundAt(level:int):RoundVO
		{
			if(dicClassicMapXmls[level])
			{
				var xml:XML = dicClassicMapXmls[level];
				if(xml)
				{
					var r:RoundVO = new RoundVO();
					r.importFromXML(xml);
					
					return r;
				}
			}
			
			return null;
		}
	}
}