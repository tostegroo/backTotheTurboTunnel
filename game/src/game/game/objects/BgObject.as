package game.game.objects 
{
	import starling.display.Image;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author ...
	 */
	public class BgObject extends Image 
	{
		public var index:int = 0;
		public var canUpdate:Boolean = true;
		public var yVariation:Number = 0;
		public var xVariation:Number = 0;
		public var random:Boolean = false;
		public var scale:Number = 0;
		public var xPivot:Number = 0;
		public var yPivot:Number = 0;
		public var yPos:Number = 0;
		
		public function BgObject(imageTexture:Texture) 
		{
			super(imageTexture);
		}
		
		public function setPivotY(value:Number):BgObject
		{
			yPivot = value;
			return this;
		}
		public function setPivotX(value:Number):BgObject
		{
			xPivot = value;
			return this;
		}
		public function setScale(value:Number):BgObject
		{
			scale = value;
			return this;
		}
		public function setY(value:Number):BgObject
		{
			yPos = value;
			return this;
		}
		public function setyVariation(value:Number):BgObject
		{
			yVariation = value;
			return this;
		}
		public function setxVariation(value:Number):BgObject
		{
			xVariation = value;
			return this;
		}
		public function setRandon(value:Boolean):BgObject
		{
			random = value;
			return this;
		}
	}
}