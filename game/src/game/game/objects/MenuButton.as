package game.game.objects 
{
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Quart;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Sine;
	import flash.events.DataEvent;
	import flash.geom.Point;
	import game.assets.Assets;
	import game.data.GameData;
	import game.game.sounds.SoundManager;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.extensions.pixelmask.PixelMaskDisplayObject;
	import starling.utils.deg2rad;
	
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
	public class MenuButton extends ButtonObject
	{
		public var btcontainer:Sprite;
		public var mask:PixelMaskDisplayObject;
		public var shiny:Image;
		public var shiny_all:Quad;
		public var tweenShiny:TweenMax;
		public var canAnimate:Boolean = false;
		
		public var select_bg:Image;
		
		public var button:Button;
		public var shadow:Image;
		private var hover:Boolean = false;
		public var selected:Boolean = false;
		public var down:Boolean = false;
		public var lastPosition:Point = new Point(0, 0);
		public var clickFunction:Function = null;
		public var overFunction:Function = null;
		public var outFunction:Function = null;
		
		public var offsetX:Number = 0;
		public var offsetY:Number = 0;
		public var shadowOffsetX:Number = 0;
		public var shadowOffsetY:Number = 0;
		private var canPlayOut:Boolean = false;
		private var canPlayOver:Boolean = true;
		
		private var touch:Touch;
		private var touchTarget:DisplayObject;
		private var canTouchThis:Boolean = true;
		
		private var easeConfig:Point = new Point(1.3, 0.3);
		
		private var type:int = 0;
		
		public function MenuButton(texture:Texture = null, shadowTexture:Texture = null, shadowOffset:Point = null, type:int = 0, offsetSide:int = 1, offset:Number = 8, offsetBG:Number = 0) 
		{
			this.type = type;
			
			if (type == 0)
			{
				offsetX = 0;
				offsetY = -offset;
			}else
			{
				offsetX = 20 * offsetSide;
				offsetY = 0;
			}
			
			btcontainer = new Sprite();
			btcontainer.x = -(offsetX / 3);
			btcontainer.y = -(offsetY / 3);
			lastPosition.x = btcontainer.x;
			lastPosition.y = btcontainer.y;
			
			if (shadowTexture != null)
			{
				shadow = new Image(shadowTexture);
				
				if (shadowOffset != null)
				{
					shadow.x = shadowOffset.x;
					shadow.y = shadowOffset.y;
					
					shadowOffsetX = shadow.x;
					shadowOffsetY = shadow.y;
				}
				addChild(shadow);
			}
			
			button = new Button(texture);
			button.scaleWhenDown = 1;
			button.pivotX = button.width / 2;
			button.pivotY = button.height / 2;
			button.x = (button.width / 2);
			button.y = (button.height / 2);
			btcontainer.addChild(button);
			
			if (GameData.is_mobile == false)
			{
				select_bg  = new Image(texture);
				select_bg.width = button.width + 8;
				select_bg.height = button.height + 8;
				select_bg.pivotX = select_bg.width / 2;
				select_bg.pivotY = select_bg.height / 2;
				select_bg.x = (select_bg.width / 2) + offsetBG;
				select_bg.y = (select_bg.height / 2) + offsetBG;
				select_bg.alpha = 0;
				btcontainer.addChildAt(select_bg, 0);
			}
			
			shiny_all = new Quad(button.width + 50, button.height + 50, 0xffffff);
			shiny_all.x = -25;
			shiny_all.y = -25;
			shiny_all.alpha = 0;
			
			shiny = new Image(Assets.getAtlas('interface_hud').getTexture('shiny'));
			shiny.width = button.width * 0.4;
			shiny.height = btcontainer.height * 2;
			shiny.alpha = 0.2;
			shiny.y = -btcontainer.height * 0.5;
			shiny.rotation = deg2rad(15);
			shiny.x = -shiny.width;
			
			btcontainer.addEventListener(TouchEvent.TOUCH, onTouchButton);
			addChild(btcontainer);
			
			mask = new PixelMaskDisplayObject(1, true);
			mask.mask = button;
			mask.touchable = false;
			mask.addChild(shiny);
			mask.addChild(shiny_all);
			
			btcontainer.addChild(mask);
			open();
		}
		
		public function open():void
		{
			canTouchThis = true;
			canAnimate = true;
			shiny.x = -shiny.width;
			shiny.alpha = 0;
			shiny_all.alpha = 0;
			
			if(select_bg)
				select_bg.alpha = 0;
			
			animateShiny(2);
		}
		
		public function close():void
		{
			canTouchThis = false;
			canAnimate = false;
			
			if (tweenShiny)
				tweenShiny.kill();
			
			TweenMax.killDelayedCallsTo(animateShiny);
			
			if(select_bg)
				select_bg.alpha = 0;
			
			shiny.x = -shiny.width;
			shiny.alpha = 0;
			shiny_all.alpha = 0;
			
			mask.isAnimated = false;
		}
		
		public function animateShiny(delay:Number = 0):void
		{
			if (canAnimate == true)
			{
				TweenMax.killTweensOf(shiny)
				TweenMax.killTweensOf(shiny_all)
				TweenMax.killDelayedCallsTo(animateShiny);
				
				shiny.x = - shiny.width;
				shiny.alpha = 0.2;
				//shiny_all.alpha = 0;
				mask.isAnimated = true;
				
				TweenMax.to(shiny_all, 0.1, {alpha:0.4, delay:delay, yoyo:true, repeat:1});
				tweenShiny = TweenMax.to(shiny, 0.6, { x:btcontainer.width + shiny.width, alpha:0.2, delay:delay, ease:Sine.easeOut, onComplete:function():void 
				{
					mask.isAnimated = false;
					shiny.x = - shiny.width;
					var delay:Number = 3 + (Math.random() * 5);
					TweenMax.delayedCall(delay, animateShiny);
				} } );
			}
		}
		
		private function onTouchButton(e:TouchEvent):void 
		{
			if (canTouchThis == true)
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
				
				var touchEndedPoint:Point;
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
						
						touchEndedPoint = new Point(touch.globalX, touch.globalY);
						if (stage.hitTest(touchEndedPoint, true) == touchTarget && clickFunction != null)
						{
							clickFunction();
						}
						
						if (outFunction != null)
							outFunction();
						
						e.stopPropagation();
					}
					
					if (touch.phase == TouchPhase.MOVED)
					{
						touchEndedPoint = new Point(touch.globalX, touch.globalY);
						if (stage.hitTest(touchEndedPoint, true) != touchTarget)
						{
							overOut();
							hover = false;
							upState();
							
							e.stopPropagation();
						}
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
				lastPosition.x = btcontainer.x;
				lastPosition.y = btcontainer.y;
				TweenMax.to(btcontainer, 0.1, { x:-(offsetX / 2), y:-(offsetY / 2), ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
			}
		}
		
		public override function upState():void
		{
			down = false;
			TweenMax.to(btcontainer, 0.1, { x:lastPosition.x, y:lastPosition.y, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
		}
		
		public override function over(playsound:Boolean = true):void 
		{
			if (canPlayOver == true && playsound == true)
			{
				SoundManager.playSound("over", "over");
				canPlayOver = false;
				canPlayOut = true;
			}
			
			TweenMax.to(btcontainer, 1, { x:(offsetX / 1.5), y:(offsetY / 1.5), ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
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
				TweenMax.to(btcontainer, 1, { x:(offsetX / 3), y:(offsetY / 3),  ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
			}else
			{
				TweenMax.to(btcontainer, 1, { x:offsetX, y:offsetY, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
			}
		}
		
		public override function select(playsound:Boolean = true):void
		{
			if (GameData.is_mobile == false)
			{
				if(playsound==true)
					SoundManager.playSound("select", "select");
				
				TweenMax.killTweensOf(select_bg);
				select_bg.alpha = 0;
				TweenMax.to(select_bg, 0.1, { alpha:0.7, ease:Sine.easeOut, repeat: -1, yoyo:true } );
				TweenMax.to(btcontainer, 1, { x:offsetX, y:offsetY, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
			}
			
			selected = true;
		}
		public override function unselect():void
		{
			if (GameData.is_mobile == false)
			{
				select_bg.alpha = 0;
				TweenMax.killTweensOf(select_bg);
				TweenMax.to(btcontainer, 1, { x:(offsetX / 3), y:(offsetY / 3),  ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
			}
			selected = false;
		}
	}
}