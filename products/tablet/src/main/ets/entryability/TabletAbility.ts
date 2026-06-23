import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { UIContext, window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import distributedDataObject from '@ohos.data.distributedDataObject';
import { AppContext } from 'common';

export default class TabletAbility extends UIAbility {
  private dObject: distributedDataObject.DataObject | null = null;
  private windowStage: window.WindowStage | null = null;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'TabletAbility onCreate');

    // Set global context for distributed data operations
    AppContext.setContext(this.context);

    // 检查是否是迁移过来的
    let dataSessionId = want.parameters?.dataSessionId as string;
    if (dataSessionId) {
      this.handleDistributedData(want);
    }
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'TabletAbility onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'TabletAbility onWindowStageCreate');
    this.windowStage = windowStage;
    windowStage.loadContent('pages/HomePage', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
      let uiContext: UIContext | undefined = windowStage.getMainWindowSync().getUIContext();
      AppStorage.setOrCreate('uiContext', uiContext);
    });
  }

  onWindowStageDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'TabletAbility onWindowStageDestroy');
  }

  onForeground() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'TabletAbility onForeground');
  }

  onBackground() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'TabletAbility onBackground');
  }

  // 迁移时系统自动调用 - 源端保存状态
  async onContinue(wantParam: Record<string, Object>): Promise<AbilityConstant.OnContinueResult> {
    hilog.info(0x0000, 'testTag', '%{public}s', 'TabletAbility onContinue');

    try {
      // 1. 创建分布式数据对象，保存完整业务状态
      let myData: Record<string, Object> = {
        'currentPage': 'HomePage',
        'calculatorExpression': AppStorage.get<string>('calculatorExpression') ?? '',
        'calculatorResult': AppStorage.get<string>('calculatorResult') ?? '0',
        'isScientificMode': AppStorage.get<boolean>('isScientificMode') ?? false,
        'isFractionMode': AppStorage.get<boolean>('isFractionMode') ?? false,
        'equationMode': AppStorage.get<string>('equationMode') ?? '',
        'showHistory': AppStorage.get<boolean>('showHistory') ?? false,
        'historyList': AppStorage.get<string>('historyList') ?? '[]',
        'timestamp': Date.now()
      };

      let sessionId = distributedDataObject.genSessionId();
      this.dObject = distributedDataObject.create(this.context, myData);
      this.dObject.setSessionId(sessionId);

      // 2. 把 sessionId 通过 wantParam 传递给对端
      wantParam['dataSessionId'] = sessionId;

      // 3. 可选：持久化，确保对端即使应用被杀也能恢复
      let targetDevice = wantParam.targetDevice as string;
      if (targetDevice) {
        await this.dObject.save(targetDevice);
      }

      hilog.info(0x0000, 'testTag', 'onContinue success, sessionId: %{public}s', sessionId);
      return AbilityConstant.OnContinueResult.AGREE;
    } catch (error) {
      hilog.error(0x0000, 'testTag', 'onContinue failed: %{public}s', JSON.stringify(error));
      return AbilityConstant.OnContinueResult.REJECT;
    }
  }

  // 对端恢复数据
  private handleDistributedData(want: Want) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'TabletAbility handleDistributedData');

    // 创建一个空的数据对象（结构要与源端一致）
    let emptyData: Record<string, Object> = {
      'currentPage': '',
      'calculatorExpression': '',
      'calculatorResult': '0',
      'isScientificMode': false,
      'isFractionMode': false,
      'equationMode': '',
      'showHistory': false,
      'historyList': '[]',
      'timestamp': 0
    };

    this.dObject = distributedDataObject.create(this.context, emptyData);

    let sessionId = want.parameters?.dataSessionId as string;
    if (!sessionId) {
      hilog.error(0x0000, 'testTag', 'dataSessionId is null');
      return;
    }

    this.dObject.on('status', (sessionId: string, networkId: string, status: string) => {
      hilog.info(0x0000, 'testTag', 'dObject status changed: %{public}s', status);
      if (status === 'restored') {
        // 数据已恢复，读取并写入 AppStorage
        let calculatorExpression = this.dObject!['calculatorExpression'] as string;
        let calculatorResult = this.dObject!['calculatorResult'] as string;
        let isScientificMode = this.dObject!['isScientificMode'] as boolean;
        let isFractionMode = this.dObject!['isFractionMode'] as boolean;
        let equationMode = this.dObject!['equationMode'] as string;
        let showHistory = this.dObject!['showHistory'] as boolean;
        let historyList = this.dObject!['historyList'] as string;
        let timestamp = this.dObject!['timestamp'] as number;

        // 恢复完整数据到 AppStorage
        AppStorage.setOrCreate('calculatorExpression', calculatorExpression);
        AppStorage.setOrCreate('calculatorResult', calculatorResult);
        AppStorage.setOrCreate('isScientificMode', isScientificMode);
        AppStorage.setOrCreate('isFractionMode', isFractionMode);
        AppStorage.setOrCreate('equationMode', equationMode);
        AppStorage.setOrCreate('showHistory', showHistory);
        AppStorage.setOrCreate('historyList', historyList);
        AppStorage.setOrCreate('migrationTimestamp', timestamp);

        hilog.info(0x0000, 'testTag', 'Data restored successfully');
      }
    });

    this.dObject.setSessionId(sessionId);
  }

  // 处理新Want（当应用已在后台，通过迁移再次启动时调用）
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'TabletAbility onNewWant');

    let dataSessionId = want.parameters?.dataSessionId as string;
    if (dataSessionId) {
      this.handleDistributedData(want);
    }
  }
}
