import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { UIContext, window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import distributedDataObject from '@ohos.data.distributedDataObject';

export default class TabletAbility extends UIAbility {
  private dObject: distributedDataObject.DataObject | null = null;
  private windowStage: window.WindowStage | null = null;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'TabletAbility onCreate');

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
      // 1. 创建分布式数据对象，保存业务状态
      let myData = {
        currentPage: 'HomePage',
        calculatorExpression: AppStorage.get<string>('calculatorExpression') ?? '',
        calculatorResult: AppStorage.get<string>('calculatorResult') ?? '0',
        historyList: AppStorage.get<string[]>('historyList') ?? [],
        timestamp: Date.now()
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
    let emptyData = {
      currentPage: '',
      calculatorExpression: '',
      calculatorResult: '0',
      historyList: [] as string[],
      timestamp: 0
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
        // 数据已恢复，可以读取并刷新UI
        let currentPage = this.dObject!['currentPage'] as string;
        let calculatorExpression = this.dObject!['calculatorExpression'] as string;
        let calculatorResult = this.dObject!['calculatorResult'] as string;
        let historyList = this.dObject!['historyList'] as string[];

        // 恢复数据到 AppStorage
        AppStorage.setOrCreate('calculatorExpression', calculatorExpression);
        AppStorage.setOrCreate('calculatorResult', calculatorResult);
        AppStorage.setOrCreate('historyList', historyList);

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
