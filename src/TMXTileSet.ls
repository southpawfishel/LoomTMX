package tmx
{
    import system.xml.*;

    public class TMXTileSet
    {
        public var name:String;
        public var source:String;
        public var firstgid:uint;
        public var tilewidth:uint;
        public var tileheight:uint;
        public var spacing:uint;
        public var margin:uint;

        public var properties:Dictionary.<String, String> = {};

        public function TMXTileSet(element:XMLElement)
        {
            name = element.getAttribute("name");
            source = element.getAttribute("source");
            firstgid = element.getNumberAttribute("firstgid") as uint;
            tilewidth = element.getNumberAttribute("tilewidth") as uint;
            tileheight = element.getNumberAttribute("tileheight") as uint;
            spacing = element.getNumberAttribute("spacing") as uint;
            margin = element.getNumberAttribute("margin") as uint;

            var nextChild:XMLElement = element.firstChildElement();
            while (nextChild)
            {
                if (nextChild.getValue() == "tileoffset")
                {
                    var tileset:TMXTileOffset = new TMXTileOffset(nextChild);
                }
                else if (nextChild.getValue() == "image")
                {
                    var image:TMXImage = new TMXImage(nextChild);
                }
                else if (nextChild.getValue() == "terraintypes")
                {
                    Debug.assert(false, "terraintypes not yet supported!");
                }
                else if (nextChild.getValue() == "tile")
                {
                    Debug.assert(false, "tile not yet supported!");
                }
                else if (nextChild.getValue() == "properties")
                {
                    TMXDocument.loadProperties(nextChild, properties);
                }

                nextChild = nextChild.nextSiblingElement();
            }
        }
    }

    public class TMXTileOffset
    {
        public var x:uint;
        public var y:uint;

        public function TMXTileOffset(element:XMLElement)
        {
            x = element.getNumberAttribute("x") as uint;
            y = element.getNumberAttribute("y") as uint;
        }
    }

    public class TMXImage
    {
        public var format:String;
        public var source:String;
        public var trans:String;
        public var width:uint;
        public var height:uint;

        public function TMXImage(element:XMLElement)
        {
            format = element.getAttribute("format");
            source = element.getAttribute("source");
            trans = element.getAttribute("trans");
            width = element.getNumberAttribute("width") as uint;
            height = element.getNumberAttribute("height") as uint;
        }
    }
}