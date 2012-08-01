package com.jack.llk.view.button
{
	import com.jack.llk.control.asset.Assets;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class CommonButton extends BaseButton
	{
		protected var icon:Image;
		private var iconTextureName:String;
		
		public function CommonButton(iconTextureName:String)
		{
			var upState:Texture = Assets.getTexture("bticonbg");
			var text:String = "";
			var downState:Texture = Assets.getTexture("bticonbged");
			super(upState, text, downState);
			
			this.iconTextureName = iconTextureName;
			initialize();			
		}
		
		private function initialize():void
		{
			icon = Assets.getImage(iconTextureName);
			icon.pivotX = icon.width/2;
			icon.pivotY = icon.height/2;
			
			icon.x = width/2/this.scaleX;
			icon.y = height/2/this.scaleY;;
			addChild(icon);			
		}
		
	}
}