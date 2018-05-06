package game.game.hud 
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.greensock.TweenMax;
	import flash.geom.Point;
	import game.assets.Assets;
	import game.assets.Device;
	import game.data.GameData;
	import game.game.objects.TitleObject;
	import game.game.sounds.SoundManager;
	import game.inputs.InputManager;
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
	public class GetReadyScreen extends Sprite
	{
		private var background:Quad;
		private var title:TitleObject;
		private var controlText:Image;
		private var controlImage:Image;
		private var jumpText:Image;
		private var jumpImage:Image;
		private var textFont:BitmapFont;
		private var txt:TextField;
		public var clickFunction:Function = null;
		private var inputType:String;
		public var opening:Boolean = false;
		private var txt_left:TextField;
		private var txt_right:TextField;
		
		private var controlHelp:Array = [];
		private var easeConfig:Point = new Point(1.2, 0.8);
		private var canTouchThis:Boolean = true;
		
		public function GetReadyScreen() 
		{
			textFont = Assets.getFont("textDisplay");
			textFont.smoothing = TextureSmoothing.TRILINEAR;
			
			controlHelp["gamepad"] = {texture_c:"to_control_pad", offsetY_c:-51, texture_p:"to_jump_pad_b", offsetY_p:-1, text:"press any button to continue"};
			controlHelp["gamepadXbox"] = {texture_c:"to_control_pad", offsetY_c:-51, texture_p:"to_jump_pad", offsetY_p:-1, text:"press any button to continue"};
			controlHelp["keyboard"] = {texture_c:"to_control_key", offsetY_c:-50, texture_p:"to_jump_key", offsetY_p:20, text:"press any key to continue"};
			controlHelp["touch"] = { texture_c:"to_control_touch", offsetY_c: -15, texture_p:"to_jump_touch", offsetY_p: -25, text:"tap to continue"};
			
			inputType = GameData.inputType;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, remove);
			
			background = new Quad(stage.stageWidth, stage.stageHeight, 0x000000);
			background.alpha = GameData.overlayAlpha;
			addChild(background);
			
			title = new TitleObject(Assets.getAtlas('interface', 1).getTexture('getready_title'));
			title.x = stage.stageWidth / 2;
			title.y = -title.height + 20;
			addChild(title);
			
			txt_left = new TextField(400, 70, "left side\n of the screen", textFont.name, 30, 0xFFFFFF);
			txt_left.hAlign = HAlign.CENTER;
			txt_left.x = ((stage.stageWidth - txt_left.width) / 2) - (200 * Device.scale);
			txt_left.y = -100;
			addChild(txt_left);
			
			controlImage = new Image(Assets.getAtlas('interface_hud', 1).getTexture(controlHelp[inputType].texture_c));
			controlImage.x = ((stage.stageWidth - controlImage.width) / 2) - (200 * Device.scale);
			controlImage.y = stage.stageHeight + controlImage.height + 20;
			addChild(controlImage);
			
			controlText = new Image(Assets.getAtlas('interface_hud', 1).getTexture('to_control_text'));
			//controlText.smoothing = TextureSmoothing.NONE;
			controlText.x = ((stage.stageWidth - controlText.width) / 2) - (200 * Device.scale);
			controlText.y = stage.stageHeight + controlText.height + 20;
			addChild(controlText);
			
			txt_right = new TextField(400, 70, "right side\n of the screen", textFont.name, 30, 0xFFFFFF);
			txt_right.hAlign = HAlign.CENTER;
			txt_right.x = ((stage.stageWidth - txt_right.width) / 2) + (200 * Device.scale);
			txt_right.y = -100;
			addChild(txt_right);
			
			if (inputType != "touch")
			{
				txt_right.alpha = 0;
				txt_left.alpha = 0;
			}
			
			jumpImage = new Image(Assets.getAtlas('interface_hud', 1).getTexture(controlHelp[inputType].texture_p));
			jumpImage.x = ((stage.stageWidth - jumpImage.width) / 2) + (200 * Device.scale);
			jumpImage.y = stage.stageHeight + jumpImage.height + 20;
			addChild(jumpImage);
			
			jumpText = new Image(Assets.getAtlas('interface_hud', 1).getTexture('to_jump_text'));
			
			//jumpText.smoothing = TextureSmoothing.NONE;
			jumpText.x = ((stage.stageWidth - jumpText.width) / 2) + (200 * Device.scale);
			jumpText.y = stage.stageHeight + jumpText.height + 20;
			addChild(jumpText);
			
			txt = new TextField(900, 40, controlHelp[inputType].text, textFont.name, 30, 0xFFFFFF);
			txt.alpha = 0;
			txt.hAlign = HAlign.CENTER;
			txt.x = (stage.stageWidth - txt.width) / 2;
			txt.y = stage.stageHeight - (70 * Device.scale);
			addChild(txt);
			
			background.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function changeGamepadState(index:int = 0):void
		{
			inputType = GameData.inputType;
			
			if (opening == false)
			{
				txt.text = String(controlHelp[inputType].text);
				
				controlImage.texture = Assets.getAtlas('interface_hud', 1).getTexture(controlHelp[inputType].texture_c);
				controlImage.readjustSize();
				TweenMax.to(controlImage, 0, { y:(340 + controlHelp[inputType].offsetY_c) * Device.scale } );
				
				jumpImage.texture = Assets.getAtlas('interface_hud', 1).getTexture(controlHelp[inputType].texture_p);
				jumpImage.readjustSize();
				TweenMax.to(jumpImage, 0, { y:(340 + controlHelp[inputType].offsetY_p) * Device.scale } );
				
				if (inputType == "touch")
				{
					txt_right.alpha = 1;
					txt_left.alpha = 1;
				}else 
				{
					txt_right.alpha = 0;
					txt_left.alpha = 0;
				}
			}
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			if (e.getTouch(this, TouchPhase.ENDED))
				close();
		}
		
		public function open():void
		{
			SoundManager.playSound("menuIn", "", 1, 0.4);
			canTouchThis = true;
			title.rotation = 0; //deg2rad( -20 + (Math.random() * 40));
			
			opening = true;
			TweenMax.to(title, 0.5, { rotation:0, y:100 * Device.scale, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), onComplete:function():void
			{
				title.open();
			}} );
			
			TweenMax.to(txt , 0.3, { alpha:1} );
			TweenMax.to(controlImage, 0.6, { y:(340 + controlHelp[inputType].offsetY_c) * Device.scale, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y)} );
			TweenMax.to(controlText, 0.6, { y:490 * Device.scale, delay:0.2, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
			TweenMax.to(txt_left, 0.6, { y:200 * Device.scale, delay:0.2, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
			
			TweenMax.to(jumpImage, 0.6, { y:(340 + controlHelp[inputType].offsetY_p) * Device.scale, delay:0.1, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y)} );
			TweenMax.to(jumpText, 0.6, { y:490 * Device.scale, delay:0.25, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), onComplete:function():void 
			{
				opening = false;
				changeGamepadState(0);
			} } );
			TweenMax.to(txt_right, 0.6, { y:200 * Device.scale, delay:0.2, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
			
			if (InputManager.gamepads)
			{
				InputManager.gamepads.onConnect = changeGamepadState;
				InputManager.gamepads.onDisconnect = changeGamepadState;
			}
		}
		
		public function close():void
		{
			if (canTouchThis == true)
			{
				canTouchThis = false;
				
				if (InputManager.gamepads)
				{
					InputManager.gamepads.onConnect = null;
					InputManager.gamepads.onDisconnect = null;
				}
				
				SoundManager.playSound("menuOut", "", 1, 0.4);
				TweenMax.to(title, 0.3, { y:-title.height + 20, ease:Back.easeIn, onComplete:function():void
				{
					title.close();
				}} );
				
				TweenMax.to(txt , 0.2, { alpha:0} );
				TweenMax.to(controlImage, 0.3, { y:stage.stageHeight + controlImage.height + 20, delay:0.1, ease:Back.easeIn} );
				TweenMax.to(controlText, 0.3, { y:stage.stageHeight + controlText.height + 20, ease:Back.easeIn } );
				TweenMax.to(txt_left, 0.3, { y:-100, ease:Back.easeIn } );
				
				TweenMax.to(jumpImage, 0.3, { y:stage.stageHeight + jumpImage.height + 20, delay:0.15, ease:Back.easeIn} );
				TweenMax.to(jumpText, 0.3, { y:stage.stageHeight + jumpText.height + 20, delay:0.05, ease:Back.easeIn } );
				TweenMax.to(txt_right, 0.3, { y:-100, ease:Back.easeIn } );
				
				TweenMax.to(this, 0.3, { autoAlpha:0, delay:0.3, onComplete:function():void 
				{
					if (clickFunction != null)
						clickFunction();
				} } );
			}
		}
		
		private function remove(e:Event):void 
		{
			background.removeEventListener(TouchEvent.TOUCH, onTouch);
			removeEventListener(Event.REMOVED_FROM_STAGE, remove);
		}
	}
}