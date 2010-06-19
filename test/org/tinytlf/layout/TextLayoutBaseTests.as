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
        private var layout:TextLayoutBase;

        [Before(async)]
        public function setup():void
        {
            layout = new TextLayoutBase();
            Async.proceedOnEvent(this,
                    prepare(ITextEngine, ITextContainer),
                    Event.COMPLETE);            
        }

        [After]
        public function tearDown():void
        {
            layout = null;
        }

        //----------------------------------------------------
        //  initialization
        //----------------------------------------------------

        [Test]
        public function text_layout_was_constructed():void
        {
            assertThat(layout, notNullValue());
        }

        [Test]
        public function engine_was_set():void
        {
            var engine:ITextEngine = nice(ITextEngine);

            layout.engine = engine;

            assertThat(layout.engine, strictlyEqualTo(engine));
        }

        [Test]
        public function containers_initialized_to_empty_vector():void
        {
            assertThat(layout.containers.length, equalTo(0));
        }

        //----------------------------------------------------
        //  basic public methods
        //----------------------------------------------------

        [Test]
        public function container_was_added():void
        {
            var container:ITextContainer = stubBasicTextContainer();

            layout.addContainer(container);

            assertThat(layout.containers.length, equalTo(1));
        }

        [Test]
        public function container_was_removed():void
        {
            var container:ITextContainer = stubBasicTextContainer();

            layout.addContainer(container);
            layout.removeContainer(container);

            assertThat(layout.containers.length, equalTo(0));
        }

        [Test]
        public function container_was_retrieved_for_line():void
        {
            var block:TextBlock = createTextBlockWithSmallContent();
            var line:TextLine = block.createTextLine();
            var retrievedContainer:ITextContainer;

            var container:ITextContainer = stubBasicTextContainer();
            stub(container).method("hasLine").args(line).returns(true);

            layout.addContainer(container);
            retrievedContainer = layout.getContainerForLine(line);

            assertThat(retrievedContainer, strictlyEqualTo(container));
        }

        [Test]
        public function clear_calls_clear_on_containers():void
        {
            var container:ITextContainer = stubBasicTextContainer();

            layout.addContainer(container);
            layout.clear();

            verify(container).method("clear").once();
        }

        [Test]
        public function reset_shapes_calls_reset_shapes_on_container():void
        {
            var container:ITextContainer = stubBasicTextContainer();

            layout.addContainer(container);
            layout.resetShapes();

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

            layout.addContainer(container);

            blocks.push(block);

            layout.render(blocks);

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

            layout.addContainer(container);
            layout.addContainer(container2);

            layout.render(blocks);

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

            layout.addContainer(container);

            layout.render(blocks);

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

            layout.addContainer(container);
            layout.addContainer(container2);

            layout.render(blocks);

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
