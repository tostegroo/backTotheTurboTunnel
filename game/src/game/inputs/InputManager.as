package game.inputs 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import game.data.GameData;
	
	
	import game.inputs.gamepads.GamePad;
	/**
	 * ...
	 * @author Fabio Toste
	 */
	public class InputManager
	{
		private static var inputStage:*;
		
		public static var gamepads:GamepadInput;
		public static var keyboard:KeyboardInput;
		public static var mouse:MouseInput;
		public static var touch:TouchInput;
		public static var canUpdate:Boolean = false;
		
		public static var inputLength:int;
		public static var inputList:Vector.<Input> = new Vector.<Input>();
		
		public static var ALL:String = "all";
		
		public static function init(stage:*):void
		{
			inputStage = stage;
			if (inputStage)
			{
				keyboard = new KeyboardInput(inputStage);
				mouse = new MouseInput(inputStage);
				
				if (GameData.is_mobile == false)
					gamepads = new GamepadInput(inputStage);
				
				//Enter frame listener
				inputStage.addEventListener(Event.ENTER_FRAME, onStageEnterFrame);
				canUpdate = true;
			}
		}
		
		public static function pause():void
		{
			canUpdate = false;
			inputStage.removeEventListener(Event.ENTER_FRAME, onStageEnterFrame);
		}
		
		public static function resume():void
		{
			canUpdate = true;
			inputStage.addEventListener(Event.ENTER_FRAME, onStageEnterFrame);
		}
		
		public static function destroy():void
		{
			inputStage.removeEventListener(Event.ENTER_FRAME, onStageEnterFrame);
		}
		
		public static function addInput(
			name:String, 
			inputs:Object = null,
			gamepadIndex:int = 0,
			pressFunction:Function = null, 
			releaseFunction:Function = null, 
			moveFunction:Function = null,
			oneHit:Boolean = false
		):void
		{
			var index:int = getIndexByName(name);
			if (index == -1)
			{
				inputLength = inputList.push(new Input(name, inputs, gamepadIndex, pressFunction, releaseFunction, moveFunction, oneHit));
			}else
			{
				trace("Input name ("+ name +") already exists.");
			}
			
			if (canUpdate == false)
				canUpdate = true;
		}
		
		public static function removeAllInputs():void
		{
			canUpdate = false;
			inputLength = 0;
			inputList = new Vector.<Input>();
			
			if (keyboard)
				keyboard.clearAllInputs();
			
			if (mouse)
				mouse.clearAllInputs();
			
			if (gamepads)
				gamepads.clearAllInputs();
			
		}
		
		public static function removeInputByName(name:String):void
		{
			var index:int = getIndexByName(name);
			if (index != -1)
			{
				inputLength = inputList.splice(index, 1).length;
			}
		}
		
		public static function removeInputAt(index:int = -1):void
		{
			if (index != -1 && index > 0 && index < inputLength)
			{
				inputLength = inputList.splice(index, 1).length;
			}
		}
		
		private static function update():void
		{
			if (canUpdate == true)
			{
				var i:int;
				var j:int;
				var inputArray:Array;
				for (i = 0; i < inputLength; i++) 
				{
					inputArray = [];
					if (inputLength>0 && keyboard && inputList[i].inputs.hasOwnProperty("keyboard") && inputList[i].useKeyboard == true)
					{
						if (inputList[i].inputs.keyboard is Array)
						{
							inputArray = inputList[i].inputs.keyboard;
						}else if (inputList[i].inputs.keyboard is Number)
						{
							inputArray = [inputList[i].inputs.keyboard];
						}else if (inputList[i].inputs.keyboard is String && inputList[i].inputs.keyboard=="all")
						{
							inputArray = [-1];
						}else
						{
							trace("Invalid input value for keyboard.");
						}
						
						for (j = 0; j < inputArray.length ; j++) 
						{
							if (inputArray[j] is Number)
							{
								if (keyboard.key[inputArray[j]] == true && inputList[i].canHit == true)
								{
									if (inputList[i].oneHit == true)
										inputList[i].canHit = false;
									
									if(inputList[i].pressFunction != null)
										inputList[i].pressFunction();
								}
								
								if (keyboard.key[inputArray[j]] == false)
								{
									if(inputList[i].releaseFunction != null)
										inputList[i].releaseFunction();
									
									keyboard.key[inputArray[j]] = null;
									inputList[i].canHit = true;
								}
							}else
							{
								trace("Invalid input value for keyboard: value: " + inputArray[j]);
							}
						}
					}
					
					inputArray = [];
					if (inputLength>0 && gamepads && inputList[i].inputs.hasOwnProperty("gamepad") && inputList[i].useGamepad == true)
					{
						if (inputList[i].inputs.gamepad is Array)
						{
							inputArray = inputList[i].inputs.gamepad;
						}else if (inputList[i].inputs.gamepad is Number || inputList[i].inputs.gamepad is String)
						{
							inputArray = [inputList[i].inputs.gamepad];
						}else if (inputList[i].inputs.gamepad is String && inputList[i].inputs.gamepad=="all")
						{
							inputArray = ["all"];
						}else
						{
							trace("Invalid input value for gamepad.");
						}
						
						for (j = 0; j < inputArray.length ; j++) 
						{
							if (inputArray[j] is Number || inputArray[j] is String)
							{
								var index:int = inputList[i].gamepadIndex;
								if (gamepads.gamepad.length > index)
								{
									var gamepad:GamePad = gamepads.gamepad[index];
									
									//joystick buttons
									if (gamepad.button[inputArray[j]] == true && inputList[i].canHit == true)
									{
										if (inputList[i].oneHit == true)
											inputList[i].canHit = false;
										
										if(inputList[i].pressFunction != null)
											inputList[i].pressFunction();
									}
									
									if (gamepad.button[inputArray[j]] == false)
									{
										if(inputList[i].releaseFunction != null)
											inputList[i].releaseFunction();
										
										gamepad.button[inputArray[j]] = null;
											inputList[i].canHit = true;
									}
									
									//joystick axis
									if (gamepad.useStickAsPOV == false)
									{
										if (inputList[i].moveFunction!=null && inputArray[j] >= 0 && inputArray[j] < gamepad.numAxes)
										{
											inputList[i].moveFunction(gamepad.axis[inputArray[j]]);
										}
									}
								}
							}else
							{
								trace("Invalid input value for gamepad: gamepag - " + j + " value: "+inputArray[j]);
							}
						}
					}
					
					inputArray = [];
					if (inputLength>0 && mouse && inputList[i].inputs.hasOwnProperty("mouse") && inputList[i].useMouse == true)
					{
						if (inputList[i].inputs.mouse is Array)
						{
							inputArray = inputList[i].inputs.mouse;
						}else if (inputList[i].inputs.mouse is Number || inputList[i].inputs.mouse is String)
						{
							inputArray = [inputList[i].inputs.mouse];
						}else
						{
							trace("Invalid input value for mouse.");
						}
						
						for (j = 0; j < inputArray.length ; j++) 
						{
							if (inputArray[j] is Number || inputArray[j] is String)
							{
								if (inputList[i].moveFunction!=null && inputArray[j]=="wheel")
								{
									inputList[i].moveFunction(mouse.wheel);
								}
							}
						}
						mouse.wheel = 0;
					}
					
					inputArray = [];
					if (inputLength>0 && inputList[i].inputs.hasOwnProperty("touch") && inputList[i].useTouch==true)
					{
						inputArray = [];
						//to do
					}
				}
			}
		}
		
		private static function getIndexByName(name:String):int
		{
			var index:int = -1;
			for (var i:int = 0; i < inputLength; i++) 
			{
				if (inputList[i].name == name)
				{
					index = i;
					break;
				}
			}
			return index;
		}
		
		static private function onStageEnterFrame(e:Event):void 
		{
			update();
		}
	}
}