import { CalculatorComponent, BreakpointType, BreakpointUtil } from 'calculator';
import { window } from '@kit.ArkUI';

@Entry
@Component
struct HomePage {
  @State currentBreakpoint: string = BreakpointType.MD;

  aboutToAppear() {
    this.registerBreakpointListener();
  }

  registerBreakpointListener() {
    try {
      const uiContext: UIContext | undefined = AppStorage.get('uiContext');
      if (uiContext) {
        const mainWindow = uiContext.getHostWindow();
        if (mainWindow) {
          const properties = mainWindow.getWindowProperties();
          const windowRect = properties.windowRect;
          const density = properties.densityPixels;
          const widthVp = windowRect.width / density;
          this.currentBreakpoint = BreakpointUtil.getBreakpoint(widthVp);
          mainWindow.on('windowSizeChange', (size: window.Size) => {
            const newWidthVp = size.width / density;
            this.currentBreakpoint = BreakpointUtil.getBreakpoint(newWidthVp);
          });
        }
      }
    } catch (e) {
      this.currentBreakpoint = BreakpointType.MD;
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
