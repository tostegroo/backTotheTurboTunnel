package game.inputs 
{
	/**
	 * ...
	 * @author eu mesmo
	 */
	public class Input 
	{
		//public properties
		public var name:String = "";
		public var pressFunction:Function ;
		public var releaseFunction:Function;
		public var moveFunction:Function;
		public var inputs:Object;
		public var oneHit:Boolean;
		public var gamepadIndex:int;
		
		//used for calculation
		public var canHit:Boolean = true;
		
		public var useKeyboard:Boolean = true;
		public var useGamepad:Boolean = true;
		public var useMouse:Boolean = true;
		public var useTouch:Boolean = true;
		
		public function Input(
			name:String,
			inputs:Object = null,
			gamepasIndex:int = 0,
			pressFunction:Function = null, 
			releaseFunction:Function = null, 
			moveFunction:Function = null,
			oneHit:Boolean = false
		)
		{
			this.name = name;
			this.pressFunction = pressFunction;
			this.releaseFunction = releaseFunction;
			this.moveFunction = moveFunction;
			this.inputs = inputs;
			this.oneHit = oneHit;
		}
		
	}

}