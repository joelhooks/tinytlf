package org.tinytlf
{
	import flash.display.Sprite;

	import mx.core.UIComponent;

	import org.flexunit.Assert;
	import org.fluint.uiImpersonation.UIImpersonator;

	public class TextEngineTests
	{
		[Test]
		public function text_engine_contructed():void
		{
		 	var engine:ITextEngine = new TextEngine(UIImpersonator.addChild(new UIComponent()).stage);
			Assert.assertTrue(engine != null);
		}
	}
}