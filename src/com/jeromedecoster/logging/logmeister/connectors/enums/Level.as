
package com.jeromedecoster.logging.logmeister.connectors.enums
{
	public class Level
	{
		public static const ALL:Level	= new Level("all");
		public static const DEBUG:Level = new Level("debug");
		public static const ERROR:Level	= new Level("error");
		public static const INFO:Level	= new Level("info");
		public static const NONE:Level	= new Level("none");
		public static const WARN:Level	= new Level("warn");
		
		private var _name:String;

		public function Level(name:String)
		{
			_name = name;
		}
		
		static public function getByName(name:String):Level
		{
			if (name == "all")	 return ALL;
			if (name == "debug") return DEBUG;
			if (name == "error") return ERROR;
			if (name == "info")  return INFO;
			if (name == "warn")  return WARN;
			return NONE;
		}
		
		public function toString():String
		{
			return "[Level name=" + name + "]";
		}

		public function get name():String { return _name; }
	}
}




