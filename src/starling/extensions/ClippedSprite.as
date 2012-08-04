package starling.extensions
{
	import flash.display3D.Context3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.errors.MissingContextError;

	public class ClippedSprite extends Sprite
	{
		private var mClipRect:Rectangle;

		public override function render(support:RenderSupport, alpha:Number):void
		{
			if (mClipRect == null)
				super.render(support, alpha);
			else
			{
				var context:Context3D=Starling.context;
				if (context == null)
					throw new MissingContextError();

				support.finishQuadBatch();
				context.setScissorRectangle(mClipRect);

				super.render(support, alpha);

				support.finishQuadBatch();
				context.setScissorRectangle(null);
			}
		}

		public override function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
		{
			// without a clip rect, the sprite should behave just like before
			if (mClipRect == null)
				return super.hitTest(localPoint, forTouch);

			// on a touch test, invisible or untouchable objects cause the test to fail
			if (forTouch && (!visible || !touchable))
				return null;

			var scale:Number=Starling.current.contentScaleFactor;
			var globalPoint:Point=localToGlobal(localPoint);

			if (mClipRect.contains(globalPoint.x * contentScaleX, globalPoint.y * contentScaleY))
				return super.hitTest(localPoint, forTouch);
			else
				return null;
		}

		public function get clipRect():Rectangle
		{
			var scaleX:Number=contentScaleX;
			var scaleY:Number=contentScaleY;

			return new Rectangle(mClipRect.x / scaleX, mClipRect.y / scaleY, mClipRect.width / scaleX, mClipRect.height / scaleY);
		}

		public function set clipRect(value:Rectangle):void
		{
			var scaleX:Number=contentScaleX;
			var scaleY:Number=contentScaleY;

			if (mClipRect == null)
				mClipRect=new Rectangle();
			mClipRect.setTo(scaleX * value.x, scaleY * value.y, scaleX * value.width, scaleY * value.height);
		}

		private function get contentScaleX():Number
		{
			var currentStarling:Starling=Starling.current;
			return currentStarling.viewPort.width / currentStarling.stage.stageWidth;
		}

		private function get contentScaleY():Number
		{
			var currentStarling:Starling=Starling.current;
			return currentStarling.viewPort.height / currentStarling.stage.stageHeight;
		}
	}
}
