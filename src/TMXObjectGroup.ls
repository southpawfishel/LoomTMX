package tmx
{
    import system.xml.*;

    public class TMXObjectGroup
    {
        public var name:String;
        public var color:String;
        public var opacity:Number = 1;
        public var visible:Boolean = true;

        public var properties:Dictionary.<String, String> = {};

        public var objects:Vector.<TMXObject> = [];

        public function TMXObjectGroup(element:XMLElement)
        {
            name = element.getAttribute("name");
            color = element.getAttribute("color");
            var opacityAttr = element.findAttribute("opacity");
            opacity = opacityAttr ? opacityAttr.numberValue : 1.0;
            var visibleAttr = element.findAttribute("visible");
            visible = visibleAttr ? visibleAttr.numberValue as Boolean : true;

            var nextChild:XMLElement = element.firstChildElement();
            while (nextChild)
            {
                if (nextChild.getValue() == "object")
                {
                    var object:TMXObject = parseObject(nextChild);
                    objects.pushSingle(object);
                }
                else if (nextChild.getValue() == "properties")
                {
                    TMXDocument.loadProperties(nextChild, properties);
                }

                nextChild = nextChild.nextSiblingElement();
            }
        }

        private function parseObject(element:XMLElement):TMXObject
        {
            var x = element.getNumberAttribute("x") as int;
            var y = element.getNumberAttribute("y") as int;

            var child = element.firstChildElement();

            if (!child)
            {
                var width = element.getNumberAttribute("width") as int;
                var height = element.getNumberAttribute("height") as int;
                var gidAttr = element.findAttribute("gid");
                if (gidAttr)
                {
                    return new TMXTileObject(x, y, gidAttr.numberValue as int);
                }
                else
                {
                    return new TMXRectangle(x, y, width, height);
                }
            }
            else if (child.getValue() == "ellipse")
            {
                width = element.getNumberAttribute("width") as int;
                height = element.getNumberAttribute("height") as int;
                return new TMXEllipse(x, y, width, height);
            }
            else if (child.getValue() == "polygon")
            {
                return new TMXPolygon(x, y, parsePoints(child.getAttribute("points")));
            }
            else if (child.getValue() == "polyline")
            {
                return new TMXPolyLine(x, y, parsePoints(child.getAttribute("points")));
            }

            return null;
        }

        private function parsePoints(pointsString:String):Vector.<int>
        {
            var vec = new Vector.<int>();

            var points = pointsString.split(" ");
            var point:String = null;
            for each (point in points)
            {
                var coords = point.split(",");
                vec.push(coords[0].toNumber(), coords[1].toNumber());
            }

            return vec;
        }
    }

    public enum TMXObjectType
    {
        RECTANGLE,
        ELLIPSE,
        TILE,
        POLYGON,
        POLYLINE
    }

    public class TMXObject
    {
        public var x:int;
        public var y:int;
        public var type:TMXObjectType;

        public function TMXObject(x:int, y:int)
        {
            this.x = x;
            this.y = y;
        }
    }

    public class TMXRectangle extends TMXObject
    {
        public var width:int;
        public var height:int;

        public function TMXRectangle(x:int, y:int, width:int, height:int)
        {
            super(x, y);
            this.type = TMXObjectType.RECTANGLE;
            this.width = width;
            this.height = height;
        }
    }

    public class TMXEllipse extends TMXObject
    {
        public var width:int;
        public var height:int;

        public function TMXEllipse(x:int, y:int, width:int, height:int)
        {
            super(x, y);
            this.type = TMXObjectType.ELLIPSE;
            this.width = width;
            this.height = height;
        }
    }

    public class TMXTileObject extends TMXObject
    {
        public var gid:int;

        public function TMXTileObject(x:int, y:int, gid:int)
        {
            super(x, y);
            this.type = TMXObjectType.TILE;
            this.gid = gid;
        }
    }

    public class TMXPolygon extends TMXObject
    {
        public var points:Vector.<int> = [];

        public function TMXPolygon(x:int, y:int, points:Vector.<int>)
        {
            super(x, y);
            this.type = TMXObjectType.POLYGON;
            this.points = points;
        }
    }

    public class TMXPolyLine extends TMXObject
    {
        public var points:Vector.<int> = [];

        public function TMXPolyLine(x:int, y:int, points:Vector.<int>)
        {
            super(x, y);
            this.type = TMXObjectType.POLYLINE;
            this.points = points;
        }
    }
}