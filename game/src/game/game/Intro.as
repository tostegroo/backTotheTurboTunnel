package game.game 
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import game.assets.Device;
	import game.data.AnalyticsData;
	import game.game.sounds.SoundManager;
	import starling.display.Quad;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import game.data.GameData;
	import game.inputs.InputManager;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.textures.TextureSmoothing;
	
	import game.assets.Assets;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	/**
	 * ...
	 * @author eu mesmo
	 */
	public class Intro extends Sprite 
	{
		public var loadedFunction:Function = null;
		
		private var logoScreen:Sprite;
		private var controllerScreen:Sprite;
		
		private var textFont:BitmapFont;
		private var txt:TextField;
		private var logo:Image;
		private var controller:Image;
		
		private var skiptxt:TextField;
		private var inputType:String;
		private var controlHelp:Array = [];
		private var touchArea:Quad;
		
		public function Intro(callback:Function = null) 
		{
			inputType = GameData.inputType;
			
			controlHelp["gamepad"] = {text:"any button to skip"};
			controlHelp["gamepadXbox"] = {text:"any button to skip"};
			controlHelp["keyboard"] = {text:"any key to skip"};
			controlHelp["touch"] = { text:"tap to skip" };
			
			textFont = Assets.getFont("textDisplay");
			textFont.smoothing = TextureSmoothing.TRILINEAR;
			
			logo = new Image(Assets.getAtlas('interface_intro', 1).getTexture('logo_mandril'));
			logo.smoothing = TextureSmoothing.TRILINEAR;
			controller = new Image(Assets.getAtlas('interface_intro', 1).getTexture('controller'));
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			if (callback != null)
				callback();
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, remove);
			
			AnalyticsData.trackPage("/intro");
			
			createLogo();
			createController();
			
			skiptxt = new TextField(300, 30, controlHelp[inputType].text, textFont.name, 26, 0xFFFFFF);
			skiptxt.hAlign = HAlign.RIGHT;
			skiptxt.alpha = 0;
			skiptxt.x = stage.stageWidth - skiptxt.width - 40;
			skiptxt.y = stage.stageHeight - skiptxt.height - 25;
			addChild(skiptxt);
			
			touchArea = new Quad(stage.stageWidth, stage.stageHeight, 0x00ff00);
			touchArea.alpha = 0;
			addChild(touchArea);
			
			if(touchArea)
				touchArea.addEventListener(TouchEvent.TOUCH, onTouch);
			
			TweenMax.to(skiptxt, 0.2, { alpha:1, yoyo:true, repeat: -1, ease:Linear } );
			
			InputManager.removeAllInputs();
			if (GameData.is_mobile == false)
			{
				InputManager.addInput("skip", { keyboard:"all", gamepad:"all" }, 0, skip, null, null, true);
				
				if (InputManager.gamepads)
				{
					InputManager.gamepads.onConnect = changeGamepadState;
					InputManager.gamepads.onDisconnect = changeGamepadState;
				}
			}
			
			if(loadedFunction!=null)
				loadedFunction(this);
			
			if (GameData.is_mobile == true)
			{
				animateLogo();
			}else
			{
				animateController();
			}
		}
		
		private function changeGamepadState(index:int = 0):void
		{
			inputType = GameData.inputType;
			skiptxt.text = String(controlHelp[inputType].text);
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			if (e.getTouch(this, TouchPhase.ENDED))
				skip();
		}
		
		public function skip():void
		{
			touchArea.removeEventListener(TouchEvent.TOUCH, onTouch);
			
			if (InputManager.gamepads)
			{
				InputManager.gamepads.onConnect = null;
				InputManager.gamepads.onDisconnect = null;
			}
			
			TweenMax.killTweensOf(skiptxt);
			skiptxt.visible = false;
			InputManager.removeAllInputs();
			
			GameData.main.changeScene("startSkip", false);
		}
		
		private function createLogo():void
		{
			logoScreen = new Sprite();
			
			var yy:Number = 0;
			
			logo.x = (900 - logo.width) / 2;
			logo.y = 0;
			logoScreen.addChild(logo);
			
			yy = logo.y + logo.height + 80;
			
			txt = new TextField(900, 40,  "Presents", textFont.name, 30, 0xFFFFFF);
			txt.hAlign = HAlign.CENTER;
			txt.x = 0;
			txt.y = yy;
			logoScreen.addChild(txt);
			
			yy = txt.y + txt.height + 80;
			
			txt = new TextField(900, 45,  "a tribute to", textFont.name, 40, 0xFFFFFF);
			txt.hAlign = HAlign.CENTER;
			txt.x = 0;
			txt.y = yy;
			logoScreen.addChild(txt);
			
			yy = txt.y + txt.height + 15;
			
			txt = new TextField(900, 45,  "Rash, Zitz, Pimple, Battletoads and Rare.", textFont.name, 40, 0xFFFFFF);
			txt.hAlign = HAlign.CENTER;
			txt.x = 0;
			txt.y = yy;
			logoScreen.addChild(txt);
			
			logoScreen.x = (stage.stageWidth - logoScreen.width) / 2;
			logoScreen.y = (stage.stageHeight - logoScreen.height) / 2;
			
			logoScreen.alpha = 0;
			addChild(logoScreen);
		}
		
		private function animateLogo():void
		{
			SoundManager.playSound("musicMenu", "musicMenu", -1, 0.5, "music");
			
			TweenMax.to(logoScreen, 0.1, { alpha:1, delay:0.5, onComplete:function():void 
			{ 
				TweenMax.to(logoScreen, 4, { alpha:1, onComplete:function():void 
				{
					TweenMax.to(logoScreen, 0.3, { alpha:0, onComplete:function():void 
					{
						TweenMax.killTweensOf(skiptxt);
						skiptxt.visible = false;
						InputManager.removeAllInputs();
						
						GameData.main.changeScene("start", false);
					}});
				}});
			}});
		}
		
		private function createController():void
		{
			controllerScreen = new Sprite();
			
			controller = new Image(Assets.getAtlas('interface_intro', 1).getTexture('controller'));
			controller.scaleX = controller.scaleY = 1;
			controller.x = (900 - controller.width) / 2;
			controller.y = 0;
			controllerScreen.addChild(controller);
			
			txt = new TextField(900, 45,  "we recommend a controller to play. seriously.", textFont.name, 40, 0xFFFFFF);
			txt.hAlign = HAlign.CENTER;
			txt.x = 0;
			txt.y = Math.ceil(controller.y + controller.height + (85 * Device.scale));
			controllerScreen.addChild(txt);
			
			txt = new TextField(900, 35,  "*doesn't have to be an Xbox 360 controller.", textFont.name, 26, 0xFFFFFF);
			txt.hAlign = HAlign.CENTER;
			txt.x = 0;
			txt.y = Math.ceil(controller.y + controller.height + (145 * Device.scale));
			controllerScreen.addChild(txt);
			
			controllerScreen.x = (stage.stageWidth - controllerScreen.width) / 2;
			controllerScreen.y = (stage.stageHeight - controllerScreen.height) / 2;
			
			controllerScreen.alpha = 0;
			addChild(controllerScreen);
		}
		
		private function animateController():void
		{
			TweenMax.to(controllerScreen, 0.1, { alpha:1, delay:0.5, onComplete:function():void 
			{ 
				TweenMax.to(controllerScreen, 3, { alpha:1, onComplete:function():void 
				{
					TweenMax.to(controllerScreen, 0.3, { alpha:0, onComplete:function():void 
					{
						animateLogo();
					}});
				}});
			}});
		}
		
		private function remove(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, remove);
			TweenMax.killAll();
		}
		
		public function stop():void
		{
			this.visible = false;
		}
		
		public function start():void
		{
			this.visible = true;
		}
	}
}