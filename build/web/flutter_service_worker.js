'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "8604a3d47fd79f1bb2d79d32987969af",
"version.json": "12481ed665e76f12267e9aff8cb08c2c",
"index.html": "c747565525ca5ec04745a698696ec4f1",
"/": "c747565525ca5ec04745a698696ec4f1",
"main.dart.js": "5d247205bad6ff72acc91c0860d1dece",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"cors.json": "ba737af866a915eb6f9e08ce68419b35",
"favicon.png": "89a6e1b861665ed5d2696c73d6493ee5",
"icons/Icon-192.png": "d49d930752a71eb85a1e7b7e528f0fcd",
"icons/icon-maskable-192.png": "d49d930752a71eb85a1e7b7e528f0fcd",
"icons/icon-maskable-512.png": "903ecf65ca59f6fc0ac0f65b230c8bee",
"icons/icon-512.png": "903ecf65ca59f6fc0ac0f65b230c8bee",
"manifest.json": "04d9cc9f2e9e567bb8a26b8c26bec210",
"assets/AssetManifest.json": "66b599ef7f6b389db86ce99fb72785f5",
"assets/NOTICES": "08c83f5c857b9eafc25fec65cc9f8b8e",
"assets/FontManifest.json": "1b2a5eab9d4d3abd26edbab0b5a992db",
"assets/AssetManifest.bin.json": "70a17587830ea69cf99b78b8b3a32ceb",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "90c71909433d6523c7a96a7b784fed17",
"assets/fonts/MaterialIcons-Regular.otf": "4bc76ef713106d5516898bff3a76a297",
"assets/assets/svg/login.svg": "160df0fdcc829bd8fc08e7599fe809b1",
"assets/assets/svg/facebook.svg": "4c6237f972e271ce5be9ab4ace767116",
"assets/assets/svg/google.svg": "a8e82812098977ebd9d625933519f773",
"assets/assets/svg/logo.svg": "126d2d2d7b8d24261d24e3cd0cef71d3",
"assets/assets/svg/confirm.svg": "03938b75bf1b0a423563e26462a75d09",
"assets/assets/png/gif.png": "da04cd5bff83e0b2f177e2f10f36a9a6",
"assets/assets/png/logs.png": "0c309f20a2c861a8c72a60fd90b6bfc1",
"assets/assets/png/logout.png": "929fd04825980d919ad08e7ed30d85fe",
"assets/assets/png/promotion.png": "355b41c234e687f5e7ca65ea13a28163",
"assets/assets/png/queries.png": "8f14a5326d43615554c2ad3baf52a8fa",
"assets/assets/png/user.png": "e9ace2e2dac30ed544ae393f52a0a0e0",
"assets/assets/png/contact.png": "27091f7fc35d73ae0337557cb5d53fa3",
"assets/assets/png/background.png": "86c5694d33a6da189ea2a29e4742e835",
"assets/assets/png/confirm.png": "6df810afceecd3df8dfccc4a0b3cd31d",
"assets/assets/png/logo.png": "b875f3fddc4c653fd5e07a1d6f83524c",
"assets/assets/png/lead_prices.png": "0321879e73ea1d333a78af6067fc8bb1",
"assets/assets/png/rank.png": "e1c83c73c71dab590efe3a89248b1dcb",
"assets/assets/png/gift.png": "f6897dda4aaf9ee738a8b69a9dcaf297",
"assets/assets/png/faq.png": "33ea8eca9344723412a8819f4701cdfd",
"assets/assets/png/media.png": "277c042865eca9c199e65d77561ef649",
"assets/assets/png/premium.png": "275e6a386b94b6e6a16c4586a81a1802",
"assets/assets/png/new_update.png": "3b49915e72cd74a130edb05891326c58",
"assets/assets/png/setting.png": "97be0efe0b5f5dc42afc223b0fcd908a",
"assets/assets/font/DM_Sans/DMSans-Regular.ttf": "7c217bc9433889f55c38ca9d058514d3",
"assets/assets/font/DM_Sans/DMSans-Medium.ttf": "24bfda9719b2ba60b94a0f9412757d10",
"assets/assets/font/DM_Sans/DMSans-Bold.ttf": "b9cec5212f09838534e6215d1f23ed55",
"assets/assets/font/DM_Sans/DMSans-BoldItalic.ttf": "f83322c859de9fce83f15d5e6714d78d",
"assets/assets/font/DM_Sans/DMSans-MediumItalic.ttf": "a72ea4b3c89082b9308ef3fcabff9824",
"assets/assets/font/DM_Sans/DMSans-Italic.ttf": "1ea925903e098f94f5c51566770a2da8",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.js": "ba4a8ae1a65ff3ad81c6818fd47e348b",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/canvaskit.js": "6cfe36b4647fbfa15683e09e7dd366bc",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206"};
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
