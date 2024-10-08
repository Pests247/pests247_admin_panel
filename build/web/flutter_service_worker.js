'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "c8174e171e4059f631eb789bb7928800",
"assets/AssetManifest.bin.json": "c699f3114e477fc113a0d7da37916b0d",
"assets/AssetManifest.json": "cc7c28f28ee60836da1d33e684550a92",
"assets/assets/font/DM_Sans/DMSans-Bold.ttf": "b9cec5212f09838534e6215d1f23ed55",
"assets/assets/font/DM_Sans/DMSans-BoldItalic.ttf": "f83322c859de9fce83f15d5e6714d78d",
"assets/assets/font/DM_Sans/DMSans-Italic.ttf": "1ea925903e098f94f5c51566770a2da8",
"assets/assets/font/DM_Sans/DMSans-Medium.ttf": "24bfda9719b2ba60b94a0f9412757d10",
"assets/assets/font/DM_Sans/DMSans-MediumItalic.ttf": "a72ea4b3c89082b9308ef3fcabff9824",
"assets/assets/font/DM_Sans/DMSans-Regular.ttf": "7c217bc9433889f55c38ca9d058514d3",
"assets/assets/png/confirm.png": "6df810afceecd3df8dfccc4a0b3cd31d",
"assets/assets/png/contact.png": "27091f7fc35d73ae0337557cb5d53fa3",
"assets/assets/png/faq.png": "33ea8eca9344723412a8819f4701cdfd",
"assets/assets/png/gift.png": "f6897dda4aaf9ee738a8b69a9dcaf297",
"assets/assets/png/logo.png": "aac24df42024359b56f638deae47d58b",
"assets/assets/png/logout.png": "929fd04825980d919ad08e7ed30d85fe",
"assets/assets/png/logs.png": "0c309f20a2c861a8c72a60fd90b6bfc1",
"assets/assets/png/media.png": "277c042865eca9c199e65d77561ef649",
"assets/assets/png/premium.png": "275e6a386b94b6e6a16c4586a81a1802",
"assets/assets/png/promotion.png": "355b41c234e687f5e7ca65ea13a28163",
"assets/assets/png/queries.png": "8f14a5326d43615554c2ad3baf52a8fa",
"assets/assets/png/setting.png": "97be0efe0b5f5dc42afc223b0fcd908a",
"assets/assets/png/user.png": "e9ace2e2dac30ed544ae393f52a0a0e0",
"assets/assets/svg/confirm.svg": "03938b75bf1b0a423563e26462a75d09",
"assets/assets/svg/facebook.svg": "4c6237f972e271ce5be9ab4ace767116",
"assets/assets/svg/google.svg": "a8e82812098977ebd9d625933519f773",
"assets/assets/svg/login.svg": "160df0fdcc829bd8fc08e7599fe809b1",
"assets/assets/svg/logo.svg": "126d2d2d7b8d24261d24e3cd0cef71d3",
"assets/FontManifest.json": "1b2a5eab9d4d3abd26edbab0b5a992db",
"assets/fonts/MaterialIcons-Regular.otf": "5e637c753c03426327b18a3a36525852",
"assets/NOTICES": "c2843571ce8bfe067314835e31c3f1a7",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"cors.json": "ba737af866a915eb6f9e08ce68419b35",
"favicon.png": "40d21d524976a6096266ac1919963c77",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"flutter_bootstrap.js": "d48ea866ae3fd12db7ff49dbd6b1c760",
"icons/Icon-192.png": "5e3ea25f0f8313af38a09db0291bcbb5",
"icons/icon-512.png": "4d850040ac3a129f6e18ed7129eac443",
"icons/icon-maskable-192.png": "a900c2d70363d3eb691722aad2010f36",
"icons/icon-maskable-512.png": "06a6d75ee34828a9ddbffcfd17eea296",
"index.html": "0585e2cdbe04f217e89ac9fc80ce45ac",
"/": "0585e2cdbe04f217e89ac9fc80ce45ac",
"main.dart.js": "c59cf1f5ae0d999cd852f5c0f4c8d0be",
"manifest.json": "34f4bd367f5bf7a13207a7014b03c385",
"version.json": "12481ed665e76f12267e9aff8cb08c2c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
