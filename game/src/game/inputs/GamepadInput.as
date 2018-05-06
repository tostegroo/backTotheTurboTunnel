package game.inputs 
{
	import com.stackandheap.ane.joystick.event.JoystickButtonEvent;
	import com.stackandheap.ane.joystick.event.JoystickEvent;
	import com.stackandheap.ane.joystick.event.JoystickMoveEvent;
	import com.stackandheap.ane.joystick.event.JoystickPovEvent;
	import com.stackandheap.ane.joystick.JoystickCapabilities;
	import com.stackandheap.ane.joystick.JoystickManager;
	import game.data.GameData;
	import game.inputs.gamepads.GamePad;
	import game.inputs.gamepads.GamepadID;
	import game.utils.math.MathHelper;
	
	/**
	 * ...
	 * @author eu mesmo
	 */
	public class GamepadInput
	{
		private var gamepadManager:JoystickManager;
		
		public var connectedGamepads:int = 0;
		public var gamepad:Vector.<GamePad> = new Vector.<GamePad>();
		public var onConnect:Function = null;
		public var onDisconnect:Function = null;
		
		public function GamepadInput(stage:*) 
		{
			gamepadManager = new JoystickManager();
			connectedGamepads = gamepadManager.connectedJoysticks.length;
			
			for (var i:int = 0; i < connectedGamepads; i++) 
			{
				gamepad.push(new GamePad(gamepadManager.getJoystickCapabilities(i)));
			}
			gamepadManager.addEventListener(JoystickEvent.CONNECTED, on_Connect);
			gamepadManager.addEventListener(JoystickEvent.DISCONNECTED, on_Disconnect);
			gamepadManager.addEventListener(JoystickEvent.MOVE, on_Move);
			gamepadManager.addEventListener(JoystickEvent.PRESS, on_Press);
			gamepadManager.addEventListener(JoystickEvent.RELEASE, on_Release);
			gamepadManager.addEventListener(JoystickEvent.POV_PRESS, on_pov_Press);
			gamepadManager.addEventListener(JoystickEvent.POV_RELEASE, on_pov_Release);
			
			vefifyInputType();
		}
		
		public function vefifyInputType():void
		{
			if (connectedGamepads > 0)
			{
				GameData.inputType = "gamepad";
				if (gamepad[0].manufacturerID == GamepadID.xbox360)
				{
					GameData.inputType = "gamepadXbox";
				}
			}else
			{
				if (GameData.is_mobile == true)
				{
					GameData.inputType = "touch";
				}else
				{
					if (GameData.is_touch == true)
					{
						GameData.inputType = "touch";
					}else 
					{
						GameData.inputType = "keyboard";
					}
				}
			}
		}
		
		//functions
		private function addGamePad(index:int = 0):void
		{
			gamepad = new Vector.<GamePad>();
			connectedGamepads = gamepadManager.connectedJoysticks.length;
			for (var i:int = 0; i < connectedGamepads; i++) 
			{
				gamepad.push(new GamePad(gamepadManager.getJoystickCapabilities(i)));
			}
			vefifyInputType();
		}
		
		private function removeGamePad(index:int = 0):void
		{
			gamepad = new Vector.<GamePad>();
			connectedGamepads = gamepadManager.connectedJoysticks.length;
			for (var i:int = 0; i < connectedGamepads; i++) 
			{
				gamepad.push(new GamePad(gamepadManager.getJoystickCapabilities(i)));
			}
			vefifyInputType();
		}
		
		public function clearAllInputs():void
		{
			for (var i:int = 0; i < connectedGamepads; i++) 
			{
				gamepad[i].button = [];
				gamepad[i].axis = [];
			}
		}
		
		//events
		private function on_Connect(e:JoystickEvent):void 
		{
			addGamePad(e.index);
			
			if (onConnect != null)
				onConnect(e.index);
		}
		
		private function on_Disconnect(e:JoystickEvent):void 
		{
			removeGamePad(e.index);
			
			if (onDisconnect != null)
				onDisconnect(e.index);
		}
		
		private function on_Move(e:JoystickMoveEvent):void 
		{
			if (e.index < gamepad.length)
			{
				var value:Number = e.value / 100;
				if (gamepad[e.index].useStickAsPOV == true)
				{
					value = MathHelper.analogicToDigital(value, gamepad[e.index].stickPOVTolerance);
					gamepad[e.index].axis[e.axisIndex] = value;
					
					if (value == 0)
					{
						gamepad[e.index].button["a_" + e.axisIndex + "_1"] = false;
						gamepad[e.index].button["a_" + e.axisIndex + "_-1"] = false;
					}else
					{
						gamepad[e.index].button["a_" + e.axisIndex + "_" + value] = true;
					}
				}else
				{
					value = MathHelper.percentageFit(value, gamepad[e.index].axixDeadZone[e.axisIndex], 1);
					gamepad[e.index].axis[e.axisIndex] = value;
				}
			}
		}
		
		private var old_bt:Number = 0;
		private function on_Press(e:JoystickButtonEvent):void 
		{
			if (e.index < gamepad.length)
			{
				gamepad[e.index].button["all"] = true;
				gamepad[e.index].button[e.buttonIndex] = true;
				//trace("press pad: " + e.index + ", button: " + e.buttonIndex);
			}
		}
		
		private function on_Release(e:JoystickButtonEvent):void 
		{
			if (e.index < gamepad.length)
			{
				if(gamepad[e.index].button["all"] == true)
					gamepad[e.index].button["all"] = false;
				
				
				if(gamepad[e.index].button[e.buttonIndex] == true)
					gamepad[e.index].button[e.buttonIndex] = false;
				//trace("release pad: " + e.index + ", button: " + e.buttonIndex);
			}
		}
		
		private function on_pov_Press(e:JoystickPovEvent):void 
		{
			if (e.index < gamepad.length)
			{
				gamepad[e.index].button["all"] = true;
				gamepad[e.index].button["p_" + e.povIndex] = true;
				//trace("press", e.index, e.povIndex);
			}
		}
		
		private function on_pov_Release(e:JoystickPovEvent):void 
		{
			if (e.index < gamepad.length)
			{
				if(gamepad[e.index].button["all"] == true)
					gamepad[e.index].button["all"] = false;
				
				if(gamepad[e.index].button["p_" + e.povIndex] == true)
					gamepad[e.index].button["p_" + e.povIndex] = false;
				//trace("release", e.index, e.povIndex);
			}
		}
	}
}