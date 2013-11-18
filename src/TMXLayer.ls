package tmx
{
    import system.xml.*;

    class TMXLayer
    {
        public var name:String;
        public var x:int = 0;
        public var y:int = 0;
        public var width:int;
        public var height:int;
        public var opacity:Number = 1;
        public var visible:Boolean = true;
        public var tiles:Vector.<uint> = [];

        public var properties:Dictionary.<String, String> = {};

        public function TMXLayer(element:XMLElement, mapWidth:int, mapHeight:int)
        {
            name = element.getAttribute("name");
            var xAttr = element.findAttribute("x");
            x = xAttr ? xAttr.numberValue : 0;
            var yAttr = element.findAttribute("y");
            y = yAttr ? xAttr.numberValue : 0;
            width = mapWidth;
            height = mapHeight;
            var opacityAttr = element.findAttribute("opacity");
            opacity = opacityAttr ? opacityAttr.numberValue : 1.0;
            var visibleAttr = element.findAttribute("visible");
            visible = visibleAttr ? visibleAttr.numberValue as Boolean : true;

            var nextChild:XMLElement = element.firstChildElement();
            while (nextChild)
            {
                if (nextChild.getValue() == "data")
                {
                    var data:TMXData = new TMXData(nextChild, width, height);
                    tiles = data.data;
                }
                else if (nextChild.getValue() == "properties")
                {
                    TMXDocument.loadProperties(nextChild, properties);
                }

                nextChild = nextChild.nextSiblingElement();
            }
        }
    }
}