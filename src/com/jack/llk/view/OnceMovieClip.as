package com.jack.llk.view
{
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class OnceMovieClip extends MovieClip
	{
		private var autoDispose:Boolean;
		private var onFinishFunc:Function;
		
		public function OnceMovieClip(textures:Vector.<Texture>, onFinish:Function=null, autoDispose:Boolean=true, fps:Number=12)
		{
			super(textures, fps);
			
			this.onFinishFunc = onFinish;
			this.autoDispose = autoDispose;
			this.loop = false;
			this.addEventListener(Event.COMPLETE, onPlayOnceComplete);
			
			Starling.juggler.add(this);
		}
		
		private function onPlayOnceComplete(event:Event):void
		{
			this.removeEventListener(Event.COMPLETE, onPlayOnceComplete);
			
			if(onFinishFunc != null)
			{
				onFinishFunc.apply();
			}
			if(autoDispose)
			{
				Starling.juggler.remove(this);
				removeFromParent(true);
			}
		}		
		
		override public function dispose():void
		{
			onFinishFunc = null;
			
			super.dispose();
		}
	}
}