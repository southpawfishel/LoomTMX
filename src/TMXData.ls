package tmx
{
    import system.utils.Base64;
    import system.xml.*;

    class TMXData
    {
        public var data:Vector.<int> = [];

        public function TMXData(element:XMLElement, width:int, height:int)
        {
            var encoding:String = element.getAttribute("encoding");
            var compression:String = element.getAttribute("compression");

            var text = element.getText();

            if (encoding == "base64")
            {
                var bytes:ByteArray = new ByteArray;
                Base64.decode(text, bytes);

                if (compression == "zlib")
                {
                    bytes.uncompress(width * height * 4);
                }
                else if (compression == "gzip")
                {
                    // TODO: Support gzip.  Ideally, this would be done by adding
                    // gzip deflate to ByteArray in the native SDK
                    Debug.assert(false, "gzip compression not yet supported!");
                }

                for (var i:int = 0; i < bytes.length; i += 4)
                {
                    var a:int = bytes.readUnsignedByte();
                    var b:int = bytes.readUnsignedByte();
                    var c:int = bytes.readUnsignedByte();
                    var d:int = bytes.readUnsignedByte();

                    var gid:int = a | b << 8 | c << 16 | d << 24;

                    data.pushSingle(gid);
                }
            }
            else if (encoding == "csv")
            {
                var splitValues = text.split(",");
                var value:String = null;
                for each (value in splitValues)
                {
                    value.trim();
                    data.pushSingle(value.toNumber() as int);
                }
            }
            else
            {
                var nextChild:XMLElement = element.firstChildElement();
                while (nextChild)
                {
                    if (nextChild.getValue() == "tile")
                    {
                        data.pushSingle(nextChild.getNumberAttribute("gid") as int);
                    }
                    nextChild = nextChild.nextSiblingElement();
                }
            }
        }
    }
}