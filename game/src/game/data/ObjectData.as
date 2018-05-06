package game.data 
{
	import flash.utils.Dictionary;
	import game.assets.Assets;
	import starling.utils.deg2rad;
	import game.data.PlayerData;
	/**
	 * ...
	 * @author Fabio Toste
	 */
	public class ObjectData 
	{
		public static var debug:Boolean = false;
		public static var debug_alpha:Number = 0.3;
		
		public static var ObjectGlobaScale:Number = 0.90;
		
		public static var basePixelMeter:Number = 500;
		public static var backgroundMeter:Number = basePixelMeter * 0.1;
		public static var background_L1_Meter:Number = basePixelMeter * 0.3;
		public static var background_L2_Meter:Number = basePixelMeter * 0.4;
		public static var background_L3_Meter:Number = basePixelMeter * 0.5;
		public static var foreground_L1_Meter:Number = basePixelMeter * 1.05;
		public static var foreground_L2_Meter:Number = basePixelMeter * 1.15;
		public static var foreground_L3_Meter:Number = basePixelMeter * 1.2;
		
		public static var bonesPosition:Dictionary = new Dictionary();
		
		//velocidades efeitos e troca de objetos
		public static var objectMakerBaseTime:Number = 380;
		public static var objectMakerBaseTimePlus:Number = 30;
		public static var objectMakerBaseX:Number = 100;
		
		//Itens
		public static var itens:Vector.<Object> = new <Object>[];
		
		//Obstacles
		public static var elements:Array = [];
		elements["wall_1"] = { 
			sizebox: { width:27, height:138, x:64, y:24 },
			zbox: { width:36, height:37, x:30, y:125, trigger:false },
			offsetTop:20,
			offsetBottom:200
		};
		elements["wall_1a"] = { 
			sizebox: { width:27, height:138, x:64, y:24 },
			zbox: { width:36, height:37, x:30, y:125, trigger:false },
			offsetTop:200,
			offsetBottom:20
		};
		elements["wall_1b"] = { 
			sizebox: { width:22, height:45, x:66, y:31 },
			zbox: { width:35, height:34, x:32, y:43, trigger:false },
			offsetTop:200,
			offsetBottom:20
		};
		elements["wall_1c"] = { 
			sizebox: { width:22, height:45, x:66, y:31 },
			zbox: { width:35, height:34, x:32, y:43, trigger:false },
			offsetTop:10,
			offsetBottom:200
		};
		elements["wall_2"] = {
			elementx: 65,
			variationy:70,
			sizebox: { width:32, height:55, x:129, y:86 },
			zbox: { width:103, height:101, x:26, y:38, trigger:false },
			offsetTop:200,
			offsetBottom:200
		};
		elements["wall_3"] = {
			elementx:40,
			variationy:60,
			y:0, 
			basey:30, 
			sizebox: { width:26, height:77, x:114, y:91 },
			zbox: { width:108, height:93, x:7, y:190, trigger:false },
			offsetTop:200,
			offsetBottom:200
		};
		
		//Objects
		public static var objects:Array = [];
		objects["level"] = [
			[ { id:"wall_1a", texture:"wall_1", x:0, y:-55 } ],
			[ { id:"wall_1", texture:"wall_1", x:0, y:-5 } ],
			[ { id:"wall_2", texture:"wall_2", x:0, y:8 } ],
			[ { id:"wall_3", texture:"wall_3", x:0, y:0 } ],
			[ { id:"wall_1a", texture:"wall_1", x:0, y:-55 } ],
			[ { id:"wall_1", texture:"wall_1", x:0, y: -5 } ],
			[ { id:"wall_1a", texture:"wall_1", x:0, y:-55 } ],
			[ { id:"wall_1", texture:"wall_1", x:0, y: -5 } ],
			[ { id:"wall_1b", texture:"wall_1a", x:0, y: -55 } ],
			[ { id:"wall_1c", texture:"wall_1a", x:0, y:-5 } ],
			[ { id:"wall_1a", texture:"wall_1", x:0, y: -55 } ],
			[ { id:"wall_1", texture:"wall_1", x:0, y:-5} ]
		];
	}

}