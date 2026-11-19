{{flutter_js}}
{{flutter_build_config}}

// Starts the game with Flutter's skwasm renderer on every browser that can
// run it, Safari included: Flutter leaves it off there by default, but on
// iPhone it is what keeps the animations smooth. Browsers that cannot run it
// get the JavaScript build with CanvasKit.
//
// CanvasKit is taken from this site rather than from Google's servers: the
// page is cross-origin isolated (see _headers), which lets skwasm draw on a
// thread of its own, and would block files from other sites.
_flutter.loader.load({
  config: {
    wasmAllowList: { webkit: true },
    canvasKitBaseUrl: "canvaskit/",
  },
});
