LoomTMX
=======

TMX Parser for Loom Game Engine

Inspired by [this discussion](http://theengine.co/forums/loom-with-loomscript/topics/current-shortcomings-of-the-tmx-classes) on the Loom Forums.

This is a pretty simple parser for TMX files produced by [Tiled](http://www.mapeditor.org) with a delegate-driven interface for handling the parsing of different elements.

Still very much a WIP, but if you run the provided app and tinker with a it a bit, you'll probably get the gist of it pretty quickly.

Still TODO:
* Finish supporting the rest of the TMX spec that is supported by TiledQt
* Get a view component that builds itself using the delegate API (perhaps just figure out how to hook this to Loom's built-in TMX support)