package com.jack.llk.log
{

	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;

	public class Reflection
	{

		public static function createDisplayObjectInstance(fullClassName:String, applicationDomain:ApplicationDomain=null):DisplayObject
		{
			return createInstance(fullClassName, applicationDomain) as DisplayObject;
		}

		public static function createInstance(fullClassName:String, applicationDomain:ApplicationDomain=null):*
		{
			var assetClass:Class=getClass(fullClassName, applicationDomain);
			if (assetClass != null)
			{
				return new assetClass();
			}
			return null;
		}

		public static function getClass(fullClassName:String, applicationDomain:ApplicationDomain=null):Class
		{
			if (applicationDomain == null)
			{
				applicationDomain=ApplicationDomain.currentDomain;
			}
			var assetClass:Class=applicationDomain.getDefinition(fullClassName) as Class;
			return assetClass;
		}

		public static function getFullClassName(o:*):String
		{
			return getQualifiedClassName(o);
		}

		public static function getClassName(o:*):String
		{
			//hardcode
			//return "";
			var tmpName:String=getQualifiedClassName(o);
			var lastI:int=tmpName.lastIndexOf(".");
			if (lastI >= 0)
			{
				tmpName=tmpName.substr(lastI + 1);
			}
			return tmpName;
		}

		public static function getPackageName(o:*):String
		{
			var name:String=getFullClassName(o);
			var lastI:int=name.lastIndexOf(".");
			if (lastI >= 0)
			{
				return name.substring(0, lastI);
			}
			else
			{
				return "";
			}
		}
	}

}


