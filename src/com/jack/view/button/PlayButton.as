package com.jack.view.button
{
	import com.jack.control.asset.Assets;
	
	import starling.textures.Texture;
	
	public class PlayButton extends BaseButton
	{
		public function PlayButton(eventType:String=null, eventData:Object=null)
		{
			var upState:Texture = Assets.getTexture("bigplaybt");
			var text:String="";
			var downState:Texture = Assets.getTexture("bigplaybted");
			
			super(upState, text, downState, eventType, eventData);
		}
	}
}