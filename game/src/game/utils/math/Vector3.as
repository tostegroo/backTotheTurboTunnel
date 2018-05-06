package game.utils.math 
{
	import flash.geom.Vector3D;
	public class Vector3: Vector3D
	{
		public var x:Number = 0;
		public var y:Number = 0;
		public var z:Number = 0;
		
		public function Vector3(x:Number = 0, y:Number = 0, z:Number = 0) 
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
	}
}