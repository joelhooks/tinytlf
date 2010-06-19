package org.tinytlf.extensions.fcss.xhtml.styles
{
    import flash.text.engine.ElementFormat;
    
    import org.flexunit.Assert;
    import org.tinytlf.ITextEngine;
    import org.tinytlf.TextEngine;
    
    public class FCSSTextStylerTest
    {
        private var engine:ITextEngine;
        private var styler:FCSSTextStyler;
        private var css:XML = <_><![CDATA[
            global
            {
                fontName: Times;
                fontSize: 26;
            }
            #id1
            {
                fontName: OverriddenFontName;
                color: #FF0000;
            }
            .class1
            {
                fontWeight: bold;
            }
        ]]></_>;
        
        [Before]
        public function setUp():void
        {
            engine = new TextEngine();
            styler = new FCSSTextStyler();
            engine.styler = styler;
            styler.style = css.toString();
        }
        
        [After]
        public function tearDown():void
        {
            engine = null;
            styler = null;
        }
        
        [Test]
        public function uses_global_style():void
        {
            var format:ElementFormat = styler.getElementFormat([XML(<_/>)]);
            
            Assert.assertTrue(format.fontDescription.fontName == 'Times');
            Assert.assertTrue(format.fontSize == 26);
        }
        
        [Test]
        public function uses_id_styles():void
        {
            var format:ElementFormat = styler.getElementFormat([<_/>,<node id="id1"/>]);
            
            Assert.assertTrue(format.fontDescription.fontName == 'OverriddenFontName');
            Assert.assertTrue(format.color == 0xFF0000);
        }
    }
}