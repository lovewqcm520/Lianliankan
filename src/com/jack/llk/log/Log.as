package com.jack.llk.log
{

	public class Log
	{
		public static const LEVEL_ERROR:int=1;
		public static const LEVEL_WARNING:int=2;
		public static const LEVEL_INFO:int=3;
		public static const LEVEL_ALL:int=3;
		public static const LEVEL_NONE:int=-1;
		private static var stc_stackCache:Object={};
		private static var TRACE_DEFAULT_LEVEL:int=3;
		private static var TRACE_SECTIONS:Object;

		public function Log()
		{
		}

		public static function traced(... args):void
		{
			//return;
			var str:String="";
			for (var i:int=0; i < args.length; i++)
			{
				str+=(args[i] + "  ");
			}

			trace("**TRACE**  " + str);
		}

		public static function error(param1:String, param2:*=null):void
		{
			//return;
			logByLevel(LEVEL_ERROR, param1, param2);
		}

		public static function warning(param1:String, param2:*):void
		{
			//return;
			logByLevel(LEVEL_WARNING, param1, param2);
		}

		public static function log(param1:String, param2:*=null):void
		{
			//return;
			logByLevel(LEVEL_INFO, param1, param2);
		}

		public static function info(param1:String, param2:*):void
		{
			//return;
			logByLevel(LEVEL_INFO, param1, param2);
		}

		private static function logByLevel(param1:int, param2:String, param3:*=null):void
		{
			//hardcode
			//return;

			var _loc_4:Object=null;
			var _loc_5:int=0;
			var _loc_6:String=null;
			
			if(param3 == null)	param3 = "";

			if (param2 == null || param1 <= LEVEL_WARNING)
			{
				_loc_4=computeSectionFromStack();
			}
			if (param2 == null)
			{
				param2=_loc_4.sectionName;
			}
			_loc_5=TRACE_DEFAULT_LEVEL;
			if (TRACE_SECTIONS != null && param1 >= LEVEL_INFO)
			{
				if (TRACE_SECTIONS.hasOwnProperty(param2))
				{
					_loc_5=TRACE_SECTIONS[param2];
				}
			}
			if (param1 <= _loc_5)
			{
				
				var clsName:String;
				if (param3)
				{
					clsName=Reflection.getClassName(param3);
					_loc_6="" + dateToShortTime(new Date()) + " " + param2 + ": ";
				}
				else
				{
					_loc_6="" + dateToShortTime(new Date()) + " " + param2;
					clsName="";
				}
				if (LEVEL_ERROR == param1)
				{
					_loc_6=_loc_6 + ("**ERROR** " + param3 + "\r\n" + _loc_4.stackTrace);
				}
				else if (LEVEL_WARNING == param1)
				{
					_loc_6=_loc_6 + ("**WARNING** " + param3);
				}
				else
				{
					_loc_6=_loc_6 + param3;
				}
				trace(_loc_6);
			}
		}

		public static function dateToShortTime(param1:Date):String
		{
			var _loc_2:*=param1.getHours();
			var _loc_3:*=param1.getMinutes();
			var _loc_4:*=param1.getSeconds();
			var _loc_5:*=new String();
			if (_loc_2 < 10)
			{
				_loc_5=_loc_5 + "0";
			}
			_loc_5=_loc_5 + _loc_2;
			_loc_5=_loc_5 + ":";
			if (_loc_3 < 10)
			{
				_loc_5=_loc_5 + "0";
			}
			_loc_5=_loc_5 + _loc_3;
			_loc_5=_loc_5 + ":";
			if (_loc_4 < 10)
			{
				_loc_5=_loc_5 + "0";
			}
			_loc_5=_loc_5 + _loc_4;
			return _loc_5;
		}


		private static function computeSectionFromStack():Object
		{
			var _loc_5:Object=null;
			var _loc_6:Array=null;
			var _loc_7:String=null;
			var _loc_8:String=null;
			var _loc_9:Array=null;
			var _loc_10:int=0;
			var _loc_11:RegExp=null;
			var _loc_12:Object=null;
			var _loc_1:String=null;
			var _loc_2:Object={stackTrace: "", rawLine: "", packageName: "", className: "", methodName: "<unknown>", fileName: "", lineNumber: 0};
			var _loc_3:*=new Error();
			var _loc_4:int=5;
			_loc_1=_loc_3.getStackTrace();
			if (_loc_1 != null && _loc_1 != "")
			{
				_loc_5=stc_stackCache[_loc_1];
				if (_loc_5 == null)
				{
					_loc_6=_loc_1.split("\n");
					if (_loc_6.length >= _loc_4)
					{
						_loc_2.stackTrace=_loc_6.slice((_loc_4 - 1)).join("\r\n");
						_loc_7=String(_loc_6[(_loc_4 - 1)]);
						_loc_2.rawLine=StringUtil.ltrim(_loc_7);
						_loc_8=_loc_7.substring(4, _loc_7.indexOf("()", 4));
						_loc_10=_loc_8.indexOf("::");
						if (_loc_10 != -1)
						{
							_loc_2.packageName=_loc_8.substr(0, _loc_10);
							_loc_8=_loc_8.substr(_loc_10 + 2);
						}
						_loc_11=/\[(.*):(\d+)\]/i;
						_loc_12=_loc_11.exec(_loc_7);
						if (_loc_12)
						{
							_loc_2.fileName=_loc_12[1];
							_loc_2.lineNumber=_loc_12[2];
						}
						if (_loc_8.indexOf("$/") != -1)
						{
							_loc_9=_loc_8.split("$/", 2);
							_loc_2.className=_loc_9[0];
							_loc_2.methodName=_loc_9[1];
						}
						else
						{
							_loc_10=_loc_8.indexOf("/");
							if (_loc_10 != -1)
							{
								_loc_9=_loc_8.split("/", 2);
								_loc_2.className=_loc_9[0];
								_loc_2.methodName=_loc_9[1];
							}
							else
							{
								_loc_2.className=_loc_8;
								_loc_2.methodName="ctor";
							}
						}
					}
					if (_loc_2.className == "global")
					{
						_loc_2.sectionName=_loc_2.methodName;
					}
					else
					{
						_loc_2.sectionName=_loc_2.className;
					}
					stc_stackCache[_loc_1]=_loc_2;
				}
				else
				{
					_loc_2=_loc_5;
				}
			}
			return _loc_2;
		}



	}
}

