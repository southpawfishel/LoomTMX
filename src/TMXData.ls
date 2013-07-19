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
                    Debug.assert(false, "gzip compression not yet supported!");
                }

                const FLIPPED_HORIZONTALLY_FLAG:int = 0x80000000;
                const FLIPPED_VERTICALLY_FLAG:int = 0x40000000;
                const FLIPPED_DIAGONALLY_FLAG:int = 0x20000000;

                for (var i:int = 0; i < bytes.length; i += 4)
                {
                    var a:int = bytes.readUnsignedByte();
                    var b:int = bytes.readUnsignedByte();
                    var c:int = bytes.readUnsignedByte();
                    var d:int = bytes.readUnsignedByte();

                    var gid:int = a | b << 8 | c << 16 | d << 24;

                    // var flipped_horizontally:Boolean = (global_tile_id & FLIPPED_HORIZONTALLY_FLAG);
                    // var flipped_vertically:Boolean = (global_tile_id & FLIPPED_VERTICALLY_FLAG);
                    // var flipped_diagonally:Boolean = (global_tile_id & FLIPPED_DIAGONALLY_FLAG);
                    // // TODO: Do something with these.

                    // gid &= ~(FLIPPED_HORIZONTALLY_FLAG | FLIPPED_VERTICALLY_FLAG | FLIPPED_DIAGONALLY_FLAG);

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
                Debug.assert(false, "Unencoded data is currently unsupported!");
            }
        }
    }
}