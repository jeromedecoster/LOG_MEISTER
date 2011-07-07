/*
 *	LogMeister for ActionScript 3.0
 *	Copyright © 2011 Base42.nl
 *	All rights reserved.
 *	
 *	http://github.com/base42/LogMeister
 * 
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *	
 *	Logmeister version 1.8.1
 *	
 */
package com.jeromedecoster.logging.logmeister
{
	import com.jeromedecoster.logging.logmeister.connectors.ILogMeisterConnector;
	import com.jeromedecoster.logging.logmeister.connectors.enums.Connector;
	import com.jeromedecoster.logging.logmeister.connectors.enums.Level;

	import flash.display.Stage;
	import flash.utils.getQualifiedClassName;

	public class LogMeister
	{
		public static const VERSION:String = "version 1.8.1";
		
		private static var enableDebug:Boolean = true;
		private static var enableInfo:Boolean = true;
		private static var enableWarn:Boolean = true;
		private static var enableError:Boolean = true;
		
		private static var loggers:Array = [];
		
		//--------------------------------------
		//  PRIVATE
		//--------------------------------------
		
		static private function forEach(iterable:Object, iterator:Function):Object
		{
			for each (var item:Object in iterable)
				iterator(item);
			return iterable;
		}
		
		//--------------------------------------
		//  PUBLIC
		//--------------------------------------
		
		public static function setLevel(level:Level, enable:Boolean):void
		{
			switch (level)
			{
				case Level.ALL:
					enableDebug = enableError = enableInfo = enableWarn = enable;
				break;
				case Level.DEBUG:	enableDebug = enable;	break;
				case Level.ERROR:	enableError = enable;	break;
				case Level.INFO:	enableInfo  = enable;	break;
				case Level.WARN:	enableWarn  = enable;	break;
			}
		}
		
		public static function initialize(stage:Stage,
										  xml:XML):void
		{
			forEach(xml.logging, function(log:XML):void
				{
					forEach(log.attributes(), function(att:XML):void
						{
							if (att == true || att == false)
							{
								LogMeister.setLevel(Level.getByName(att.name()), att != false);
							};
						});
					
					forEach(log.children(), function(chi:XML):void
						{
							var con:Connector = Connector.getByName(chi.name());
							if (con == null) return;
							
							var format:String = chi.text()[0] || null;
							
							var logger:ILogMeisterConnector;
							if (con == Connector.MONSTER_DEBUGGER) logger = con.newInstance(stage, format);
							else logger = con.newInstance(format);
							
							if (logger != null) LogMeister.addLogger(logger);
						});
				});
		}

		/*
		 * Add a logger connector (@see ILogMeisterConnector), a logger cannot be added twice
		 */
		public static function addLogger(logger:ILogMeisterConnector):void
		{
			for each (var log:ILogMeisterConnector in loggers)
			{
				if (getQualifiedClassName(log) == getQualifiedClassName(logger))
				{
					// ignore double added loggers
					return;
				}
			}

			logger.init();
			loggers[loggers.length] = logger;
		}

		/*
		 * Clear the list of active Loggers, after this statement you will not recieve any debug messages
		 */
		public static function clearLoggers():void
		{
			loggers = [];
		}

		NSLogMeister static function debug(...args):void
		{
			if (!enableDebug) return;
			for each (var logger:ILogMeisterConnector in loggers)
			{
				logger.sendDebug.apply(null, args);
			}
		}

		NSLogMeister static function info(...args):void
		{
			if (!enableInfo) return;
			for each (var logger:ILogMeisterConnector in loggers)
			{
				logger.sendInfo.apply(null, args);
			}
		}

		NSLogMeister static function warn(...args):void
		{
			if (!enableWarn) return;
			for each (var logger:ILogMeisterConnector in loggers)
			{
				logger.sendWarn.apply(null, args);
			}
		}

		NSLogMeister static function error(...args):void
		{
			if (!enableError) return;
			for each (var logger:ILogMeisterConnector in loggers)
			{
				logger.sendError.apply(null, args);
			}
		}
	}
}




