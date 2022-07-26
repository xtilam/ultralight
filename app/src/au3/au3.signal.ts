//@ts-ignore

import { downloadComppleteSignal, downloadProgressSignal } from "./au3.download"

//@ts-nocheck
const signalList: any = {
    downloadComplete: downloadComppleteSignal,
    downloadProgress: downloadProgressSignal
}

export function handleSignal(signal: any) {
    if(Array.isArray(signal) && signal.length > 0){
        const signalName = signal.shift()
        const action = signalList[signalName]
        if(!action) {
            return console.log('not found handle', signalName, signal)
        }
        action(signal)
    }
}

