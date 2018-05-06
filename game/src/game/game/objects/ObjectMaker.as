package game.game.objects 
{
	import com.greensock.TweenMax;
	import flash.data.SQLResult;
	import game.assets.Device;
	import game.data.GameData;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import game.game.chars.Player;
	
	import game.data.ObjectData;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author Fabio Toste
	 */
	public class ObjectMaker extends Sprite
	{
		private const debug:Boolean = false;
		
		public var canUpdate:Boolean = true;
		public var espera:Boolean = false;
		public var forceCreation:Boolean = false;
		public var updatePosition:Boolean = true;
		
		private var objectMakerSpeed:Number = 0;
		private var objectMakerTime:Number = ObjectData.objectMakerBaseTime;
		
		private var currentLastX:Number = 0;
		private var buffer:Vector.<GameObject> = new Vector.<GameObject>();
		private var stageObjects:Vector.<GameObject> = new Vector.<GameObject>();
		//private var lastIDs:Vector.<int> = new Vector.<int>();
		private var lastId:int = -1;
		private var currObject:int = 0;
		
		public var baseY:Number = 0;
		public var level:String = "";
		public var playerSprite:Player;
		public var timeAlert:Number = 0.3;
		
		public function ObjectMaker(level:String = "level", playerSprite:Player = null)
		{
			this.playerSprite = playerSprite;
			this.level = level;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			updatePositions();
			reset();
		}
		
		public function toggleUpdate():void
		{
			canUpdate = !canUpdate;
			var i:int = 0;
			if (canUpdate == true)
			{
				for (i = 0; i < stageObjects.length; i++) 
				{
					stageObjects[i].alpha = 1;
				}
			}else
			{
				for (i = 0; i < stageObjects.length; i++) 
				{
					stageObjects[i].alpha = 0;
				}
			}
		}
		
		public function updatePositions():void
		{
			GameData.getPositions(function(result:SQLResult):void 
			{
				var output:Point;
				if (result.data != null)
				{
					var numResults:int = result.data.length; 
					for (var i:int = 0; i < numResults; i++) 
					{
						if (result.data[i].deadPosition)
						{
							var pos:int = Math.floor(result.data[i].deadPosition);
							if (pos > 0)
							{
								var cnt:Number = result.data[i].count;
								cnt = (cnt >= 50) ? 5 : (cnt >= 10) ? 4 : (cnt >= 5) ? 3 : (cnt < 5 && cnt >= 3) ? 2 : 1;
								
								if (ObjectData.bonesPosition[pos] == undefined)
									ObjectData.bonesPosition[pos] = cnt;
							}
						}
					}
				}
			});
		}
		
		public function reset():void 
		{
			TweenMax.killDelayedCallsTo(useObject);
			currObject = 0;
			objectMakerSpeed = 0;
			objectMakerTime = ObjectData.objectMakerBaseTime * 15;
			espera = false;
			addChild(playerSprite);
			
			if (debug)
			{
				updatePosition = false;
				espera = true;
				
				var xx:Number = 700;
				for (var i:int = 0; i < ObjectData.objects[this.level].length; i++) 
				{
					var object:GameObject;
					object = new GameObject(i, this.level);
					object.y += baseY;
					object.x = xx;
					object.canUpdate = true;
					stageObjects.push(object);
					this.addChild(object);
					xx += 300;
				}
			}
		}
		
		public function update(groundSpeed:Number, deltaTime:Number = 1/60):void 
		{
			if (canUpdate == true)
			{
				if (updatePosition == true)
					currentLastX -= groundSpeed;
				
				for (var i:int = 0; i < stageObjects.length; i++) 
				{
					var obj:GameObject = GameObject(stageObjects[i]);
					if (obj.canUpdate)
					{
						obj.update(deltaTime);
						if (obj.x > -(obj.trueWidth + 300))
						{
							if (updatePosition == true)
								obj.x -= groundSpeed;
							
							var xMax:Number = (obj.animated == true) ? stage.stageWidth : stage.stageWidth;
							if (obj.x < xMax && obj.x > -obj.trueWidth + 50)
								obj.collisionTest(playerSprite);
							
						}else
						{
							if (buffer.indexOf(obj) == -1)
								buffer.push(obj);
						}
						
						var idx:int = 0;
						if (obj.playerAlign == true)
						{
							idx = (obj.index == 1) ? getChildIndex(playerSprite) + 1 : getChildIndex(playerSprite) - 1;
							idx = (idx < 0) ? 0 : idx;
							idx = (idx > this.numChildren) ? this.numChildren : idx;
							this.setChildIndex(obj, idx);
						}
					}
				}
				
				if (espera == false)
				{
					if (forceCreation==true || objectMakerSpeed >= objectMakerTime) 
					{
						objectMakerSpeed = 0;
						makeObject((ObjectData.objectMakerBaseTime + (Math.random() * ObjectData.objectMakerBaseTimePlus)) / 1);
						forceCreation = false;
					}
					objectMakerSpeed += groundSpeed;
				}
			}
		}
		
		public function makeObject(makeTime:Number = 0):void
		{
			var id:int = Math.floor(Math.random() * ObjectData.objects[this.level].length);
			var chute:int = Math.floor(Math.random() * 20);
			
			id += (id == lastId) ? 1 : 0;
			id = (id > ObjectData.objects[this.level].length - 1) ? 0 : id;
			
			if (ObjectData.objects[this.level][id][0].id == "wall_1b" || ObjectData.objects[this.level][id][0].id == "wall_1c")
			{
				if (chute != 3)
					id = (ObjectData.objects[this.level][id][0].id == "wall_1b") ? 0 : 1;
			}
			
			var object:GameObject;
			for (var i:int = 0; i < buffer.length; i++) 
			{
				if (id == buffer[i].id)
				{
					object = buffer[i];
					object.showElement( -1);
					
					buffer.splice(i, 1);
					break;
				}
			}
			
			if (!object)
			{
				object = new GameObject(id, this.level);
				object.y += baseY;
				stageObjects.push(object);
				this.addChild(object);
			}
			
			espera = true;
			object.canUpdate = false;
			object.x = stage.stageWidth - (object.width + (Device.stageOffset * 0.7));
			
			TweenMax.killTweensOf(object);
			TweenMax.to(object, timeAlert, { alpha:0, yoyo:true, repeat: -1 } );
			
			TweenMax.killDelayedCallsTo(useObject);
			TweenMax.delayedCall(timeAlert, useObject, [object, makeTime]);
			
			lastId = id;
		}
		
		public function useObject(object:GameObject, makeTime:Number):void 
		{
			TweenMax.killTweensOf(object);
			object.alpha = 1;
			object.resetElements();
			object.x = stage.stageWidth + ObjectData.objectMakerBaseX;
			
			currObject ++;
			
			var pos:int = currObject;
			if (ObjectData.bonesPosition[pos] != undefined)
			{
				var id:int = ObjectData.bonesPosition[pos];
				var tid:String = ObjectData.objects[this.level][object.id][0].id;
				
				if (id == 5)
					id = (tid == "wall_1" || tid == "wall_1a") ? 5 : 6;
				
				object.showElement(id-1);
			}
			
			objectMakerTime = makeTime + object.trueWidth;
			object.canUpdate = true;
			espera = false;
		}
	}
}