import { CalculatorComponent, BreakpointType, BreakpointUtil } from 'calculator';
import { window } from '@kit.ArkUI';

@Entry
@Component
struct HomePage {
  @State currentBreakpoint: BreakpointType = BreakpointType.SM;

  aboutToAppear() {
    // Listen for window size changes to update breakpoint
    this.registerBreakpointListener();
  }

  /**
   * Register breakpoint listener based on window size
   */
  async registerBreakpointListener() {
    try {
      const uiContext: UIContext | undefined = AppStorage.get('uiContext');
      if (uiContext) {
        const mainWindowStage: window.WindowStage | undefined = AppStorage.get('windowStage');
        if (mainWindowStage) {
          const mainWindow: window.Window = await mainWindowStage.getMainWindow();
          // Get initial window size
          const properties: window.WindowProperties = mainWindow.getWindowProperties();
          const windowRect: window.Rect = properties.windowRect;
          const widthVp: number = windowRect.width;
          this.currentBreakpoint = BreakpointUtil.getBreakpoint(widthVp);

          // Listen for window size changes
          mainWindow.on('windowSizeChange', (size: window.Size) => {
            const newWidthVp: number = size.width;
            this.currentBreakpoint = BreakpointUtil.getBreakpoint(newWidthVp);
          });
        }
      }
    } catch (e) {
      // Fallback to SM breakpoint if window access fails
      this.currentBreakpoint = BreakpointType.SM;
    }
  }

  build() {
    Column() {
      CalculatorComponent({ currentBreakpoint: this.currentBreakpoint })
    }
    .height('100%')
    .width('100%')
  }
}
