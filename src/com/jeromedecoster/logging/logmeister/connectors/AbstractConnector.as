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
	import com.jeromedecoster.logging.logmeister.connectors.vo.Sender;

	import flash.system.Capabilities;

	internal class AbstractConnector
	{
		private var _format:String;
		private var defaultFormat:String;
		private var senderLineNumber:uint = 7;

		public function AbstractConnector(defaultFormat:String = "{message}")
		{
			this.defaultFormat = validate(defaultFormat);
			_format = this.defaultFormat;
		}
		
		//--------------------------------------
		//  PRIVATE
		//--------------------------------------
		
		private function validate(format:String):String
		{
			return (format == null || format.indexOf("{message}") == -1) ? "{message}" : format.replace(/^\s+|\s+$/g, "");;
		}
		
		//--------------------------------------
		//  PROTECTED
		//--------------------------------------
		
		protected function parse(format:String,
								 sender:Sender,
								 level:Level,
								 args:Array):String
		{
			var s:String = format.replace(/{message}/g, args[0]);
			
			const n:int = args.length;
			var arg:*;
			var re:RegExp;
			for (var i:int = 1; i < n; ++i)
			{
				arg = args[i];
				re = new RegExp("\\{" + int(i - 1) + "\\}", "g");
				s = s.replace(re, arg);
			}
			
			if (s.indexOf("{time") > -1)
			{
				const now:Date = new Date();
				var hou:String = now.hours.toString();
				if (hou.length == 1) hou = "0" + hou;
				var min:String = now.minutes.toString();
				if (min.length == 1) min = "0" + min;
				var sec:String = now.seconds.toString();
				if (sec.length == 1) sec = "0" + sec;
				var time:String = hou + ":" + min + ":" + sec;
				s = s.replace(/{time}/g, time);
				
				if (s.indexOf("{time.ms}") > -1)
				{
					var mil:String = now.milliseconds.toString();
					while (mil.length < 3) mil = "0" + mil;
					time += "." + mil;
					s = s.replace(/{time\.ms}/g, time);
				}
			}
			
			if (sender != null)
			{
				if (level == Level.ERROR)
				{
					const isend:int = s.indexOf("{sender}");
					const ifull:int = s.indexOf("{sender.full}");
				
					if (isend > -1 && ifull == -1) s = s.replace(/{sender}/g, "{sender.full}");
					else if (ifull == -1) s = s + " [{sender.full}]";
				}
				
				s = s.replace(/{sender}/g, sender.caller);
				s = s.replace(/{sender\.full}/g, sender.caller + " " + sender.location);
			}
			
			s = s.replace(/{level}/g, level.name);
			
			return s;
		}
		
		protected function getSender():Sender
		{
			if (!Capabilities.isDebugger) return null;
			
			try
			{
				var sender:String = new Error().getStackTrace().split("\n")[senderLineNumber];
				
				var start:String = sender.match(/(?<=(\sat\s)).*(?=\(\))/g)[0];
				var end:String = sender.match(/(\w+\.as:\d+)/g)[0];
				var before:String = start.match(/\w+$/g)[0];
				
				if (start.indexOf("/") == -1)
				{
					return new Sender(before + ".constructor", end);
				}
				
				if (start.indexOf("global/") == 0)
				{
					return new Sender("global." + before, end);
				}
				
				if (start.indexOf("<anonymous>") > -1)
				{
					return new Sender("Function.anonymous", end);
				}
				
				var previous:String = start.match(/\w+(?=\$*\/)/g)[0];
				return new Sender(previous + "." + before, end);
			}
			catch (e:Error)
			{
				return null;
			}
			return null;
		}

		//--------------------------------------
		//  PUBLIC
		//--------------------------------------
		
		public function init():void
		{
		}
		
		public function get format():String { return _format; }
		
		public function set format(value:String):void
		{
			_format = validate(value);
		}
	}
}




