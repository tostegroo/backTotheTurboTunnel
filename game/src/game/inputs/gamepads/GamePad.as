package game.inputs.gamepads 
{
	import com.stackandheap.ane.joystick.JoystickCapabilities;
	
	/**
	 * ...
	 * @author Fabio Toste
	 */
	public class GamePad 
	{
		public var name:String;
		public var manufacturerID:int;
		public var productID:int;
		public var numAxes:int;
		public var numButtons:int;
		public var minR:Number;
		public var maxR:Number;
		public var minU:Number;
		public var maxU:Number;
		public var minV:Number;
		public var maxV:Number;
		public var minX:Number;
		public var maxX:Number;
		public var minY:Number;
		public var maxY:Number;
		public var minZ:Number;
		public var maxZ:Number;
		
		public var useStickAsPOV:Boolean = true;
		public var stickPOVTolerance:Number = 0.7;
		
		public var button:Array = [];
		public var axis:Array = [];
		public var axixDeadZone:Vector.<Number> = new Vector.<Number>();
		
		public function GamePad(capabilities:JoystickCapabilities) 
		{
			name = capabilities.productName;
			manufacturerID = capabilities.manufacturerID;
			productID = capabilities.productID;
			minR = capabilities.minR; 
			maxR = capabilities.maxR;
			minU = capabilities.minU; 
			maxU = capabilities.maxU;
			minV = capabilities.minV; 
			maxV = capabilities.maxV;
			minX = capabilities.minX; 
			maxX = capabilities.maxX;
			minY = capabilities.minY; 
			maxY = capabilities.maxY;
			minZ = capabilities.minZ; 
			maxZ = capabilities.maxZ;
			numAxes = capabilities.numAxes;
			numButtons = capabilities.numButtons;
			
			var i:int;
			for (i = 0; i < numAxes; i++) 
			{
				axixDeadZone.push(0.1);
				axis[i] = null;
			}
			for (i = 0; i < numButtons; i++) 
			{
				button[i] = null;
			}
		}
		
	}

}