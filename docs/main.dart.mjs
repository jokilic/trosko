// Compiles a dart2wasm-generated main module from `source` which can then
// instantiatable via the `instantiate` method.
//
// `source` needs to be a `Response` object (or promise thereof) e.g. created
// via the `fetch()` JS API.
export async function compileStreaming(source) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(
      await WebAssembly.compileStreaming(source, builtins), builtins);
}

// Compiles a dart2wasm-generated wasm modules from `bytes` which is then
// instantiatable via the `instantiate` method.
export async function compile(bytes) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(await WebAssembly.compile(bytes, builtins), builtins);
}

// DEPRECATED: Please use `compile` or `compileStreaming` to get a compiled app,
// use `instantiate` method to get an instantiated app and then call
// `invokeMain` to invoke the main function.
export async function instantiate(modulePromise, importObjectPromise) {
  var moduleOrCompiledApp = await modulePromise;
  if (!(moduleOrCompiledApp instanceof CompiledApp)) {
    moduleOrCompiledApp = new CompiledApp(moduleOrCompiledApp);
  }
  const instantiatedApp = await moduleOrCompiledApp.instantiate(await importObjectPromise);
  return instantiatedApp.instantiatedModule;
}

// DEPRECATED: Please use `compile` or `compileStreaming` to get a compiled app,
// use `instantiate` method to get an instantiated app and then call
// `invokeMain` to invoke the main function.
export const invoke = (moduleInstance, ...args) => {
  moduleInstance.exports.$invokeMain(args);
}

class CompiledApp {
  constructor(module, builtins) {
    this.module = module;
    this.builtins = builtins;
  }

  // The second argument is an options object containing:
  // `loadDeferredWasm` is a JS function that takes a module name matching a
  //   wasm file produced by the dart2wasm compiler and returns the bytes to
  //   load the module. These bytes can be in either a format supported by
  //   `WebAssembly.compile` or `WebAssembly.compileStreaming`.
  // `loadDynamicModule` is a JS function that takes two string names matching,
  //   in order, a wasm file produced by the dart2wasm compiler during dynamic
  //   module compilation and a corresponding js file produced by the same
  //   compilation. It should return a JS Array containing 2 elements. The first
  //   should be the bytes for the wasm module in a format supported by
  //   `WebAssembly.compile` or `WebAssembly.compileStreaming`. The second
  //   should be the result of using the JS 'import' API on the js file path.
  async instantiate(additionalImports, {loadDeferredWasm, loadDynamicModule} = {}) {
    let dartInstance;

    // Prints to the console
    function printToConsole(value) {
      if (typeof dartPrint == "function") {
        dartPrint(value);
        return;
      }
      if (typeof console == "object" && typeof console.log != "undefined") {
        console.log(value);
        return;
      }
      if (typeof print == "function") {
        print(value);
        return;
      }

      throw "Unable to print message: " + value;
    }

    // A special symbol attached to functions that wrap Dart functions.
    const jsWrappedDartFunctionSymbol = Symbol("JSWrappedDartFunction");

    function finalizeWrapper(dartFunction, wrapped) {
      wrapped.dartFunction = dartFunction;
      wrapped[jsWrappedDartFunctionSymbol] = true;
      return wrapped;
    }

    // Imports
    const dart2wasm = {
            _3: (o, t) => typeof o === t,
      _4: (o, c) => o instanceof c,
      _7: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._7(f,arguments.length,x0) }),
      _8: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._8(f,arguments.length,x0,x1) }),
      _37: x0 => new Array(x0),
      _39: x0 => x0.length,
      _41: (x0,x1) => x0[x1],
      _42: (x0,x1,x2) => { x0[x1] = x2 },
      _43: x0 => new Promise(x0),
      _45: (x0,x1,x2) => new DataView(x0,x1,x2),
      _47: x0 => new Int8Array(x0),
      _48: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      _49: x0 => new Uint8Array(x0),
      _51: x0 => new Uint8ClampedArray(x0),
      _53: x0 => new Int16Array(x0),
      _55: x0 => new Uint16Array(x0),
      _57: x0 => new Int32Array(x0),
      _59: x0 => new Uint32Array(x0),
      _61: x0 => new Float32Array(x0),
      _63: x0 => new Float64Array(x0),
      _65: (x0,x1,x2) => x0.call(x1,x2),
      _70: (decoder, codeUnits) => decoder.decode(codeUnits),
      _71: () => new TextDecoder("utf-8", {fatal: true}),
      _72: () => new TextDecoder("utf-8", {fatal: false}),
      _73: (s) => +s,
      _74: x0 => new Uint8Array(x0),
      _75: (x0,x1,x2) => x0.set(x1,x2),
      _76: (x0,x1) => x0.transferFromImageBitmap(x1),
      _78: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._78(f,arguments.length,x0) }),
      _79: x0 => new window.FinalizationRegistry(x0),
      _80: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      _81: (x0,x1) => x0.unregister(x1),
      _82: (x0,x1,x2) => x0.slice(x1,x2),
      _83: (x0,x1) => x0.decode(x1),
      _84: (x0,x1) => x0.segment(x1),
      _85: () => new TextDecoder(),
      _87: x0 => x0.click(),
      _88: x0 => x0.buffer,
      _89: x0 => x0.wasmMemory,
      _90: () => globalThis.window._flutter_skwasmInstance,
      _91: x0 => x0.rasterStartMilliseconds,
      _92: x0 => x0.rasterEndMilliseconds,
      _93: x0 => x0.imageBitmaps,
      _120: x0 => x0.remove(),
      _121: (x0,x1) => x0.append(x1),
      _122: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _123: (x0,x1) => x0.querySelector(x1),
      _125: (x0,x1) => x0.removeChild(x1),
      _203: x0 => x0.stopPropagation(),
      _204: x0 => x0.preventDefault(),
      _206: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      _251: x0 => x0.unlock(),
      _252: x0 => x0.getReader(),
      _253: (x0,x1,x2) => x0.addEventListener(x1,x2),
      _254: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      _255: (x0,x1) => x0.item(x1),
      _256: x0 => x0.next(),
      _257: x0 => x0.now(),
      _258: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._258(f,arguments.length,x0) }),
      _259: (x0,x1) => x0.addListener(x1),
      _260: (x0,x1) => x0.removeListener(x1),
      _261: (x0,x1) => x0.matchMedia(x1),
      _262: (x0,x1) => x0.revokeObjectURL(x1),
      _263: x0 => x0.close(),
      _264: (x0,x1,x2,x3,x4) => ({type: x0,data: x1,premultiplyAlpha: x2,colorSpaceConversion: x3,preferAnimation: x4}),
      _265: x0 => new window.ImageDecoder(x0),
      _266: x0 => ({frameIndex: x0}),
      _267: (x0,x1) => x0.decode(x1),
      _268: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._268(f,arguments.length,x0) }),
      _269: (x0,x1) => x0.getModifierState(x1),
      _270: (x0,x1) => x0.removeProperty(x1),
      _271: (x0,x1) => x0.prepend(x1),
      _272: x0 => x0.disconnect(),
      _273: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._273(f,arguments.length,x0) }),
      _274: (x0,x1) => x0.getAttribute(x1),
      _275: (x0,x1) => x0.contains(x1),
      _276: x0 => x0.blur(),
      _277: x0 => x0.hasFocus(),
      _278: (x0,x1) => x0.hasAttribute(x1),
      _279: (x0,x1) => x0.getModifierState(x1),
      _280: (x0,x1) => x0.appendChild(x1),
      _281: (x0,x1) => x0.createTextNode(x1),
      _282: (x0,x1) => x0.removeAttribute(x1),
      _283: x0 => x0.getBoundingClientRect(),
      _284: (x0,x1) => x0.observe(x1),
      _285: x0 => x0.disconnect(),
      _286: (x0,x1) => x0.closest(x1),
      _696: () => globalThis.window.flutterConfiguration,
      _697: x0 => x0.assetBase,
      _703: x0 => x0.debugShowSemanticsNodes,
      _704: x0 => x0.hostElement,
      _705: x0 => x0.multiViewEnabled,
      _706: x0 => x0.nonce,
      _708: x0 => x0.fontFallbackBaseUrl,
      _712: x0 => x0.console,
      _713: x0 => x0.devicePixelRatio,
      _714: x0 => x0.document,
      _715: x0 => x0.history,
      _716: x0 => x0.innerHeight,
      _717: x0 => x0.innerWidth,
      _718: x0 => x0.location,
      _719: x0 => x0.navigator,
      _720: x0 => x0.visualViewport,
      _721: x0 => x0.performance,
      _723: x0 => x0.URL,
      _725: (x0,x1) => x0.getComputedStyle(x1),
      _726: x0 => x0.screen,
      _727: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._727(f,arguments.length,x0) }),
      _728: (x0,x1) => x0.requestAnimationFrame(x1),
      _733: (x0,x1) => x0.warn(x1),
      _736: x0 => globalThis.parseFloat(x0),
      _737: () => globalThis.window,
      _738: () => globalThis.Intl,
      _739: () => globalThis.Symbol,
      _740: (x0,x1,x2,x3,x4) => globalThis.createImageBitmap(x0,x1,x2,x3,x4),
      _742: x0 => x0.clipboard,
      _743: x0 => x0.maxTouchPoints,
      _744: x0 => x0.vendor,
      _745: x0 => x0.language,
      _746: x0 => x0.platform,
      _747: x0 => x0.userAgent,
      _748: (x0,x1) => x0.vibrate(x1),
      _749: x0 => x0.languages,
      _750: x0 => x0.documentElement,
      _751: (x0,x1) => x0.querySelector(x1),
      _754: (x0,x1) => x0.createElement(x1),
      _757: (x0,x1) => x0.createEvent(x1),
      _758: x0 => x0.activeElement,
      _761: x0 => x0.head,
      _762: x0 => x0.body,
      _764: (x0,x1) => { x0.title = x1 },
      _767: x0 => x0.visibilityState,
      _768: () => globalThis.document,
      _769: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._769(f,arguments.length,x0) }),
      _770: (x0,x1) => x0.dispatchEvent(x1),
      _778: x0 => x0.target,
      _780: x0 => x0.timeStamp,
      _781: x0 => x0.type,
      _783: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      _790: x0 => x0.firstChild,
      _794: x0 => x0.parentElement,
      _796: (x0,x1) => { x0.textContent = x1 },
      _797: x0 => x0.parentNode,
      _799: x0 => x0.isConnected,
      _803: x0 => x0.firstElementChild,
      _805: x0 => x0.nextElementSibling,
      _806: x0 => x0.clientHeight,
      _807: x0 => x0.clientWidth,
      _808: x0 => x0.offsetHeight,
      _809: x0 => x0.offsetWidth,
      _810: x0 => x0.id,
      _811: (x0,x1) => { x0.id = x1 },
      _814: (x0,x1) => { x0.spellcheck = x1 },
      _815: x0 => x0.tagName,
      _816: x0 => x0.style,
      _818: (x0,x1) => x0.querySelectorAll(x1),
      _819: (x0,x1,x2) => x0.setAttribute(x1,x2),
      _820: x0 => x0.tabIndex,
      _821: (x0,x1) => { x0.tabIndex = x1 },
      _822: (x0,x1) => x0.focus(x1),
      _823: x0 => x0.scrollTop,
      _824: (x0,x1) => { x0.scrollTop = x1 },
      _825: x0 => x0.scrollLeft,
      _826: (x0,x1) => { x0.scrollLeft = x1 },
      _827: x0 => x0.classList,
      _829: (x0,x1) => { x0.className = x1 },
      _831: (x0,x1) => x0.getElementsByClassName(x1),
      _832: (x0,x1) => x0.attachShadow(x1),
      _835: x0 => x0.computedStyleMap(),
      _836: (x0,x1) => x0.get(x1),
      _842: (x0,x1) => x0.getPropertyValue(x1),
      _843: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
      _844: x0 => x0.offsetLeft,
      _845: x0 => x0.offsetTop,
      _846: x0 => x0.offsetParent,
      _848: (x0,x1) => { x0.name = x1 },
      _849: x0 => x0.content,
      _850: (x0,x1) => { x0.content = x1 },
      _854: (x0,x1) => { x0.src = x1 },
      _855: x0 => x0.naturalWidth,
      _856: x0 => x0.naturalHeight,
      _860: (x0,x1) => { x0.crossOrigin = x1 },
      _862: (x0,x1) => { x0.decoding = x1 },
      _863: x0 => x0.decode(),
      _868: (x0,x1) => { x0.nonce = x1 },
      _873: (x0,x1) => { x0.width = x1 },
      _875: (x0,x1) => { x0.height = x1 },
      _878: (x0,x1) => x0.getContext(x1),
      _940: (x0,x1) => x0.fetch(x1),
      _941: x0 => x0.status,
      _943: x0 => x0.body,
      _944: x0 => x0.arrayBuffer(),
      _947: x0 => x0.read(),
      _948: x0 => x0.value,
      _949: x0 => x0.done,
      _951: x0 => x0.name,
      _952: x0 => x0.x,
      _953: x0 => x0.y,
      _956: x0 => x0.top,
      _957: x0 => x0.right,
      _958: x0 => x0.bottom,
      _959: x0 => x0.left,
      _971: x0 => x0.height,
      _972: x0 => x0.width,
      _973: x0 => x0.scale,
      _974: (x0,x1) => { x0.value = x1 },
      _977: (x0,x1) => { x0.placeholder = x1 },
      _979: (x0,x1) => { x0.name = x1 },
      _980: x0 => x0.selectionDirection,
      _981: x0 => x0.selectionStart,
      _982: x0 => x0.selectionEnd,
      _985: x0 => x0.value,
      _987: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      _988: x0 => x0.readText(),
      _989: (x0,x1) => x0.writeText(x1),
      _991: x0 => x0.altKey,
      _992: x0 => x0.code,
      _993: x0 => x0.ctrlKey,
      _994: x0 => x0.key,
      _995: x0 => x0.keyCode,
      _996: x0 => x0.location,
      _997: x0 => x0.metaKey,
      _998: x0 => x0.repeat,
      _999: x0 => x0.shiftKey,
      _1000: x0 => x0.isComposing,
      _1002: x0 => x0.state,
      _1003: (x0,x1) => x0.go(x1),
      _1005: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
      _1006: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      _1007: x0 => x0.pathname,
      _1008: x0 => x0.search,
      _1009: x0 => x0.hash,
      _1013: x0 => x0.state,
      _1016: (x0,x1) => x0.createObjectURL(x1),
      _1018: x0 => new Blob(x0),
      _1020: x0 => new MutationObserver(x0),
      _1021: (x0,x1,x2) => x0.observe(x1,x2),
      _1022: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1022(f,arguments.length,x0,x1) }),
      _1025: x0 => x0.attributeName,
      _1026: x0 => x0.type,
      _1027: x0 => x0.matches,
      _1028: x0 => x0.matches,
      _1032: x0 => x0.relatedTarget,
      _1034: x0 => x0.clientX,
      _1035: x0 => x0.clientY,
      _1036: x0 => x0.offsetX,
      _1037: x0 => x0.offsetY,
      _1040: x0 => x0.button,
      _1041: x0 => x0.buttons,
      _1042: x0 => x0.ctrlKey,
      _1046: x0 => x0.pointerId,
      _1047: x0 => x0.pointerType,
      _1048: x0 => x0.pressure,
      _1049: x0 => x0.tiltX,
      _1050: x0 => x0.tiltY,
      _1051: x0 => x0.getCoalescedEvents(),
      _1054: x0 => x0.deltaX,
      _1055: x0 => x0.deltaY,
      _1056: x0 => x0.wheelDeltaX,
      _1057: x0 => x0.wheelDeltaY,
      _1058: x0 => x0.deltaMode,
      _1065: x0 => x0.changedTouches,
      _1068: x0 => x0.clientX,
      _1069: x0 => x0.clientY,
      _1072: x0 => x0.data,
      _1075: (x0,x1) => { x0.disabled = x1 },
      _1077: (x0,x1) => { x0.type = x1 },
      _1078: (x0,x1) => { x0.max = x1 },
      _1079: (x0,x1) => { x0.min = x1 },
      _1080: x0 => x0.value,
      _1081: (x0,x1) => { x0.value = x1 },
      _1082: x0 => x0.disabled,
      _1083: (x0,x1) => { x0.disabled = x1 },
      _1085: (x0,x1) => { x0.placeholder = x1 },
      _1087: (x0,x1) => { x0.name = x1 },
      _1089: (x0,x1) => { x0.autocomplete = x1 },
      _1090: x0 => x0.selectionDirection,
      _1092: x0 => x0.selectionStart,
      _1093: x0 => x0.selectionEnd,
      _1096: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      _1097: (x0,x1) => x0.add(x1),
      _1100: (x0,x1) => { x0.noValidate = x1 },
      _1101: (x0,x1) => { x0.method = x1 },
      _1102: (x0,x1) => { x0.action = x1 },
      _1128: x0 => x0.orientation,
      _1129: x0 => x0.width,
      _1130: x0 => x0.height,
      _1131: (x0,x1) => x0.lock(x1),
      _1150: x0 => new ResizeObserver(x0),
      _1153: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1153(f,arguments.length,x0,x1) }),
      _1161: x0 => x0.length,
      _1162: x0 => x0.iterator,
      _1163: x0 => x0.Segmenter,
      _1164: x0 => x0.v8BreakIterator,
      _1165: (x0,x1) => new Intl.Segmenter(x0,x1),
      _1166: x0 => x0.done,
      _1167: x0 => x0.value,
      _1168: x0 => x0.index,
      _1172: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
      _1173: (x0,x1) => x0.adoptText(x1),
      _1174: x0 => x0.first(),
      _1175: x0 => x0.next(),
      _1176: x0 => x0.current(),
      _1182: x0 => x0.hostElement,
      _1183: x0 => x0.viewConstraints,
      _1186: x0 => x0.maxHeight,
      _1187: x0 => x0.maxWidth,
      _1188: x0 => x0.minHeight,
      _1189: x0 => x0.minWidth,
      _1190: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1190(f,arguments.length,x0) }),
      _1191: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1191(f,arguments.length,x0) }),
      _1192: (x0,x1) => ({addView: x0,removeView: x1}),
      _1193: x0 => x0.loader,
      _1194: () => globalThis._flutter,
      _1195: (x0,x1) => x0.didCreateEngineInitializer(x1),
      _1196: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1196(f,arguments.length,x0) }),
      _1197: f => finalizeWrapper(f, function() { return dartInstance.exports._1197(f,arguments.length) }),
      _1198: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
      _1199: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1199(f,arguments.length,x0) }),
      _1200: x0 => ({runApp: x0}),
      _1201: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1201(f,arguments.length,x0,x1) }),
      _1202: x0 => x0.length,
      _1203: () => globalThis.window.ImageDecoder,
      _1204: x0 => x0.tracks,
      _1206: x0 => x0.completed,
      _1208: x0 => x0.image,
      _1214: x0 => x0.displayWidth,
      _1215: x0 => x0.displayHeight,
      _1216: x0 => x0.duration,
      _1219: x0 => x0.ready,
      _1220: x0 => x0.selectedTrack,
      _1221: x0 => x0.repetitionCount,
      _1222: x0 => x0.frameCount,
      _1283: x0 => x0.toArray(),
      _1284: x0 => x0.toUint8Array(),
      _1285: x0 => ({serverTimestamps: x0}),
      _1286: x0 => ({source: x0}),
      _1289: x0 => new firebase_firestore.FieldPath(x0),
      _1290: (x0,x1) => new firebase_firestore.FieldPath(x0,x1),
      _1291: (x0,x1,x2) => new firebase_firestore.FieldPath(x0,x1,x2),
      _1292: (x0,x1,x2,x3) => new firebase_firestore.FieldPath(x0,x1,x2,x3),
      _1293: (x0,x1,x2,x3,x4) => new firebase_firestore.FieldPath(x0,x1,x2,x3,x4),
      _1294: (x0,x1,x2,x3,x4,x5) => new firebase_firestore.FieldPath(x0,x1,x2,x3,x4,x5),
      _1295: (x0,x1,x2,x3,x4,x5,x6) => new firebase_firestore.FieldPath(x0,x1,x2,x3,x4,x5,x6),
      _1296: (x0,x1,x2,x3,x4,x5,x6,x7) => new firebase_firestore.FieldPath(x0,x1,x2,x3,x4,x5,x6,x7),
      _1297: (x0,x1,x2,x3,x4,x5,x6,x7,x8) => new firebase_firestore.FieldPath(x0,x1,x2,x3,x4,x5,x6,x7,x8),
      _1298: (x0,x1,x2,x3,x4,x5,x6,x7,x8,x9) => new firebase_firestore.FieldPath(x0,x1,x2,x3,x4,x5,x6,x7,x8,x9),
      _1299: () => globalThis.firebase_firestore.documentId(),
      _1300: (x0,x1) => new firebase_firestore.GeoPoint(x0,x1),
      _1301: x0 => globalThis.firebase_firestore.vector(x0),
      _1302: x0 => globalThis.firebase_firestore.Bytes.fromUint8Array(x0),
      _1303: x0 => globalThis.firebase_firestore.writeBatch(x0),
      _1304: (x0,x1) => globalThis.firebase_firestore.collection(x0,x1),
      _1306: (x0,x1) => globalThis.firebase_firestore.doc(x0,x1),
      _1309: x0 => x0.call(),
      _1333: x0 => x0.commit(),
      _1334: (x0,x1) => x0.delete(x1),
      _1338: x0 => globalThis.firebase_firestore.deleteDoc(x0),
      _1339: x0 => globalThis.firebase_firestore.getDoc(x0),
      _1340: x0 => globalThis.firebase_firestore.getDocFromServer(x0),
      _1341: x0 => globalThis.firebase_firestore.getDocFromCache(x0),
      _1348: (x0,x1) => globalThis.firebase_firestore.setDoc(x0,x1),
      _1349: (x0,x1) => globalThis.firebase_firestore.query(x0,x1),
      _1350: x0 => globalThis.firebase_firestore.getDocs(x0),
      _1351: x0 => globalThis.firebase_firestore.getDocsFromServer(x0),
      _1352: x0 => globalThis.firebase_firestore.getDocsFromCache(x0),
      _1353: x0 => globalThis.firebase_firestore.limit(x0),
      _1354: x0 => globalThis.firebase_firestore.limitToLast(x0),
      _1357: (x0,x1) => globalThis.firebase_firestore.orderBy(x0,x1),
      _1359: (x0,x1,x2) => globalThis.firebase_firestore.where(x0,x1,x2),
      _1365: (x0,x1) => x0.data(x1),
      _1369: x0 => x0.docChanges(),
      _1386: (x0,x1) => globalThis.firebase_firestore.getFirestore(x0,x1),
      _1388: x0 => globalThis.firebase_firestore.Timestamp.fromMillis(x0),
      _1389: f => finalizeWrapper(f, function() { return dartInstance.exports._1389(f,arguments.length) }),
      _1407: () => globalThis.firebase_firestore.or,
      _1408: () => globalThis.firebase_firestore.and,
      _1413: x0 => x0.path,
      _1416: () => globalThis.firebase_firestore.GeoPoint,
      _1417: x0 => x0.latitude,
      _1418: x0 => x0.longitude,
      _1420: () => globalThis.firebase_firestore.VectorValue,
      _1421: () => globalThis.firebase_firestore.Bytes,
      _1424: x0 => x0.type,
      _1426: x0 => x0.doc,
      _1428: x0 => x0.oldIndex,
      _1430: x0 => x0.newIndex,
      _1432: () => globalThis.firebase_firestore.DocumentReference,
      _1436: x0 => x0.path,
      _1445: x0 => x0.metadata,
      _1446: x0 => x0.ref,
      _1451: x0 => x0.docs,
      _1453: x0 => x0.metadata,
      _1457: () => globalThis.firebase_firestore.Timestamp,
      _1458: x0 => x0.seconds,
      _1459: x0 => x0.nanoseconds,
      _1495: x0 => x0.hasPendingWrites,
      _1497: x0 => x0.fromCache,
      _1504: x0 => x0.source,
      _1509: () => globalThis.firebase_firestore.startAfter,
      _1510: () => globalThis.firebase_firestore.startAt,
      _1511: () => globalThis.firebase_firestore.endBefore,
      _1512: () => globalThis.firebase_firestore.endAt,
      _1516: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1516(f,arguments.length,x0) }),
      _1517: (x0,x1,x2) => x0.addEventListener(x1,x2),
      _1518: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1518(f,arguments.length,x0) }),
      _1519: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1519(f,arguments.length,x0) }),
      _1520: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1520(f,arguments.length,x0) }),
      _1521: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1521(f,arguments.length,x0) }),
      _1522: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1522(f,arguments.length,x0) }),
      _1523: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1523(f,arguments.length,x0) }),
      _1524: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1524(f,arguments.length,x0) }),
      _1525: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1525(f,arguments.length,x0) }),
      _1526: (x0,x1) => x0.createElement(x1),
      _1527: (x0,x1) => x0.end(x1),
      _1528: x0 => x0.pause(),
      _1529: x0 => x0.play(),
      _1530: x0 => x0.load(),
      _1531: (x0,x1) => x0.removeAttribute(x1),
      _1532: (x0,x1) => x0.setSinkId(x1),
      _1540: x0 => x0.delete(),
      _1546: (x0,x1) => globalThis.firebase_auth.reauthenticateWithCredential(x0,x1),
      _1560: x0 => x0.toJSON(),
      _1561: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1561(f,arguments.length,x0) }),
      _1562: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1562(f,arguments.length,x0) }),
      _1563: (x0,x1,x2) => x0.onAuthStateChanged(x1,x2),
      _1564: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1564(f,arguments.length,x0) }),
      _1565: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1565(f,arguments.length,x0) }),
      _1566: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1566(f,arguments.length,x0) }),
      _1567: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1567(f,arguments.length,x0) }),
      _1568: (x0,x1,x2) => x0.onIdTokenChanged(x1,x2),
      _1572: (x0,x1,x2) => globalThis.firebase_auth.createUserWithEmailAndPassword(x0,x1,x2),
      _1582: (x0,x1,x2) => globalThis.firebase_auth.signInWithEmailAndPassword(x0,x1,x2),
      _1587: x0 => x0.signOut(),
      _1588: (x0,x1) => globalThis.firebase_auth.connectAuthEmulator(x0,x1),
      _1593: (x0,x1) => globalThis.firebase_auth.EmailAuthProvider.credential(x0,x1),
      _1611: x0 => globalThis.firebase_auth.OAuthProvider.credentialFromResult(x0),
      _1626: x0 => globalThis.firebase_auth.getAdditionalUserInfo(x0),
      _1627: (x0,x1,x2) => ({errorMap: x0,persistence: x1,popupRedirectResolver: x2}),
      _1628: (x0,x1) => globalThis.firebase_auth.initializeAuth(x0,x1),
      _1634: x0 => globalThis.firebase_auth.OAuthProvider.credentialFromError(x0),
      _1649: () => globalThis.firebase_auth.debugErrorMap,
      _1652: () => globalThis.firebase_auth.browserSessionPersistence,
      _1654: () => globalThis.firebase_auth.browserLocalPersistence,
      _1656: () => globalThis.firebase_auth.indexedDBLocalPersistence,
      _1659: x0 => globalThis.firebase_auth.multiFactor(x0),
      _1660: (x0,x1) => globalThis.firebase_auth.getMultiFactorResolver(x0,x1),
      _1662: x0 => x0.currentUser,
      _1666: x0 => x0.tenantId,
      _1676: x0 => x0.displayName,
      _1677: x0 => x0.email,
      _1678: x0 => x0.phoneNumber,
      _1679: x0 => x0.photoURL,
      _1680: x0 => x0.providerId,
      _1681: x0 => x0.uid,
      _1682: x0 => x0.emailVerified,
      _1683: x0 => x0.isAnonymous,
      _1684: x0 => x0.providerData,
      _1685: x0 => x0.refreshToken,
      _1686: x0 => x0.tenantId,
      _1687: x0 => x0.metadata,
      _1689: x0 => x0.providerId,
      _1690: x0 => x0.signInMethod,
      _1691: x0 => x0.accessToken,
      _1692: x0 => x0.idToken,
      _1693: x0 => x0.secret,
      _1704: x0 => x0.creationTime,
      _1705: x0 => x0.lastSignInTime,
      _1710: x0 => x0.code,
      _1712: x0 => x0.message,
      _1724: x0 => x0.email,
      _1725: x0 => x0.phoneNumber,
      _1726: x0 => x0.tenantId,
      _1749: x0 => x0.user,
      _1752: x0 => x0.providerId,
      _1753: x0 => x0.profile,
      _1754: x0 => x0.username,
      _1755: x0 => x0.isNewUser,
      _1758: () => globalThis.firebase_auth.browserPopupRedirectResolver,
      _1763: x0 => x0.displayName,
      _1764: x0 => x0.enrollmentTime,
      _1765: x0 => x0.factorId,
      _1766: x0 => x0.uid,
      _1768: x0 => x0.hints,
      _1769: x0 => x0.session,
      _1771: x0 => x0.phoneNumber,
      _1783: (x0,x1) => x0.getItem(x1),
      _1788: x0 => x0.remove(),
      _1789: (x0,x1) => x0.appendChild(x1),
      _1792: (x0,x1,x2) => x0.setItem(x1,x2),
      _1794: (x0,x1,x2,x3,x4,x5,x6,x7) => ({apiKey: x0,authDomain: x1,databaseURL: x2,projectId: x3,storageBucket: x4,messagingSenderId: x5,measurementId: x6,appId: x7}),
      _1795: (x0,x1) => globalThis.firebase_core.initializeApp(x0,x1),
      _1796: x0 => globalThis.firebase_core.getApp(x0),
      _1797: () => globalThis.firebase_core.getApp(),
      _1799: () => globalThis.firebase_core.SDK_VERSION,
      _1805: x0 => x0.apiKey,
      _1807: x0 => x0.authDomain,
      _1809: x0 => x0.databaseURL,
      _1811: x0 => x0.projectId,
      _1813: x0 => x0.storageBucket,
      _1815: x0 => x0.messagingSenderId,
      _1817: x0 => x0.measurementId,
      _1819: x0 => x0.appId,
      _1821: x0 => x0.name,
      _1822: x0 => x0.options,
      _1823: (x0,x1) => x0.debug(x1),
      _1824: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1824(f,arguments.length,x0) }),
      _1825: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1825(f,arguments.length,x0,x1) }),
      _1826: (x0,x1) => ({createScript: x0,createScriptURL: x1}),
      _1827: (x0,x1,x2) => x0.createPolicy(x1,x2),
      _1828: (x0,x1) => x0.createScriptURL(x1),
      _1829: (x0,x1,x2) => x0.createScript(x1,x2),
      _1830: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1830(f,arguments.length,x0) }),
      _1831: (x0,x1,x2) => x0.setAttribute(x1,x2),
      _1832: (x0,x1) => x0.querySelector(x1),
      _1833: (x0,x1) => x0.append(x1),
      _1834: (x0,x1) => x0.getAttribute(x1),
      _1835: () => globalThis.removeSplashFromWeb(),
      _1837: Date.now,
      _1839: s => new Date(s * 1000).getTimezoneOffset() * 60,
      _1840: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      _1841: () => {
        let stackString = new Error().stack.toString();
        let frames = stackString.split('\n');
        let drop = 2;
        if (frames[0] === 'Error') {
            drop += 1;
        }
        return frames.slice(drop).join('\n');
      },
      _1842: () => typeof dartUseDateNowForTicks !== "undefined",
      _1843: () => 1000 * performance.now(),
      _1844: () => Date.now(),
      _1845: () => {
        // On browsers return `globalThis.location.href`
        if (globalThis.location != null) {
          return globalThis.location.href;
        }
        return null;
      },
      _1846: () => {
        return typeof process != "undefined" &&
               Object.prototype.toString.call(process) == "[object process]" &&
               process.platform == "win32"
      },
      _1847: () => new WeakMap(),
      _1848: (map, o) => map.get(o),
      _1849: (map, o, v) => map.set(o, v),
      _1850: x0 => new WeakRef(x0),
      _1851: x0 => x0.deref(),
      _1858: () => globalThis.WeakRef,
      _1861: s => JSON.stringify(s),
      _1862: s => printToConsole(s),
      _1863: (o, p, r) => o.replaceAll(p, () => r),
      _1864: (o, p, r) => o.replace(p, () => r),
      _1865: Function.prototype.call.bind(String.prototype.toLowerCase),
      _1866: s => s.toUpperCase(),
      _1867: s => s.trim(),
      _1868: s => s.trimLeft(),
      _1869: s => s.trimRight(),
      _1870: (string, times) => string.repeat(times),
      _1871: Function.prototype.call.bind(String.prototype.indexOf),
      _1872: (s, p, i) => s.lastIndexOf(p, i),
      _1873: (string, token) => string.split(token),
      _1874: Object.is,
      _1875: o => o instanceof Array,
      _1876: (a, i) => a.push(i),
      _1880: a => a.pop(),
      _1881: (a, i) => a.splice(i, 1),
      _1882: (a, s) => a.join(s),
      _1883: (a, s, e) => a.slice(s, e),
      _1885: (a, b) => a == b ? 0 : (a > b ? 1 : -1),
      _1886: a => a.length,
      _1888: (a, i) => a[i],
      _1889: (a, i, v) => a[i] = v,
      _1891: o => {
        if (o instanceof ArrayBuffer) return 0;
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
          return 1;
        }
        return 2;
      },
      _1892: (o, offsetInBytes, lengthInBytes) => {
        var dst = new ArrayBuffer(lengthInBytes);
        new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
        return new DataView(dst);
      },
      _1894: o => o instanceof Uint8Array,
      _1895: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      _1896: o => o instanceof Int8Array,
      _1897: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      _1898: o => o instanceof Uint8ClampedArray,
      _1899: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      _1900: o => o instanceof Uint16Array,
      _1901: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      _1902: o => o instanceof Int16Array,
      _1903: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      _1904: o => o instanceof Uint32Array,
      _1905: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      _1906: o => o instanceof Int32Array,
      _1907: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      _1909: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
      _1910: o => o instanceof Float32Array,
      _1911: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      _1912: o => o instanceof Float64Array,
      _1913: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      _1914: (t, s) => t.set(s),
      _1915: l => new DataView(new ArrayBuffer(l)),
      _1916: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      _1918: o => o.buffer,
      _1919: o => o.byteOffset,
      _1920: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      _1921: (b, o) => new DataView(b, o),
      _1922: (b, o, l) => new DataView(b, o, l),
      _1923: Function.prototype.call.bind(DataView.prototype.getUint8),
      _1924: Function.prototype.call.bind(DataView.prototype.setUint8),
      _1925: Function.prototype.call.bind(DataView.prototype.getInt8),
      _1926: Function.prototype.call.bind(DataView.prototype.setInt8),
      _1927: Function.prototype.call.bind(DataView.prototype.getUint16),
      _1928: Function.prototype.call.bind(DataView.prototype.setUint16),
      _1929: Function.prototype.call.bind(DataView.prototype.getInt16),
      _1930: Function.prototype.call.bind(DataView.prototype.setInt16),
      _1931: Function.prototype.call.bind(DataView.prototype.getUint32),
      _1932: Function.prototype.call.bind(DataView.prototype.setUint32),
      _1933: Function.prototype.call.bind(DataView.prototype.getInt32),
      _1934: Function.prototype.call.bind(DataView.prototype.setInt32),
      _1937: Function.prototype.call.bind(DataView.prototype.getBigInt64),
      _1938: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      _1939: Function.prototype.call.bind(DataView.prototype.getFloat32),
      _1940: Function.prototype.call.bind(DataView.prototype.setFloat32),
      _1941: Function.prototype.call.bind(DataView.prototype.getFloat64),
      _1942: Function.prototype.call.bind(DataView.prototype.setFloat64),
      _1955: (ms, c) =>
      setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
      _1956: (handle) => clearTimeout(handle),
      _1957: (ms, c) =>
      setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
      _1958: (handle) => clearInterval(handle),
      _1959: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      _1960: () => Date.now(),
      _1965: o => Object.keys(o),
      _1966: (x0,x1,x2) => x0.transaction(x1,x2),
      _1967: (x0,x1) => x0.objectStore(x1),
      _1968: (x0,x1) => x0.getAllKeys(x1),
      _1969: (x0,x1) => x0.getAll(x1),
      _1971: (x0,x1) => x0.delete(x1),
      _1972: (x0,x1,x2) => x0.put(x1,x2),
      _1973: x0 => x0.clear(),
      _1974: x0 => x0.close(),
      _1976: (x0,x1,x2) => x0.open(x1,x2),
      _1977: (x0,x1) => x0.contains(x1),
      _1980: (x0,x1) => x0.createObjectStore(x1),
      _1981: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1981(f,arguments.length,x0) }),
      _1982: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1982(f,arguments.length,x0) }),
      _1991: () => new AbortController(),
      _1992: x0 => x0.abort(),
      _1993: (x0,x1,x2,x3,x4,x5) => ({method: x0,headers: x1,body: x2,credentials: x3,redirect: x4,signal: x5}),
      _1994: (x0,x1) => globalThis.fetch(x0,x1),
      _1995: (x0,x1) => x0.get(x1),
      _1996: f => finalizeWrapper(f, function(x0,x1,x2) { return dartInstance.exports._1996(f,arguments.length,x0,x1,x2) }),
      _1997: (x0,x1) => x0.forEach(x1),
      _1998: x0 => x0.getReader(),
      _1999: x0 => x0.read(),
      _2000: x0 => x0.cancel(),
      _2001: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2001(f,arguments.length,x0) }),
      _2002: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2002(f,arguments.length,x0) }),
      _2003: x0 => x0.openCursor(),
      _2004: x0 => x0.continue(),
      _2005: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2005(f,arguments.length,x0) }),
      _2006: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2006(f,arguments.length,x0) }),
      _2015: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2015(f,arguments.length,x0) }),
      _2016: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      _2017: (x0,x1,x2,x3) => x0.removeEventListener(x1,x2,x3),
      _2023: (x0,x1) => x0.key(x1),
      _2024: x0 => x0.trustedTypes,
      _2025: (x0,x1) => { x0.text = x1 },
      _2035: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      _2036: (x0,x1) => x0.exec(x1),
      _2037: (x0,x1) => x0.test(x1),
      _2038: x0 => x0.pop(),
      _2040: o => o === undefined,
      _2042: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      _2044: o => {
        const proto = Object.getPrototypeOf(o);
        return proto === Object.prototype || proto === null;
      },
      _2045: o => o instanceof RegExp,
      _2046: (l, r) => l === r,
      _2047: o => o,
      _2048: o => o,
      _2049: o => o,
      _2050: b => !!b,
      _2051: o => o.length,
      _2053: (o, i) => o[i],
      _2054: f => f.dartFunction,
      _2055: () => ({}),
      _2056: () => [],
      _2058: () => globalThis,
      _2059: (constructor, args) => {
        const factoryFunction = constructor.bind.apply(
            constructor, [null, ...args]);
        return new factoryFunction();
      },
      _2061: (o, p) => o[p],
      _2062: (o, p, v) => o[p] = v,
      _2063: (o, m, a) => o[m].apply(o, a),
      _2065: o => String(o),
      _2066: (p, s, f) => p.then(s, (e) => f(e, e === undefined)),
      _2067: o => {
        if (o === undefined) return 1;
        var type = typeof o;
        if (type === 'boolean') return 2;
        if (type === 'number') return 3;
        if (type === 'string') return 4;
        if (o instanceof Array) return 5;
        if (ArrayBuffer.isView(o)) {
          if (o instanceof Int8Array) return 6;
          if (o instanceof Uint8Array) return 7;
          if (o instanceof Uint8ClampedArray) return 8;
          if (o instanceof Int16Array) return 9;
          if (o instanceof Uint16Array) return 10;
          if (o instanceof Int32Array) return 11;
          if (o instanceof Uint32Array) return 12;
          if (o instanceof Float32Array) return 13;
          if (o instanceof Float64Array) return 14;
          if (o instanceof DataView) return 15;
        }
        if (o instanceof ArrayBuffer) return 16;
        // Feature check for `SharedArrayBuffer` before doing a type-check.
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
            return 17;
        }
        return 18;
      },
      _2068: o => [o],
      _2069: (o0, o1) => [o0, o1],
      _2070: (o0, o1, o2) => [o0, o1, o2],
      _2071: (o0, o1, o2, o3) => [o0, o1, o2, o3],
      _2072: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI8ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _2073: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI8ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _2076: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _2077: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _2078: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _2079: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _2080: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF64ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _2081: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF64ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _2082: x0 => new ArrayBuffer(x0),
      _2083: s => {
        if (/[[\]{}()*+?.\\^$|]/.test(s)) {
            s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
        }
        return s;
      },
      _2085: x0 => x0.index,
      _2087: x0 => x0.flags,
      _2088: x0 => x0.multiline,
      _2089: x0 => x0.ignoreCase,
      _2090: x0 => x0.unicode,
      _2091: x0 => x0.dotAll,
      _2092: (x0,x1) => { x0.lastIndex = x1 },
      _2093: (o, p) => p in o,
      _2094: (o, p) => o[p],
      _2095: (o, p, v) => o[p] = v,
      _2096: (o, p) => delete o[p],
      _2097: x0 => x0.random(),
      _2098: (x0,x1) => x0.getRandomValues(x1),
      _2099: () => globalThis.crypto,
      _2100: () => globalThis.Math,
      _2101: Function.prototype.call.bind(Number.prototype.toString),
      _2102: Function.prototype.call.bind(BigInt.prototype.toString),
      _2103: Function.prototype.call.bind(Number.prototype.toString),
      _2104: (d, digits) => d.toFixed(digits),
      _2491: (x0,x1) => { x0.href = x1 },
      _2878: x0 => x0.error,
      _2879: x0 => x0.src,
      _2880: (x0,x1) => { x0.src = x1 },
      _2888: (x0,x1) => { x0.preload = x1 },
      _2889: x0 => x0.buffered,
      _2892: x0 => x0.currentTime,
      _2893: (x0,x1) => { x0.currentTime = x1 },
      _2894: x0 => x0.duration,
      _2899: (x0,x1) => { x0.playbackRate = x1 },
      _2912: (x0,x1) => { x0.volume = x1 },
      _2929: x0 => x0.code,
      _2930: x0 => x0.message,
      _3004: x0 => x0.length,
      _3508: (x0,x1) => { x0.src = x1 },
      _3510: (x0,x1) => { x0.type = x1 },
      _3514: (x0,x1) => { x0.async = x1 },
      _3518: (x0,x1) => { x0.crossOrigin = x1 },
      _3520: (x0,x1) => { x0.text = x1 },
      _3977: () => globalThis.window,
      _4017: x0 => x0.self,
      _4018: x0 => x0.document,
      _4021: x0 => x0.location,
      _4297: x0 => x0.indexedDB,
      _4302: x0 => x0.trustedTypes,
      _4303: x0 => x0.sessionStorage,
      _4304: x0 => x0.localStorage,
      _4319: x0 => x0.hostname,
      _4637: x0 => x0.length,
      _6542: x0 => x0.target,
      _6582: x0 => x0.signal,
      _6639: x0 => x0.baseURI,
      _6656: () => globalThis.document,
      _6737: x0 => x0.body,
      _6739: x0 => x0.head,
      _7070: (x0,x1) => { x0.id = x1 },
      _7093: x0 => x0.innerHTML,
      _7094: (x0,x1) => { x0.innerHTML = x1 },
      _8416: x0 => x0.value,
      _8418: x0 => x0.done,
      _9120: x0 => x0.url,
      _9122: x0 => x0.status,
      _9124: x0 => x0.statusText,
      _9125: x0 => x0.headers,
      _9126: x0 => x0.body,
      _10582: x0 => x0.result,
      _10583: x0 => x0.error,
      _10588: (x0,x1) => { x0.onsuccess = x1 },
      _10590: (x0,x1) => { x0.onerror = x1 },
      _10594: (x0,x1) => { x0.onupgradeneeded = x1 },
      _10612: x0 => x0.version,
      _10613: x0 => x0.objectStoreNames,
      _10680: x0 => x0.key,
      _10683: x0 => x0.value,
      _12743: x0 => x0.name,
      _13461: () => globalThis.console,
      _13489: x0 => x0.name,
      _13490: x0 => x0.message,
      _13491: x0 => x0.code,
      _13493: x0 => x0.customData,

    };

    const baseImports = {
      dart2wasm: dart2wasm,
      Math: Math,
      Date: Date,
      Object: Object,
      Array: Array,
      Reflect: Reflect,
      S: new Proxy({}, { get(_, prop) { return prop; } }),

    };

    const jsStringPolyfill = {
      "charCodeAt": (s, i) => s.charCodeAt(i),
      "compare": (s1, s2) => {
        if (s1 < s2) return -1;
        if (s1 > s2) return 1;
        return 0;
      },
      "concat": (s1, s2) => s1 + s2,
      "equals": (s1, s2) => s1 === s2,
      "fromCharCode": (i) => String.fromCharCode(i),
      "length": (s) => s.length,
      "substring": (s, a, b) => s.substring(a, b),
      "fromCharCodeArray": (a, start, end) => {
        if (end <= start) return '';

        const read = dartInstance.exports.$wasmI16ArrayGet;
        let result = '';
        let index = start;
        const chunkLength = Math.min(end - index, 500);
        let array = new Array(chunkLength);
        while (index < end) {
          const newChunkLength = Math.min(end - index, 500);
          for (let i = 0; i < newChunkLength; i++) {
            array[i] = read(a, index++);
          }
          if (newChunkLength < chunkLength) {
            array = array.slice(0, newChunkLength);
          }
          result += String.fromCharCode(...array);
        }
        return result;
      },
      "intoCharCodeArray": (s, a, start) => {
        if (s === '') return 0;

        const write = dartInstance.exports.$wasmI16ArraySet;
        for (var i = 0; i < s.length; ++i) {
          write(a, start++, s.charCodeAt(i));
        }
        return s.length;
      },
      "test": (s) => typeof s == "string",
    };


    

    dartInstance = await WebAssembly.instantiate(this.module, {
      ...baseImports,
      ...additionalImports,
      
      "wasm:js-string": jsStringPolyfill,
    });

    return new InstantiatedApp(this, dartInstance);
  }
}

class InstantiatedApp {
  constructor(compiledApp, instantiatedModule) {
    this.compiledApp = compiledApp;
    this.instantiatedModule = instantiatedModule;
  }

  // Call the main function with the given arguments.
  invokeMain(...args) {
    this.instantiatedModule.exports.$invokeMain(args);
  }
}
