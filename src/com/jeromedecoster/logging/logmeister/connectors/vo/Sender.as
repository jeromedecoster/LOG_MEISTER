
package com.jeromedecoster.logging.logmeister.connectors.vo
{
	final public class Sender
	{
		public var caller:String;
		public var location:String;
	
		public function Sender(caller:String, location:String)
		{
			this.caller = caller;
			this.location = location;
		}
	}
}
