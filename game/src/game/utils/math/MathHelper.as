package game.utils.math 
{
	import flash.geom.Point;
	import starling.display.Quad;
	/**
	 * ...
	 * @author Fabio Toste
	 */
	public final class MathHelper
    {
		public static function intersectsSAT(targetA:Quad, targetB:Quad):Boolean
		{
			var A:Point = new Point(Math.cos(targetA.rotation), Math.sin(targetA.rotation));  // axis2= (-axis1.y,axis1.x)
			var B:Point = new Point(Math.cos(targetB.rotation), Math.sin(targetB.rotation)); // axis2= (-axis1.y,axis1.x)
			
			var pntA:Point = targetA.localToGlobal(new Point(targetA.x, targetA.y));
			var pntB:Point = targetB.localToGlobal(new Point(targetB.x, targetB.y));
			
			var D:Point = new Point(pntB.x - pntA.x, pntB.y - pntA.y);
			var AbsAdB:Vector.<Number> = new Vector.<Number>(4, true);
			
			//trace(D.x, D.y);
			
			// axis C0+t*A0 (proj B onto Ax axis)  =>  w0 + proj(B->A0)  =>  w0 + A0*B0 + A0*B1
			AbsAdB[0] = Math.abs(A.x * B.x + A.y * B.y); //A0*B0
			AbsAdB[1] = Math.abs(A.x * -B.y + A.y * B.x); //A0*B1
			
			if (Math.abs( -A.y * D.x + A.x * D.y) * 2 > targetA.absoluteWidth + targetB.absoluteWidth * AbsAdB[0] + targetB.absoluteHeight * AbsAdB[1]) return false;
			
			// axis C0+t*A1 (proj B onto Ay axis)  => h0 + proj(B->A1)  =>  h0 + A1*B0 + A1*B1
			AbsAdB[2] = Math.abs( -A.y * B.x + A.x * B.y); // A1*B0 
			AbsAdB[3] = AbsAdB[0]; //A1*B1 = -Ay*-By + Ax*Bx
			
			if (Math.abs(A.x * D.x + A.y * D.y) * 2 > targetA.absoluteHeight + targetB.absoluteWidth * AbsAdB[2] + targetB.absoluteHeight * AbsAdB[3]) return false;
			
			// axis C0+t*B0 (proj A onto Bx axis)   => w1 + proj(A->B0)  =>  w1 + B0*A0 + B0*A1
			if (Math.abs( -B.y * D.x + B.x * D.y) * 2 > targetB.absoluteWidth + targetA.absoluteWidth * AbsAdB[0] + targetA.absoluteHeight * AbsAdB[2]) return false;
			
			// axis C0+t*B1 (proj A onto By axis)   => h1 + proj(A->B1)  => h1 + B1*A0 + B1*A1
			if (Math.abs(B.x * D.x + B.y * D.y) * 2 > targetB.absoluteHeight + targetA.absoluteWidth * AbsAdB[1] + targetA.absoluteHeight * AbsAdB[3]) return false;
			
			return true;
		}
		
		public static function analogicToDigital(value:Number, tolerance:Number):int
		{
			value = percentageFit(value, tolerance, 1);
			return (value == 0) ? 0 : (value > 0) ? 1 : -1;
		}
		
		public static function percentageFit(value:Number, from:Number, to:Number):Number
		{
			var signal:int = (value > 0) ? 1 : -1;
			value = Math.abs(value);
			var returnValue:Number = value-from;
			var fitValue:Number = to-from;
			returnValue  = (returnValue <0) ? 0 : returnValue;
			returnValue  = (returnValue > fitValue ) ? fitValue  : returnValue;
			returnValue  = returnValue / fitValue;
			return returnValue * signal;
		}
		
		public static function radToDeg(radian:Number):Number
		{
			return radian / Math.PI * 180;
		}
		
		public static function degToRad(degree:Number):Number
		{
			return degree / 180 * Math.PI;
		}
		
		public static function ease( origin:Number, target:Number, speed:Number ):Number
		{
			return ( origin - target ) / speed;
		}
		
		public static function dist1D( startPosition:Number, endPosition:Number ):Number
		{
			return Math.sqrt( Math.abs( startPosition - endPosition ) );
		}
		
		public static function dist2D( startPositionX:int, startPositionY:int, endPositionX:int, endPositionY:int ):Number
		{
			var dirX:Number = startPositionX - endPositionX;
			var dirY:Number = startPositionY - endPositionY;
			return Math.sqrt( dirX * dirX + dirY * dirY );
		}
		
		public static function average( ... nums ):Number
		{
			var total:int = nums.length;
			var sum:Number = 0;
			var i:int = 0;
			while( i < total )
			{
				sum += nums[i];
				i++;
			}
			return sum / total;                   
		}

		public static function smoothAverage( number:Number, number2:Number, speed:Number = 0.5 ):Number
		{
			var sinSpeed:Number = Math.sin( number ) * ( speed );
			var cosSpeed:Number = Math.cos( number ) * ( speed );
			var sin:Number = Math.sin( number2 ) * ( 1 - speed );
			var cos:Number = Math.sin( number2 ) * ( 1 - speed );
			return Math.atan2( sinSpeed + sin, cosSpeed + cos );
		}

		public static function lerp( delta:Number, from:int, to:int ):int
		{
			if ( delta > 1 ) { return to; }
			if ( delta < 0 ) { return from; }
			return from + ( to - from ) * delta;
		}
		
		public static function clamp( value:Number, min:Number, max:Number ):Number
		{
			return Math.max( min, Math.min( max, value ) );
		}
		
		public static function clampNum( value:Number ):Number
		{
			return clamp( value, 0, 1 );
		}
		
		public static function rand( min:Number, max:Number ):Number
		{
			return min + ( max - min ) * Math.random();
		}
		
		public static function approach( current:Number, target:Number, increment:Number ):Number
		{
			increment = Math.abs( increment );
			if ( current < target )
			{
				return clamp( current + increment, current, target );
			}
			else if ( current > target )
			{
				return clamp( current - increment, target, current );
			}
			return target;
		}
		
		public static function isBetween( number:Number, min:Number, max:Number ):Boolean
		{
			return number >= min && number <= max;
		}
		
		public static function vectorRand():Point
		{
			return new Point( rand( -1, 1 ), rand( -1, 1 ) );
		}
			
		public static function fit( value:Number, valueMin:Number, valueMax:Number, outMin:Number, outMax:Number ):Number
		{
			return ( value - valueMin ) * ( outMax - outMin ) / ( valueMax - valueMin ) + outMin;
		}
		
		public static function toFixed( value:Number, factor:int ):Number
		{
			return Math.round( value * factor ) / factor;
		}
    }
}