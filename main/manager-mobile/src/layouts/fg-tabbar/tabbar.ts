/**
 * tabbar state; storageSync is added so the correct tabbar page is kept when the browser refreshes
 * Uses simple reactive state instead of pinia global state
 */
export const tabbarStore = reactive({
  curIdx: uni.getStorageSync('app-tabbar-index') || 0,
  setCurIdx(idx: number) {
    this.curIdx = idx
    uni.setStorageSync('app-tabbar-index', idx)
  },
})
