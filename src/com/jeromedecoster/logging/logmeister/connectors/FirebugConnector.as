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

	import flash.external.ExternalInterface;

	public class FirebugConnector extends AbstractConnector implements ILogMeisterConnector
	{
		public function FirebugConnector(format:String = null)
		{
			super("{message} [{sender}]");
			if (format != null) this.format = format;
		}
		
		//--------------------------------------
		//  PUBLIC
		//--------------------------------------
		
		public function sendDebug(...args):void
		{
			trace("sendDebug ava:", ExternalInterface.available);
			if (!ExternalInterface.available) return;
			var message:String = parse(format, getSender(), Level.DEBUG, args);
			ExternalInterface.call("console.log", message);
		}

		public function sendInfo(...args):void
		{
			if (!ExternalInterface.available) return;
			var message:String = parse(format, getSender(), Level.INFO, args);
			ExternalInterface.call("console.info", message);
		}

		public function sendWarn(...args):void
		{
			if (!ExternalInterface.available) return;
			var message:String = parse(format, getSender(), Level.WARN, args);
			ExternalInterface.call("console.warn", message);
		}

		public function sendError(...args):void
		{
			if (!ExternalInterface.available) return;
			var message:String = parse(format, getSender(), Level.ERROR, args);
			ExternalInterface.call("console.error", message);
		}
	}
}





