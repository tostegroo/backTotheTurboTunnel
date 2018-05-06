package game.game.hud 
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.greensock.TweenMax;
	import flash.events.SoftKeyboardEvent;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.StageText;
	import flash.text.StageTextInitOptions;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import game.assets.Assets;
	import game.assets.Device;
	import game.data.GameData;
	import game.game.objects.MenuButton;
	import game.game.objects.TitleObject;
	import game.game.sounds.SoundManager;
	import game.inputs.gamepads.GenericGamepad;
	import game.inputs.gamepads.Xbox360Gamepad;
	import game.inputs.InputManager;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.HAlign;
	import starling.utils.deg2rad;
	/**
	 * ...
	 * @author FAbio Toste
	 */
	public class NameScreen extends Sprite
	{
		private var background:Quad;
		private var textFont:BitmapFont;
		private var txt:TextField;
		public var clickFunction:Function = null;
		private var inputBackground:Quad;
		private var inputType:String;
		public var opening:Boolean = false;
		private var bt_exit:MenuButton;
		
		private var controlHelp:Array = [];
		private var easeConfig:Point = new Point(1.2, 0.8);
		
		private var canTouchThis:Boolean = true;
		private var textField:flash.text.TextField;
		
		public function NameScreen() 
		{
			textFont = Assets.getFont("textDisplay");
			textFont.smoothing = TextureSmoothing.TRILINEAR;
			
			inputType = GameData.inputType;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, remove);
			
			background = new Quad(stage.stageWidth, stage.stageHeight, 0x000000);
			background.alpha = 0.9;
			addChild(background);
			
			txt = new TextField(900, 50, "Additional Name", textFont.name, 40, 0xb2b2b2);
			txt.hAlign = HAlign.CENTER;
			txt.x = (stage.stageWidth - txt.width) / 2;
			txt.y = 170 * Device.scale;
			addChild(txt);
			
			txt = new TextField(900, 150, "if you're afraid of someone using the same 3 character name \n as you're using, you can add a name or a nickname \n to distinguish yourself from others.", textFont.name, 30, 0xb2b2b2);
			txt.hAlign = HAlign.CENTER;
			txt.x = (stage.stageWidth - txt.width) / 2;
			txt.y = 420 * Device.scale;
			addChild(txt);
			
			//Font.registerFont(Assets.soj);
			//var font:Font = new Assets.soj();
			
			textField = new flash.text.TextField();
			var textFormat:TextFormat = new TextFormat("Arial", 70, 0xFFFFFF);
			textFormat.align = TextFormatAlign.CENTER;
			textField.type = TextFieldType.INPUT;
			textField.autoSize = TextFieldAutoSize.NONE;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.defaultTextFormat = textFormat;
			textField.maxChars = 20;
			textField.width = 900;
			textField.height = 100;
			textField.x = ((stage.stageWidth-textField.width) / 2);
			textField.y = 266 * Device.scale;
			textField.setTextFormat(textFormat);
			textField.needsSoftKeyboard = true;
			textField.alpha = 0;
			textField.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, onActivateKeyboard);
			textField.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, onDeactivateKeyboard);
			textField.text = "";
			
			inputBackground = new Quad(900, 100, 0xffffff);
			inputBackground.x = (stage.stageWidth - inputBackground.width) / 2;
			inputBackground.y = 260 * Device.scale;
			inputBackground.alpha = 0.1;
			addChild(inputBackground);
			
			textField.text = GameData.userName;
			
			bt_exit = new MenuButton(Assets.getAtlas('interface').getTexture('bt_p_back'), Assets.getAtlas('interface').getTexture('bt_p_back_over'), new Point(6, 52));
			bt_exit.x = (stage.stageWidth - bt_exit.button.width) / 2;
			bt_exit.y = stage.stageHeight + bt_exit.button.height + (90 * Device.scale);
			bt_exit.clickFunction = close;
			addChild(bt_exit);
			bt_exit.overOut(false);
			
			TweenMax.to(this, 0, { autoAlpha:0 } );
			//background.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onActivateKeyboard(event:SoftKeyboardEvent):void
		{
		}
		
		private function onDeactivateKeyboard(event:SoftKeyboardEvent):void
		{
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			//if (e.getTouch(this, TouchPhase.ENDED))
				//close();
		}
		
		public function open():void
		{
			InputManager.removeAllInputs();
			InputManager.keyboard.backFunction = close;
			
			canTouchThis = true;
			opening = true;
			Starling.current.nativeOverlay.addChild(textField);
			TweenMax.to(textField, 0.3, { autoAlpha:1, onComplete:function():void 
			{
				Starling.current.nativeStage.focus = textField;
				textField.setSelection(textField.length, textField.length);
				
				var bt_a_pad:int = (GameData.inputType == "gamepadXbox") ? Xbox360Gamepad.A : GenericGamepad.BUTTON0;
				InputManager.addInput("action", { keyboard:[Keyboard.ENTER], gamepad:[bt_a_pad] }, 0, action, null, null, true);
			}});
			
			TweenMax.to(bt_exit, 0.6, { y:stage.stageHeight - (135 * Device.scale), delay:0.2, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), onComplete:function():void{bt_exit.open();}} );
			TweenMax.to(this, 0.3, { autoAlpha:1, onComplete:function():void 
			{}});
			bt_exit.select();
		}
		
		public function close():void
		{
			if (canTouchThis == true)
			{
				InputManager.keyboard.backFunction = null;
				canTouchThis = false;
				InputManager.removeAllInputs();
				
				GameData.userName = textField.text;
				
				if (GameData.main.game)
					GameData.main.game.setGameOverInputs();
				
				TweenMax.to(bt_exit, 0.3, { y:stage.stageHeight + bt_exit.button.height + (90 * Device.scale), ease:Back.easeIn, onComplete:function():void{bt_exit.close()}} );
				
				TweenMax.to(textField, 0.3, { autoAlpha:0, delay:0.3, onComplete:function():void 
				{
					Starling.current.nativeOverlay.removeChild(textField);
				}});
				
				if (clickFunction != null)
					clickFunction();
				
				TweenMax.to(this, 0.3, { autoAlpha:0, delay:0.3 } );
				bt_exit.unselect();
			}
		}
		
		public function action():void
		{
			bt_exit.downState();
			close();
		}
		
		private function remove(e:Event):void 
		{
			background.removeEventListener(TouchEvent.TOUCH, onTouch);
			removeEventListener(Event.REMOVED_FROM_STAGE, remove);
		}
	}
}