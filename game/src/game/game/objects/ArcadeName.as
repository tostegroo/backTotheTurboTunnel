package game.game.objects 
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import flash.geom.Point;
	import game.data.GameData;	
	import game.assets.Assets;
	import game.game.sounds.SoundManager;
	import starling.display.Sprite;
	import starling.events.Event;
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
	public class ArcadeName extends Sprite 
	{
		private var letter0:LetterSelect;
		private var letter1:LetterSelect;
		private var letter2:LetterSelect;
		public var selectedName:String = "AAA";
		public var selected:int = 0;
		public var canEdit:Boolean = true;
		private var easeConfig:Point = new Point(1.2, 0.8);
		
		public function ArcadeName() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, remove);
			
			letter0 = new LetterSelect();
			letter0.index = 0;
			letter0.onSelect = selectLetter;
			letter0.afterUpdate = updateName;
			addChild(letter0);
			
			letter1 = new LetterSelect();
			letter1.index = 1;
			letter1.onSelect = selectLetter;
			letter1.afterUpdate = updateName;
			addChild(letter1);
			
			letter2 = new LetterSelect();
			letter2.index = 2;
			letter2.onSelect = selectLetter;
			letter2.afterUpdate = updateName;
			addChild(letter2);
			
			letter0.x = -(letter0.width + letter1.width/2) + 30;
			letter1.x = letter0.x + (letter0.width - 20);
			letter2.x = letter1.x + (letter1.width - 20);
			
			selectLetter(0);
		}
		
		public function selectLetter(index:int = 0, unselect:Boolean = false):void
		{
			if (unselect == false)
			{
				index = (index > 2) ? 0 : index;
				index = (index < 0) ? 2 : index;
			}
			
			for (var i:int = 0; i < 3; i++) 
			{
				if (i == index)
				{
					this["letter" + i].select();
				}else
				{
					this["letter" + i].unselect();
				}
			}
			selected = index;
		}
		
		public function changeLetter(side:int = 0):void
		{
			this["letter" + selected].changeLetter(side);
		}
		
		public function updateName(name:String = ""):void
		{
			var i:int;
			if (name == "")
			{
				for (i = 0; i < 3; i++) 
				{
					name += this["letter" + i].currentLetter;
				}
			}else
			{
				for (i = 0; i < name.length; i++) 
				{
					this["letter" + i].setLetter(name.substr(i, 1));
				}
			}
			selectedName = name;
			GameData.nick = name;
		}
		
		public function select(playsound:Boolean = true, animate:Boolean = true):void
		{
			if (GameData.is_mobile == false)
			{
				if(playsound==true)
					SoundManager.playSound("select", "select");
				
				TweenMax.killTweensOf(this);
				this.alpha = 1;
				TweenMax.to(this, 0.1, { scaleX:1, scaleY:1, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
				
				if (animate == true)
					TweenMax.to(this, 0.1, { alpha:0.2, ease:Sine.easeOut, repeat: -1, yoyo:true } );
			}
		}
		
		public function unselect():void
		{
			if (GameData.is_mobile == false)
			{
				for (var i:int = 0; i < 3; i++) 
				{
					this["letter" + i].unselect();
				}
				
				TweenMax.killTweensOf(this);
				this.alpha = 1;
				TweenMax.to(this, 0.1, { scaleX:0.9, scaleY:0.9, ease:Back.easeIn } );
			}
		}
		
		public function unedit():void
		{
			selectLetter(-1, true);
			canEdit = false;
			
			TweenMax.killTweensOf(this);
			this.alpha = 1;
			TweenMax.to(this, 0.1, { alpha:0.2, ease:Sine.easeOut, repeat: -1, yoyo:true } );
		}
		
		public function edit():void
		{
			selectLetter(0);
			canEdit = true;
			
			TweenMax.killTweensOf(this);
			this.alpha = 1;
		}
		
		private function remove(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, remove);
		}
	}
}