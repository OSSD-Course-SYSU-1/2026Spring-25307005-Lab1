/**
 * Distributed Sync Utility
 * Provides cross-device data synchronization for continuation and collaboration.
 * Uses @ohos.data.distributedDataObject for real-time data sync between devices.
 */

import distributedDataObject from '@ohos.data.distributedDataObject';
import { Context } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'DistributedSyncUtil';
const DOMAIN = 0x0000;

/**
 * Calculator state data structure for cross-device sync
 */
export interface CalculatorState {
  currentPage: string;
  calculatorExpression: string;
  calculatorResult: string;
  isScientificMode: boolean;
  isFractionMode: boolean;
  equationMode: string;
  showHistory: boolean;
  historyList: string;
  timestamp: number;
}

/**
 * Callback type for data change notifications
 */
export type OnDataChangeCallback = (state: CalculatorState) => void;

/**
 * Callback type for status change notifications
 */
export type OnStatusChangeCallback = (sessionId: string, networkId: string, status: string) => void;

/**
 * DistributedSyncUtil - Singleton class for managing distributed data synchronization
 *
 * Two modes:
 * 1. Continuation mode: One-shot data transfer during device migration
 * 2. Collaboration mode: Real-time bidirectional data sync between devices
 */
class DistributedSyncUtil {
  private dObject: distributedDataObject.DataObject | null = null;
  private sessionId: string = '';
  private dataChangeCallback: OnDataChangeCallback | null = null;
  private statusChangeCallback: OnStatusChangeCallback | null = null;
  private isCollaborationMode: boolean = false;

  /**
   * Create an empty calculator state with default values
   */
  createEmptyState(): CalculatorState {
    return {
      currentPage: '',
      calculatorExpression: '',
      calculatorResult: '0',
      isScientificMode: false,
      isFractionMode: false,
      equationMode: '',
      showHistory: false,
      historyList: '[]',
      timestamp: 0
    };
  }

  /**
   * Create a distributed data object from the given state
   *
   * @param context Ability context
   * @param state Calculator state to sync
   * @return The created distributed data object
   */
  createDistributedObject(context: Context, state: CalculatorState): distributedDataObject.DataObject {
    this.dObject = distributedDataObject.create(context, state);
    return this.dObject;
  }

  /**
   * Generate a new session ID
   */
  generateSessionId(): string {
    this.sessionId = distributedDataObject.genSessionId();
    return this.sessionId;
  }

  /**
   * Set session ID on the distributed data object
   *
   * @param sessionId Session ID to set
   */
  setSessionId(sessionId: string): void {
    this.sessionId = sessionId;
    if (this.dObject) {
      this.dObject.setSessionId(sessionId);
    }
  }

  /**
   * Get current session ID
   */
  getSessionId(): string {
    return this.sessionId;
  }

  /**
   * Get the distributed data object
   */
  getDistributedObject(): distributedDataObject.DataObject | null {
    return this.dObject;
  }

  /**
   * Save distributed data to target device for persistence
   *
   * @param targetDevice Target device ID
   */
  async saveToDevice(targetDevice: string): Promise<void> {
    if (this.dObject && targetDevice) {
      try {
        await this.dObject.save(targetDevice);
        hilog.info(DOMAIN, TAG, 'Data saved to device: %{public}s', targetDevice);
      } catch (error) {
        hilog.error(DOMAIN, TAG, 'Failed to save data: %{public}s', JSON.stringify(error));
      }
    }
  }

  /**
   * Revoke saved data from device
   *
   * @param targetDevice Target device ID
   */
  async revokeFromDevice(targetDevice: string): Promise<void> {
    if (this.dObject && targetDevice) {
      try {
        await this.dObject.revokeSave(targetDevice);
        hilog.info(DOMAIN, TAG, 'Data revoked from device: %{public}s', targetDevice);
      } catch (error) {
        hilog.error(DOMAIN, TAG, 'Failed to revoke data: %{public}s', JSON.stringify(error));
      }
    }
  }

  /**
   * Read current state from the distributed data object
   *
   * @return Current calculator state
   */
  readState(): CalculatorState {
    if (!this.dObject) {
      return this.createEmptyState();
    }
    return {
      currentPage: this.dObject['currentPage'] as string ?? '',
      calculatorExpression: this.dObject['calculatorExpression'] as string ?? '',
      calculatorResult: this.dObject['calculatorResult'] as string ?? '0',
      isScientificMode: this.dObject['isScientificMode'] as boolean ?? false,
      isFractionMode: this.dObject['isFractionMode'] as boolean ?? false,
      equationMode: this.dObject['equationMode'] as string ?? '',
      showHistory: this.dObject['showHistory'] as boolean ?? false,
      historyList: this.dObject['historyList'] as string ?? '[]',
      timestamp: this.dObject['timestamp'] as number ?? 0
    };
  }

  /**
   * Update the distributed data object with new state values
   * This triggers automatic sync to all connected devices
   *
   * @param state Partial state to update
   */
  updateState(state: Partial<CalculatorState>): void {
    if (!this.dObject) {
      return;
    }
    if (state.currentPage !== undefined) {
      this.dObject['currentPage'] = state.currentPage;
    }
    if (state.calculatorExpression !== undefined) {
      this.dObject['calculatorExpression'] = state.calculatorExpression;
    }
    if (state.calculatorResult !== undefined) {
      this.dObject['calculatorResult'] = state.calculatorResult;
    }
    if (state.isScientificMode !== undefined) {
      this.dObject['isScientificMode'] = state.isScientificMode;
    }
    if (state.isFractionMode !== undefined) {
      this.dObject['isFractionMode'] = state.isFractionMode;
    }
    if (state.equationMode !== undefined) {
      this.dObject['equationMode'] = state.equationMode;
    }
    if (state.showHistory !== undefined) {
      this.dObject['showHistory'] = state.showHistory;
    }
    if (state.historyList !== undefined) {
      this.dObject['historyList'] = state.historyList;
    }
    if (state.timestamp !== undefined) {
      this.dObject['timestamp'] = state.timestamp;
    }
  }

  /**
   * Register a callback for data changes from remote devices
   * Used in collaboration mode to receive real-time updates
   *
   * @param callback Function to call when data changes
   */
  registerDataChangeCallback(callback: OnDataChangeCallback): void {
    this.dataChangeCallback = callback;
    if (this.dObject) {
      this.dObject.on('change', () => {
        if (this.dataChangeCallback) {
          const state = this.readState();
          this.dataChangeCallback(state);
        }
      });
    }
  }

  /**
   * Register a callback for status changes (restored, etc.)
   *
   * @param callback Function to call when status changes
   */
  registerStatusChangeCallback(callback: OnStatusChangeCallback): void {
    this.statusChangeCallback = callback;
    if (this.dObject) {
      this.dObject.on('status', (sessionId: string, networkId: string, status: string) => {
        hilog.info(DOMAIN, TAG, 'Status changed: %{public}s', status);
        if (this.statusChangeCallback) {
          this.statusChangeCallback(sessionId, networkId, status);
        }
      });
    }
  }

  /**
   * Unregister data change callback
   */
  unregisterDataChangeCallback(): void {
    this.dataChangeCallback = null;
    if (this.dObject) {
      this.dObject.off('change');
    }
  }

  /**
   * Unregister status change callback
   */
  unregisterStatusChangeCallback(): void {
    this.statusChangeCallback = null;
    if (this.dObject) {
      this.dObject.off('status');
    }
  }

  /**
   * Start collaboration mode - enables real-time bidirectional sync
   *
   * @param context Ability context
   * @param initialState Initial state to sync
   * @param onDataChange Callback for remote data changes
   * @param onStatusChange Callback for status changes
   * @return Session ID for this collaboration session
   */
  startCollaboration(
    context: Context,
    initialState: CalculatorState,
    onDataChange: OnDataChangeCallback,
    onStatusChange?: OnStatusChangeCallback
  ): string {
    this.isCollaborationMode = true;
    this.dObject = distributedDataObject.create(context, initialState);
    this.sessionId = this.generateSessionId();
    this.dObject.setSessionId(this.sessionId);

    // Register callbacks
    this.registerDataChangeCallback(onDataChange);
    if (onStatusChange) {
      this.registerStatusChangeCallback(onStatusChange);
    }

    hilog.info(DOMAIN, TAG, 'Collaboration started, sessionId: %{public}s', this.sessionId);
    return this.sessionId;
  }

  /**
   * Join an existing collaboration session
   *
   * @param context Ability context
   * @param sessionId Session ID to join
   * @param onDataChange Callback for remote data changes
   * @param onStatusChange Callback for status changes
   */
  joinCollaboration(
    context: Context,
    sessionId: string,
    onDataChange: OnDataChangeCallback,
    onStatusChange?: OnStatusChangeCallback
  ): void {
    this.isCollaborationMode = true;
    const emptyState = this.createEmptyState();
    this.dObject = distributedDataObject.create(context, emptyState);

    // Register callbacks before setting session ID
    this.registerDataChangeCallback(onDataChange);
    if (onStatusChange) {
      this.registerStatusChangeCallback(onStatusChange);
    }

    this.sessionId = sessionId;
    this.dObject.setSessionId(sessionId);

    hilog.info(DOMAIN, TAG, 'Joined collaboration, sessionId: %{public}s', sessionId);
  }

  /**
   * Stop collaboration mode and clean up resources
   */
  stopCollaboration(): void {
    this.isCollaborationMode = false;
    this.unregisterDataChangeCallback();
    this.unregisterStatusChangeCallback();

    if (this.dObject) {
      this.dObject.setSessionId('');
      this.dObject = null;
    }
    this.sessionId = '';

    hilog.info(DOMAIN, TAG, 'Collaboration stopped');
  }

  /**
   * Check if currently in collaboration mode
   */
  isInCollaboration(): boolean {
    return this.isCollaborationMode && this.dObject !== null;
  }

  /**
   * Restore state from distributed data object to AppStorage
   * Used after continuation migration completes
   */
  restoreToAppStorage(): void {
    const state = this.readState();
    AppStorage.setOrCreate('calculatorExpression', state.calculatorExpression);
    AppStorage.setOrCreate('calculatorResult', state.calculatorResult);
    AppStorage.setOrCreate('isScientificMode', state.isScientificMode);
    AppStorage.setOrCreate('isFractionMode', state.isFractionMode);
    AppStorage.setOrCreate('equationMode', state.equationMode);
    AppStorage.setOrCreate('showHistory', state.showHistory);
    AppStorage.setOrCreate('historyList', state.historyList);
    AppStorage.setOrCreate('migrationTimestamp', state.timestamp);

    hilog.info(DOMAIN, TAG, 'State restored to AppStorage');
  }

  /**
   * Collect current state from AppStorage for sync
   *
   * @return Current calculator state from AppStorage
   */
  collectFromAppStorage(): CalculatorState {
    return {
      currentPage: 'HomePage',
      calculatorExpression: AppStorage.get<string>('calculatorExpression') ?? '',
      calculatorResult: AppStorage.get<string>('calculatorResult') ?? '0',
      isScientificMode: AppStorage.get<boolean>('isScientificMode') ?? false,
      isFractionMode: AppStorage.get<boolean>('isFractionMode') ?? false,
      equationMode: AppStorage.get<string>('equationMode') ?? '',
      showHistory: AppStorage.get<boolean>('showHistory') ?? false,
      historyList: AppStorage.get<string>('historyList') ?? '[]',
      timestamp: Date.now()
    };
  }
}

export default new DistributedSyncUtil();
