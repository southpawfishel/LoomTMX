package tmx
{
    import system.platform.Path;
    import system.xml.*;

    public class TMXTileSet
    {
        public var name:String;
        public var firstgid:int;
        public var tilewidth:int;
        public var tileheight:int;
        public var spacing:int;
        public var margin:int;

        public var properties:Dictionary.<String, String> = {};

        public var image:TMXImage = null;
        public var tileoffset:TMXTileOffset = null;
        public var tiles:Vector.<TMXTile> = [];

        private var _parentFile:String = null;

        public function TMXTileSet(parentFile:String, element:XMLElement)
        {
            _parentFile = parentFile;
            parseTileSet(element);
        }

        public function parseTileSet(element:XMLElement)
        {
            var nameAttr = element.findAttribute("name");
            if (nameAttr) name = nameAttr.value;

            var sourceAttr = element.findAttribute("source");
            if (sourceAttr)
            {
                var source = sourceAttr.value;
                var slashIndex = _parentFile.lastIndexOf(Path.getFolderDelimiter());
                var sourcePath = _parentFile.substr(0, slashIndex+1) + source;
                var sourceDoc = new XMLDocument();
                // TODO: Set this up using a loom text asset
                sourceDoc.loadFile(sourcePath);

                parseTileSet(sourceDoc.rootElement());
            }

            var firstgidAttr = element.findAttribute("firstgid");
            if (firstgidAttr) firstgid = firstgidAttr.numberValue as int;

            var tilewidthAttr = element.findAttribute("tilewidth");
            if (tilewidthAttr) tilewidth = tilewidthAttr.numberValue as int;

            var tileheightAttr = element.findAttribute("tileheight");
            if (tileheightAttr) tileheight = tileheightAttr.numberValue as int;

            var spacingAttr = element.findAttribute("spacing");
            if (spacingAttr) spacing = spacingAttr.numberValue as int;

            var marginAttr = element.findAttribute("margin");
            if (marginAttr) margin = marginAttr.numberValue as int;

            var nextChild:XMLElement = element.firstChildElement();
            while (nextChild)
            {
                if (nextChild.getValue() == "tileoffset")
                {
                    tileoffset = new TMXTileOffset(nextChild);
                }
                else if (nextChild.getValue() == "image")
                {
                    image = new TMXImage(nextChild);
                }
                else if (nextChild.getValue() == "terraintypes")
                {
                    trace("terraintypes not yet supported!");
                }
                else if (nextChild.getValue() == "tile")
                {
                    tiles.pushSingle(new TMXTile(nextChild));
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
        public var x:int;
        public var y:int;

        public function TMXTileOffset(element:XMLElement)
        {
            x = element.getNumberAttribute("x") as int;
            y = element.getNumberAttribute("y") as int;
        }
    }

    public class TMXImage
    {
        public var format:String;
        public var source:String;
        public var trans:String;
        public var width:int;
        public var height:int;

        public function TMXImage(element:XMLElement)
        {
            format = element.getAttribute("format");
            source = element.getAttribute("source");
            trans = element.getAttribute("trans");
            width = element.getNumberAttribute("width") as int;
            height = element.getNumberAttribute("height") as int;

            // TODO: Handle images which include data
        }
    }

    public class TMXTile
    {
        public var id:int;
        public var terrain:Vector.<int> = [];
        public var probability:Number = 1;

        public function TMXTile(element:XMLElement)
        {
            id = element.getNumberAttribute("id");
            var probabilityAttr = element.findAttribute("probability");
            probability = probabilityAttr ? probabilityAttr.numberValue : 1.0;
            var terrainAttr = element.findAttribute("terrain");
            if (terrainAttr)
            {
                var terrainStrings = terrainAttr.value.split(",");
                for each (var terrainString in terrainStrings)
                {
                    terrain.pushSingle(terrainString.toNumber() as int);
                }
            }
        }
    }
}