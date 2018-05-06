package game.inputs 
{
	
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author eu mesmo
	 */
	public class KeyboardInput
	{
		public var key:Array = [];
		private var stage:Stage;
		public var backFunction:Function = null;
		public var menuFunction:Function = null;
		public var searchFunction:Function = null;
		
		public function KeyboardInput(stage:*)
		{
			this.stage = stage;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, on_Press);
			stage.addEventListener(KeyboardEvent.KEY_UP, on_Release);
		}
		
		private function on_Press(e:KeyboardEvent):void 
		{
			if( e.keyCode == Keyboard.BACK )
			{
				e.preventDefault();
				e.stopImmediatePropagation();
			}
			if( e.keyCode == Keyboard.MENU )
			{
				e.preventDefault();
				e.stopImmediatePropagation();
			}
			if( e.keyCode == Keyboard.SEARCH )
			{
				e.preventDefault();
				e.stopImmediatePropagation();
			}
			
			if ((e.altKey && e.keyCode == 13) || e.keyCode == 122)
			{
				goFullscreen();
			}else if (e.keyCode == 27 || e.keyCode == 175 || e.keyCode == 174)
			{}else
			{
				if (e.altKey == false && e.keyCode != 17 && e.keyCode !=18)
					key[-1] = true;
				
				key[e.keyCode] = true;
			}
		}
		
		private function on_Release(e:KeyboardEvent):void 
		{
			if( e.keyCode == Keyboard.BACK )
			{
				e.preventDefault();
				e.stopImmediatePropagation();
				
				if (backFunction != null)
					backFunction();
			}
			if( e.keyCode == Keyboard.MENU )
			{
				e.preventDefault();
				e.stopImmediatePropagation();
				
				if (menuFunction != null)
					menuFunction();
			}
			if( e.keyCode == Keyboard.SEARCH )
			{
				e.preventDefault();
				e.stopImmediatePropagation();
				
				if (searchFunction != null)
					searchFunction();
			}
			
			if (key[-1] && key[-1] == true)
				key[ -1] = false;
			
			if (key[e.keyCode] && key[e.keyCode] == true)
				key[e.keyCode] = false;
		}
		
		public function clearAllInputs():void
		{
			key = [];
		}
		
		private function goFullscreen():void
		{
			if (stage.displayState == StageDisplayState.NORMAL)
			{
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}
		}
	}
}