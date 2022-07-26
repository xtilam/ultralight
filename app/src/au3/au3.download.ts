const downloadManager = {
    stack: [] as any[],
}

export function startDownload(url: string, savePath: string, progressAction?: ProgressInfoCallback) {
    return new Promise((resolve) => {
        const stack = {
            url, savePath,
            progressAction: progressAction || (() => { }),
            resolve: resolve
        }

        downloadManager.stack.push(stack)

        if (downloadManager.stack.length === 1) {
            au3('startDownload', stack.url, stack.savePath)
        }
    })
}

export function downloadComppleteSignal() {
    const stack = downloadManager.stack.shift()
    stack.resolve()
    if (downloadManager.stack.length) {
        au3('startDownload', stack.url, stack.savePath)
    }
}

export function downloadProgressSignal(args: any) {
    const current = downloadManager.stack[0]
    current.progressAction.apply(null, args)
} 

type ProgressInfoCallback = (totalSize: number, currentSize: number, pathSave: string) => void