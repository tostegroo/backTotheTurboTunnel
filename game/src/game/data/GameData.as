package game.data 
{
	import flash.data.SQLCollationType;
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement; 
	import flash.errors.SQLError;
	import flash.events.IOErrorEvent;
	import mx.utils.UIDUtil;
	import game.core.Notification;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.SQLErrorEvent; 
	import flash.events.SQLEvent; 
	import flash.filesystem.File;
	import flash.display.Stage;
	
	import com.adobe.serialization.json.JSON;
	
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import game.core.Main;
	import game.game.Game;
	/**
	 * ...
	 * @author Fabio Toste
	 */
	public class GameData
	{
		public static var gravity:Number = 2800;
		
		public static var fullofwin:int = 1000;
		public static var riff:int = 50;
		
		public static var debug:Boolean = false;
		public static var gamePaused:Boolean = false;
		public static var pauseScreen:Boolean = false;
		public static var stageFlash:Stage;
		public static var position:Number = 0;
		public static var points:int = 0;
		public static var hiscore:int = 0;
		public static var nick:String = "AAA";
		public static var uid:String = "";
		public static var userName:String = "";
		public static var fid:String = "";
		public static var overlayAlpha:Number = 0.7;
		public static var main:Main;
		public static var inputType:String = "keyboard";
		public static var can_exit:Boolean = true;
		public static var is_mobile:Boolean = false;
		public static var is_touch:Boolean = false;
		
		public static var infoURLLink:String = "http://bogdoggames.com/turbotunnel/info";
		public static var rankingURLSite:String = "http://bogdoggames.com/turbotunnel/ranking";
		
		private static var conn:SQLConnection;
		private static var dbCreatedFunction:Function = null;
		private static var updateURL:String = "http://bogdoggames.com/turbotunnel/update.php";
		private static var rankingURL:String = "http://bogdoggames.com/turbotunnel/ranking.php";
		private static var positionsURL:String = "http://bogdoggames.com/turbotunnel/positions.php";
		private static var infoURl:String = "http://bogdoggames.com/turbotunnel/info.php";
		
		public static function updateServerData(data:* = null):void
		{
			if (Notification.getNetWorkStatus() == true && data != null)
			{
				var requestVars:URLVariables = new URLVariables();
				requestVars.data = com.adobe.serialization.json.JSON.encode(data);
				
				var data:Object = null;
				var loader:URLLoader = new URLLoader();
				var request:URLRequest = new URLRequest(updateURL);
				request.method = URLRequestMethod.POST;
				request.data = requestVars;
				loader.addEventListener(ErrorEvent.ERROR, onErrorUpdateServerData);
				loader.addEventListener(Event.COMPLETE, onCompleteUpdateServerData);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onFailureSD);
				loader.load(request);
			}
		}
		
		static private function onFailureSD(e:IOErrorEvent):void 
		{
			trace("Error ID:", e.errorID, "Error Type:", e.type, "Error Text:", e.text); 
		}
		
		static private function onCompleteUpdateServerData(e:Event):void 
		{
			var loader: URLLoader = URLLoader(e.target);
			if (loader.data == '1' || loader.data == 1)
			{
				var sql:String = "UPDATE gameData SET submitted=1 WHERE submitted=0;";
				executeSQL(sql);
			}
		}
		
		static private function onErrorUpdateServerData(e:ErrorEvent):void 
		{
			trace("Error ID:", e.errorID, "Error Type:", e.type, "Error Text:", e.text); 
		}
		
		public static function getServerData(url:String = "", onSuccess:Function = null, onError:Function = null):void
		{
			if (Notification.getNetWorkStatus() == true && url != "")
			{
				var request:URLRequest = new URLRequest(url);
				var loader:URLLoader = new URLLoader();
				
				if (onError != null)
				{
					loader.addEventListener(ErrorEvent.ERROR, onError);
				}else
				{
					loader.addEventListener(ErrorEvent.ERROR, onErrorGetServerData);
				}
				
				if(onSuccess!=null)
					loader.addEventListener(Event.COMPLETE, onSuccess);
				
				loader.addEventListener(IOErrorEvent.IO_ERROR, onFailure);
				
				loader.load(request);
			}else
			{
				if (onError != null)
					onError({errorID:"0001", type:"Connection error", text:"No Internet Connection"});
			}
		}
		
		static private function onFailure(e:IOErrorEvent):void 
		{
			trace("Error ID:", e.errorID, "Error Type:", e.type, "Error Text:", e.text); 
		}
		
		static private function onErrorGetServerData(e:ErrorEvent):void 
		{
			trace("Error ID:", e.errorID, "Error Type:", e.type, "Error Text:", e.text);
		}
		
		public static function createDBConnection(callback:Function = null):void
		{
			conn = new SQLConnection();
			conn.addEventListener(SQLEvent.OPEN, openDB); 
			conn.addEventListener(SQLErrorEvent.ERROR, errorDB);
			dbCreatedFunction = callback;
			
			var folder:File = File.applicationStorageDirectory; 
			var dbFile:File = folder.resolvePath("gamedata.db");
			conn.openAsync(dbFile);
		}
		
		public static function addUserInfo(name:String = "", nick:String = "*_*", fid:String = "", points:int = 0, position:Number = 0, useAsRanking:int = 0, callback:Function = null):void
		{
			var sql:String =  
			"INSERT INTO gameData (name, nick, fid, totalPoints, deadPosition, useAsRanking) " +  
			"VALUES ('" + name + "', '" + nick + "', '" + fid + "', " + points + ", " + position + ", " + useAsRanking + ")";
			
			executeSQL(sql, function(e:SQLEvent):void 
			{
				if (callback != null)
					callback();
			});
		}
		
		public static function getHiscore(callback:Function = null):void
		{
			var sql:String =  
			"SELECT totalPoints FROM gameData ORDER BY totalPoints DESC LIMIT 1;";
			
			executeSQL(sql, function(e:SQLEvent):void 
			{
				var hiscore:int = 0;
				var result:SQLResult = e.target.getResult();
				if (result.data != null)
				{
					var numResults:int = result.data.length; 
					for (var i:int = 0; i < numResults; i++) 
					{ 
						hiscore = result.data[i].totalPoints;
					}
				}
				
				if (callback != null)
					callback(hiscore);
			});
		}
		
		public static function updateUserInfo(callback:Function = null):void
		{
			var sql:String = "SELECT * FROM gameData WHERE submitted=0;";
			executeSQL(sql, function(e:SQLEvent):void 
			{
				var result:SQLResult = e.target.getResult();
				if (result.data != null)
				{
					updateServerData(result.data);
				}
				
				if (callback != null)
					callback(true);
			}, function(e:SQLErrorEvent):void 
			{
				if (callback != null)
					callback(false);
			});
		}
		
		public static function getVolume(callback:Function = null):void
		{
			var sql:String = "SELECT sfxVolume, musicVolume FROM gameinfos LIMIT 1;";
			executeSQL(sql, function(e:SQLEvent):void 
			{
				var result:SQLResult = e.target.getResult();
				var sfx:Number = 0.7;
				var music:Number = 0.7;
				if (result.data != null)
				{
					var numResults:int = result.data.length; 
					for (var i:int = 0; i < numResults; i++) 
					{ 
						sfx = result.data[i].sfxVolume;
						music = result.data[i].musicVolume;
					}
				}
				
				if (callback != null)
					callback(sfx, music);
			});
		}
		
		public static function updateVolume(sfx:Number = 1, music:Number = 1, callback:Function = null):void
		{
			var sql:String = "UPDATE gameinfos SET sfxVolume=" + sfx + ", musicVolume=" + music;
			executeSQL(sql, function(e:SQLEvent):void 
			{
				var result:SQLResult = e.target.getResult();
				if (callback != null)
					callback(true);
			});
		}
		
		public static function getNID(callback:Function = null):void
		{
			var sql:String = "SELECT userId FROM gameData GROUP BY userId LIMIT 1;";
			executeSQL(sql, function(e:SQLEvent):void 
			{
				var result:SQLResult = e.target.getResult();
				var output:String = "";
				if (result.data != null)
				{
					var numResults:int = result.data.length; 
					for (var i:int = 0; i < numResults; i++) 
					{ 
						output = result.data[i].userId;
					}
				}
				
				if (callback != null)
					callback(output);
			});
		}
		
		public static function getNick(callback:Function = null):void
		{
			var sql:String = "SELECT nick FROM gameinfos LIMIT 1;";
			executeSQL(sql, function(e:SQLEvent):void 
			{
				var result:SQLResult = e.target.getResult();
				var output:String = "AAA";
				if (result.data != null)
				{
					var numResults:int = result.data.length; 
					for (var i:int = 0; i < numResults; i++) 
					{ 
						output = result.data[i].nick;
					}
				}
				
				if (callback != null)
					callback(output);
			});
		}
		
		public static function getName(callback:Function = null):void
		{
			var sql:String = "SELECT name FROM gameinfos LIMIT 1;";
			executeSQL(sql, function(e:SQLEvent):void 
			{
				var result:SQLResult = e.target.getResult();
				var output:String = "AAA";
				if (result.data != null)
				{
					var numResults:int = result.data.length; 
					for (var i:int = 0; i < numResults; i++) 
					{ 
						output = result.data[i].name;
					}
				}
				
				if (callback != null)
					callback(output);
			});
		}
		
		public static function updateNick(name:String = "", nick:String = "AAA", callback:Function = null):void
		{
			var sql:String = "UPDATE gameinfos SET name='" + name + "', nick='" + nick + "'";
			executeSQL(sql, function(e:SQLEvent):void 
			{
				var result:SQLResult = e.target.getResult();
				if (callback != null)
					callback(true);
			});
		}
		
		public static function updateRanking(callback:Function = null):void
		{
			getServerData(rankingURL+"?format=sql&limit=10", function(e:Event):void 
			{
				var loader: URLLoader = URLLoader(e.target);
				if (loader.data != '0' && loader.data != 0)
				{
					var dataString:String = loader.data.toString();
					var sql:String = "DELETE * from ranking";
					executeSQL(sql, function(e:SQLEvent):void 
					{
						var sql:String = "INSERT INTO ranking " + dataString;
						executeSQL(sql, function(e:SQLEvent):void 
						{
							if (callback != null)
								callback(true);
						}, function(e:SQLErrorEvent):void 
						{
							if (callback != null)
								callback(false);
						});
					}, function(e:SQLErrorEvent):void 
					{
						if (callback != null)
							callback(false);
					});
				}
			}, function(e:ErrorEvent):void 
			{
				trace("Error ID:", e.errorID, "Error Type:", e.type, "Error Text:", e.text);
				if (callback != null)
					callback(false);
			});
		}
		
		public static function getRanking(callback:Function = null):void
		{
			var sql:String =
			"SELECT nick, totalPoints FROM ranking " +
			"UNION " +
			"SELECT * FROM (SELECT nick, totalPoints FROM gameData ORDER BY totalPoints DESC limit 10) " +
			"ORDER BY totalPoints DESC " + 
			"LIMIT 10;";
			
			executeSQL(sql, function(e:SQLEvent):void 
			{
				var result:SQLResult = e.target.getResult();
				if (callback != null)
					callback(result);
			});
		}
		
		public static function getInfoURL():void
		{
			getServerData(infoURl, function(e:Event):void 
			{
				var loader: URLLoader = URLLoader(e.target);
				if (loader.data!=null && loader.data!="0" && loader.data!="")
				{
					infoURLLink = loader.data.toString();
				}
			});
		}
		
		public static function updatePositions(callback:Function = null):void
		{	
			getLastUpdate(function(value:String):void 
			{
				var lastUpdate:String = (value=="0") ? "2014-04-19 00:00:00" : value;
				getServerData(positionsURL+"?format=sql&from="+lastUpdate, function(e:Event):void 
				{
					var loader: URLLoader = URLLoader(e.target);
					if (loader.data != '0' && loader.data != 0)
					{
						updateLastUpdate(loader.data.lastUpdate);
						var sql:String = "INSERT INTO positions " + loader.data.sql;
						executeSQL(sql, function(e:SQLEvent):void 
						{
							if (callback != null)
								callback(true);
						}, function(e:SQLErrorEvent):void 
						{
							if (callback != null)
								callback(false);
						});
					}
				}, function(e:ErrorEvent):void 
				{
					trace("Error ID:", e.errorID, "Error Type:", e.type, "Error Text:", e.text);
					if (callback != null)
						callback(false);
				});
			} );
		}
		
		public static function getPositions(callback:Function = null):void
		{
			var sql:String = 
			"SELECT deadPosition, count FROM positions " +
			"UNION " +
			"SELECT * FROM (SELECT ROUND(deadPosition, 0) as deadPosition, COUNT(id) as count FROM gameData GROUP BY ROUND(deadPosition, 0)) " +
			"ORDER BY deadPosition ASC;";
			
			executeSQL(sql, function(e:SQLEvent):void 
			{
				var result:SQLResult = e.target.getResult();
				if (callback != null)
					callback(result);
			});
		}
		
		public static function getLastUpdate(callback:Function = null):void
		{
			var sql:String = "SELECT dateUpdated FROM gameinfos LIMIT 1;";
			executeSQL(sql, function(e:SQLEvent):void 
			{
				var result:SQLResult = e.target.getResult();
				var output:String = '0';
				if (result.data != null)
				{
					var numResults:int = result.data.length; 
					for (var i:int = 0; i < numResults; i++) 
					{ 
						output = result.data[i].dateUpdated;
					}
				}
				
				if (callback != null)
					callback(output);
				
			}, function(e:SQLErrorEvent):void 
			{
				if (callback != null)
					callback('0');
			});
		}
		
		public static function updateLastUpdate(newDate:String = "0", callback:Function = null):void
		{
			var sql:String = "UPDATE gameinfos SET dateUpdated='" + newDate + "'";
			executeSQL(sql, function(e:SQLEvent):void 
			{	
				if (callback != null)
					callback(true);
				
			}, function(e:SQLErrorEvent):void 
			{
				if (callback != null)
					callback(false);
			});
		}
		
		private static function openDB(e:SQLEvent):void 
		{
			dropTables();
			createTables();
		}
		
		private static function createTables():void
		{
			var sql:String =
			"CREATE TABLE IF NOT EXISTS gameData (" +  
			"    id INTEGER PRIMARY KEY AUTOINCREMENT, " +
			"    userId TEXT DEFAULT '" + UIDUtil.createUID() + "', " +
			"    fId VARCHAR(255), " +
			"    name VARCHAR(100), " +
			"    nick VARCHAR(3), " +  
			"    totalPoints INTEGER DEFAULT 0, " +  
			"    deadPosition NUMERIC, " +
			"    submitted INTEGER DEFAULT 0, " +
			"    useAsRanking INTEGER DEFAULT 0, " +
			"    dateCreated TEXT DEFAULT CURRENT_TIMESTAMP" +
			"); ";
			
			executeSQL(sql, function(e:SQLEvent):void 
			{ 
				var sql:String = "CREATE TABLE IF NOT EXISTS gameinfos (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(100), nick VARCHAR(3), fId VARCHAR(255), dateUpdated TEXT, infoLink TEXT, sfxVolume NUMERIC, musicVolume NUMERIC); ";
				executeSQL(sql, function(e:SQLEvent):void 
				{
					var sql_i:String = "INSERT INTO gameinfos (name, nick, fId, dateUpdated, infoLink, sfxVolume, musicVolume) VALUES ('', 'AAA', '', '', '', 0.5, 0.7)";
					executeSQL(sql_i);
					
					var sql:String = "CREATE TABLE IF NOT EXISTS positions (id INTEGER PRIMARY KEY AUTOINCREMENT, deadPosition NUMERIC, count INTEGER DEFAULT 0); ";
					executeSQL(sql, function(e:SQLEvent):void 
					{
						var sql:String = "CREATE TABLE IF NOT EXISTS ranking (id INTEGER PRIMARY KEY AUTOINCREMENT, nick VARCHAR(3), totalPoints INTEGER DEFAULT 0); ";
						executeSQL(sql, function(e:SQLEvent):void 
						{
							if (dbCreatedFunction != null)
							{
								dbCreatedFunction();
								dbCreatedFunction = null;
							}
						});
					});
				});
			});
		}
		
		private static function dropTables():void
		{
			//executeSQL("DROP TABLE IF EXISTS gameinfos");
			//executeSQL("DROP TABLE IF EXISTS gameData");
			//executeSQL("DROP TABLE IF EXISTS positions");
			//executeSQL("DROP TABLE IF EXISTS ranking");
		}
		
		private static function errorDB(e:SQLErrorEvent):void 
		{ 
			trace("Error message:", e.error.message); 
			trace("Details:", e.error.details);
		}
		
		private static function executeSQL(sql:String, onSuccess:Function = null, onError:Function = null):void
		{
			var sqlStatement:SQLStatement = new SQLStatement(); 
			sqlStatement.sqlConnection = conn;
			sqlStatement.text = sql;
			
			if(onSuccess!=null)
				sqlStatement.addEventListener(SQLEvent.RESULT, onSuccess); 
			
			if (onError != null)
			{
				sqlStatement.addEventListener(SQLErrorEvent.ERROR, onError);
			}else
			{
				sqlStatement.addEventListener(SQLErrorEvent.ERROR, sqlError);
			}
			sqlStatement.execute();
		}
		
		private static function sqlError(e:SQLErrorEvent):void 
		{ 
			trace("Error message:", e.error.message); 
			trace("Details:", e.error.details);
			e.target.removeEventListener(SQLErrorEvent.ERROR, sqlError);
		}
		
		public static function reset():void 
		{
			gamePaused = false;
		}
	}
}