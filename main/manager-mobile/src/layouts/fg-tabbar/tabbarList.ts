import type { TabBar } from '@uni-helper/vite-plugin-uni-pages'

type FgTabBarItem = TabBar['list'][0] & {
  icon: string
  iconType: 'uiLib' | 'unocss' | 'iconfont'
}

/**
 * tabbar selection strategy; see the tabbar.md file for details
 * 0: 'NO_TABBAR' `No tabbar`
 * 1: 'NATIVE_TABBAR'  `Fully native tabbar`
 * 2: 'CUSTOM_TABBAR_WITH_CACHE' `Cached custom tabbar`
 * 3: 'CUSTOM_TABBAR_WITHOUT_CACHE' `Uncached custom tabbar`
 *
 * Reminder: after any code change in this file you must re-run, otherwise pages.json is not updated and errors occur
 */
export const TABBAR_MAP = {
  NO_TABBAR: 0,
  NATIVE_TABBAR: 1,
  CUSTOM_TABBAR_WITH_CACHE: 2,
  CUSTOM_TABBAR_WITHOUT_CACHE: 3,
}
// TODO: switch the tabbar strategy here
export const selectedTabbarStrategy = TABBAR_MAP.NATIVE_TABBAR

// When selectedTabbarStrategy==NATIVE_TABBAR(1), iconPath and selectedIconPath are required
// When selectedTabbarStrategy==CUSTOM_TABBAR(2,3), icon and iconType are required
// When selectedTabbarStrategy==NO_TABBAR(0), tabbarList has no effect
export const tabbarList: FgTabBarItem[] = [
  {
    iconPath: 'static/tabbar/robot.png',
    selectedIconPath: 'static/tabbar/robot_activate.png',
    pagePath: 'pages/index/index',
    text: 'Home',
    icon: 'home',
    // When using an icon bundled with the UI framework, iconType is uiLib
    iconType: 'uiLib',
  },
  {
    iconPath: 'static/tabbar/network.png',
    selectedIconPath: 'static/tabbar/network_activate.png',
    pagePath: 'pages/device-config/index',
    text: 'Network Setup',
    icon: 'i-carbon-network-3',
    iconType: 'uiLib',
  },
  {
    iconPath: 'static/tabbar/system.png',
    selectedIconPath: 'static/tabbar/system_activate.png',
    pagePath: 'pages/settings/index',
    text: 'System',
    icon: 'i-carbon-settings',
    iconType: 'uiLib',
  },
]

// NATIVE_TABBAR(1) and CUSTOM_TABBAR_WITH_CACHE(2) need tabbar caching
export const cacheTabbarEnable = selectedTabbarStrategy === TABBAR_MAP.NATIVE_TABBAR
  || selectedTabbarStrategy === TABBAR_MAP.CUSTOM_TABBAR_WITH_CACHE

const _tabbar: TabBar = {
  // Only WeChat Mini Program supports custom. No effect on App and H5
  custom: selectedTabbarStrategy === TABBAR_MAP.CUSTOM_TABBAR_WITH_CACHE,
  color: '#e6e6e6',
  selectedColor: '#667dea',
  backgroundColor: '#fff',
  borderStyle: 'black',
  height: '50px',
  fontSize: '10px',
  iconWidth: '24px',
  spacing: '3px',
  list: tabbarList as unknown as TabBar['list'],
}

// 0 and 1 need the bottom tabbar configuration to be shown, to make use of caching
export const tabBar = cacheTabbarEnable ? _tabbar : undefined
