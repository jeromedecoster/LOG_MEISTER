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
package com.jeromedecoster.logging.logmeister.connectors
{
	import com.jeromedecoster.logging.logmeister.connectors.enums.Level;
	import com.demonsters.debugger.MonsterDebugger;
	import com.jeromedecoster.logging.logmeister.connectors.vo.Sender;

	import flash.display.DisplayObject;

	public class MonsterDebuggerConnector extends AbstractConnector implements ILogMeisterConnector
	{
		private var stage:DisplayObject;

		public function MonsterDebuggerConnector(stage:DisplayObject,
												 format:String = null)
		{
			this.stage = stage;
			if (format != null) this.format = format;
		}
		
		//--------------------------------------
		//  PUBLIC
		//--------------------------------------
		
		override public function init():void
		{
			MonsterDebugger.initialize(stage);
		}

		public function sendDebug(...args):void
		{
			var sender:Sender = getSender();
			var message:String = parse(format, sender, Level.DEBUG, args);
			MonsterDebugger.trace(sender.caller, message, "", "", 0x000000);
		}

		public function sendInfo(...args):void
		{
			var sender:Sender = getSender();
			var message:String = parse(format, sender, Level.INFO, args);
			MonsterDebugger.trace(sender.caller, message, "", "", 0x007d00);
		}

		public function sendWarn(...args):void
		{
			var sender:Sender = getSender();
			var message:String = parse(format, sender, Level.WARN, args);
			MonsterDebugger.trace(sender.caller, message, "", "", 0xbc5a00);
		}

		public function sendError(...args):void
		{
			var sender:Sender = getSender();
			var message:String = parse(format, sender, Level.ERROR, args);
			MonsterDebugger.trace(sender.caller, message, "", "", 0xbc0000);
		}

		public static function inspect(object:*):void
		{
			MonsterDebugger.inspect(object);
		}
	}
}




