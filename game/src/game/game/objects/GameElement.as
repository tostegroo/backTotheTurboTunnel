package game.game.objects 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import game.data.GameData;
	import game.game.sounds.SoundManager;
	import game.utils.math.MathHelper;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.display.Quad;
	
	import game.game.chars.Player;
	import game.assets.Assets;
	import game.data.ObjectData;
	import game.data.PlayerData;
	
	
	/**
	 * ...
	 * @author Fabio Toste
	 */
	public class GameElement extends Sprite
	{
		private var localPoint:Point = new Point(0, 0);
		private var globalPoint:Point = new Point(0, 0);
		private var colliding:Boolean = false;
		private var collidingY:Boolean = true;
		private var collidingZ:Boolean = true;
		
		public var tipo:String = "element";
		public var index:int = 0;
		public var playerAlign:Boolean = false;
		
		public var hit:Vector.<Boolean> = new Vector.<Boolean>();
		public var hitBox:Vector.<Object> = new Vector.<Object>();
		
		public var bitmap:Image;
		public var ignoreHit:Boolean = false;
		public var elements:Sprite;
		
		public var minOffset:Point = new Point(50, 0);
		public var maxOffset:Point = new Point(50, 0);
		
		public var boundBox:Quad;
		public var sizebox:Quad;
		public var zbox:Quad;
		public var zboxTrigger:Boolean = true;
		public var zboxRect:Rectangle = new Rectangle(0, 0, 0, 0);
		public var sizeRect:Rectangle = new Rectangle(0, 0, 0, 0);
		public var basePosition:Point = new Point(0, 0);
		public var hitZ:Boolean = false;
		public var passsed:Boolean = false;
		public var offsetTop:Number = 0;
		public var offsetBottom:Number = 0;
		public var offsetLeft:Number = 0;
		public var offsetRight:Number = 0;
		
		public var d:Point = new Point(0, 0);
		public var last_d:Point = new Point(0, 0);
		
		public var id:String;
		public var texture:String;
		public var level:String;
		public var scale:Number = 1 / Assets.textureScale;
		public var hasHiddenElement:Boolean = true;
		
		public function GameElement(id:String = "", texture:String = "", level:String = "") 
		{	
			this.level = level;
			this.id = id;
			this.texture = texture;
			
			bitmap = new Image(Assets.getAtlas(level).getTexture(texture));
			//bitmap.smoothing = TextureSmoothing.NONE;
			bitmap.x = (ObjectData.elements[id].hasOwnProperty("x")) ? ObjectData.elements[id].x * bitmap.scaleX: 0;
			bitmap.y = (ObjectData.elements[id].hasOwnProperty("y")) ? -(bitmap.height + (ObjectData.elements[id].y * bitmap.scaleY)): -bitmap.height;
			this.addChild(bitmap);
			
			boundBox = new Quad(bitmap.width + maxOffset.x + minOffset.x, bitmap.height + maxOffset.y + minOffset.y, 0x000000);
			boundBox.alpha = (ObjectData.debug==true) ? 0.3 : 0;
			boundBox.y = bitmap.y - minOffset.y;
			boundBox.x = bitmap.x - minOffset.x;
			this.addChild(boundBox);
			
			basePosition.x = (ObjectData.elements[id].hasOwnProperty("basex")) ? ObjectData.elements[id].basex : 0;
			basePosition.y = (ObjectData.elements[id].hasOwnProperty("basey")) ? ObjectData.elements[id].basey : 0;
			
			offsetTop = (ObjectData.elements[id].hasOwnProperty("offsetTop")) ? ObjectData.elements[id].offsetTop : 0;
			offsetBottom = (ObjectData.elements[id].hasOwnProperty("offsetBottom")) ? ObjectData.elements[id].offsetBottom : 0;
			offsetLeft = (ObjectData.elements[id].hasOwnProperty("offsetLeft")) ? ObjectData.elements[id].offsetLeft : 0;
			offsetRight = (ObjectData.elements[id].hasOwnProperty("offsetRight")) ? ObjectData.elements[id].offsetRight : 0;
			
			var obj:Object;
			var height:Number;
			var xx:Number;
			var width:Number;
			var yy:Number;
			var i:int;
			
			if (ObjectData.elements[id].hasOwnProperty("hitbox"))
			{
				var rotation:Number;
				var losePoints:int;
				var trigger:Boolean;
				var index:int;
				for (i = 0; i < ObjectData.elements[id].hitbox.length ; i++) 
				{
					obj = ObjectData.elements[id].hitbox[i];
					
					xx = (obj.hasOwnProperty("x")) ? bitmap.x + (obj.x * scale): bitmap.x;
					yy = (obj.hasOwnProperty("y")) ? bitmap.y + (obj.y * scale) :  -(height + ObjectData.elements[id].y);
					width = (obj.hasOwnProperty("width")) ? (obj.width * scale): bitmap.width - xx;
					height = (obj.hasOwnProperty("height")) ? (obj.height * scale) : bitmap.height;
					losePoints = (obj.hasOwnProperty("losePoints")) ? obj.losePoints :  1;
					rotation = (obj.hasOwnProperty("rotation")) ? obj.rotation : 0;
					trigger = (obj.hasOwnProperty("trigger")) ? obj.trigger : true;
					
					index = hitBox.push({box:new Quad(width, height, 0xFF0000), type:obj.type, losePoints:losePoints, trigger:trigger}) - 1;
					hit.push(false);
					hitBox[index].box.alpha = (ObjectData.debug == true) ? ObjectData.debug_alpha : 0;
					hitBox[index].box.absoluteWidth = hitBox[index].box.width;
					hitBox[index].box.absoluteHeight = hitBox[index].box.height;
					hitBox[index].box.pivotX = hitBox[index].box.width / 2;
					hitBox[index].box.pivotY = hitBox[index].box.height / 2;
					hitBox[index].box.y = yy + (hitBox[index].box.height / 2);
					hitBox[index].box.x = xx + (hitBox[index].box.width / 2);
					hitBox[index].box.rotation = rotation;
					this.addChild(hitBox[index].box);
				}
			}
			
			if (ObjectData.elements[id].hasOwnProperty("sizebox"))
			{
				obj = ObjectData.elements[id].sizebox;
				xx = (obj.hasOwnProperty("x")) ? bitmap.x + (obj.x * scale) : bitmap.x;
				yy = (obj.hasOwnProperty("y")) ? bitmap.y + (obj.y * scale) :  -(height + ObjectData.elements[id].y);
				width = (obj.hasOwnProperty("width")) ? (obj.width * scale) : bitmap.width - xx;
				height = (obj.hasOwnProperty("height")) ? (obj.height * scale) : bitmap.height;
				
				sizebox = new Quad(width, height, 0x0000FF);
				sizebox.alpha = (ObjectData.debug==true) ? ObjectData.debug_alpha : 0;
				sizebox.y = yy;
				sizebox.x = xx;
				this.addChild(sizebox);
			}
			
			if (ObjectData.elements[id].hasOwnProperty("zbox"))
			{
				obj = ObjectData.elements[id].zbox;
				xx = (obj.hasOwnProperty("x")) ? bitmap.x + (obj.x * scale): bitmap.x;
				yy = (obj.hasOwnProperty("y")) ? bitmap.y + (obj.y * scale) :  -(height + ObjectData.elements[id].y);
				width = (obj.hasOwnProperty("width")) ? (obj.width * scale) : bitmap.width - xx;
				height = (obj.hasOwnProperty("height")) ? (obj.height * scale) : bitmap.height;
				zboxTrigger = (obj.hasOwnProperty("trigger")) ? obj.trigger : true;
				
				zbox = new Quad(width, height, 0x00FF00);
				zbox.alpha = (ObjectData.debug == true) ? ObjectData.debug_alpha : 0;
				
				var offsetY:Number = (ObjectData.elements[id].hasOwnProperty("y")) ? ObjectData.elements[id].y : 0;
				zbox.y = yy + offsetY;
				zbox.x = xx;
				this.addChild(zbox);
			}
			
			if (hasHiddenElement == true)
			{
				elements = new Sprite();
				var img:Image;
				for (i = 0; i < 6; i++) 
				{
					var ex:Number = (ObjectData.elements[id].hasOwnProperty("elementx")) ? ObjectData.elements[id].elementx : 0;
					
					img = new Image(Assets.getAtlas(level).getTexture('bones_' + (i + 1)));
					img.x = (i == 4 || i == 5) ? ex - 38: ex -32;
					img.y = - img.height - 8;
					img.alpha = 0.98;
					img.visible = false;
					elements.addChild(img);
				}
				addChild(elements);
			}
		}
		
		public function showElement(id:int = -1):void
		{
			if (elements)
			{
				var img:Image;
				for (var i:int = 0; i < elements.numChildren; i++) 
				{
					img = elements.getChildAt(i) as Image;
					
					if (id == i)
					{
						var vy:Number = (ObjectData.elements[this.id].hasOwnProperty("variationy")) ? ObjectData.elements[this.id].variationy : 0;
						var ex:Number = (ObjectData.elements[this.id].hasOwnProperty("elementx")) ? ObjectData.elements[this.id].elementx : 0;
						
						img.y = - img.height - 8 - (Math.random() * vy);
						var pctx:Number = Math.abs(img.y - zbox.y) / (zbox.height - img.height);
						pctx  = (pctx  < 0) ? 0 : pctx;
						pctx  = (pctx > 1) ? 1 : pctx;
						
						img.x = (i == 4 || i == 5) ? ex - 38: ex -32;
						img.x -= (vy > 0) ? zbox.width * (1 - pctx) * 0.7 : 0;
						
						img.visible = true;
					}else 
					{
						img.visible = false;
					}
				}
			}
		}
		
		public function collisionTest(hitSprite:Player, spriteHitBox:Rectangle):void 
		{
			collidingY = true;
			collidingZ = true;
			
			localPoint.setTo(this.boundBox.x, this.boundBox.y);
			globalPoint = localToGlobal(localPoint);
			var left:Number = globalPoint.x;
			var right:Number = globalPoint.x + boundBox.width;
			var top:Number = globalPoint.y;
			var buttom:Number = globalPoint.y + boundBox.height;
			
			localPoint.setTo(hitSprite.boundbox.x, hitSprite.boundbox.y);
			globalPoint = hitSprite.boundbox.localToGlobal(localPoint);
			var hitLeft:Number = globalPoint.x;
			var hitRight:Number = globalPoint.x + hitSprite.boundbox.width;
			var hitTop:Number = globalPoint.y;
			var hitButtom:Number = globalPoint.y + hitSprite.boundbox.height;
			var overlapJump:Number = 0;
			
			var sizeX:Number = 10;
			var sizeY:Number = 10;
			var lastOffset:Number = 0;
			
			if (ignoreHit == false)
			{
				playerAlign = (hitRight > left && hitLeft < right) ? true : false;
				if (playerAlign)
				{
					if (this.sizebox != null)
					{
						sizeX = sizebox.width;
						sizeY = sizebox.height;
					}
					
					collidingY = (Math.abs(hitSprite.positionY) < Math.abs(this.basePosition.y) + sizeY && Math.abs(hitSprite.positionY) >= Math.abs(this.basePosition.y)) ? true : false;
					
					if (this.zbox != null)
					{
						localPoint.setTo(zbox.x, zbox.y);
						globalPoint = localToGlobal(localPoint);							
						zboxRect.x = globalPoint.x;
						zboxRect.width = zbox.width;
						zboxRect.y = globalPoint.y;
						zboxRect.height = zbox.height;
						
						localPoint.setTo(sizebox.x, sizebox.y);
						globalPoint = localToGlobal(localPoint);							
						sizeRect.x = globalPoint.x;
						sizeRect.width = sizebox.width;
						sizeRect.y = globalPoint.y;
						sizeRect.height = sizebox.height;
						
						collidingZ = (hitSprite.zboxRect.bottom > (zboxRect.top - offsetTop) && hitSprite.zboxRect.top < (zboxRect.bottom + offsetBottom)) ? true : false;
						if (collidingZ)
						{
							var pctZ:Number = (hitSprite.zboxRect.bottom - zboxRect.top) / (zboxRect.height + hitSprite.zboxRect.height);
							if (hitSprite.zboxRect.right > zboxRect.left + (zboxRect.width * pctZ) && hitSprite.zboxRect.left < zboxRect.left + (zboxRect.width * pctZ) + sizeX)
							{
								if (collidingY)
								{
									if (zboxTrigger == true)
									{
										hitItem(hitSprite, 0);
									}else
									{
										var overlapLeft:Number = ((zboxRect.left + (zboxRect.width * pctZ)) - offsetLeft) - hitSprite.zboxRect.right;
										var overlapRight:Number = ((zboxRect.left + (zboxRect.width * pctZ) + sizeX) + offsetRight) - hitSprite.zboxRect.left;
										var overlapTop:Number = (zboxRect.top - offsetTop) - hitSprite.zboxRect.bottom;
										var overlapBottom:Number = (zboxRect.bottom + offsetBottom) - hitSprite.zboxRect.top;
										
										if (
											Math.abs(overlapLeft) < Math.abs(overlapTop) && 
											Math.abs(overlapLeft) < Math.abs(overlapRight) &&
											Math.abs(overlapLeft) < Math.abs(overlapBottom)
										)
										{
											hitSprite.offsetPosition.x = overlapLeft;
											hitElement(hitSprite);
										}
										if (
											Math.abs(overlapRight) < Math.abs(overlapLeft) && 
											Math.abs(overlapRight) < Math.abs(overlapBottom) && 
											Math.abs(overlapRight) < Math.abs(overlapTop)
										)
										{
											hitSprite.offsetPosition.x = overlapRight;
										}
										
										if (
											Math.abs(overlapTop) < Math.abs(overlapLeft) && 
											Math.abs(overlapTop) < Math.abs(overlapRight) && 
											Math.abs(overlapTop) < Math.abs(overlapBottom)
										)
										{
											hitSprite.offsetPosition.y = overlapTop;
										}
										if (
											Math.abs(overlapBottom) < Math.abs(overlapLeft) && 
											Math.abs(overlapBottom) < Math.abs(overlapRight) && 
											Math.abs(overlapBottom) < Math.abs(overlapTop)
										)
										{
											hitSprite.offsetPosition.y = overlapBottom;
										}
									}
								}
								
								if (hitSprite.positionY + hitSprite.sizebox.height > Math.abs(basePosition.y))
								{
									overlapJump = ((hitSprite.positionY + hitSprite.sizebox.height) - Math.abs(basePosition.y));
									lastOffset = hitSprite.offsetY;
									hitSprite.offsetY = (overlapJump > 0) ? 500 : 0;
									if (hitSprite.jumpPos < 0 && hitSprite.offsetY==500 && this.id=="wall_3")
									{
										hitSprite.stopJump(true);
										hitElement(hitSprite);
									}
								}
							}
						}
						index = (hitSprite.zboxRect.left < (zboxRect.left + (zboxRect.width * pctZ)) && hitSprite.zboxRect.bottom > (zboxRect.top + 10)) ? 0 : 1;
						index = (hitSprite.zboxRect.top >= (zboxRect.bottom - 10)) ? 0 : index;
						index = (hitSprite.sizeRect.right < (sizeRect.left + sizeRect.width) && hitSprite.zboxRect.bottom > zboxRect.top) ? 0 : index;
					}
					
					if (Math.abs(basePosition.y) > 0 )
					{
						index = (hitSprite.positionY > 5 && hitSprite.zboxRect.left < zboxRect.left) ? 0 : 1;
						index = (hitSprite.sizeRect.right < sizeRect.left) ? 0 : index;
					}
					
					if (collidingZ && collidingY && hitBox.length > 0)
					{
						var obj:Rectangle;
						for (var j:int = 0; j < hitBox.length; j++) 
						{
							obj = hitBox[j].box.getBounds(this);
							if (hitBox[j].trigger == true)
							{
								if (hitBox[j].box.rotation == 0 && hitSprite.hitbox.rotation==0)
									colliding = obj.intersects(spriteHitBox);
								else
									colliding = MathHelper.intersectsSAT(this.hitBox[j].box, hitSprite.hitbox);
								
								if (hit[j]==false && colliding == true)
									hitItem(hitSprite, j);
							}
						}
					}
					
					if (hitSprite.zboxRect.left > zboxRect.right && passsed==false)
					{
						SoundManager.playSound("pass");
						GameData.main.game.gameHUD.updatePoint( +1);
						passsed = true;
					}
				}
			}
		}
		
		public function getPlataformLevel(hitSprite:Player):int
		{
			var height:Number = 0;
			if (ObjectData.elements[id].hasOwnProperty("plataforms"))
			{
				var vX:Number;
				var vWidth:Number;
				var hsX:Number;
				var hh:Number;
				for (var i:int = 0; i < ObjectData.elements[id].plataforms.length; i++) 
				{
					vX = (ObjectData.elements[id].plataforms[i].hasOwnProperty("x")) ? (ObjectData.elements[id].plataforms[i].x * scale) : 0;
					vWidth = (ObjectData.elements[id].plataforms[i].hasOwnProperty("width")) ? (ObjectData.elements[id].plataforms[i].width * scale) : (this.width - vX);
					localPoint.setTo(this.x, this.y)
					globalPoint = this.localToGlobal(localPoint);
					hsX = hitSprite.x + hitSprite.hitbox.x + hitSprite.hitbox.width;
					hh = (ObjectData.elements[id].plataforms[i].y * scale);
					
					if (Math.abs(hitSprite.y-hitSprite.realY) >= hh && hsX >= ((globalPoint.x - this.x) + vX) && hitSprite.x + hitSprite.hitbox.x <= ((globalPoint.x - this.x) + vX) + vWidth)
					{
						var nheight:Number = hh;
						if (nheight >= height)
						{
							height = nheight;
						}
					}
				}
			}
			return height;
		}
		
		public function hitItem(hitSprite:Player, hitIndex:int = 0):void
		{
			if (hit.length > 0 && hit[hitIndex] == false)
			{
				hit[hitIndex] = true;
				if (hitSprite.state == PlayerData.STATE_LIVE)
				{
					hitSprite.hitObject(hitBox[hitIndex].type, this.id);
				}
			}
		}
		
		public function hitElement(hitSprite:Player):void
		{
			if (hitZ == false)
			{
				hitZ = true;
				if (hitSprite.state == PlayerData.STATE_LIVE)
				{
					hitSprite.hitObject(PlayerData.STATE_DEAD, this.id);
				}
			}
		}
		
		public function resetHit():void
		{
			passsed = false;
			hitZ = false;
			for (var i:int = 0; i < hit.length ; i++) 
			{
				hit[i] = false;
			}
		}
	}
}