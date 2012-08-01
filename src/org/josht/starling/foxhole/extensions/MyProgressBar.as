package org.josht.starling.foxhole.extensions
{
	import org.josht.starling.foxhole.controls.ProgressBar;
	
	public class MyProgressBar extends ProgressBar
	{
		private var onProgressFunc:Function;
		private var onFinishFunc:Function;
		
		public function MyProgressBar()
		{
			super();
		}
		
		public function set onProgress(func:Function):void
		{			
			if(onProgressFunc != func)
				onProgressFunc = func;
		}
		
		public function set onFinish(func:Function):void
		{			
			if(onFinishFunc != func)
				onFinishFunc = func;
		}
		
		override public function set value(newValue:Number):void
		{
			// TODO Auto Generated method stub
			super.value = newValue;
			
			// call the function 
			if(onProgressFunc != null)
				onProgressFunc.apply();
			
			// if progress finished
			if(this.value == 1)
			{
				if(onFinishFunc != null)
					onFinishFunc.apply();
			}				
		}
		
		override public function dispose():void
		{
			onProgressFunc = null;
			onFinishFunc = null;
			
			super.dispose();
		}
	}
}