
package demo
{
	import com.bit101.components.Component;
	import com.bit101.components.TextArea;
	import com.bit101.utils.MinimalConfigurator;
	import com.jeromedecoster.logging.debug;
	import com.jeromedecoster.logging.error;
	import com.jeromedecoster.logging.info;
	import com.jeromedecoster.logging.logmeister.LogMeister;
	import com.jeromedecoster.logging.logmeister.connectors.SosMaxConnector;
	import com.jeromedecoster.logging.warn;

	import flash.display.Sprite;

	public class DemoConfig extends Sprite
	{
		private var configurator:MinimalConfigurator;
		private var xmlConf1:XML;
		private var xmlConf2:XML;
		private var xmlConf3:XML;

		public function DemoConfig()
		{
			this.xmlConf1 = <datas>
								<gi/>
								<logging info="true">
									<monsterDebugger/>
								</logging>
								<joe/>
								<logging debug="false" warn="true">
									<sosMax/>
								</logging>
							</datas>;

			this.xmlConf2 = <datas>
								<gi/>
								<logging info="true">
									<firebug/>
								</logging>
								<logging debug="false" warn="true">
									<sosMax><![CDATA[>:>:>{message}]]></sosMax>
								</logging>
							</datas>;

			this.xmlConf3 = <datas>
								<gi/>
								<logging all="false">
									<monsterDebugger><![CDATA[<{level}> (sender) {message}]]></monsterDebugger>
								</logging>
								<logging warn="true">
									<sosMax/>
								</logging>
							</datas>;

			Component.initStage(stage);

			var xml:XML = <comps>
								<VBox x="10" y="10">
									<PushButton id="confx1" action="call(this.configXML1)" label="config XML 1"/>
									<TextArea id="conft1" height="140"/>
								</VBox>
								<VBox x="10" y="190">
									<PushButton id="confx2" action="call(this.configXML2)" label="config XML 2"/>
									<TextArea id="conft2" width="250" height="140"/>
								</VBox>
								<VBox x="270" y="190">
									<PushButton id="confx3" action="call(this.configXML3)" label="config XML 3"/>
									<TextArea id="conft3" width="270" height="160"/>
								</VBox>
								<VBox x="280" y="10">
									<PushButton id="debSim" action="call(this.debugSimple)" label="debug('debug simple')"/>
									<PushButton id="infSim" action="call(this.infoSimple)" label="info('info simple')"/>
									<PushButton id="warSim" action="call(this.warnSimple)" label="warn('warn simple')"/>
									<PushButton id="errSim" action="call(this.errorSimple)" label="error('error simple')"/>
								</VBox>
								<VBox x="300" y="125">
									<PushButton id="conffv" action="call(this.configXMLnull)" label="config XML null"/>
									<PushButton id="clear" action="call(this.clearLoggers)" label="clearLoggers"/>
								</VBox>
							</comps>;

			var def:XML = <comps>
								<PushButton width="120"/>
							</comps>;

			configurator = new MinimalConfigurator(this, def);
			configurator.parseXML(xml);
			TextArea(this.configurator.getCompById("conft1")).text = this.xmlConf1.toXMLString();
			TextArea(this.configurator.getCompById("conft2")).text = this.xmlConf2.toXMLString();
			TextArea(this.configurator.getCompById("conft3")).text = this.xmlConf3.toXMLString();

			 LogMeister.addLogger(new SosMaxConnector());
			 debug("test:{0}", stage.loaderInfo.parameters.test);
		}

		public function configXML1():void
		{
			LogMeister.initialize(stage, this.xmlConf1);
		}

		public function configXML2():void
		{
			LogMeister.initialize(stage, this.xmlConf2);
		}

		public function configXML3():void
		{
			LogMeister.initialize(stage, this.xmlConf3);
		}

		public function configXMLnull():void
		{
			LogMeister.initialize(stage, null);
		}

		public function clearLoggers():void
		{
			LogMeister.clearLoggers();
		}

		public function debugSimple():void
		{
			debug("debug simple");
		}

		public function infoSimple():void
		{
			info("info simple");
		}

		public function warnSimple():void
		{
			warn("warn simple");
		}

		public function errorSimple():void
		{
			error("error simple");
		}
	}
}




