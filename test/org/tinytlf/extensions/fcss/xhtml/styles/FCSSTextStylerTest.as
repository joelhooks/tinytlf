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
            global{
                fontName: Times;
                fontSize: 26;
                fontWeight: normal;
            }
            #someID{
                fontName: SomeIdFont;
            }
            .someClass{
                fontName: SomeClassFont;
            }
            b{
                fontWeight: bold;
            }
            .normal{
                fontWeight: normal;
            }
            #redColor{
                color: #FF0000;
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
            var format:ElementFormat = styler.getElementFormat([<_/>,<node id="someID"/>]);
            
            Assert.assertTrue(format.fontDescription.fontName == 'SomeIdFont');
        }
        
        [Test]
        public function uses_class_styles():void
        {
            var format:ElementFormat = styler.getElementFormat([<_/>,<node class="someClass"/>]);
            
            Assert.assertTrue(format.fontDescription.fontName == 'SomeClassFont');
        }
        
        [Test]
        public function uses_inherited_tag_styles():void
        {
            var format:ElementFormat = styler.getElementFormat([<_/>,<b/>,<node id="redColor"/>]);
            
            Assert.assertTrue(format.fontDescription.fontWeight == 'bold');
            Assert.assertTrue(format.color == 0xFF0000);
        }
        
        [Test]
        public function overrides_inherited_tag_styles():void
        {
            var format:ElementFormat = styler.getElementFormat([<_/>,<b/>,<node id="redColor" class="normal"/>]);
            
            Assert.assertTrue(format.fontDescription.fontWeight == 'normal');
            Assert.assertTrue(format.color == 0xFF0000);
        }
        
        [Test]
        public function uses_inline_styles():void
        {
            var format:ElementFormat = styler.getElementFormat([<_/>,<node style="fontWeight:bold;"/>]);
            
            Assert.assertTrue(format.fontDescription.fontWeight == 'bold');
        }
        
        [Test]
        public function uses_inline_tag_styles_styles():void
        {
            var format:ElementFormat = styler.getElementFormat([<_/>,<node fontWeight='bold' color='#FF0000'/>]);
            
            Assert.assertTrue(format.fontDescription.fontWeight == 'bold');
            Assert.assertTrue(format.color == 0xFF0000);
        }
    }
}