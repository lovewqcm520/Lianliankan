package com.jack.llk.view.button
{
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.deg2rad;

	public class SettingButton extends CommonButton
	{
		public function SettingButton()
		{
			super("setbt");
		}

		override protected function onBtnTriggered(event:Event):void
		{
			// spin the set icon
			var tween:Tween=new Tween(icon, 0.5);
			var oldRotation:Number=icon.rotation;
			var newRotation:Number=oldRotation + deg2rad(360);
			tween.animate("rotation", newRotation);
			Starling.juggler.add(tween);

			super.onBtnTriggered(event);
		}


	}
}
