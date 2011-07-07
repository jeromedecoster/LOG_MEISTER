
package com.jeromedecoster.logging.logmeister.connectors.enums
{
	import com.jeromedecoster.logging.logmeister.connectors.ConsoleConnector;
	import com.jeromedecoster.logging.logmeister.connectors.FirebugConnector;
	import com.jeromedecoster.logging.logmeister.connectors.ILogMeisterConnector;
	import com.jeromedecoster.logging.logmeister.connectors.MonsterDebuggerConnector;
	import com.jeromedecoster.logging.logmeister.connectors.SosMaxConnector;
	
	public class Connector
	{
		public static const CONSOLE:Connector = new Connector("console", ConsoleConnector);
		public static const FIREBUG:Connector = new Connector("firebug", FirebugConnector);
		public static const MONSTER_DEBUGGER:Connector = new Connector("monsterDebugger", MonsterDebuggerConnector);
		public static const SOS_MAX:Connector = new Connector("sosMax", SosMaxConnector);
		
		private var _name:String;
		private var klass:Class;
		
		public function Connector(name:String, klass:Class)
		{
			_name = name;
			this.klass = klass;
		}
		
		static public function getByName(name:String):Connector
		{
			if (name == "firebug")	 		return FIREBUG;
			if (name == "monsterDebugger")	return MONSTER_DEBUGGER;
			if (name == "sosMax")			return SOS_MAX;
			return null;
		}
		
		
		public function newInstance(...args):ILogMeisterConnector
		{
			args = args || [];
			switch (args.length)
			{
				case 0:  return new klass();
				case 1:  return new klass(args[0]);
				case 2:  return new klass(args[0], args[1]);
			}
			return null;
		}
		
		public function toString():String
		{
			return "[Connector name=" + name + "]";
		}

		public function get name():String { return _name; }
	}
}




