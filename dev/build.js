const { execSync, spawn, exec, spawnSync } = require('child_process')
const fs = require('fs')
const path = require('path')
const md5 = require('md5')
const jsObfuscator = require('javascript-obfuscator')
const config = require('../config')

main()

async function main() {
    const autoIncludeFileAu3 = path.join(config.autoIncludePath, 'auto_include.au3')
    const excludeFileExtensions = ['.LICENSE.txt', '.js.map', '.css.map', 'robots.txt', '.html', '.js', '.css', '.gitignore']
    const au3BuildConfig = [
        '/in', config.mainAU3,
        '/out', path.join(config.buildPath, config.nameExecutable),
        '/icon', path.join(config.autoITPath, 'Aut2Exe/Icons/AutoIt_Main_v11_256x256_RGB-A.ico'),
        '/nopack',
        '/comp', 2,
        '/x64'
    ]
    
    if (fs.existsSync(config.buildPath)) fs.rmSync(config.buildPath, { recursive: true })
    fs.mkdirSync(config.buildPath)
    await spawnCommand(path.join(config.autoITPath, '/aut2exe/aut2exe.exe'), au3BuildConfig)[1]

    await execCommand(`cd ${path.join(__dirname, '../app')} && npm run webpack:build`)[1]
    copyResource(path.join(__dirname, '../app/public'), path.join(config.buildPath, 'assets'))

    function copyResource(resourcePath, assetsPath) {
        const autoResourceAu3Path = path.join(config.autoIncludePath, 'production/auto_resource.au3')
        fs.mkdirSync(assetsPath)
        copy()

        function copy(subPath = '') {
            let currentPath = path.join(resourcePath, subPath)
            const stats = fs.statSync(currentPath)
            if (stats.isDirectory()) {
                const files = fs.readdirSync(currentPath)
                for (const file of files) {
                    copy(`${subPath}/${file}`)
                }
            } else {
                for (const ext of excludeFileExtensions) {
                    if (currentPath.endsWith(ext)) return
                }

                fs.cpSync(currentPath, path.join(assetsPath, subPath))
            }
        }
    }

    // obfuscator and encrypt js
    const jsBuildPath = path.join(__dirname, '../app/build/bundle.js')
    if(!fs.existsSync(jsBuildPath)) throw ('Not found bundle.js')
    fs.writeFileSync(jsBuildPath, jsObfuscator.obfuscate(fs.readFileSync(jsBuildPath, { encoding: 'utf-8' })).getObfuscatedCode())

    spawnCommand(path.join(__dirname, 'encrypt.exe'), [`--input=${jsBuildPath}`, `--output=${path.join(__dirname, '../build/data.dat')}`])
}


function spawnCommand(...args) {
    const child = spawn.apply(undefined, args)
    child.stdout.on('data', (d) => {
        console.log(d.toString())
    })
    child.stderr.on('data', (d) => {
        console.log(d.toString())
    })
    return [child, new Promise((resolve, reject) => {
        child.on('exit', (code, signal) => {
            resolve([code, signal])
        })
    })]
}

function execCommand(command) {
    const child = exec(command)
    child.stdout.on('data', (d) => {
        console.log(d.toString())
    })
    child.stderr.on('data', (d) => {
        console.log(d.toString())
    })
    return [child, new Promise((resolve, reject) => {
        child.on('exit', (code, signal) => {
            resolve([code, signal])
        })
    })]
}