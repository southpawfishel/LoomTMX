package
{
    import loom.Application;
    import loom2d.display.StageScaleMode;
    import loom2d.display.Image;
    import loom2d.textures.Texture;
    import loom2d.ui.SimpleLabel;

    import tmx.*;

    public class LoomTMX extends Application
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

            // Create a sprite that auto-updates when the map updates.
            var map:TMXMapSprite = new TMXMapSprite(tmx);
            stage.addChild(map);

            tmx.load();

            // Once the map has loaded, we can access layers by name.
            map.getImageLayer("image_test").visible = false;

        }

        public function onTMXUpdated(file:String, tmx:TMXDocument):void
        {
            trace("started parsing tmx: " + file);

            trace("\tversion: " + tmx.version);
            trace("\torientation: " + tmx.orientation);
            trace("\twidth: " + tmx.width);
            trace("\theight: " + tmx.height);
            trace("\ttileWidth: " + tmx.tileWidth);
            trace("\ttileHeight: " + tmx.tileHeight);
            trace("\tbackgroundcolor: " + tmx.backgroundcolor);
        }

        public function onTilesetParsed(file:String, tileset:TMXTileset):void
        {
            trace("parsed tileset:");
            trace("\tname: " + tileset.name);
            trace("\tfirstgid: " + tileset.firstgid);
            trace("\ttilewidth: " + tileset.tilewidth);
            trace("\ttileheight: " + tileset.tileheight);
            trace("\tspacing: " + tileset.spacing);
            trace("\tmargin: " + tileset.margin);

            var i = tileset.image;
            trace("\timage: [ fmt:" + i.format + " src:" + i.source + " trans:" + i.trans + " w:" + i.width + " h:" + i.height + "]");

            var terrainTypes = tileset.terrainTypes;
            if (terrainTypes.length > 0)
            {
                trace("\tterraintypes:");
                for each (var terrain in terrainTypes)
                {
                    trace("\t\tterrain: [" + terrain.name + " " + terrain.tile + "]");
                }
            }

            var tiles = tileset.tiles;
            if (tiles.length > 0)
            {
                trace("\ttiles:");
                for each (var tile in tiles)
                {
                    var terrainString = "";
                    for each (var t in tile.terrain)
                    {
                        terrainString = terrainString + t + " ";
                    }
                    trace("\t\ttile: [ id:" + tile.id + " terrain: " + terrainString + " probability:" + tile.probability + "]");
                }
            }
        }

        public function onLayerParsed(file:String, layer:TMXLayer):void
        {
            trace("parsed layer:" + layer.name);
            trace("\tx: " + layer.x);
            trace("\ty: " + layer.y);
            trace("\twidth: " + layer.width);
            trace("\theight: " + layer.height);
            trace("\topacity: " + layer.opacity);
            trace("\tvisible: " + layer.visible);

            for (var key in layer.properties)
            {
                trace("\tproperties[" + key + "] = " + layer.properties[key]);
            }

            // var x = 0;
            // var y = 0;
            // for (y = 0; y < layer.height; ++y)
            // {
            //     var row:String = ""
            //     for (x = 0; x < layer.width; ++x)
            //     {
            //         row = row + layer.tiles[(y * layer.width) + x] + " ";
            //     }
            //     trace(row);
            // }
        }

        public function onObjectGroupParsed(file:String, group:TMXObjectGroup):void
        {
            trace("parsed object group:" + group.name);
            trace("objects:");
            for each (var object:TMXObject in group.objects)
            {
                switch (object.type)
                {
                    case TMXObjectType.RECTANGLE:
                        var rect = object as TMXRectangle;
                        trace("\trect [" + rect.x + " " + rect.y + " " + rect.width + " " + rect.height + "]");
                        break;
                    case TMXObjectType.ELLIPSE:
                        var ellipse = object as TMXEllipse;
                        trace("\tellipse [" + ellipse.x + " " + ellipse.y + " " + ellipse.width + " " + ellipse.height + "]");
                        break;
                    case TMXObjectType.TILE:
                        var tile = object as TMXTileObject;
                        trace("\ttile [" + tile.x + " " + tile.y + " " + tile.gid + "]");
                        break;
                    case TMXObjectType.POLYGON:
                        var poly = object as TMXPolygon;
                        trace("\tpolygon [" + poly.x + " " + poly.y + "]");
                        var point = 0;
                        var str = "\t\t";
                        for (point = 0; point < poly.points.length; point += 2)
                        {
                            str = str + poly.points[point] + "," + poly.points[point+1] + " ";
                        }
                        trace(str);
                        break;
                    case TMXObjectType.POLYLINE:
                        var line = object as TMXPolyLine;
                        trace("\tpolyline [" + line.x + " " + line.y + "]");
                        str = "\t\t";
                        for (point = 0; point < line.points.length; point += 2)
                        {
                            str = str + line.points[point] + "," + line.points[point+1] + " ";
                        }
                        trace(str);
                        break;
                }
            }
        }

        public function onImageLayerParsed(file:String, imageLayer:TMXImageLayer):void
        {
            trace("parsed image layer:");
            var i = imageLayer.image;
            trace("\timage: [ name:" + imageLayer.name + " src:" + i.source + "]");

        }

        public function onPropertiesParsed(file:String, properties:Dictionary.<String, String>):void
        {
            trace("parsed map properties:");
            for (var key in properties)
            {
                trace("\tproperties[" + key + "] = " + properties[key]);
            }
        }

        public function onTMXLoadComplete(file:String, tmx:TMXDocument):void
        {
            trace("finished parsing tmx: " + file);
        }
    }
}