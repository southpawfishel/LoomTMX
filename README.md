LoomTMX
=======

TMX Parser for Loom Game Engine

Inspired by [this discussion](http://theengine.co/forums/loom-with-loomscript/topics/current-shortcomings-of-the-tmx-classes) on the Loom Forums.

This is a pretty simple parser for TMX files produced by [Tiled](http://www.mapeditor.org) with a delegate-driven interface for handling the parsing of different elements.

Using the library is pretty simple:
```as3

package
{
    import loom.Application;
    import loom2d.display.StageScaleMode;

    import tmx.*;

    public class TMXTest extends Application
    {
        override public function run():void
        {
            // Comment out this line to turn off automatic scaling.
            stage.scaleMode = StageScaleMode.LETTERBOX;

            // Load our tmx file and listen for when parts of it are parsed.
            var tmx:TMXDocument = new TMXDocument("assets/tiled_examples/object_test.tmx");
            tmx.onTilesetParsed += onTilesetParsed;
            tmx.onLayerParsed += onLayerParsed;
            tmx.onObjectGroupParsed += onObjectGroupParsed;
            tmx.onImageLayerParsed += onImageLayerParsed;
            tmx.onPropertiesParsed += onPropertiesParsed;
            tmx.onTMXUpdated += onTMXUpdated;
            tmx.onTMXLoadComplete += onTMXLoadComplete;

            // Create a displayable map sprite that auto-updates when the map updates.
            var map:TMXMapSprite = new TMXMapSprite(tmx);
            stage.addChild(map);

            // Load up the map.
            tmx.load();
        }

        public function onTMXUpdated(file:String, tmx:TMXDocument):void
        {
            // Called when TMX loads or has changed on disk
        }

        public function onTilesetParsed(file:String, tileset:TMXTileset):void
        {
            // Handle parsing of a tileset
        }

        public function onLayerParsed(file:String, layer:TMXLayer):void
        {
            // Handle parsing of a layer
        }

        public function onObjectGroupParsed(file:String, group:TMXObjectGroup):void
        {
            // Handle parsing of an object group
        }

        public function onImageLayerParsed(file:String, imageLayer:TMXImageLayer):void
        {
            // Handle parsing of an image layer
        }

        public function onPropertiesParsed(file:String, properties:Dictionary.<String, String>):void
        {
            // Called when map's properties have loaded
        }

        public function onTMXLoadComplete(file:String, tmx:TMXDocument):void
        {
            // Called when the TMX finishes loading
        }
    }
}

```

The above example is a simplified version of the provided app ([LoomTMX.ls](https://github.com/southpawfishel/LoomTMX/blob/master/src/LoomTMX.ls)) that comes with this repo.  To see more of what's possible with the API, please tinker with it a bit (although the above example just showed you damn near everything).

Still TODO:
* Parser: support gzip compressed layers
* Parser: support embedded image data
