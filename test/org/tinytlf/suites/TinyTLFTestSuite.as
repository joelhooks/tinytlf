package org.tinytlf.suites
{
    import org.tinytlf.*;
    import org.tinytlf.extensions.fcss.xhtml.styles.FCSSTextStylerTest;

    [Suite]
    [RunWith("org.flexunit.runners.Suite")]
    public class TinyTLFTestSuite
    {
        public var textEngineTests:TextEngineTests;
        public var fcssStylerTests:FCSSTextStylerTest;
    }
}
