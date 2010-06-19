/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.tinytlf.layout
{
    import flash.display.Sprite;
    import flash.events.Event;

    import mockolate.prepare;

    import mx.core.UIComponent;

    import org.flexunit.Assert;
    import org.flexunit.async.Async;
    import org.fluint.uiImpersonation.UIImpersonator;
    import org.hamcrest.assertThat;
    import org.hamcrest.object.*;
    import org.tinytlf.ITextEngine;

    public class TextContainerBaseTests
    {
        private var container:TextContainerBase;
        private var target:UIComponent;

        [Before(async, ui)]
        public function setup():void
        {
            target = new UIComponent();
            container = new TextContainerBase(target);

            UIImpersonator.addChild(target);

            Async.proceedOnEvent(this,
                    prepare(ITextEngine),
                    Event.COMPLETE);
        }

        [After(ui)]
        public function tearDown():void
        {
            UIImpersonator.removeAllChildren();
            container = null;
        }

        [Test]
        public function was_constructed():void
        {
            assertThat(container, notNullValue());
        }

        [Test]
        public function has_target_after_construction():void
        {
            assertThat(container.target, strictlyEqualTo(target));
        }

        [Test]
        public function target_was_set():void
        {
            var newTarget:UIComponent = new UIComponent();

            container.target = newTarget;

            assertThat(container.target, strictlyEqualTo(newTarget));
        }

        [Test]
        public function child_added_to_target_after_setting_targer():void
        {
            assertThat(target.numChildren, equalTo(1));
        }

        [Test]
        public function shapes_is_target_child_after_setting_target():void
        {
            assertThat(container.shapes, strictlyEqualTo(target.getChildAt(0)));
        }

        [Test]
        public function children_moved_to_new_shapes_when_set():void
        {
            var shapes:Sprite = new Sprite();

            shapes.addChild(new Sprite());
            container.shapes = shapes;

            assertThat(shapes.numChildren, equalTo(1));
        }

        [Test]
        public function children_removed_from_existing_shapes_when_shapes_set():void
        {
            var targetShapes:Sprite = container.shapes;
            targetShapes.addChild(new Sprite());
            container.shapes = new Sprite();

            assertThat(targetShapes.numChildren, equalTo(0));
        }

        [Test]
        public function allowed_width_default_is_NaN():void
        {
            Assert.assertTrue(isNaN(container.allowedWidth));
        }

        [Test]
        public function allowed_height_default_is_NaN():void
        {
            Assert.assertTrue(isNaN(container.allowedHeight));
        }
    }
}