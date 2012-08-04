package com.jack.llk.control
{
	import com.jack.llk.log.Log;
	
	import flash.net.SharedObject;

	/**
	 * key				value
	 * sound			true/false
	 * music			true/false
	 *
	 * @author Jack
	 */
	public class LocalCache
	{
		private var cache:SharedObject;
		private static var _instance:LocalCache;

		public function LocalCache(singletonEnforcer:SingletonEnforcer)
		{
			if (singletonEnforcer == null)
			{
				throw new Error("singletonEnforcer");
			}
			else
			{
				cache=SharedObject.getLocal(Constant.MAIN_SHAREDOBJECT);
			}
		}

		public static function getInstance():LocalCache
		{
			if (LocalCache._instance == null)
			{
				LocalCache._instance=new LocalCache(new SingletonEnforcer());
			}

			return LocalCache._instance;
		}

		public function addValue(key:String, value:Object):void
		{
			cache.data[key]=value;
			cache.flush();
			
			Log.traced("Local SharedObject Flush", key, value.toString());
		}

		public function getValue(key:String):*
		{
			if(cache.data[key])
				Log.traced("Local SharedObject Get", key, cache.data[key].toString());
			
			return cache.data[key];			
		}

		public function clear():void
		{
			cache.clear();
		}
	}
}


class SingletonEnforcer
{
}
