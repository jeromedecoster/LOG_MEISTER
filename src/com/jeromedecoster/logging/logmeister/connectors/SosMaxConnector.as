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
 *	Thanks to Eric-Paul Lecluse for the help on this connector
 *	Thanks to Riccardo Prandini for the update
 *	
 */
package com.jeromedecoster.logging.logmeister.connectors
{
	import com.jeromedecoster.logging.logmeister.connectors.enums.Level;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.XMLSocket;
	import flash.system.Capabilities;
	import flash.utils.Timer;

	public class SosMaxConnector extends AbstractConnector implements ILogMeisterConnector
	{
		private var debugger:Boolean;
		private var isConnected:Boolean;
		private var socket:XMLSocket;
		private var stack:Array;
		private var timer:Timer;

		public function SosMaxConnector(format:String = null)
		{
			super("({time}) [{sender}] {message}");
			if (format != null) this.format = format;
		}
		
		//--------------------------------------
		//  EVENTS
		//--------------------------------------
		
		/**
		 * @private
		 * Try to reconnect
		 */
		private function onTimer(event:TimerEvent):void
		{
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
			connect();
		}

		private function onError(event:Event):void
		{
			// ignore errors.
			// they only occur when the SOS viewer is not running.
			timer.start();
		}

		private function onConnect(event:Event):void
		{
			debugger = Capabilities.isDebugger;
			isConnected = true;
			timer.stop();

			while (stack.length)
			{
				var m:Message = stack.shift() as Message;
				sendSOSMessage(m.message, m.key);
			}
		}
		
		//--------------------------------------
		//  PRIVATE
		//--------------------------------------
		
		private function connect():void
		{
			try
			{
				socket.connect("localhost", 4444);
			}
			catch (error:SecurityError)
			{
				trace("SecurityError in SOSAppender: " + error);
			}
		}
		
		private function sendSOSMessage(message:String, key:String = "debug"):void
		{
			if (isConnected)
			{
				try
				{
					socket.send("!SOS<showMessage key='" + key + "'>" + message.replace(/&/g, "&amp;").replace(/\>/g, "&gt;").replace(/\</g, "&lt;") + "</showMessage>");
				}
				catch (e:Error)
				{
					// ignore error
					trace("no debugger found");
				}
			}
			else
			{
				stack[stack.length] = new Message(message, key);
				while (stack.length > 200) stack.shift();
			}
		}
		
		//--------------------------------------
		//  PUBLIC
		//--------------------------------------
		
		override public function init():void
		{
			socket = new XMLSocket();
			socket.addEventListener(Event.CONNECT, onConnect);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onError);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);

			stack = [];
			timer = new Timer(2000);
			timer.addEventListener(TimerEvent.TIMER, onTimer);

			connect();
		}

		public function sendDebug(...args):void
		{
			var message:String = parse(format, getSender(), Level.DEBUG, args);
			sendSOSMessage(message, Level.DEBUG.name);
		}

		public function sendInfo(...args):void
		{
			var message:String = parse(format, getSender(), Level.INFO, args);
			sendSOSMessage(message, Level.INFO.name);
		}

		public function sendWarn(...args):void
		{
			var message:String = parse(format, getSender(), Level.WARN, args);
			sendSOSMessage(message, Level.WARN.name);
		}

		public function sendError(...args):void
		{
			var message:String = parse(format, getSender(), Level.ERROR, args);
			sendSOSMessage(message, Level.ERROR.name);
		}
	}
}

final class Message
{
	public var message:String;
	public var key:String;

	public function Message(message:String, key:String)
	{
		this.message = message;
		this.key = key;
	}
}




