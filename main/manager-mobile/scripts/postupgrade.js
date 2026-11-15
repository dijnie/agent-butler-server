// # Running `pnpm upgrade` upgrades the `uniapp` related dependencies
// # After the upgrade many useless dependencies are added automatically; they need to be removed to reduce the dependency size
// # Just run the command below

const { exec } = require('node:child_process')

// Define the command to run
const dependencies = [
  '@dcloudio/uni-app-harmony',
  // TODO: if you do not need the mini program of a platform, delete or comment it out manually
  '@dcloudio/uni-mp-alipay',
  '@dcloudio/uni-mp-baidu',
  '@dcloudio/uni-mp-jd',
  '@dcloudio/uni-mp-kuaishou',
  '@dcloudio/uni-mp-lark',
  '@dcloudio/uni-mp-qq',
  '@dcloudio/uni-mp-toutiao',
  '@dcloudio/uni-mp-xhs',
  '@dcloudio/uni-quickapp-webview',
  // The i18n template should comment out the line below
  'vue-i18n',
]

// Run the command with exec
exec(`pnpm un ${dependencies.join(' ')}`, (error, stdout, stderr) => {
  if (error) {
    // If there is an error, print the error message
    console.error(`Execution error: ${error}`)
    return
  }
  // Print normal output
  console.log(`stdout: ${stdout}`)
  // If there is error output, print it too
  console.error(`stderr: ${stderr}`)
})
