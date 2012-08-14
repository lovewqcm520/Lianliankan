package com.jack.llk.control.asset
{
	import com.jack.llk.vo.RoundVO;
	
	import flash.utils.Dictionary;

	public class Maps
	{
		// map data
		[Embed(source="assets/data/MapProject.xml", mimeType="application/octet-stream")]
		private static const mapsXml:Class;
		
		private static const dicXmls:Dictionary = new Dictionary();
		
		public function Maps()
		{
			
		}
		
		public static function init():void
		{
			var xml:XML=XML(new mapsXml());
			
			// parse the project xml
			var xmlList:XMLList = xml.children();				
			for each (var x:XML in xmlList) 
			{
				dicXmls[int(x.level)] = x;
			}				
		}
		
		public static function getRoundAt(level:int):RoundVO
		{
			if(dicXmls[level])
			{
				var xml:XML = dicXmls[level];
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