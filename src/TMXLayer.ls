package tmx
{
    import system.xml.*;

    class TMXLayer
    {
        public var name:String;
        public var x:uint = 0;
        public var y:uint = 0;
        public var width:uint;
        public var height:uint;
        public var opacity:Number = 1;
        public var visible:Boolean = true;
        public var tiles:Vector.<int> = [];

        public var properties:Dictionary.<String, String> = {};

        public function TMXLayer(element:XMLElement, mapWidth:uint, mapHeight:uint)
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