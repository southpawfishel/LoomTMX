package tmx
{
    import loom.LoomTextAsset;

    import system.xml.*;

    public delegate TMXUpdatedCallback(file:String, document:TMXDocument);
    public delegate TMXLoadCompleteCallback(file:String, document:TMXDocument);
    public delegate TMXTilesetParsedCallback(file:String, tileset:TMXTileset);
    public delegate TMXLayerParsedCallback(file:String, layer:TMXLayer);
    public delegate TMXObjectGroupParsedCallback(file:String, objectGroup:TMXObjectGroup);
    public delegate TMXImageLayerParsedCallback(file:String, imageLayer:TMXImageLayer);
    public delegate TMXPropertiesParsedCallback(file:String, properties:Dictionary.<String, String>);

    public class TMXDocument
    {
        private var _filename:String = null;
        private var _textAsset:LoomTextAsset = null;

        // Map level properties
        public var version:Number;
        public var orientation:String;
        public var width:int;
        public var height:int;
        public var tileWidth:int;
        public var tileHeight:int;
        public var backgroundcolor:String;

        public var properties:Dictionary.<String, String> = {};

        public var tilesets:Vector.<TMXTileset> = [];
        public var layers:Vector.<TMXLayer> = [];
        public var objectGroups:Vector.<TMXObjectGroup> = [];
        public var imageLayers:Vector.<TMXImageLayer> = [];

        public var onTMXUpdated:TMXUpdatedCallback = new TMXUpdatedCallback();
        public var onTMXLoadComplete:TMXLoadCompleteCallback = new TMXLoadCompleteCallback();
        public var onTilesetParsed:TMXTilesetParsedCallback = new TMXTilesetParsedCallback();
        public var onLayerParsed:TMXLayerParsedCallback = new TMXLayerParsedCallback();
        public var onObjectGroupParsed:TMXObjectGroupParsedCallback = new TMXObjectGroupParsedCallback();
        public var onImageLayerParsed:TMXImageLayerParsedCallback = new TMXImageLayerParsedCallback();
        public var onPropertiesParsed:TMXPropertiesParsedCallback = new TMXPropertiesParsedCallback();

        public function TMXDocument(filename:String)
        {
            _filename = filename;
            _textAsset = LoomTextAsset.create(_filename);
        }

        public function load():void
        {
            _textAsset.updateDelegate += onTextAssetUpdated;
            _textAsset.load();
        }

        public static function loadProperties(element:XMLElement, propertiesMap:Dictionary.<String, String>)
        {
            var nextChild:XMLElement = element.firstChildElement("property");
            while (nextChild)
            {
                propertiesMap[nextChild.getAttribute("name")] = nextChild.getAttribute("value");

                nextChild = nextChild.nextSiblingElement("property");
            }
        }

        private function onTextAssetUpdated(name:String, contents:String):void
        {
            var xmlDoc = new XMLDocument();
            var result = xmlDoc.parse(contents);
            if (result != XMLError.XML_NO_ERROR)
            {
                trace("Encountered error parsing " + name + ": " + result);
                return;
            }

            var root:XMLElement = xmlDoc.rootElement();
            parseMap(root);
        }

        private function parseMap(root:XMLElement):void
        {
            Debug.assert(root.getValue() == "map", "Error: expected 'map' as root node of TMX file!");

            version = root.getNumberAttribute("version");
            orientation = root.getAttribute("orientation");
            width = root.getNumberAttribute("width") as int;
            height = root.getNumberAttribute("height") as int;
            tileWidth = root.getNumberAttribute("tilewidth") as int;
            tileHeight = root.getNumberAttribute("tileheight") as int;
            backgroundcolor = root.getAttribute("backgroundcolor");

            onTMXUpdated(_filename, this);

            var nextChild:XMLElement = root.firstChildElement();
            while (nextChild)
            {
                if (nextChild.getValue() == "tileset")
                {
                    var tileset:TMXTileset = new TMXTileset(_filename, nextChild);
                    tilesets.pushSingle(tileset);
                    onTilesetParsed(_filename, tileset);
                }
                else if (nextChild.getValue() == "layer")
                {
                    var layer:TMXLayer = new TMXLayer(nextChild, width, height);
                    layers.pushSingle(layer);
                    onLayerParsed(_filename, layer);
                }
                else if (nextChild.getValue() == "objectgroup")
                {
                    var objectGroup:TMXObjectGroup = new TMXObjectGroup(nextChild);
                    objectGroups.pushSingle(objectGroup);
                    onObjectGroupParsed(_filename, objectGroup);
                }
                else if (nextChild.getValue() == "imagelayer")
                {
                    var imageLayer:TMXImageLayer = new TMXImageLayer(nextChild);
                    imageLayers.pushSingle(imageLayer);
                    onImageLayerParsed(_filename, imageLayer);
                }
                else if (nextChild.getValue() == "properties")
                {
                    TMXDocument.loadProperties(nextChild, properties);
                    onPropertiesParsed(_filename, properties);
                }

                nextChild = nextChild.nextSiblingElement();
            }

            onTMXLoadComplete(_filename, this);
        }
    }
}