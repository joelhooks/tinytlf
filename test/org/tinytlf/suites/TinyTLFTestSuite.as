package org.tinytlf.suites
{
    import org.tinytlf.*;
    import org.tinytlf.extensions.fcss.xhtml.styles.FCSSTextStylerTest;
    import org.tinytlf.layout.TextLayoutBaseTests;

    [Suite]
    [RunWith("org.flexunit.runners.Suite")]
    public class TinyTLFTestSuite
    {
        public var textEngineTests:TextEngineTests;
        public var textLayoutBaseTests:TextLayoutBaseTests;
        public var fcssStylerTests:FCSSTextStylerTest;
    }
}
