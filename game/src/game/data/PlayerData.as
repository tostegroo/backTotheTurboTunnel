package game.data 
{
	import flash.display.Stage;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Fabio Toste
	 */
	public class PlayerData 
	{
		public static var debug:Boolean = false;
		public static var debug_alpha:Number = 0.3;
		public static var canDie:Boolean = true;
		
		public static var stageFlash:Stage;
		public static var gamePaused:Boolean = false;
		
		public static var antiGravitySpeedBase:Number = 250;
		public static var antiGravityPowBase:Number = 4;
		public static var moveforce:Point = new Point(980, 580); //new Point(980, 580);
		public static var breakForce:Number = 2.3;
		public static var jumpPower:Number = 800;
		
		public static var speedMax:Number = 6; //4.3; //altera velocidade
		
		public static const IDLE:int = 0;
		public static const RUNNING:int = 1;
		public static const JUMPING:int = 2;
		public static const FALLING:int = 3;
		public static const UPIN:int = 4;
		public static const UPOUT:int = 5;
		public static const DOWNIN:int = 6;
		public static const DOWNOUT:int = 7;
		public static const BACKIN:int = 8;
		public static const BACKOUT:int = 9;
		public static const FRONTIN:int = 10;
		public static const FRONTOUT:int = 11;
		public static const DEAD:int = 12;
		public static const FALLING_FORCE:int = 13;
		
		public static const STATE_LIVE:int = 0;
		public static const STATE_RECOVERY:int = 1;
		public static const STATE_DEAD:int = 2;
		
		public static function reset():void {}
	}
}