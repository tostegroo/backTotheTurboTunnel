package game.game.objects 
{
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import starling.display.Image;
	import starling.utils.deg2rad;
	
	import game.assets.Assets;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.TextureSmoothing;
	import starling.utils.HAlign;
	/**
	 * ...
	 * @author eu mesmo
	 */
	public class LetterSelect extends Sprite
	{
		private var letterContainer:Sprite;
		private var textFont:BitmapFont;
		private var shadow:TextField;
		private var letter:TextField;
		private var arrowUp:Image;
		private var arrowDown:Image;
		private var touch:Boolean = false;
		private var chars:Vector.<String> = new < String > ["_", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "X", "Y", "W", "Z", "*", "!", ")", "(", ";", ":"];
		private var currentChar:int = 0;
		private var selected:Boolean = false;
		public var currentLetter:String = "_";
		public var afterUpdate:Function = null;
		
		public var index:int = 0;
		public var onSelect:Function = null;
		
		private var moveCount:Number = 0;
		
		public function LetterSelect() 
		{
			textFont = Assets.getFont("textDisplay");
			textFont.smoothing = TextureSmoothing.TRILINEAR;
			
			letterContainer = new Sprite();
			
			shadow = new TextField(90, 130, "_", textFont.name, 118, 0x000000);
			shadow.hAlign = HAlign.CENTER;
			shadow.x = -(shadow.width / 2) + 3;
			shadow.y = -(shadow.height / 2) + 4;
			letterContainer.addChild(shadow);
			
			letter = new TextField(90, 130, "_", textFont.name, 118, 0xFFFFFF);
			letter.hAlign = HAlign.CENTER;
			letter.x = -letter.width / 2;
			letter.y = -letter.height / 2;
			letterContainer.addChild(letter);
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			
			addChild(letterContainer);
			
			arrowUp = new Image(Assets.getAtlas('interface_hud').getTexture('letters_arrow'));
			arrowUp.pivotX = arrowUp.width / 2;
			arrowUp.pivotY = arrowUp.height / 2;
			arrowUp.alpha = 0;
			arrowUp.rotation = -deg2rad(2);
			arrowUp.y = -(letter.height / 2) - 14;
			arrowUp.x = 0;
			addChild(arrowUp);
			arrowUp.addEventListener(TouchEvent.TOUCH, onTouchUp);
			
			arrowDown = new Image(Assets.getAtlas('interface_hud').getTexture('letters_arrow'));
			arrowDown.pivotX = arrowDown.width / 2;
			arrowDown.pivotY = arrowDown.height / 2;
			arrowDown.alpha = 0;
			arrowDown.rotation = -deg2rad(178);
			arrowDown.y = (letter.height / 2) - 10;
			arrowDown.x = 0;
			addChild(arrowDown);
			arrowDown.addEventListener(TouchEvent.TOUCH, onTouchDown);
		}
		
		private function onTouchUp(e:TouchEvent):void 
		{
			if (e.getTouch(this, TouchPhase.ENDED))
			{
				changeLetter(1);
			}
			e.stopPropagation();
		}
		
		private function onTouchDown(e:TouchEvent):void 
		{
			if (e.getTouch(this, TouchPhase.ENDED))
			{
				changeLetter(-1);
			}
			e.stopPropagation();
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			if (e.getTouch(this, TouchPhase.BEGAN))
			{
				moveCount = 0;
				touch = true;
				if (onSelect != null)
					onSelect(index);
				
			}else if (e.getTouch(this, TouchPhase.MOVED))
			{
				if (touch == true)
				{
					var my:Number = e.getTouch(this).getMovement(this).y;
					var side:int = (my > 0) ? -1 : (my < 0) ? 1 : 0;
					
					if((side==-1 && moveCount>0) || (side==1 && moveCount<0))
						moveCount = 0;
					
					my = (Math.abs(my) / 40) * side;
					moveCount += my;
					
					if (Math.abs(moveCount) > 1)
					{
						changeLetter(moveCount);
						moveCount = 0;
					}	
				}
			}else if (e.getTouch(this, TouchPhase.ENDED))	
			{
				moveCount = 0;
				touch = false;
			}
			e.stopPropagation();
		}
		
		public function select():void
		{
			if (selected == false)
			{
				selected = true;
				letterContainer.alpha = 1;
				TweenMax.to(letterContainer, 0.1, { alpha:0, repeat: -1, yoyo:true } );
				
				TweenMax.to(arrowUp, 0.1, { alpha:1 } );
				TweenMax.to(arrowDown, 0.1, { alpha:1 } );
				
				TweenMax.to(this, 0.06, {y:-12, scaleX:1.1, scaleY:1.1, ease:Sine.easeInOut});
			}
		}
		
		public function unselect():void
		{
			if (selected == true)
			{
				selected = false;
				TweenMax.killTweensOf(letterContainer);
				letterContainer.alpha = 1;
				
				TweenMax.to(arrowUp, 0.1, { alpha:0 } );
				TweenMax.to(arrowDown, 0.1, { alpha:0 } );
				
				TweenMax.to(this, 0.06, {y:0, scaleX:1, scaleY:1, ease:Sine.easeInOut});
			}
		}
		
		public function changeLetter(side:int = 0):void
		{
			var char:int = currentChar + side;
			char = (char < 0) ? chars.length-1 : char;
			char = (char > chars.length-1) ? 0 : char;
			
			letter.text = chars[char];
			shadow.text = chars[char];
			currentChar = char;
			currentLetter = chars[char];
			
			if (afterUpdate != null)
				afterUpdate();
		}
		
		public function setLetter(charLetter:String = ""):void
		{
			var ch:int = chars.indexOf(charLetter);
			if (ch != -1)
			{
				letter.text = charLetter;
				shadow.text = charLetter;
				currentLetter = charLetter;
				currentChar = ch;
			}
		}
	}
}