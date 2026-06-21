/**
 * Breakpoint system for responsive layout.
 * Monitors window width changes and maps to breakpoint ranges.
 */
export enum BreakpointType {
  XS = 'xs',   // [0, 320vp)
  SM = 'sm',   // [320vp, 600vp)
  MD = 'md',   // [600vp, 840vp)
  LG = 'lg',   // [840vp, +∞)
}

/**
 * Breakpoint reference values in vp
 */
export class BreakpointConstants {
  static readonly SM_BREAKPOINT: number = 320;
  static readonly MD_BREAKPOINT: number = 600;
  static readonly LG_BREAKPOINT: number = 840;
}

/**
 * Utility class for breakpoint calculations
 */
export class BreakpointUtil {
  /**
   * Get current breakpoint type based on window width
   *
   * @param width Window width in vp
   * @return Current breakpoint type
   */
  static getBreakpoint(width: number): BreakpointType {
    if (width < BreakpointConstants.SM_BREAKPOINT) {
      return BreakpointType.XS;
    } else if (width < BreakpointConstants.MD_BREAKPOINT) {
      return BreakpointType.SM;
    } else if (width < BreakpointConstants.LG_BREAKPOINT) {
      return BreakpointType.MD;
    } else {
      return BreakpointType.LG;
    }
  }

  /**
   * Get grid columns count based on breakpoint
   *
   * @param breakpoint Current breakpoint
   * @return Number of grid columns
   */
  static getGridColumns(breakpoint: BreakpointType): number {
    switch (breakpoint) {
      case BreakpointType.XS:
        return 4;
      case BreakpointType.SM:
        return 4;
      case BreakpointType.MD:
        return 8;
      case BreakpointType.LG:
        return 12;
      default:
        return 4;
    }
  }

  /**
   * Get calculator key columns based on breakpoint
   *
   * @param breakpoint Current breakpoint
   * @return Number of key columns
   */
  static getKeyColumns(breakpoint: BreakpointType): number {
    switch (breakpoint) {
      case BreakpointType.XS:
      case BreakpointType.SM:
        return 4;
      case BreakpointType.MD:
        return 5;
      case BreakpointType.LG:
        return 6;
      default:
        return 4;
    }
  }

  /**
   * Get scientific key columns based on breakpoint
   *
   * @param breakpoint Current breakpoint
   * @return Number of scientific key columns
   */
  static getScientificKeyColumns(breakpoint: BreakpointType): number {
    switch (breakpoint) {
      case BreakpointType.XS:
      case BreakpointType.SM:
        return 5;
      case BreakpointType.MD:
        return 5;
      case BreakpointType.LG:
        return 10;
      default:
        return 5;
    }
  }

  /**
   * Get key button size based on breakpoint
   *
   * @param breakpoint Current breakpoint
   * @return Key size in vp
   */
  static getKeySize(breakpoint: BreakpointType): number {
    switch (breakpoint) {
      case BreakpointType.XS:
        return 48;
      case BreakpointType.SM:
        return 55;
      case BreakpointType.MD:
        return 60;
      case BreakpointType.LG:
        return 65;
      default:
        return 55;
    }
  }

  /**
   * Get font size for keys based on breakpoint
   *
   * @param breakpoint Current breakpoint
   * @return Font size in fp
   */
  static getKeyFontSize(breakpoint: BreakpointType): number {
    switch (breakpoint) {
      case BreakpointType.XS:
        return 14;
      case BreakpointType.SM:
        return 16;
      case BreakpointType.MD:
        return 18;
      case BreakpointType.LG:
        return 20;
      default:
        return 16;
    }
  }

  /**
   * Check if should use side-by-side layout (for tablet/PC)
   *
   * @param breakpoint Current breakpoint
   * @return Whether to use side-by-side layout
   */
  static isSideBySideLayout(breakpoint: BreakpointType): boolean {
    return breakpoint === BreakpointType.MD || breakpoint === BreakpointType.LG;
  }
}
