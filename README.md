LoomTMX
=======

TMX Parser for Loom Game Engine

Inspired by [this discussion](http://theengine.co/forums/loom-with-loomscript/topics/current-shortcomings-of-the-tmx-classes) on the Loom Forums.

This is a pretty simple parser for TMX files produced by [Tiled](http://www.mapeditor.org) with a delegate-driven interface for handling the parsing of different elements.

Still very much a WIP, but if you run the provided app ([LoomTMX.ls](https://github.com/southpawfishel/LoomTMX/blob/master/src/LoomTMX.ls)) and tinker with a it a bit, you'll probably get the gist of it pretty quickly.

Still TODO:
* Parser: support gzip compressed layers
* Parser: support embedded image data
* Implement a view component that builds itself using the delegate API (perhaps just figure out how to hook this to Loom's built-in TMX support)
