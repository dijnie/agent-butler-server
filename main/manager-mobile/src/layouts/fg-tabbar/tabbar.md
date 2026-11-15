# tabbar notes

`tabbar` has `4` cases:

- 0 `No tabbar`: only one page entry, no `tabbar` shown at the bottom; commonly used for temporary campaign pages.
- 1 `Native tabbar`: uses `switchTab` to switch tabbar; `tabbar` pages are cached.
  - Pros: the built-in native tabbar renders first and is cached.
  - Cons: only 2 sets of images can be used to switch between selected and unselected states; changing the color requires replacing the images (or using iconfont).
- 2 `Cached custom tabbar`: uses `switchTab` to switch tabbar; `tabbar` pages are cached. Uses the `tabbar` component of a third-party UI library and hides the native `tabbar`.
  - Pros: any `svg icon` can be configured freely, and switching the font color is easy. Cached. All kinds of fancy animations can be implemented.
  - Cons: the first tabbar click flickers.
- 3 `Uncached custom tabbar`: uses `navigateTo` to switch `tabbar`; `tabbar` pages are not cached. Uses the `tabbar` component of a third-party UI library.
  - Pros: any svg icon can be configured freely, and switching the font color is easy. All kinds of fancy animations can be implemented.
  - Cons: the first `tabbar` click flickers; no cache.


> Note: fancy effects have to be implemented yourself; this template does not provide them.
