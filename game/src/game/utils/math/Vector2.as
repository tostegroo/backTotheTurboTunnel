package game.utils.math 
{
	import flash.geom.Point;
	
	public class Vector2 
	{
		public var x:Number = 0;
		public var y:Number = 0;
		
		public function Vector2(dx:Number = 0, dy:Number = 0)
		{
			x = dx;
			y = dy;
		}
		
		public function initFromPoint(p:Point):Vector2
		{
			x = p.x;
			y = p.y;
			return this;
		}
		
		public function reset():Vector2 
		{
			x = 0;
			y = 0;
			return this;
		}
		
		public function add(ov:*):Vector2 
		{
			x += ov.x;
			y += ov.y;
			return this;
		}
		
		public function subtract(ov:*):Vector2 
		{
			x -= ov.x;
			y -= ov.y;
			return this;
		}
 
		public function multiply(ov:*):Vector2 
		{
			x *= ov.x;
			y *= ov.y;
			return this;
		}
		
		public function multiplyLength(o:*):Vector2 
		{
			x *= o;
			y *= o;
			return this;
		}
 
		public function divideLength(o:*):Vector2 
		{
			x /= o;
			y /= o;
			return this;
		}
		
		public function give(ov:*):Vector2 
		{
			ov.x = x;
			ov.y = y;
			return this;
		}
		
		public function copy(ov:*):Vector2 
		{
			x = ov.x;
			y = ov.y;
			return this;
		}
		
		public function setAngle(n:Number):Vector2 
		{
			var length:Number = Math.sqrt(x * x + y * y);
			x = Math.cos(n)* length;
			y = Math.sin(n) * length;
			return this;
		}
		
		public function setAngleDeg(n:Number):Vector2
		{
			n *= 0.0174532925;
			var length:Number = Math.sqrt(x * x + y * y);
			x = Math.cos(n)* length;
			y = Math.sin(n) * length;
			return this;
		}
		
		public function rotateBy(n:Number):Vector2 
		{
			var angle:Number = getAngle();
			var length:Number = Math.sqrt(x * x + y * y);
			x = Math.cos(n + angle) * length;
			y = Math.sin(n + angle) * length;
			return this;
		}
		
		public function rotateByDeg(n:Number):Vector2 
		{
			n *= 0.0174532925;
			rotateBy(n);
			return this;
		}
		
		public function normalise(n:Number = 1.0):Vector2 
		{
			normalize(n);
			return this;
		}
		
		public function normalize(n:Number = 1.0):Vector2
		{
			var length:Number = Math.sqrt(x * x + y * y);
			x = (x / length) * n;
			y = (y / length) * n;
			return this;
		}
	
		public function length():Number 
		{
			return (Math.sqrt(x * x + y * y));
		}
		
		public function setLength(newlength:Number):Vector2
		{
			normalize(1);
			x *= newlength;
			y *= newlength;
			return this;
		}
		
		public function getAngle():Number
		{
			return (Math.atan2(y, x));
		}
		
		public function getAngleDeg():Number 
		{
			return (Math.atan2(y, x) * 57.2957);
		}
		
		public function dot(ov:*):Number 
		{
			return (x * ov.x + y * ov.y);
		}
 
		public function clone():Vector2
		{
			return new Vector2(x, y);
		}
		
		public function zero():Vector2
		{
			x = 0;
			y = 0;
			return this;
		}
		
		public function lookAt(ov:*):Vector2
		{
			var vectorToTarget:Vector2 = new Vector2(ov.x - x, ov.y - y);
			setAngle( vectorToTarget.getAngle() );
			return this;
		}
		
		public function minus(ov:*):Vector2 
		{
			return new Vector2( x -= ov.x, y -= ov.y);
		}
		
		public function times(scalar:Number):Vector2 
		{
			return new Vector2(x * scalar, y * scalar);
		}
		
		public function plus(ov:*):Vector2 
		{
			return new Vector2(x -= ov.x, y -= ov.y);
		}
	}
}