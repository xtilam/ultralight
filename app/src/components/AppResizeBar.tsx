import React from "react"


export function AppResizeBar() {
    type css = React.CSSProperties;
    const resizeBarWidth = 5;

    const xbarResizeStyle: css = {
        height: resizeBarWidth,
        width: '100%',
        position: 'fixed',
        left: 0,
        cursor: 'n-resize',
        WebkitUserSelect: 'none',
        zIndex: 999,
    }
    const ybarResizeStyle: css = {
        ...xbarResizeStyle,
        height: xbarResizeStyle.width,
        width: xbarResizeStyle.height,
        top: 0,
        left: 'unset',
        cursor: 'e-resize'
    }
    const mixBarStyle: css = {
        position: 'fixed',
        width: resizeBarWidth,
        height: resizeBarWidth,
        WebkitUserSelect: 'none',
        zIndex: 999,
    }
    return <>
        <div style={{ ...ybarResizeStyle, left: 0 }} onMouseDown={() => startResizeWindow('left')}></div>
        <div style={{ ...ybarResizeStyle, right: 0 }} onMouseDown={() => startResizeWindow('right')}></div>
        <div style={{ ...xbarResizeStyle, top: 0 }} onMouseDown={() => startResizeWindow('top')}></div>
        <div style={{ ...xbarResizeStyle, bottom: 0 }} onMouseDown={() => startResizeWindow('bottom')}></div>
        <div style={{ ...mixBarStyle, cursor: 'nwse-resize', top: 0, left: 0, }} onMouseDown={() => startResizeWindow('top', 'left')}></div>
        <div style={{ ...mixBarStyle, cursor: 'nesw-resize', top: 0, right: 0, }} onMouseDown={() => startResizeWindow('top', 'right',)}></div>
        <div style={{ ...mixBarStyle, cursor: 'nesw-resize', bottom: 0, left: 0, }} onMouseDown={() => startResizeWindow('bottom', 'left')}></div>
        <div style={{ ...mixBarStyle, cursor: 'nwse-resize', bottom: 0, right: 0, }} onMouseDown={() => startResizeWindow('bottom', 'right')}></div>
    </>
}