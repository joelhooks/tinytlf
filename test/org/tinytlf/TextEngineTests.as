package org.tinytlf
{
    import flash.display.Sprite;

    import flash.display.Stage;

    import mx.core.UIComponent;

    import org.flexunit.Assert;
    import org.fluint.uiImpersonation.UIImpersonator;
    import org.tinytlf.decor.ITextDecor;
    import org.tinytlf.decor.TextDecor;
    import org.tinytlf.interaction.ITextInteractor;
    import org.tinytlf.interaction.TextInteractorBase;
    import org.tinytlf.layout.ITextLayout;
    import org.tinytlf.layout.TextLayoutBase;
    import org.tinytlf.layout.factory.AbstractLayoutModelFactory;
    import org.tinytlf.layout.factory.ILayoutModelFactory;
    import org.tinytlf.styles.ITextStyler;
    import org.tinytlf.styles.TextStyler;

    public class TextEngineTests
    {
        private var stage:Stage;
        private var engine:ITextEngine;

        [Before]
        public function setup():void
        {
            stage = UIImpersonator.addChild(new UIComponent()).stage;
            engine = new TextEngine(stage);
        }

        [After]
        public function tearDown():void
        {
            stage = null;
            engine = null;
        }

        [Test]
        public function text_engine_constructed():void
        {
            Assert.assertTrue(engine != null);
        }

        [Test]
        public function engine_has_default_decor():void
        {
            var decor:ITextDecor = engine.decor;

            Assert.assertTrue(decor is TextDecor);
        }

        [Test]
        public function engine_has_default_block_factory():void
        {
            var factory:ILayoutModelFactory = engine.blockFactory;

            Assert.assertTrue(factory is AbstractLayoutModelFactory);
        }

        [Test]
        public function engine_has_default_interactor():void
        {
            var interactor:ITextInteractor = engine.interactor;

            Assert.assertTrue(interactor is TextInteractorBase);
        }

        [Test]
        public function engine_has_default_layout():void
        {
            var layout:ITextLayout = engine.layout;
            UIComponent
            Assert.assertTrue(layout is TextLayoutBase);
        }

        [Test]
        public function engine_has_default_styler():void
        {
            var styler:ITextStyler = engine.styler;

            Assert.assertTrue(styler is TextStyler)
        }


    }
}
