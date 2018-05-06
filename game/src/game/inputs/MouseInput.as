package game.inputs 
{
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author eu mesmo
	 */
	public class MouseInput 
	{
		public var button:Array = [];
		public var wheel:Number = 0;
		public var axis:Array = [];
		
		public function MouseInput(stage:*) 
		{
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, on_Wheel);
		}
		
		private function on_Wheel(e:MouseEvent):void 
		{
			wheel = e.delta;
		}
		
		public function clearAllInputs():void
		{
			wheel = 0;
		}
	}
}