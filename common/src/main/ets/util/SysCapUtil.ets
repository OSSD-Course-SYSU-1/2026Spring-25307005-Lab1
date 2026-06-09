/**
 * System Capability Utility
 * Use canIUse to check device capabilities before calling system APIs
 */

/**
 * Check if a system capability is supported
 *
 * @param sysCap System capability string (e.g., "SystemCapability.Communication.NFC.Core")
 * @return Whether the capability is supported
 */
export function isSysCapSupported(sysCap: string): boolean {
  try {
    return canIUse(sysCap);
  } catch (e) {
    return false;
  }
}

/**
 * Common system capabilities used in the calculator app
 */
export class SysCapConstants {
  // NFC capability
  static readonly NFC_CORE: string = 'SystemCapability.Communication.NFC.Core';
  // Bluetooth capability
  static readonly BLUETOOTH_CORE: string = 'SystemCapability.Communication.Bluetooth.Core';
  // Camera capability
  static readonly CAMERA: string = 'SystemCapability.Multimedia.Camera.Core';
  // Vibration capability
  static readonly VIBRATOR: string = 'SystemCapability.Sensors.MiscDevice.Vibrator';
  // Clipboard capability
  static readonly CLIPBOARD: string = 'SystemCapability.MiscServices.Pasteboard';
  // File picker capability
  static readonly FILE_PICKER: string = 'SystemCapability.FileManagement.UserFilePicker';
}

/**
 * Feature availability checker
 * Determines which features should be shown based on device capabilities
 */
export class FeatureAvailability {
  /**
   * Check if clipboard (copy result) feature is available
   */
  static isClipboardAvailable(): boolean {
    return isSysCapSupported(SysCapConstants.CLIPBOARD);
  }

  /**
   * Check if vibration feedback is available
   */
  static isVibrationAvailable(): boolean {
    return isSysCapSupported(SysCapConstants.VIBRATOR);
  }

  /**
   * Check if file export is available
   */
  static isFileExportAvailable(): boolean {
    return isSysCapSupported(SysCapConstants.FILE_PICKER);
  }
}
