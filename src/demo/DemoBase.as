
package demo
{
	import com.bit101.components.Component;
	import com.bit101.utils.MinimalConfigurator;
	import com.jeromedecoster.logging.debug;
	import com.jeromedecoster.logging.error;
	import com.jeromedecoster.logging.info;
	import com.jeromedecoster.logging.logmeister.LogMeister;
	import com.jeromedecoster.logging.logmeister.connectors.ConsoleConnector;
	import com.jeromedecoster.logging.logmeister.connectors.FirebugConnector;
	import com.jeromedecoster.logging.logmeister.connectors.MonsterDebuggerConnector;
	import com.jeromedecoster.logging.logmeister.connectors.SosMaxConnector;
	import com.jeromedecoster.logging.warn;

	import flash.display.Sprite;

	public class DemoBase extends Sprite
	{
		private var _console:ConsoleConnector;
		private var _firebug:FirebugConnector;
		private var _monsterDebugger:MonsterDebuggerConnector;
		private var _sosMax:SosMaxConnector;
 		private var configurator:MinimalConfigurator;
		
		public function DemoBase()
		{
			Component.initStage(stage);
			
			var xml:XML = 	<comps>
								<VBox x="20" y="20">
									<PushButton id="addCon" action="call(this.addConsole)" label="addConsole"/>
									<PushButton id="fmtCon" action="call(this.formatConsole)" label="formatConsole"/>
									<PushButton id="addFir" action="call(this.addFirebug)" label="addFirebug"/>
									<PushButton id="fmtFir" action="call(this.formatFirebug)" label="formatFirebug"/>
									<PushButton id="addMon" action="call(this.addMonsterDebugger)" label="addMonsterDebugger"/>
									<PushButton id="fmtMon" action="call(this.formatMonsterDebugger)" label="formatMonsterDebugger"/>
									<PushButton id="addSos" action="call(this.addSosMax)" label="addSosMax"/>
									<PushButton id="fmtSos" action="call(this.formatSosMax)" label="formatSosMax"/>
								</VBox>
								<VBox x="150" y="20">
									<PushButton id="debSim" action="call(this.debugSimple)" label="debug('debug simple')"/>
									<PushButton id="debArg" action="call(this.debugArgs)" label="debug('debug args {0} et {1} et {1}', 'ici', 12)" width="250"/>
									<PushButton id="infSim" action="call(this.infoSimple)" label="info('info simple')"/>
									<PushButton id="infArg" action="call(this.infoArgs)" label="info('info args {0} et {1} et {1}', 'ici', 12)" width="250"/>
									<PushButton id="warSim" action="call(this.warnSimple)" label="warn('warn simple')"/>
									<PushButton id="warArg" action="call(this.warnArgs)" label="warn('warn args {0} et {1} et {1}', 'ici', 12)" width="250"/>
									<PushButton id="errSim" action="call(this.errorSimple)" label="error('error simple')"/>
									<PushButton id="errArg" action="call(this.errorArgs)" label="error('error args {0} et {1} et {1}', 'ici', 12)" width="250"/>
								</VBox>
								<VBox x="20" y="250">
									<PushButton id="fmtTim" action="call(this.formatTime)" label="format = '({time}) {message}'" width="200"/>
									<PushButton id="fmtTms" action="call(this.formatTimeMs)" label="format = '({time.ms}) {message}'" width="200"/>
									<PushButton id="fmtSen" action="call(this.formatSender)" label="format = '({sender}) {message}'" width="200"/>
									<PushButton id="fmtSfu" action="call(this.formatSenderFull)" label="format = '({sender.full}) {message}'" width="200"/>
									<PushButton id="fmtLev" action="call(this.formatLevel)" label="format = '({level}) {message}'" width="200"/>
								</VBox>
								<VBox x="250" y="250">
									<PushButton id="clear" action="call(this.clearLoggers)" label="clearLoggers"/>
								</VBox>
							</comps>;
			
			var def:XML = 	<comps>
								<PushButton width="120"/>
							</comps>;
							
			configurator = new MinimalConfigurator(this, def);
			configurator.parseXML(xml);
		}

		public function clearLoggers():void
		{
			LogMeister.clearLoggers();
		}
		
		public function formatTime():void
		{
			console.format = firebug.format =
			monsterDebugger.format = sosMax.format = "({time}) {message}";
		}
		
		public function formatTimeMs():void
		{
			console.format = firebug.format =
			monsterDebugger.format = sosMax.format = "({time.ms}) {message}";
		}
		
		public function formatSender():void
		{
			console.format = firebug.format =
			monsterDebugger.format = sosMax.format = "({sender}) {message}";
		}
		
		public function formatSenderFull():void
		{
			console.format = firebug.format =
			monsterDebugger.format = sosMax.format = "({sender.full}) {message}";
		}
		
		public function formatLevel():void
		{
			console.format = firebug.format =
			monsterDebugger.format = sosMax.format = "({level}) {message}";
		}
		
		public function debugSimple():void
		{
			debug("debug simple");
		}
		
		public function debugArgs():void
		{
			debug("debug args {0} et {1} et {1}", "ici", 12);
		}
		
		public function infoSimple():void
		{
			info("info simple");
		}
		
		public function infoArgs():void
		{
			info("info args {0} et {1} et {1}", "ici", 12);
		}
		
		public function warnSimple():void
		{
			warn("warn simple");
		}
		
		public function warnArgs():void
		{
			warn("warn args {0} et {1} et {1}", "ici", 12);
		}
		
		public function errorSimple():void
		{
			error("error simple");
		}
		
		public function errorArgs():void
		{
			error("error args {0} et {1} et {1}", "ici", 12);
		}
		
		public function addSosMax():void
		{
			LogMeister.addLogger(sosMax);
		}
		
		public function formatSosMax():void
		{
			sosMax.format = "<{sender}> {message}";
		}

		public function get sosMax():SosMaxConnector
		{
			return _sosMax ||= new SosMaxConnector();
		}
		
		public function addConsole():void
		{
			LogMeister.addLogger(console);
		}
		
		public function formatConsole():void
		{
			console.format = "<{sender}> {message}";
		}
		
		public function get console():ConsoleConnector
		{
			return _console ||= new ConsoleConnector();
		}

		public function addFirebug():void
		{
			LogMeister.addLogger(firebug);
		}
		
		public function formatFirebug():void
		{
			firebug.format = "<{sender}> {message}";
		}
		
		public function get firebug():FirebugConnector
		{
			return _firebug ||= new FirebugConnector();
		}

		public function addMonsterDebugger():void
		{
			LogMeister.addLogger(monsterDebugger);
		}
		
		public function formatMonsterDebugger():void
		{
			monsterDebugger.format = "<{sender}> {message}";
		}
		
		public function get monsterDebugger():MonsterDebuggerConnector
		{
			return _monsterDebugger ||= new MonsterDebuggerConnector(stage);
		}
	}
}




