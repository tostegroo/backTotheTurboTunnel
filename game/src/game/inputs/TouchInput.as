package game.inputs 
{
	import flash.events.TransformGestureEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	/**
	 * ...
	 * @author eu mesmo
	 */
	public class TouchInput 
	{
		public function TouchInput(stage:*) 
		{
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			
			stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE , onSwipe); 
		}
		
		private function onSwipe (e:TransformGestureEvent):void
		{
			
		}
	}
}