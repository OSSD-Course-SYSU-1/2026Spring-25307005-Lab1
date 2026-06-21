<<<<<<< HEAD
import { CommonConstants, Symbol, CalculateUtil, CheckEmptyUtil, HistoryManager, HistoryItem, FractionUtil, Fraction, Logger, FeatureAvailability, DistributedSyncUtil, CalculatorState } from 'common';
import keysModel from '../viewmodel/PresskeysViewModel';
import { PressKeysBean } from '../viewmodel/PressKeysItem';
import { BreakpointType, BreakpointUtil } from './BreakpointSystem';
import pasteboard from '@ohos.pasteboard';
=======
import { CommonConstants, Symbol, CalculateUtil, CheckEmptyUtil, HistoryManager, HistoryItem, FractionUtil, Fraction, Logger, FeatureAvailability } from 'common';
import keysModel from '../viewmodel/PresskeysViewModel';
import { PressKeysBean } from '../viewmodel/PressKeysItem';
import { BreakpointType, BreakpointUtil } from './BreakpointSystem';
>>>>>>> ec2c3a8fa90320418457a7069fe965d421ef26be

@Component
export struct CalculatorComponent {
  @State inputValue: string = '';
  @State calValue: string = '';
  @State isScientificMode: boolean = false;
  @State equationMode: string = '';
  @State showHistory: boolean = false;
  @State isFractionMode: boolean = false;
  @State historyList: Array<HistoryItem> = [];
<<<<<<< HEAD
  @State isCollaborating: boolean = false;
  @State collaborationPeer: string = '';
  @Prop currentBreakpoint: BreakpointType = BreakpointType.SM;
  private expressions: Array<string> = [];
  private syncUtil: DistributedSyncUtil = DistributedSyncUtil;
  private isRestoring: boolean = false;

  aboutToAppear() {
    // Listen for migration restoration from AppStorage
    this.listenForMigrationRestore();

    // Check if there's already restored data in AppStorage (from continuation)
    this.restoreFromAppStorage();
  }

  aboutToDisappear() {
    // Clean up collaboration if active
    if (this.syncUtil.isInCollaboration()) {
      this.syncUtil.stopCollaboration();
    }
  }

  /**
   * Listen for AppStorage changes triggered by migration restoration
   */
  private listenForMigrationRestore() {
    // Use @StorageLink or @StorageProp would be ideal, but since we need
    // to react to changes from Ability layer, we poll AppStorage on key changes
    // The Ability sets 'migrationTimestamp' when data is restored
    AppStorage.setOrCreate('migrationTimestamp', 0);
  }

  /**
   * Restore calculator state from AppStorage after migration
   */
  private restoreFromAppStorage() {
    const expression = AppStorage.get<string>('calculatorExpression');
    const result = AppStorage.get<string>('calculatorResult');
    const isScientific = AppStorage.get<boolean>('isScientificMode');
    const isFraction = AppStorage.get<boolean>('isFractionMode');
    const equationMode = AppStorage.get<string>('equationMode');
    const showHistory = AppStorage.get<boolean>('showHistory');
    const historyListStr = AppStorage.get<string>('historyList');

    if (expression !== undefined && expression !== '') {
      this.isRestoring = true;
      this.inputValue = expression;
      this.calValue = result ?? '0';
      if (isScientific !== undefined) {
        this.isScientificMode = isScientific;
      }
      if (isFraction !== undefined) {
        this.isFractionMode = isFraction;
      }
      if (equationMode !== undefined) {
        this.equationMode = equationMode;
      }
      if (showHistory !== undefined) {
        this.showHistory = showHistory;
      }
      if (historyListStr) {
        try {
          const items = JSON.parse(historyListStr) as Array<HistoryItem>;
          if (Array.isArray(items)) {
            this.historyList = items;
            // Also restore to HistoryManager
            items.forEach((item: HistoryItem) => {
              HistoryManager.addHistory(item.expression, item.result);
            });
          }
        } catch (e) {
          Logger.error('[CalculatorComponent] Failed to parse historyList: ' + JSON.stringify(e));
        }
      }
      // Rebuild expressions array from the input value
      this.rebuildExpressions(expression);
      this.isRestoring = false;
    }
  }

  /**
   * Rebuild expressions array from formatted input string
   */
  private rebuildExpressions(expression: string) {
    this.expressions = [];
    if (!expression) {
      return;
    }
    // Simple tokenization: split by operators while keeping them
    const tokens = expression.match(/(\d+\.?\d*|[+\-×÷^]|sin|cos|tan|log|ln|√|!|π|e|\(|\)|\/\d+)/g);
    if (tokens) {
      this.expressions = tokens;
    } else {
      this.expressions = [expression];
    }
  }

  /**
   * Handle remote data change from collaboration
   */
  private handleCollaborationDataChange(state: CalculatorState) {
    this.isRestoring = true;
    this.inputValue = state.calculatorExpression;
    this.calValue = state.calculatorResult;
    this.isScientificMode = state.isScientificMode;
    this.isFractionMode = state.isFractionMode;
    this.equationMode = state.equationMode;
    this.showHistory = state.showHistory;

    if (state.historyList) {
      try {
        const items = JSON.parse(state.historyList) as Array<HistoryItem>;
        if (Array.isArray(items)) {
          this.historyList = items;
        }
      } catch (e) {
        Logger.error('[CalculatorComponent] Failed to parse collaboration historyList');
      }
    }

    this.rebuildExpressions(state.calculatorExpression);
    this.isRestoring = false;
  }

  /**
   * Sync current state to distributed data object for collaboration
   */
  private syncStateToDistributed() {
    if (this.isRestoring || !this.syncUtil.isInCollaboration()) {
      return;
    }
    const historyListStr = JSON.stringify(this.historyList);
    this.syncUtil.updateState({
      currentPage: 'HomePage',
      calculatorExpression: this.inputValue,
      calculatorResult: this.calValue,
      isScientificMode: this.isScientificMode,
      isFractionMode: this.isFractionMode,
      equationMode: this.equationMode,
      showHistory: this.showHistory,
      historyList: historyListStr,
      timestamp: Date.now()
    });
  }
=======
  @Prop currentBreakpoint: BreakpointType = BreakpointType.SM;
  private expressions: Array<string> = [];
>>>>>>> ec2c3a8fa90320418457a7069fe965d421ef26be

  build() {
    // Use different layout based on breakpoint
    if (BreakpointUtil.isSideBySideLayout(this.currentBreakpoint)) {
      // Side-by-side layout for tablet/PC
      this.buildSideBySideLayout()
    } else {
      // Stacked layout for phone
      this.buildStackedLayout()
    }
  }

  /**
   * Stacked layout for phone (vertical)
   */
  @Builder
  buildStackedLayout() {
    Column() {
      this.buildInputArea()
      this.buildResultArea()
      this.buildControlButtons()
      if (this.showHistory) {
        this.buildHistoryPanel()
      }
      if (this.isScientificMode) {
        this.buildScientificKeys()
        this.buildFractionInput()
      }
      this.buildStandardKeys()
    }
    .height(CommonConstants.FULL_PERCENT)
    .width(CommonConstants.FULL_PERCENT)
    .backgroundColor($r('app.color.column_back_color'))
  }

  /**
   * Side-by-side layout for tablet/PC (horizontal)
   */
  @Builder
  buildSideBySideLayout() {
    Row() {
      // Left: Display and controls
      Column() {
        this.buildInputArea()
        this.buildResultArea()
        this.buildControlButtons()
        if (this.showHistory) {
          this.buildHistoryPanel()
        }
      }
      .layoutWeight(1)
      .height(CommonConstants.FULL_PERCENT)
      .backgroundColor($r('app.color.column_back_color'))

      // Right: Key pad
      Column() {
        if (this.isScientificMode) {
          this.buildScientificKeys()
          this.buildFractionInput()
        }
        this.buildStandardKeys()
      }
      .layoutWeight(1)
      .height(CommonConstants.FULL_PERCENT)
      .backgroundColor($r('app.color.row_back_color'))
    }
    .height(CommonConstants.FULL_PERCENT)
    .width(CommonConstants.FULL_PERCENT)
  }

  /**
   * Input display area
   */
  @Builder
  buildInputArea() {
    Column() {
      TextInput({ text: this.resultFormat(this.inputValue) })
        .height(CommonConstants.FULL_PERCENT)
        .fontSize(
          (this.inputValue.length > CommonConstants.INPUT_LENGTH_MAX) ?
            $r('app.float.font_size_text') : $r('app.float.font_size_input')
        )
        .enabled(false)
        .fontColor(Color.Black)
        .textAlign(TextAlign.End)
        .backgroundColor($r('app.color.input_back_color'))
    }
    .width(CommonConstants.FULL_PERCENT)
    .height($r('app.float.input_height'))
    .alignItems(HorizontalAlign.End)
    .margin({
      right: $r('app.float.input_margin_right'),
      top: $r('app.float.input_margin_top')
    })
  }

  /**
   * Result display area
   */
  @Builder
  buildResultArea() {
    Column() {
      Text(this.resultFormat(this.calValue))
        .fontSize($r('app.float.font_size_text'))
        .fontColor($r('app.color.text_color'))
    }
    .width(CommonConstants.FULL_PERCENT)
    .height($r('app.float.text_height'))
    .alignItems(HorizontalAlign.End)
    .margin({
      right: $r('app.float.text_margin_right'),
      bottom: $r('app.float.text_margin_bottom')
    })
  }

  /**
<<<<<<< HEAD
   * Top control buttons (history, fraction, scientific mode, collaboration)
=======
   * Top control buttons (history, fraction, scientific mode)
>>>>>>> ec2c3a8fa90320418457a7069fe965d421ef26be
   */
  @Builder
  buildControlButtons() {
    Column() {
      Row() {
        // History button
        Column() {
          Text('历史')
            .fontSize('14vp')
            .fontColor(Color.White)
        }
<<<<<<< HEAD
        .width('18%')
=======
        .width('25%')
>>>>>>> ec2c3a8fa90320418457a7069fe965d421ef26be
        .height('40vp')
        .backgroundColor('#6C7B8B')
        .justifyContent(FlexAlign.Center)
        .borderRadius(5)
        .onClick(() => {
          this.showHistory = !this.showHistory;
          if (this.showHistory) {
            this.historyList = HistoryManager.getHistory();
          }
<<<<<<< HEAD
          this.syncStateToDistributed();
        })

        Blank().width('2%')

        // Fraction/Decimal toggle
        Column() {
          Text(this.isFractionMode ? '小数' : '分数')
            .fontSize('14vp')
            .fontColor(Color.White)
        }
        .width('18%')
=======
        })

        Blank().width('3%')

        // Fraction/Decimal toggle
        Column() {
          Text(this.isFractionMode ? '小数模式' : '分数模式')
            .fontSize('14vp')
            .fontColor(Color.White)
        }
        .width('25%')
>>>>>>> ec2c3a8fa90320418457a7069fe965d421ef26be
        .height('40vp')
        .backgroundColor(this.isFractionMode ? '#FF6B6B' : '#4ECDC4')
        .justifyContent(FlexAlign.Center)
        .borderRadius(5)
        .onClick(() => {
          this.isFractionMode = !this.isFractionMode;
          if (this.calValue && this.calValue !== 'NaN') {
            this.updateDisplayFormat();
          }
<<<<<<< HEAD
          this.syncStateToDistributed();
        })

        Blank().width('2%')

        // Scientific mode toggle
        Column() {
          Text(this.isScientificMode ? '标准' : '科学')
            .fontSize('14vp')
            .fontColor(Color.White)
        }
        .width('18%')
=======
        })

        Blank().width('3%')

        // Scientific mode toggle
        Column() {
          Text(this.isScientificMode ? '标准模式' : '科学模式')
            .fontSize('14vp')
            .fontColor(Color.White)
        }
        .width('35%')
>>>>>>> ec2c3a8fa90320418457a7069fe965d421ef26be
        .height('40vp')
        .backgroundColor('#4A90E2')
        .justifyContent(FlexAlign.Center)
        .borderRadius(5)
        .onClick(() => {
          this.isScientificMode = !this.isScientificMode;
<<<<<<< HEAD
          this.syncStateToDistributed();
        })

        Blank().width('2%')

        // Collaboration button
        Column() {
          Text(this.isCollaborating ? '协同中' : '协同')
            .fontSize('14vp')
            .fontColor(Color.White)
        }
        .width('18%')
        .height('40vp')
        .backgroundColor(this.isCollaborating ? '#FF9500' : '#8E44AD')
        .justifyContent(FlexAlign.Center)
        .borderRadius(5)
        .onClick(() => {
          this.toggleCollaboration();
=======
>>>>>>> ec2c3a8fa90320418457a7069fe965d421ef26be
        })
      }
      .width(CommonConstants.FULL_PERCENT)
      .justifyContent(FlexAlign.Center)
<<<<<<< HEAD

      // Collaboration status bar
      if (this.isCollaborating) {
        Row() {
          Text('已连接: ' + this.collaborationPeer)
            .fontSize('12vp')
            .fontColor('#666666')
            .layoutWeight(1)

          Text('断开')
            .fontSize('12vp')
            .fontColor('#FF0000')
            .onClick(() => {
              this.stopCollaboration();
            })
        }
        .width('95%')
        .padding({ top: '5vp', bottom: '5vp' })
      }
=======
>>>>>>> ec2c3a8fa90320418457a7069fe965d421ef26be
    }
    .width(CommonConstants.FULL_PERCENT)
    .margin({ bottom: '3vp' })
  }

  /**
   * History panel
   */
  @Builder
  buildHistoryPanel() {
    Column() {
      Row() {
        Text('计算历史')
          .fontSize('16vp')
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Bold)

        Blank()

        Text('清空')
          .fontSize('14vp')
          .fontColor('#FF0000')
          .onClick(() => {
            HistoryManager.clearHistory();
            this.historyList = [];
          })
      }
      .width('95%')
      .padding({ top: '10vp', bottom: '10vp' })

      if (this.historyList.length === 0) {
        Column() {
          Text('暂无历史记录')
            .fontSize('14vp')
            .fontColor('#999999')
        }
        .width('95%')
        .height('150vp')
        .justifyContent(FlexAlign.Center)
      } else {
        List() {
          ForEach(this.historyList, (item: HistoryItem, index: number) => {
            ListItem() {
              Column() {
                Row() {
                  Text(item.expression)
                    .fontSize('14vp')
                    .fontColor('#333333')
                    .layoutWeight(1)

                  Text('=')
                    .fontSize('14vp')
                    .fontColor('#666666')
                    .margin({ left: '5vp', right: '5vp' })

                  Text(item.result)
                    .fontSize('14vp')
                    .fontColor('#4A90E2')
                    .fontWeight(FontWeight.Bold)
                }
                .width('100%')

                Text(HistoryManager.formatTime(item.timestamp))
                  .fontSize('12vp')
                  .fontColor('#999999')
                  .margin({ top: '3vp' })
              }
              .width('95%')
              .padding('8vp')
              .backgroundColor(index % 2 === 0 ? '#FFFFFF' : '#F5F5F5')
              .borderRadius(5)
              .onClick(() => {
                this.inputValue = item.expression;
                this.calValue = item.result;
                this.showHistory = false;
              })
            }
          }, (item: HistoryItem) => JSON.stringify(item))
        }
        .width('95%')
        .height('200vp')
        .divider({ strokeWidth: 1, color: '#E0E0E0' })
      }
    }
    .width(CommonConstants.FULL_PERCENT)
    .backgroundColor('#F9F9F9')
    .border({ width: 1, color: '#E0E0E0' })
    .borderRadius(10)
    .margin({ bottom: '5vp' })
  }

  /**
   * Scientific keys area
   */
  @Builder
  buildScientificKeys() {
    Column() {
      Row() {
        ForEach(keysModel.getScientificKeys(), (columnItem: Array<PressKeysBean>, columnItemIndex?: number) => {
          Column() {
            ForEach(columnItem, (keyItem: PressKeysBean, keyItemIndex?: number) => {
              Column() {
                Text(keyItem.value)
                  .fontSize('14vp')
                  .fontColor(Color.Black)
              }
              .width('55vp')
              .height('30vp')
              .borderWidth(1)
              .borderColor($r('app.color.border_color'))
              .borderRadius(15)
              .backgroundColor('#E8E8E8')
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .onClick(() => {
                this.inputScientificSymbol(keyItem.value);
              })
            }, (keyItem: PressKeysBean) => JSON.stringify(keyItem))
          }
          .width(CommonConstants.FULL_PERCENT)
          .justifyContent(FlexAlign.Center)
          .layoutWeight(1)
        })
      }
      .width(CommonConstants.FULL_PERCENT)
    }
    .width(CommonConstants.FULL_PERCENT)
    .margin({ bottom: '3vp' })
  }

  /**
   * Fraction input buttons
   */
  @Builder
  buildFractionInput() {
    Column() {
      Row() {
        Column() {
          Text('分数输入')
            .fontSize('12vp')
            .fontColor('#666666')
        }
        .width('100%')
        .margin({ bottom: '3vp' })
      }

      Row() {
        Column() {
          Text('a/b')
            .fontSize('14vp')
            .fontColor(Color.Black)
        }
        .width('55vp')
        .height('30vp')
        .borderWidth(1)
        .borderColor($r('app.color.border_color'))
        .borderRadius(15)
        .backgroundColor('#FFE4B5')
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.inputFractionSymbol('/');
        })

        Blank().width('8vp')

        Column() {
          Text('a b/c')
            .fontSize('14vp')
            .fontColor(Color.Black)
        }
        .width('55vp')
        .height('30vp')
        .borderWidth(1)
        .borderColor($r('app.color.border_color'))
        .borderRadius(15)
        .backgroundColor('#FFE4B5')
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.inputFractionSymbol(' ');
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width(CommonConstants.FULL_PERCENT)
    .margin({ bottom: '3vp' })
  }

  /**
   * Standard keys area
   */
  @Builder
  buildStandardKeys() {
    Column() {
      Row() {
        ForEach(keysModel.getPressKeys(), (columnItem: Array<PressKeysBean>, columnItemIndex?: number) => {
          Column() {
            ForEach(columnItem, (keyItem: PressKeysBean, keyItemIndex?: number) => {
              Column() {
                Column() {
                  if (keyItem.flag === 0) {
                    Image(keyItem.source !== undefined ? keyItem.source : '')
                      .width(keyItem.width)
                      .height(keyItem.height)
                  } else {
                    Text(keyItem.value)
                      .fontSize(
                        (keyItem.value === CommonConstants.DOTS) ?
                          $r('app.float.font_size_dot') : $r('app.float.font_size_text')
                      )
                      .width(keyItem.width)
                      .height(keyItem.height)
                  }
                }
                .width($r('app.float.key_width'))
                .height(
                  ((columnItemIndex === 2) && (keyItem.value === 'equ')) ?
                    $r('app.float.equals_height') : $r('app.float.key_height')
                )
                .borderWidth(1)
                .borderColor($r('app.color.border_color'))
                .borderRadius($r('app.float.border_radius'))
                .backgroundColor(
                  (keyItem.value === 'equ') ?
                    $r('app.color.equals_back_color') : Color.White
                )
                .alignItems(HorizontalAlign.Center)
                .justifyContent(FlexAlign.Center)
                .onClick(() => {
                  if (keyItem.flag === 0) {
                    this.inputSymbol(keyItem.value);
                  } else {
                    this.inputNumber(keyItem.value);
                  }
                })
              }
              .layoutWeight(
                (keyItem.value === 'equ') ? CommonConstants.TWO : 1
              )
              .width(CommonConstants.FULL_PERCENT)
              .justifyContent(FlexAlign.Center)
            }, (keyItem: PressKeysBean) => JSON.stringify(keyItem))
          }
          .layoutWeight(1)
          .margin({
            top: $r('app.float.margin_top'),
            bottom: $r('app.float.margin_bottom')
          })
        }, (item: Array<Array<PressKeysBean>>) => JSON.stringify(item))
      }
      .height(CommonConstants.FULL_PERCENT)
      .alignItems(VerticalAlign.Top)
      .margin({
        left: $r('app.float.margin_left'),
        right: $r('app.float.margin_right')
      })
    }
    .layoutWeight(1)
    .width(CommonConstants.FULL_PERCENT)
    .backgroundColor($r('app.color.row_back_color'))
  }

  // ==================== Business Logic Methods ====================

  inputSymbol(value: string) {
    if (CheckEmptyUtil.isEmpty(value)) {
      return;
    }
    let len = this.expressions.length;
    switch (value) {
      case Symbol.CLEAN:
        this.expressions = [];
        this.calValue = '';
        this.equationMode = '';
        break;
      case Symbol.DEL:
        this.inputDelete(len);
        break;
      case Symbol.EQU:
        if (this.equationMode !== '') {
          this.solveEquation();
          return;
        }
        if (len === 0) {
          return;
        }
        this.getResult().then((result: boolean) => {
          if (!result) {
            return;
          }
          const expression = this.inputValue;
          const resultValue = this.calValue;
          HistoryManager.addHistory(expression, resultValue);
          this.inputValue = this.calValue;
          this.calValue = '';
          this.expressions = [];
          this.expressions.push(this.inputValue);
        })
        break;
      default:
        this.inputOperators(len, value);
        break;
    }
    this.formatInputValue();
<<<<<<< HEAD
    this.syncStateToDistributed();
=======
>>>>>>> ec2c3a8fa90320418457a7069fe965d421ef26be
  }

  inputNumber(value: string) {
    if (CheckEmptyUtil.isEmpty(value)) {
      return;
    }
    if (this.equationMode !== '') {
      this.inputValue += value;
      return;
    }
    let len = this.expressions.length;
    let last = len > 0 ? this.expressions[len - 1] : '';
    let secondLast = len > 1 ? this.expressions[len - CommonConstants.TWO] : undefined;
    if (!this.validateEnter(last, value)) {
      return;
    }
    if (last === '/' && len >= 2) {
      let numerator = secondLast;
      if (numerator && !CalculateUtil.isSymbol(numerator) && !CalculateUtil.isScientificSymbol(numerator)) {
        this.expressions.pop();
        this.expressions.pop();
        this.expressions.push(numerator + '/' + value);
        this.formatInputValue();
        this.getResult();
        return;
      }
    }
    if (last && last.indexOf('/') !== -1) {
      this.expressions[len - 1] += value;
      this.formatInputValue();
      this.getResult();
      return;
    }
    let isLastOperator = CalculateUtil.isSymbol(last) || CalculateUtil.isScientificSymbol(last);
    if (!last) {
      this.expressions.push(value);
    } else if (isLastOperator) {
      this.expressions.push(value);
    } else if (!secondLast) {
      this.expressions[len - 1] += value;
    } else {
      let isSecondLastOperator = CalculateUtil.isSymbol(secondLast) || CalculateUtil.isScientificSymbol(secondLast);
      if (isSecondLastOperator) {
        this.expressions[len - 1] += value;
      } else {
        this.expressions.push(value);
      }
    }
    this.formatInputValue();
    if (value !== CommonConstants.DOTS) {
      this.getResult();
    }
<<<<<<< HEAD
    this.syncStateToDistributed();
=======
>>>>>>> ec2c3a8fa90320418457a7069fe965d421ef26be
  }

  validateEnter(last: string, value: string) {
    if (!last && value === CommonConstants.PERCENT_SIGN) {
      return false;
    }
    if ((last === CommonConstants.MIN) && (value === CommonConstants.PERCENT_SIGN)) {
      return false;
    }
    if (last.endsWith(CommonConstants.PERCENT_SIGN)) {
      return false;
    }
    if ((last.indexOf(CommonConstants.DOTS) !== -1) && (value === CommonConstants.DOTS)) {
      return false;
    }
    if ((last === '0') && (value !== CommonConstants.DOTS) &&
      (value !== CommonConstants.PERCENT_SIGN)) {
      return false;
    }
    return true;
  }

  inputDelete(len: number) {
    if (len === 0) {
      return;
    }
    let last = this.expressions[len - 1];
    let lastLen = last.length;
    if (lastLen === 1) {
      this.expressions.pop();
      len = this.expressions.length;
    } else {
      this.expressions[len - 1] = last.slice(0, last.length - 1);
    }
    if (len === 0) {
      this.inputValue = '';
      this.calValue = '';
      return;
    }
    if (!CalculateUtil.isSymbol(this.expressions[len - 1])) {
      this.getResult();
    }
  }

  inputOperators(len: number, value: string) {
    let last = len > 0 ? this.expressions[len - 1] : undefined;
    let secondLast = len > 1 ? this.expressions[len - CommonConstants.TWO] : undefined;
    if (!last && (value === Symbol.MIN)) {
      this.expressions.push(this.getSymbol(value));
      return;
    }
    if (!last) {
      return;
    }
    if (!CalculateUtil.isSymbol(last)) {
      this.expressions.push(this.getSymbol(value));
      return;
    }
    if ((value === Symbol.MIN) &&
      (last === CommonConstants.MIN || last === CommonConstants.ADD)) {
      this.expressions.pop();
      this.expressions.push(this.getSymbol(value));
      return;
    }
    if (!secondLast) {
      return;
    }
    if (value !== Symbol.MIN) {
      this.expressions.pop();
    }
    if (CalculateUtil.isSymbol(secondLast)) {
      this.expressions.pop();
    }
    this.expressions.push(this.getSymbol(value));
  }

  getSymbol(value: string) {
    if (CheckEmptyUtil.isEmpty(value)) {
      return '';
    }
    let symbol = '';
    switch (value) {
      case Symbol.ADD:
        symbol = CommonConstants.ADD;
        break;
      case Symbol.MIN:
        symbol = CommonConstants.MIN;
        break;
      case Symbol.MUL:
        symbol = CommonConstants.MUL;
        break;
      case Symbol.DIV:
        symbol = CommonConstants.DIV;
        break;
      default:
        break;
    }
    return symbol;
  }

  deepCopy(): Array<string> {
    let copyExpressions: Array<string> = Array.from(this.expressions);
    return copyExpressions;
  }

  async getResult() {
    let calResult = CalculateUtil.parseExpression(this.deepCopy());
    if (calResult === 'NaN') {
      this.calValue = this.resourceToString($r('app.string.error'));
      return false;
    }
    if (this.isFractionMode) {
      calResult = this.convertToFraction(calResult);
    }
    this.calValue = calResult;
    return true;
  }

  convertToFraction(decimalStr: string): string {
    if (!decimalStr || decimalStr === 'NaN') {
      return decimalStr;
    }
    if (decimalStr.indexOf('/') !== -1) {
      return decimalStr;
    }
    try {
      const decimal = parseFloat(decimalStr);
      if (isNaN(decimal)) {
        return decimalStr;
      }
      const fraction = FractionUtil.decimalToFraction(decimal);
      const fractionStr = FractionUtil.fractionToString(fraction);
      if (fraction.denominator <= 1000 && fractionStr !== 'NaN') {
        return fractionStr;
      }
    } catch (e) {
      Logger.error('[CalculatorComponent] convertToFraction error: ' + JSON.stringify(e));
    }
    return decimalStr;
  }

  updateDisplayFormat() {
    if (!this.calValue || this.calValue === 'NaN') {
      return;
    }
    if (this.isFractionMode) {
      this.calValue = this.convertToFraction(this.calValue);
    } else {
      if (this.calValue.indexOf('/') !== -1) {
        try {
          const fraction = FractionUtil.parseFraction(this.calValue);
          const decimal = FractionUtil.fractionToDecimal(fraction);
          if (!isNaN(decimal)) {
            this.calValue = decimal.toString();
          }
        } catch (e) {
          Logger.error('[CalculatorComponent] updateDisplayFormat error: ' + JSON.stringify(e));
        }
      }
    }
  }

  resultFormat(value: string) {
    let reg = (value.indexOf('.') > -1) ? new RegExp("/(\d)(?=(\d{3})+\.)/g") : new RegExp("/(\d)(?=(?:\d{3})+$)/g");
    return value.replace(reg, '$1,');
  }

  resourceToString(resource: Resource): string {
    if (CheckEmptyUtil.isEmpty(resource)) {
      return '';
    }
    let result = '';
    try {
      const uiContext: UIContext | undefined = AppStorage.get('uiContext');
      let context = uiContext!.getHostContext()!;
      result = context.resourceManager.getStringSync(resource.id);
    } catch (error) {
      Logger.error('[CalculatorComponent] getResourceString fail: ' + JSON.stringify(error))
    }
    return result;
  }

  formatInputValue() {
    let deepExpressions: Array<string> = [];
    this.deepCopy().forEach((item: string, index: number) => {
      deepExpressions[index] = this.resultFormat(item);
    });
    this.inputValue = deepExpressions.join('');
  }

  inputScientificSymbol(value: string) {
    if (CheckEmptyUtil.isEmpty(value)) {
      return;
    }
    if (this.equationMode !== '') {
      if (value === ',') {
        this.inputValue += ',';
        return;
      }
      if (value === '-') {
        this.inputValue += '-';
        return;
      }
    }
    if (value === 'π') {
      this.expressions.push(Math.PI.toString());
      this.formatInputValue();
      this.getResult();
      return;
    }
    if (value === 'e') {
      this.expressions.push(Math.E.toString());
      this.formatInputValue();
      this.getResult();
      return;
    }
    if (value === '方程') {
      this.showEquationDialog();
      return;
    }
    if (value === 'x²') {
      this.expressions.push('^');
      this.expressions.push('2');
      this.formatInputValue();
      this.getResult();
      return;
    }
    if (value === '1/x') {
      this.expressions.unshift('1');
      this.expressions.push('÷');
      this.formatInputValue();
      this.getResult();
      return;
    }
    if (value === '(' || value === ')') {
      this.expressions.push(value);
      this.formatInputValue();
      return;
    }
    const unaryOperators = ['sin', 'cos', 'tan', 'log', 'ln', '√', '!'];
    if (unaryOperators.indexOf(value) !== -1) {
      let len = this.expressions.length;
      if (len > 0) {
        let last = this.expressions[len - 1];
        if (!CalculateUtil.isSymbol(last) && !CalculateUtil.isScientificSymbol(last)) {
          if (value === '!') {
            this.expressions.push(value);
          } else {
            this.expressions.splice(len - 1, 0, value);
          }
          this.formatInputValue();
          this.getResult();
          return;
        }
      }
      this.expressions.push(value);
      this.formatInputValue();
      return;
    }
    this.expressions.push(value);
    this.formatInputValue();
  }

  showEquationDialog() {
    if (this.equationMode === '') {
      this.equationMode = 'quadratic';
      this.calValue = '方程模式：输入系数 a,b,c 解 ax²+bx+c=0';
      this.expressions = [];
      this.inputValue = '';
    } else {
      this.equationMode = '';
      this.calValue = '';
      this.expressions = [];
      this.inputValue = '';
    }
  }

  solveEquation() {
    let input = this.inputValue.trim();
    let coefficients: string[];
    if (input.indexOf(',') !== -1) {
      coefficients = input.split(',');
    } else {
      coefficients = input.split(/\s+/);
    }
    coefficients = coefficients.map(c => c.trim()).filter(c => c !== '');
    if (coefficients.length === 2) {
      let a = coefficients[0];
      let b = coefficients[1];
      this.calValue = CalculateUtil.solveLinearEquation(a, b);
    } else if (coefficients.length === 3) {
      let a = coefficients[0];
      let b = coefficients[1];
      let c = coefficients[2];
      this.calValue = CalculateUtil.solveQuadraticEquation(a, b, c);
    } else {
      this.calValue = '错误：请输入2个系数（一次方程）或3个系数（二次方程）';
    }
  }

  inputFractionSymbol(symbol: string) {
    this.inputValue += symbol;
    this.expressions.push(symbol);
    this.formatInputValue();
  }
<<<<<<< HEAD

  // ==================== Collaboration Methods ====================

  /**
   * Toggle collaboration mode on/off
   */
  toggleCollaboration() {
    if (this.isCollaborating) {
      this.stopCollaboration();
    } else {
      this.startCollaboration();
    }
  }

  /**
   * Start collaboration - creates a session and waits for peer to join
   */
  startCollaboration() {
    try {
      const uiContext: UIContext | undefined = AppStorage.get('uiContext');
      if (!uiContext) {
        Logger.error('[CalculatorComponent] No UIContext available for collaboration');
        return;
      }

      const context = uiContext.getHostContext();
      if (!context) {
        Logger.error('[CalculatorComponent] No host context available for collaboration');
        return;
      }

      const historyListStr = JSON.stringify(this.historyList);
      const initialState: CalculatorState = {
        currentPage: 'HomePage',
        calculatorExpression: this.inputValue,
        calculatorResult: this.calValue,
        isScientificMode: this.isScientificMode,
        isFractionMode: this.isFractionMode,
        equationMode: this.equationMode,
        showHistory: this.showHistory,
        historyList: historyListStr,
        timestamp: Date.now()
      };

      const sessionId = this.syncUtil.startCollaboration(
        context,
        initialState,
        (state: CalculatorState) => {
          this.handleCollaborationDataChange(state);
        },
        (sessionId: string, networkId: string, status: string) => {
          Logger.info('[CalculatorComponent] Collaboration status: ' + status);
          if (status === 'restored') {
            this.collaborationPeer = networkId;
          }
        }
      );

      this.isCollaborating = true;
      this.collaborationPeer = '等待连接...';

      // Store session ID in AppStorage so other devices can join
      AppStorage.setOrCreate('collaborationSessionId', sessionId);

      Logger.info('[CalculatorComponent] Collaboration started, sessionId: ' + sessionId);
    } catch (error) {
      Logger.error('[CalculatorComponent] Failed to start collaboration: ' + JSON.stringify(error));
    }
  }

  /**
   * Stop collaboration and clean up
   */
  stopCollaboration() {
    this.syncUtil.stopCollaboration();
    this.isCollaborating = false;
    this.collaborationPeer = '';
    AppStorage.setOrCreate('collaborationSessionId', '');
    Logger.info('[CalculatorComponent] Collaboration stopped');
  }

  /**
   * Copy result to clipboard (supports cross-device paste)
   */
  copyResultToClipboard() {
    try {
      if (this.calValue) {
        const pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, this.calValue);
        const systemPasteboard = pasteboard.getSystemPasteboard();
        systemPasteboard.setData(pasteData);
        Logger.info('[CalculatorComponent] Result copied to clipboard');
      }
    } catch (error) {
      Logger.error('[CalculatorComponent] Failed to copy to clipboard: ' + JSON.stringify(error));
    }
  }

  /**
   * Paste from clipboard (supports cross-device paste)
   */
  async pasteFromClipboard() {
    try {
      const systemPasteboard = pasteboard.getSystemPasteboard();
      const pasteData = await systemPasteboard.getData();
      if (pasteData) {
        const text = pasteData.getPrimaryText();
        if (text) {
          this.inputValue = text;
          this.expressions = [text];
          this.getResult();
          this.syncStateToDistributed();
        }
      }
    } catch (error) {
      Logger.error('[CalculatorComponent] Failed to paste from clipboard: ' + JSON.stringify(error));
    }
  }
=======
>>>>>>> ec2c3a8fa90320418457a7069fe965d421ef26be
}
