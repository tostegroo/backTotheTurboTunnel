package game.game.objects 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.Graphics;
	import game.utils.math.MathHelper;
	import starling.display.Quad;
	
	import game.data.ObjectData;
	//import game.game.hud.HUD;
	import game.game.objects.GameElement;
	import game.data.PlayerData;
	import game.game.chars.Player;
	
	import com.greensock.easing.Sine;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	/**
	 * ...
	 * @author Fabio Toste
	 */
	public class GameObject extends Sprite
	{
		public var id:int = 0;
		public var level:String = "";
		public var index:int = 0;
		
		private var caindo:Boolean = true;
		public var trueWidth:Number = 0;
		public var animated:Boolean = false;
		public var playerAlign:Boolean = false;
		public var canUpdate:Boolean = false;
		
		public function GameObject(id:int = 0, level:String = "level") 
		{
			this.id = id;
			this.level = level;
			if (ObjectData.objects[level].length > 0)
			{
				for (var i:int = 0; i < ObjectData.objects[level][id].length; i++) 
				{
					var element:*;
					var obj:Object = ObjectData.objects[level][id][i];
					animated = obj.hasOwnProperty("animate") ? true : false;
					element = new GameElement(obj.id, obj.texture, this.level);
					element.ignoreHit = (obj.hasOwnProperty("ignoreHit")) ? obj.ignoreHit : false;
					element.x = obj.x;
					element.y = obj.y;
					this.name = obj.id;
					this.addChild(element);
					
					trueWidth += element.x + element.width;
				}
			}
		}
		
		public function showElement(id:int = -1):void
		{
			for (var i:int = 0; i < this.numChildren; i++) 
			{
				var element:GameElement = this.getChildAt(i) as GameElement;
				element.showElement(id);
			}
		}
		
		public function resetElements():void
		{
			var idd:int = this.id;
			for (var i:int = 0; i < this.numChildren; i++) 
			{
				var element:GameElement = this.getChildAt(i) as GameElement;
				element.resetHit();
			}
		}
		
		public function collisionTest(hitSprite:Player):void
		{
			var colliding:Boolean = false;
			var spriteHitBox:Rectangle = hitSprite.hitbox.getBounds(this);
			for (var i:int = 0; i < this.numChildren; i++)
			{
				var element:* = this.getChildAt(i);
				if (element.tipo == "element")
				{
					element.collisionTest(hitSprite, spriteHitBox);
					this.index = element.index;
					this.playerAlign = element.playerAlign;
				}else 
				{
					var obj:Rectangle = element.getBounds(this);
					colliding = obj.intersects(spriteHitBox);
					
					if (element.hit==false && colliding == true)
						element.hitItem(hitSprite);
				}
			}
		}
		
		public function update(deltaTime:Number = 1/60):void 
		{
			for (var i:int = 0; i < this.numChildren; i++)
			{
				var element:* = this.getChildAt(i);
				if (element.tipo == "item")
				{
					element.update(deltaTime);
				}
			}
		}
	}
}