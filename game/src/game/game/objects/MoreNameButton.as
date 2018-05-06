package game.game.objects 
{
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Sine;
	import flash.events.DataEvent;
	import flash.geom.Point;
	import game.assets.Assets;
	import game.data.GameData;
	import game.game.sounds.SoundManager;
	import starling.display.DisplayObject;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
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
	public class MoreNameButton extends ButtonObject
	{
		private var textFont:BitmapFont;
		public var txt:TextField;
		private var hover:Boolean = false;
		public var selected:Boolean = false;
		public var down:Boolean = false;
		public var clickFunction:Function = null;
		public var overFunction:Function = null;
		public var outFunction:Function = null;
		
		private var touch:Touch;
		private var touchTarget:DisplayObject;
		
		private var easeConfig:Point = new Point(1.8, 0.5);
		
		public function MoreNameButton() 
		{
			textFont = Assets.getFont("textDisplay");
			textFont.smoothing = TextureSmoothing.TRILINEAR;
			
			var name:String = (GameData.userName == "") ? "adicional name" : GameData.userName;
			txt = new TextField(250, 30, name, textFont.name, 20, 0xFFFFFF);
			txt.hAlign = HAlign.CENTER;
			addChild(txt);
			
			this.pivotX = this.width / 2;
			this.pivotY = this.height / 2;
			
			this.scaleX = this.scaleY = 0.9;
			this.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public function changeText(name:String = ""):void
		{
			txt.text = name;
		}
		
		public function open():void
		{	
		}
		
		public function close():void
		{
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
				TweenMax.to(this, 0.1, { scaleX:0.9, scaleY:0.9, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
			}
		}
		
		public override function upState():void
		{
			down = false;
			TweenMax.to(this, 0.1, { scaleX:1, scaleY:1, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
		}
		
		public override function over(playsound:Boolean = true):void 
		{
			if(playsound==true)
				SoundManager.playSound("over", "over");
			
			TweenMax.to(this, 0.1, { scaleX:1.1, scaleY:1.1, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
		}
		
		public override function overOut(playsound:Boolean = true):void
		{
			if(playsound==true)
				SoundManager.playSound("overOut", "overOut");
			
			if (selected == false)
			{
				TweenMax.to(this, 0.1, { scaleX:1, scaleY:1, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
			}else
			{
				TweenMax.to(this, 0.1, { scaleX:1.05, scaleY:1.05, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
			}
		}
		
		public override function select(playsound:Boolean = true):void
		{
			if (GameData.is_mobile == false)
			{
				if(playsound==true)
					SoundManager.playSound("select", "select");
				
				TweenMax.killTweensOf(this);
				this.alpha = 1;
				TweenMax.to(this, 0.1, { alpha:0.2, ease:Sine.easeOut, repeat: -1, yoyo:true } );
				TweenMax.to(this, 0.1, { scaleX:1.1, scaleY:1.1,  ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
			}
			selected = true;
		}
		public override function unselect():void
		{
			if (GameData.is_mobile == false)
			{
				TweenMax.killTweensOf(this);
				this.alpha = 1;
				TweenMax.to(this, 0.1, { scaleX:1, scaleY:1, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
			}
			selected = false;
		}
	}
}