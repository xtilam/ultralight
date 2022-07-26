const path = require('path')

module.exports = {
    otherBuildChange: [
        // "C:/Users/ztila/source/repos/AU3_Utralight/x64/Debug/AU3Utralight.dll",
        // "C:/Users/ztila/source/repos/SendSignalDLL/x64/Debug/SendSignalDLL.dll",
        // "C:/Users/ztila/source/repos/AU3_Utralight/x64/Release/AU3Utralight.dll",
        // ["C:/Users/ztila/source/repos/ConsoleApplication3/x64/Release/Au3EncryptData.exe", path.join(__dirname, 'dev/encrypt.exe')],
        // ["C:/Users/ztila/source/repos/SendSignalDLL/x64/Release/SendSignalDLL.dll", path.join(__dirname, 'au3-lib/bin/SendSignalDLL.dll')],
        // ["C:/Users/ztila/source/repos/AU3_Utralight/x64/Release/AU3Utralight.dll", path.join(__dirname, 'au3-lib/bin/AU3Utralight.dll')],
    ],
    mainAU3: path.join(__dirname, '/src/au3/main.au3'),
    autoCleanDLLBuild: true,
    autoITPath: 'C://Program Files (x86)//AutoIt3',
    buildPath: path.join(__dirname, 'build'),
    autoIncludePath: path.join(__dirname, '/src/au3/auto_include'),
    nameExecutable: 'ultralight.exe'
}