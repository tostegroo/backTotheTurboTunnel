package game.game.objects 
{
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;
	import flash.events.DataEvent;
	import flash.geom.Point;
	import game.assets.Assets;
	import game.data.GameData;
	import game.game.sounds.SoundManager;
	import starling.display.DisplayObject;
	
	import com.greensock.TweenMax;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.TouchEvent;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	/**
	 * ...
	 * @author eu mesmo
	 */
	public class ExitButton extends ButtonObject
	{
		public var button:Image;
		public var text:Image;
		public var arrow:Image;
		private var hover:Boolean = false;
		public var selected:Boolean = false;
		public var down:Boolean = false;
		public var clickFunction:Function = null;
		public var overFunction:Function = null;
		public var outFunction:Function = null;
		private var canPlayOut:Boolean = false;
		private var canPlayOver:Boolean = true;
		
		private var touch:Touch;
		private var touchTarget:DisplayObject;
		
		private var easeConfig:Point = new Point(1.8, 0.5);
		
		public function ExitButton() 
		{
			text = new Image(Assets.getAtlas('interface').getTexture('bt_exit_desk_text'));
			addChild(text);
			
			button = new Image(Assets.getAtlas('interface').getTexture('bt_exit_desk'));
			button.y = text.y + text.height + 5;
			addChild(button);
			
			arrow = new Image(Assets.getAtlas('interface').getTexture('bt_exit_desk_arrow'));
			arrow.y = button.y + 13;
			arrow.x = button.x + 22;
			addChild(arrow);
			
			this.pivotX = this.width / 2;
			this.pivotY = this.height / 2;
			
			this.scaleX = this.scaleY = 0.9;
			this.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public function open():void
		{
			//canAnimate = true;
			//animateShiny();
		}
		
		public function close():void
		{
			//canAnimate = false;
			
			//if (tweenShiny)
				//tweenShiny.kill();
			
			//mask.isAnimated = false;
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			var touchHover:Touch = e.getTouch(this, TouchPhase.HOVER);
			if (touchHover)
			{
				if (hover == false)
				{
					hover = true;
					over();
				}
			}else
			{
				overOut();
				hover = false;
			}
			
			touch = e.getTouch(this);
			if (touch != null)
			{
				if (touch.phase == TouchPhase.BEGAN)
				{
					touchTarget = touch.target;
					downState();
					e.stopPropagation();
					
					if (overFunction != null)
						overFunction();
				}
				
				if (touch.phase == TouchPhase.ENDED)
				{
					upState();
					e.stopPropagation();
					
					var touchEndedPoint:Point = new Point(touch.globalX, touch.globalY);
					if (stage.hitTest(touchEndedPoint, true) == touchTarget && clickFunction != null)
						clickFunction();
					
					if (outFunction != null)
						outFunction();
				}
				
				if (touch.phase == TouchPhase.MOVED)
				{
					touchEndedPoint = new Point(touch.globalX, touch.globalY);
					if (stage.hitTest(touchEndedPoint, true) != touchTarget)
					{
						overOut();
						hover = false;
						upState();
					}
				}
			}
		}
		
		public override function downState():void
		{
			if (down == false)
			{
				SoundManager.playSound("click", "click");
				down = true;
				TweenMax.to(this, 0.1, { scaleX:0.8, scaleY:0.8, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
			}
		}
		
		public override function upState():void
		{
			down = false;
			TweenMax.to(this, 0.1, { scaleX:0.9, scaleY:0.9, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
		}
		
		public override function over(playsound:Boolean = true):void 
		{
			if (canPlayOver == true && playsound == true)
			{
				SoundManager.playSound("over", "over");
				canPlayOver = false;
				canPlayOut = true;
			}
			
			TweenMax.to(text, 0.5, { y: -1, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
			TweenMax.to(arrow, 0.5, { x: button.x + 20, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
			TweenMax.to(this, 0.2, { scaleX:0.95, scaleY:0.95, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
		}
		
		public override function overOut(playsound:Boolean = true):void
		{
			if (canPlayOut == true && playsound == true)
			{
				SoundManager.playSound("overOut", "overOut");
				canPlayOver = true;
				canPlayOut = false;
			}
			
			if (selected == false)
			{
				TweenMax.to(this, 0.2, { scaleX:0.9, scaleY:0.9, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
				TweenMax.to(text, 0.5, { y: 0, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
				TweenMax.to(arrow, 0.5, { x: button.x + 22, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
			}else
			{
				TweenMax.to(this, 0.2, { scaleX:1, scaleY:1, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y)} );
				TweenMax.to(text, 0.5, { y: -2, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
				TweenMax.to(arrow, 0.5, { x: button.x + 18, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
			}
		}
		
		public override function select(playsound:Boolean = true):void
		{
			if (GameData.is_mobile == false)
			{
				if(playsound==true)
					SoundManager.playSound("select", "select");
				
				TweenMax.to(text, 0.5, { y: -2, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
				TweenMax.to(arrow, 0.5, { x: button.x + 18, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
				TweenMax.to(this, 0.2, { scaleX:1, scaleY:1, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
			}
			selected = true;
		}
		public override function unselect():void
		{
			if (GameData.is_mobile == false)
			{
				TweenMax.to(text, 0.5, { y: 0, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
				TweenMax.to(arrow, 0.5, { x: button.x + 22, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
				TweenMax.to(this, 0.2, { scaleX:0.9, scaleY:0.9, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
			}
			selected = false;
		}
	}
}