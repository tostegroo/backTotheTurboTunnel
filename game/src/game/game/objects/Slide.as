package game.game.objects 
{
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import flash.geom.Point;
	import game.assets.Assets;
	import game.assets.Device;
	import game.game.sounds.SoundManager;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	/**
	 * ...
	 * @author eu mesmo
	 */
	public class Slide extends Sprite
	{
		public var text:Image;
		public var disabled:Image;
		public var bar:Image;
		public var controlArea:Quad;
		public var button:MenuButton;
		public var canMove:Boolean = false;
		
		public var disableArea:Quad;
		
		private var pt:Point = new Point(0, 0);
		private var mv:Point = new Point(0, 0);
		private var oldValue:Number = 0;
		
		public var step:Number = 0.1;
		public var value:Number = 0;
		public var setProp:String = "";
		public var enabled:Boolean = true;
		
		public function Slide(textTexture:String = "", disabledTexture:String = "", setProp:String = "") 
		{
			this.setProp = setProp;
			
			text = new Image(Assets.getAtlas('interface').getTexture(textTexture));
			text.x = (127 * Device.scale) - text.width;
			addChild(text);
			
			disabled = new Image(Assets.getAtlas('interface').getTexture(disabledTexture));
			disabled.x = text.x - (13 * Device.scale);
			disabled.y = 8 * Device.scale;
			TweenMax.to(disabled, 0, { autoAlpha:0 });
			addChild(disabled);
			
			disableArea = new Quad(text.width , text.height, 0xff0000);
			disableArea.alpha = 0;
			disableArea.x = text.x;
			disableArea.y = text.y;
			addChild(disableArea);
			disableArea.addEventListener(TouchEvent.TOUCH, onTouchDisable);
			
			bar = new Image(Assets.getAtlas('interface').getTexture('slider_bg'));
			bar.x = text.x + text.width + (20 * Device.scale);
			bar.y = 6 * Device.scale;
			addChild(bar);
			
			button = new MenuButton(Assets.getAtlas('interface').getTexture('slider_bt'), Assets.getAtlas('interface').getTexture('slider_bt_shadow'), new Point(1, 0), 0, 0, 6, 0.5);
			button.x = bar.x;
			button.y = -10 * Device.scale;
			button.overOut(false);
			addChild(button);
			
			controlArea = new Quad(bar.width + (10 * Device.scale), button.button.height, 0xff0000);
			controlArea.alpha = 0;
			controlArea.x = bar.x - (5 * Device.scale);
			controlArea.y = bar.y - ((controlArea.height - bar.height) / 2);
			addChild(controlArea);
			controlArea.addEventListener(TouchEvent.TOUCH, onTouch);
			
			if (setProp == "sfx")
			{
				setValue(SoundManager.sfx_volume);
			}else
			{
				setValue(SoundManager.music_volume);
			}
		}
		
		public function open():void
		{
			button.open();
		}
		
		public function close():void
		{
			button.close();
		}
		
		private function onTouchDisable(e:TouchEvent):void 
		{
			if (e.getTouch(this, TouchPhase.ENDED))
			{
				if (enabled == true)
				{
					disable();
				}else
				{
					enable();
				}
			}
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(this.controlArea);
			
			if (touch != null)
			{
				pt.setTo(touch.getLocation(this).x, touch.getLocation(this).y);
				
				var bh:Number = (button.button.width / 2);
				var xpos:Number = pt.x - bh;
				xpos = (xpos > controlArea.x + controlArea.width - button.button.width) ? controlArea.x + controlArea.width - button.button.width : xpos;
				xpos = (xpos < controlArea.x) ? controlArea.x : xpos;
				var pctValue:Number = (xpos - controlArea.x) / (controlArea.width - button.button.width);
				
				var touchHover:Touch = e.getTouch(this, TouchPhase.HOVER);
				if (touchHover)
				{
					if (pt.x > (button.x) && pt.x < (button.x + button.button.width))
					{
						button.over(false);
					}else
					{
						button.overOut(false);
					}
				}else
				{
					button.overOut(false);
				}
				
				if (touch.phase == TouchPhase.BEGAN)
				{
					setValue(pctValue, 0.2);
					canMove = true;
					button.over(false);
				}else if (touch.phase == TouchPhase.ENDED)
				{
					canMove = false;
					button.overOut(false);
					
					if (setProp == "sfx")
					{
						SoundManager.playSound("ok", "ok");
					}else
					{
						SoundManager.playSound("ok", "ok", 1, 1, "music");
					}
				}else if (touch.phase == TouchPhase.MOVED)
				{
					if (canMove == true)
						setValue(pctValue);
						button.over(false);
				}
			}
		}
		
		public function select():void
		{
			button.select();
		}
		
		public function unselect():void
		{
			button.unselect();
		}
		
		public function enable():void
		{
			setValue(oldValue, 0.2);
			TweenMax.to(disabled, 0.1, { autoAlpha:0 } );
			enabled = true;
		}
		
		public function disable():void
		{
			oldValue = value;
			setValue(0, 0.2);
			TweenMax.to(disabled, 0.1, { autoAlpha:1 } );
			enabled = false;
		}
		
		public function setValue(value:Number = 0.5, time:Number = 0, callback:Function = null):void
		{
			value = (value > 1) ? 1 : value;
			value = (value < 0) ? 0 : value;
			
			var xpos:Number = controlArea.x + ((controlArea.width - button.button.width) * value);
			
			TweenMax.to(button, time, {x:xpos, ease:Sine.easeInOut, onComplete:callback } );
			this.value = value;
			
			if (setProp != "")
			{
				SoundManager.setMasterVolumeByType(setProp, value); 
			}
		}
	}
}