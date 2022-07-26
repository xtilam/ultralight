type resizeDirection = 'left' | 'top' | 'bottom' | 'right'

declare function au3(...args): any;
declare function startMoveWindow(): void;
declare function stopMoveWindow(): void;
declare function startResizeWindow(...direction: resizeDirection[]): void;
declare function stopResizeWindow(): void;
declare function au3HandleSignal(...args);