package game.core 
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FileManager 
	{
		public static const APP_STORAGE_DIRECTORY:int = 0;
		public static const APP_DIRECTORY:int = 1;
		public static const DESKTOP_DIRECTORY:int = 2;
		public static const DOCUMENTS_DIRECTORY:int = 3;
		public static const USER_DIRECTORY:int = 4;
		
		private static var instance:FileManager = null;
		public static function getInstance():FileManager
		{
			if (FileManager.instance == null) FileManager.instance = new FileManager();
			return FileManager.instance;
		}
		
		public static function readFile(baseDirectory:int = 0, fileName:String = ""):String
		{
			var content:String = "";
			var file:File = getFilePath(baseDirectory, fileName);
			try 
			{
				if (file.exists && !file.isDirectory)
				{
					var stream:FileStream = new FileStream();
					stream.open(file, FileMode.READ);
					content = stream.readUTFBytes(stream.bytesAvailable);
					stream.close();
				}
			}catch (e:Error)
			{
				trace("error on read file");
			}
			return content;
		}
		
		public static function writeFile(baseDirectory:int = 0, fileName:String = "", content:String = "", createNew:Boolean = true):void
		{
			var file:File = getFilePath(baseDirectory, fileName);
			try 
			{
				if (!file.isDirectory)
				{
					var stream:FileStream = new FileStream();
					stream.open(file, FileMode.WRITE);
					stream.writeUTFBytes(content);
					stream.close();
				}
			}catch (e:Error)
			{
				trace("error on write file");
			}
		}
		
		public static function deleteFile(baseDirectory:int = 0, fileName:String = ""):void
		{
			var file:File = getFilePath(baseDirectory, fileName);
			try 
			{
				file.deleteFile();
			}catch (e:Error)
			{
				trace("error on write file");
			}
		}
		
		private static function getFilePath(baseDirectory:int = 0, fileName:String = ""):File
		{
			var fileOpened:File;
			switch (baseDirectory)
			{
				case APP_STORAGE_DIRECTORY:
					fileOpened = File.applicationStorageDirectory.resolvePath(fileName);
					break;
					
				case APP_DIRECTORY:
					fileOpened = File.applicationDirectory.resolvePath(fileName);
					break;
					
				case DESKTOP_DIRECTORY:
					fileOpened = File.desktopDirectory.resolvePath(fileName);
					break;
					
				case DOCUMENTS_DIRECTORY:
					fileOpened = File.documentsDirectory.resolvePath(fileName);
					break;
					
				case USER_DIRECTORY:
					fileOpened = File.userDirectory.resolvePath(fileName);
					break;
					
				default:
					fileOpened = File.applicationStorageDirectory.resolvePath(fileName);
			}
			return fileOpened;
		}
	}
}