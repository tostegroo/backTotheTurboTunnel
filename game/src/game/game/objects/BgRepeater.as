package game.game.objects 
{
	import com.greensock.TweenMax;
	
	import starling.display.BlendMode;
	import starling.events.Event;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	import com.greensock.easing.*;
	/**
	 * ...
	 * @author Fabio Toste
	 */
	public class BgRepeater extends Sprite 
	{
		private var objects:Array;
		private var params:Object;
		private var currentLastX:Number = 0;
		private var useWidth:Boolean = true;
		private var random:Boolean = false;
		
		private var elements:Vector.<BgObject> = new Vector.<BgObject>();
		private var elementsOnStage:Vector.<BgObject> = new Vector.<BgObject>();
		private var buffer:Vector.<int> = new Vector.<int>();
		
		public function BgRepeater(objects:Array, params:Object = null) 
		{
			this.objects = objects;
			this.params = params;
			addEventListener(Event.ADDED_TO_STAGE, init);			
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if (params.hasOwnProperty('random'))
			{
				random = params.random;
			}
			
			createSprites();
			placeElements();
		}
		
		private function createSprites():void 
		{
			addElements();
			
			if (params.hasOwnProperty('repeat'))
			{
				var totalRepeat:int = 0;
				if (params.hasOwnProperty('repeatCount'))
				{
					totalRepeat = params.repeatCount -1;
				}else 
				{
					totalRepeat = 10;
					if (elements[0])
					{
						totalRepeat = Math.ceil(stage.stageWidth / elements[0].width);
					}
				}
				
				for (var i:int = 0; i < totalRepeat; i++) 
				{
					addElements();
				}
			}
		}
		
		private function addElements():void
		{
			var img:BgObject
			var length:Number = objects.length;
			for (var i:int = 0; i < length; i++) 
			{
				if (objects[i] is BgObject)
				{
					img = objects[i];
					
				}else if (objects[i] is Texture)
				{
					img = new BgObject(objects[i]);
				}
				
				if (img)
				{
					if (img.xPivot !=0)
					{
						useWidth = false;
						img.pivotX = img.width * img.xPivot;
					}else if (params.hasOwnProperty('pivotX'))
					{
						useWidth = false;
						img.pivotX = img.width * params.pivotX;
					}
					
					if (img.yPivot !=0)
					{
						img.pivotY = img.height * img.yPivot;
					}else if (params.hasOwnProperty('pivotY'))
					{
						img.pivotY = img.height * params.pivotY;
					}
					
					if (img.scale !=0)
					{
						if (img.scale == 100)
						{
							var skl:Number = stage.stageHeight / 768;
							skl = (params.hasOwnProperty('scale')) ? skl * params.scale : skl;
							img.scaleX = img.scaleY = skl;
						}else
						{
							img.scaleX = img.scaleY = img.scale;
						}
					}else if (params.hasOwnProperty('scale'))
					{
						img.scaleX = img.scaleY = params.scale;
					}
					
					elements.push(img);
				}
			}
		}
		
		private function placeElements():void 
		{
			var counter:uint = 0;
			var idx:int = 0;
			var currElement:BgObject;
			while (elements.length > 0) 
			{
				if (params.hasOwnProperty('random'))
				{
					if (params.random)
					{
						var rnd:Number = Math.floor(Math.random() * elements.length);
						elementsOnStage.push(elements[rnd]);
						elements.splice(rnd, 1);
					} else
					{
						elementsOnStage.push(elements[counter]);
						elements.splice(counter, 1);
					}
				} else
				{
					elementsOnStage.push(elements[counter]);
					elements.splice(counter, 1);
				}
				
				currElement = elementsOnStage[elementsOnStage.length - 1];
				currElement.index = elementsOnStage.length - 1;
				
				if (params.hasOwnProperty('yVariation'))
				{
					currElement.y = -currElement.height + currElement.yPos + (Math.random() * (params.yVariation));
				} else
				{
					currElement.y = -currElement.height + currElement.yPos;
				}
				
				var distance:Number;
				if (currElement.xVariation > 0)
				{
					distance = params.distance + (Math.random() * currElement.xVariation);
				} else if (params.hasOwnProperty('distanceVariation'))
				{
					distance = (params.distance + Math.floor(Math.random() * params.distanceVariation));	
				} else
				{
					distance = params.distance;
				}
				
				if (random == true)
				{
					if (currentLastX < stage.stageWidth)
					{
						currElement.x = currentLastX + distance;
					}else
					{
						currElement.x = stage.stageWidth + 100;
						currElement.canUpdate = false;
						buffer.push(elementsOnStage.length - 1);
					}
				}else
				{
					currElement.x = currentLastX;
				}
				
				if (useWidth)
				{
					currentLastX += Math.floor(currElement.width + distance);
				}else 
				{
					currentLastX += Math.floor(distance);
				}
				
				generateAnimation(currElement);
				this.addChild(currElement);
			}
			counter ++;
		}
		
		private function generateAnimation(currElement:*):void 
		{
			if (params.hasOwnProperty('animation'))
			{
				var paramsTween:Object = {};
				var time:Number = 0;
				var pivotX:Number = (params.hasOwnProperty('pivotX')) ? params.pivotX : 0;
				var pivotY:Number = (params.hasOwnProperty('pivotY')) ? params.pivotY : 0;
				var rotIni:Number = 0;
				var randomDelay:Number = 1;
				var w:Number = currElement.width;
				
				for (var param:String in params.animation) 
				{
					if (param == "randomDelay")
					{
						if (params.animation[param] == true)
						{
							randomDelay = Math.random();
						}else
						{
							randomDelay = 1;
						}
					}else if (param == "time")
					{
						time = params.animation[param];
					}else if (param == "pixotX")
					{
						pivotX = params.animation[param];
					}else if (param == "pixotY")
					{
						pivotY = params.animation[param];
					}else if (param == "rotIni")
					{
						rotIni = params.animation[param];
					}else
					{
						if (param == "y")
						{
							paramsTween[param] = currElement.yPos + currElement.y + params.animation[param];
						}else
						{
							paramsTween[param] = params.animation[param];
						}
					}
				}
				
				if (paramsTween.hasOwnProperty('delay'))
				{
					paramsTween.delay *= randomDelay;
				}
				if (paramsTween.hasOwnProperty('repeatDelay'))
				{
					paramsTween.repeatDelay *= randomDelay;
				}
				currElement.pivotX = w * pivotX;
				currElement.pivotY = w * pivotY;
				currElement.rotation = rotIni;
				
				TweenMax.killTweensOf(currElement);
				TweenMax.to(currElement, time, paramsTween);
			}
		}
		
		public function update(val:Number):void 
		{
			currentLastX -= val;
			var child:BgObject;
			var w:Number = 0;
			for (var i:int = 0; i < numChildren; i++) 
			{
				child = getChildAt(i) as BgObject;
				
				if (child.canUpdate == true)
				{
					child.x -= val;
					w = child.width;
					if (child.x <= -(w + this.x)) 
					{
						if (random == true)
						{
							var rnd:int = Math.floor(Math.random() * buffer.length);
							var bgobj:BgObject = elementsOnStage[buffer[rnd]];
							bgobj.canUpdate = true;
							buffer.splice(rnd, 1);
							
							child.canUpdate = false;
							child.x = stage.stageWidth + 100;
							buffer.push(child.index);
							
							child = bgobj;
						}
						
						var distance:Number;
						if (child.xVariation > 0)
						{
							distance = (params.distance + (Math.random() * child.xVariation));
						} else if (params.hasOwnProperty('distanceVariation'))
						{
							distance = params.distance + (Math.random() * params.distanceVariation);	
						} else
						{
							distance = params.distance;
						}
						
						if (child.xVariation > 0)
						{
							child.y = -child.height + child.yPos + (Math.random() * (child.yVariation));
						} else if (params.hasOwnProperty('yVariation'))
						{
							child.y = -child.height + child.yPos + (Math.random() * (params.yVariation));
						} else
						{
							child.y = child.yPos -child.height;
						}
						
						var xx:Number = currentLastX + distance;
						xx = ( random==true && xx < stage.stageWidth + 100) ? stage.stageWidth + 100 : xx;
						
						child.x = xx;
						if (useWidth)
						{
							currentLastX += Math.floor(w + distance);
						}else 
						{
							currentLastX += Math.floor(distance);
						}
						generateAnimation(child);
					}
				}
			}
		}
		
	}

}