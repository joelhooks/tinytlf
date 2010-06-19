/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.layout
{
    import flash.events.Event;

    import flash.text.engine.*;

    import mockolate.*;

    import org.flexunit.async.Async;
    import org.hamcrest.assertThat;
    import org.hamcrest.object.*;
    import org.tinytlf.ITextEngine;

    public class TextLayoutBaseTests
    {
        private var textLayout:TextLayoutBase;

        [Before(async)]
        public function setup():void
        {
            textLayout = new TextLayoutBase();
            Async.proceedOnEvent(this,
                    prepare(ITextEngine, ITextContainer),
                    Event.COMPLETE);            
        }

        [After]
        public function tearDown():void
        {
            textLayout = null;
        }

        //----------------------------------------------------
        //  initialization
        //----------------------------------------------------

        [Test]
        public function text_layout_was_constructed():void
        {
            assertThat(textLayout, notNullValue());
        }

        [Test]
        public function engine_was_set():void
        {
            var engine:ITextEngine = nice(ITextEngine);

            textLayout.engine = engine;

            assertThat(textLayout.engine, strictlyEqualTo(engine));
        }

        [Test]
        public function containers_initialized_to_empty_vector():void
        {
            assertThat(textLayout.containers.length, equalTo(0));
        }

        //----------------------------------------------------
        //  basic public methods
        //----------------------------------------------------

        [Test]
        public function container_was_added():void
        {
            var container:ITextContainer = stubBasicTextContainer();

            textLayout.addContainer(container);

            assertThat(textLayout.containers.length, equalTo(1));
        }

        [Test]
        public function clear_calls_clear_on_containers():void
        {
            var container:ITextContainer = stubBasicTextContainer();

            textLayout.addContainer(container);
            textLayout.clear();

            verify(container).method("clear").once();
        }

        [Test]
        public function reset_shapes_calls_reset_shapes_on_container():void
        {
            var container:ITextContainer = stubBasicTextContainer();

            textLayout.addContainer(container);
            textLayout.resetShapes();

            verify(container).method("resetShapes").once();
        }

        //----------------------------------------------------
        //  render
        //----------------------------------------------------

        [Test]
        public function render_laid_out_single_block_in_single_container():void
        {
            var blocks:Vector.<TextBlock> = new Vector.<TextBlock>;
            var block:TextBlock = new TextBlock();

            var container:ITextContainer = nice(ITextContainer);
            stub(container).method("layout").args(block, instanceOf(TextLine));

            textLayout.addContainer(container);

            blocks.push(block);

            textLayout.render(blocks)

            verify(container).method("layout").once();
        }

        [Test]
        public function render_laid_out_single_block_in_multiple_container():void
        {
            var blocks:Vector.<TextBlock> = new Vector.<TextBlock>;
            var block:TextBlock = createTextBlockWithSmallContent();
            var line:TextLine = block.createTextLine();

            var container:ITextContainer = nice(ITextContainer);
            stub(container).method("layout").args(block, null).returns(line);

            var container2:ITextContainer = nice(ITextContainer);
            stub(container2).method("layout").args(block, line);

            blocks.push(block);

            textLayout.addContainer(container);
            textLayout.addContainer(container2);

            textLayout.render(blocks);

            verify(container2).method("layout").once();
        }

        [Test]
        public function render_laid_out_multiple_blocks_in_single_container():void
        {
            var blocks:Vector.<TextBlock> = new Vector.<TextBlock>;
            var block:TextBlock = createTextBlockWithSmallContent();
            var block2:TextBlock = createTextBlockWithSmallContent();

            var container:ITextContainer = nice(ITextContainer);
            stub(container).method("layout").args(instanceOf(TextBlock), null);

            blocks.push(block);
            blocks.push(block2);

            textLayout.addContainer(container);

            textLayout.render(blocks);

            verify(container).method("layout").args(block, null).once();
            verify(container).method("layout").args(block2, null).once();
        }

        [Test]
        public function render_laid_out_multiple_blocks_in_multiple_containers():void
        {
            var blocks:Vector.<TextBlock> = new Vector.<TextBlock>;
            var block:TextBlock = createTextBlockWithSmallContent();
            var block2:TextBlock = createTextBlockWithSmallContent();
            var line:TextLine = block.createTextLine();

            var container:ITextContainer = nice(ITextContainer);
            stub(container).method("layout").args(instanceOf(TextBlock), null).returns(line);

            var container2:ITextContainer = nice(ITextContainer);
            stub(container2).method("layout").args(instanceOf(TextBlock), null);

            blocks.push(block);
            blocks.push(block2);

            textLayout.addContainer(container);
            textLayout.addContainer(container2);

            textLayout.render(blocks);

            verify(container).method("layout").args(block, null).once();

            verify(container2).method("layout").args(block, line).once();
            verify(container2).method("layout").args(block2, null).once();
        }

        //----------------------------------------------------
        //
        //  test helper methods
        //
        //----------------------------------------------------

        private function stubBasicTextContainer():ITextContainer
        {
            var container:ITextContainer = nice(ITextContainer);
            stub(container).method("clear");
            stub(container).method("resetShapes");
            stub(container).setter("engine");

            return container;
        }

        private function createTextBlockWithSmallContent():TextBlock
        {
            var block:TextBlock = new TextBlock();
            var elementFormat:ElementFormat = new ElementFormat();
            block.content = new TextElement("hairy dog is lazy", elementFormat);
            return block;
        }
    }
}
