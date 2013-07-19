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

            // Setup anything else, like UI, or game objects.
            var bg = new Image(Texture.fromAsset("assets/bg.png"));
            bg.width = stage.stageWidth;
            bg.height = stage.stageHeight;
            stage.addChild(bg);
            
            var sprite = new Image(Texture.fromAsset("assets/logo.png"));
            sprite.center();
            sprite.x = stage.stageWidth / 2;
            sprite.y = stage.stageHeight / 2 + 50;
            stage.addChild(sprite);

            var label = new SimpleLabel("assets/Curse-hd.fnt");
            label.text = "Hello Loom!";
            label.center();
            label.x = stage.stageWidth / 2;
            label.y = stage.stageHeight / 2 - 100;
            stage.addChild(label);

            var tmx:TMXDocument = new TMXDocument("assets/tiled_examples/desert.tmx");
            tmx.onTilesetParsed += onTilesetParsed;
            tmx.onLayerParsed += onLayerParsed;
            tmx.onObjectGroupParsed += onObjectGroupParsed;
            tmx.onPropertiesParsed += onPropertiesParsed;
            tmx.onTMXUpdated += onTMXUpdated;
            tmx.load();

        }

        public function onTilesetParsed(file:String, tileset:TMXTileSet):void
        {
            trace("parsed tileset:");
            trace("name: " + tileset.name);
            trace("firstgid: " + tileset.firstgid);
            trace("tilewidth: " + tileset.tilewidth);
            trace("tileheight: " + tileset.tileheight);
            trace("spacing: " + tileset.spacing);
            trace("margin: " + tileset.margin);
        }

        public function onLayerParsed(file:String, layer:TMXLayer):void
        {
            trace("parsed layer:" + layer.name);
            trace("x: " + layer.x);
            trace("y: " + layer.y);
            trace("width: " + layer.width);
            trace("height: " + layer.height);
            trace("opacity: " + layer.opacity);
            trace("visible: " + layer.visible);

            for (var key in layer.properties)
            {
                trace("properties[" + key + "] = " + layer.properties[key]);
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
                        trace("rect [" + rect.x + " " + rect.y + " " + rect.width + " " + rect.height + "]");
                        break;
                    case TMXObjectType.ELLIPSE:
                        var ellipse = object as TMXEllipse;
                        trace("ellipse [" + ellipse.x + " " + ellipse.y + " " + ellipse.width + " " + ellipse.height + "]");
                        break;
                    case TMXObjectType.TILE:
                        var tile = object as TMXTileObject;
                        trace("tile [" + tile.x + " " + tile.y + " " + tile.gid + "]");
                        break;
                    case TMXObjectType.POLYGON:
                        var poly = object as TMXPolygon;
                        trace("polygon [" + poly.x + " " + poly.y + "]");
                        var point = 0;
                        var str = "";
                        for (point = 0; point < poly.points.length; point += 2)
                        {
                            str = str + poly.points[point] + "," + poly.points[point+1] + " ";
                        }
                        trace(str);
                        break;
                    case TMXObjectType.POLYLINE:
                        var line = object as TMXPolyLine;
                        trace("polyline [" + line.x + " " + line.y + "]");
                        str = "";
                        for (point = 0; point < line.points.length; point += 2)
                        {
                            str = str + line.points[point] + "," + line.points[point+1] + " ";
                        }
                        trace(str);
                        break;
                }
            }
        }

        public function onPropertiesParsed(file:String, properties:Dictionary.<String, String>):void
        {
            trace("parsed map properties:");
            for (var key in properties)
            {
                trace("properties[" + key + "] = " + properties[key]);
            }
        }

        public function onTMXUpdated(file:String, tmx:TMXDocument):void
        {
            trace("finished parsing tmx: " + file);

            trace("version: " + tmx.version);
            trace("orientation: " + tmx.orientation);
            trace("width: " + tmx.width);
            trace("height: " + tmx.height);
            trace("tileWidth: " + tmx.tileWidth);
            trace("tileHeight: " + tmx.tileHeight);
            trace("backgroundcolor: " + tmx.backgroundcolor);
        }
    }
}