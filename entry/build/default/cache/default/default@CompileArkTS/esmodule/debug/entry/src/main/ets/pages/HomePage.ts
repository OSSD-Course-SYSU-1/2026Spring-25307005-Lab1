if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface HomePage_Params {
    inputValue?: string;
    calValue?: string;
    isScientificMode?: boolean;
    equationMode?: string;
    showHistory?: boolean;
    isFractionMode?: boolean;
    historyList?: Array<HistoryItem>;
    expressions?: Array<string>;
}
import Logger from "@bundle:com.example.simplecalculator/entry/ets/common/util/Logger";
import CalculateUtil from "@bundle:com.example.simplecalculator/entry/ets/common/util/CalculateUtil";
import CheckEmptyUtil from "@bundle:com.example.simplecalculator/entry/ets/common/util/CheckEmptyUtil";
import HistoryManager from "@bundle:com.example.simplecalculator/entry/ets/common/util/HistoryManager";
import type { HistoryItem } from "@bundle:com.example.simplecalculator/entry/ets/common/util/HistoryManager";
import FractionUtil from "@bundle:com.example.simplecalculator/entry/ets/common/util/FractionUtil";
import keysModel from "@bundle:com.example.simplecalculator/entry/ets/viewmodel/PresskeysViewModel";
import type { PressKeysBean } from '../viewmodel/PressKeysItem';
import { CommonConstants, Symbol } from "@bundle:com.example.simplecalculator/entry/ets/common/constants/CommonConstants";
class HomePage extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__inputValue = new ObservedPropertySimplePU('', this, "inputValue");
        this.__calValue = new ObservedPropertySimplePU('', this, "calValue");
        this.__isScientificMode = new ObservedPropertySimplePU(false, this, "isScientificMode");
        this.__equationMode = new ObservedPropertySimplePU('', this, "equationMode");
        this.__showHistory = new ObservedPropertySimplePU(false, this, "showHistory");
        this.__isFractionMode = new ObservedPropertySimplePU(false, this, "isFractionMode");
        this.__historyList = new ObservedPropertyObjectPU([], this, "historyList");
        this.expressions = [];
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: HomePage_Params) {
        if (params.inputValue !== undefined) {
            this.inputValue = params.inputValue;
        }
        if (params.calValue !== undefined) {
            this.calValue = params.calValue;
        }
        if (params.isScientificMode !== undefined) {
            this.isScientificMode = params.isScientificMode;
        }
        if (params.equationMode !== undefined) {
            this.equationMode = params.equationMode;
        }
        if (params.showHistory !== undefined) {
            this.showHistory = params.showHistory;
        }
        if (params.isFractionMode !== undefined) {
            this.isFractionMode = params.isFractionMode;
        }
        if (params.historyList !== undefined) {
            this.historyList = params.historyList;
        }
        if (params.expressions !== undefined) {
            this.expressions = params.expressions;
        }
    }
    updateStateVars(params: HomePage_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__inputValue.purgeDependencyOnElmtId(rmElmtId);
        this.__calValue.purgeDependencyOnElmtId(rmElmtId);
        this.__isScientificMode.purgeDependencyOnElmtId(rmElmtId);
        this.__equationMode.purgeDependencyOnElmtId(rmElmtId);
        this.__showHistory.purgeDependencyOnElmtId(rmElmtId);
        this.__isFractionMode.purgeDependencyOnElmtId(rmElmtId);
        this.__historyList.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__inputValue.aboutToBeDeleted();
        this.__calValue.aboutToBeDeleted();
        this.__isScientificMode.aboutToBeDeleted();
        this.__equationMode.aboutToBeDeleted();
        this.__showHistory.aboutToBeDeleted();
        this.__isFractionMode.aboutToBeDeleted();
        this.__historyList.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __inputValue: ObservedPropertySimplePU<string>;
    get inputValue() {
        return this.__inputValue.get();
    }
    set inputValue(newValue: string) {
        this.__inputValue.set(newValue);
    }
    private __calValue: ObservedPropertySimplePU<string>;
    get calValue() {
        return this.__calValue.get();
    }
    set calValue(newValue: string) {
        this.__calValue.set(newValue);
    }
    private __isScientificMode: ObservedPropertySimplePU<boolean>;
    get isScientificMode() {
        return this.__isScientificMode.get();
    }
    set isScientificMode(newValue: boolean) {
        this.__isScientificMode.set(newValue);
    }
    private __equationMode: ObservedPropertySimplePU<string>; // 'linear' or 'quadratic'
    get equationMode() {
        return this.__equationMode.get();
    }
    set equationMode(newValue: string) {
        this.__equationMode.set(newValue);
    }
    private __showHistory: ObservedPropertySimplePU<boolean>; // Show history panel
    get showHistory() {
        return this.__showHistory.get();
    }
    set showHistory(newValue: boolean) {
        this.__showHistory.set(newValue);
    }
    private __isFractionMode: ObservedPropertySimplePU<boolean>; // Fraction output mode
    get isFractionMode() {
        return this.__isFractionMode.get();
    }
    set isFractionMode(newValue: boolean) {
        this.__isFractionMode.set(newValue);
    }
    private __historyList: ObservedPropertyObjectPU<Array<HistoryItem>>; // History records
    get historyList() {
        return this.__historyList.get();
    }
    set historyList(newValue: Array<HistoryItem>) {
        this.__historyList.set(newValue);
    }
    private expressions: Array<string>;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.height(CommonConstants.FULL_PERCENT);
            Column.backgroundColor({ "id": 16777223, "type": 10001, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width(CommonConstants.FULL_PERCENT);
            Column.height({ "id": 16777235, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
            Column.alignItems(HorizontalAlign.End);
            Column.margin({
                right: { "id": 16777236, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" },
                top: { "id": 16777237, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" }
            });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            TextInput.create({ text: this.resultFormat(this.inputValue) });
            TextInput.height(CommonConstants.FULL_PERCENT);
            TextInput.fontSize((this.inputValue.length > CommonConstants.INPUT_LENGTH_MAX) ? { "id": 16777234, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" } : { "id": 16777233, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
            TextInput.enabled(false);
            TextInput.fontColor(Color.Black);
            TextInput.textAlign(TextAlign.End);
            TextInput.backgroundColor({ "id": 16777225, "type": 10001, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
        }, TextInput);
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width(CommonConstants.FULL_PERCENT);
            Column.height({ "id": 16777244, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
            Column.alignItems(HorizontalAlign.End);
            Column.margin({
                right: { "id": 16777246, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" },
                bottom: { "id": 16777245, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" }
            });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.resultFormat(this.calValue));
            Text.fontSize({ "id": 16777234, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
            Text.fontColor({ "id": 16777228, "type": 10001, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
        }, Text);
        Text.pop();
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Top control buttons
            Column.create();
            // Top control buttons
            Column.width(CommonConstants.FULL_PERCENT);
            // Top control buttons
            Column.margin({ bottom: '5vp' });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width(CommonConstants.FULL_PERCENT);
            Row.justifyContent(FlexAlign.Center);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // History button
            Column.create();
            // History button
            Column.width('25%');
            // History button
            Column.height('40vp');
            // History button
            Column.backgroundColor('#6C7B8B');
            // History button
            Column.justifyContent(FlexAlign.Center);
            // History button
            Column.borderRadius(5);
            // History button
            Column.onClick(() => {
                this.showHistory = !this.showHistory;
                if (this.showHistory) {
                    this.historyList = HistoryManager.getHistory();
                }
            });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('历史');
            Text.fontSize('14vp');
            Text.fontColor(Color.White);
        }, Text);
        Text.pop();
        // History button
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
            Blank.width('5%');
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Fraction/Decimal toggle button
            Column.create();
            // Fraction/Decimal toggle button
            Column.width('25%');
            // Fraction/Decimal toggle button
            Column.height('40vp');
            // Fraction/Decimal toggle button
            Column.backgroundColor(this.isFractionMode ? '#FF6B6B' : '#4ECDC4');
            // Fraction/Decimal toggle button
            Column.justifyContent(FlexAlign.Center);
            // Fraction/Decimal toggle button
            Column.borderRadius(5);
            // Fraction/Decimal toggle button
            Column.onClick(() => {
                this.isFractionMode = !this.isFractionMode;
                // Re-calculate display if there's a result
                if (this.calValue && this.calValue !== 'NaN') {
                    this.updateDisplayFormat();
                }
            });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.isFractionMode ? '小数模式' : '分数模式');
            Text.fontSize('14vp');
            Text.fontColor(Color.White);
        }, Text);
        Text.pop();
        // Fraction/Decimal toggle button
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
            Blank.width('5%');
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Scientific mode toggle button
            Column.create();
            // Scientific mode toggle button
            Column.width('35%');
            // Scientific mode toggle button
            Column.height('40vp');
            // Scientific mode toggle button
            Column.backgroundColor('#4A90E2');
            // Scientific mode toggle button
            Column.justifyContent(FlexAlign.Center);
            // Scientific mode toggle button
            Column.borderRadius(5);
            // Scientific mode toggle button
            Column.onClick(() => {
                this.isScientificMode = !this.isScientificMode;
            });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.isScientificMode ? '标准模式' : '科学模式');
            Text.fontSize('14vp');
            Text.fontColor(Color.White);
        }, Text);
        Text.pop();
        // Scientific mode toggle button
        Column.pop();
        Row.pop();
        // Top control buttons
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            // History panel
            if (this.showHistory) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.width(CommonConstants.FULL_PERCENT);
                        Column.backgroundColor('#F9F9F9');
                        Column.border({ width: 1, color: '#E0E0E0' });
                        Column.borderRadius(10);
                        Column.margin({ bottom: '5vp' });
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        // History header
                        Row.create();
                        // History header
                        Row.width('95%');
                        // History header
                        Row.padding({ top: '10vp', bottom: '10vp' });
                    }, Row);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('计算历史');
                        Text.fontSize('16vp');
                        Text.fontColor(Color.Black);
                        Text.fontWeight(FontWeight.Bold);
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Blank.create();
                    }, Blank);
                    Blank.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('清空');
                        Text.fontSize('14vp');
                        Text.fontColor('#FF0000');
                        Text.onClick(() => {
                            HistoryManager.clearHistory();
                            this.historyList = [];
                        });
                    }, Text);
                    Text.pop();
                    // History header
                    Row.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        If.create();
                        // History list
                        if (this.historyList.length === 0) {
                            this.ifElseBranchUpdateFunction(0, () => {
                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                    Column.create();
                                    Column.width('95%');
                                    Column.height('150vp');
                                    Column.justifyContent(FlexAlign.Center);
                                }, Column);
                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                    Text.create('暂无历史记录');
                                    Text.fontSize('14vp');
                                    Text.fontColor('#999999');
                                }, Text);
                                Text.pop();
                                Column.pop();
                            });
                        }
                        else {
                            this.ifElseBranchUpdateFunction(1, () => {
                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                    List.create();
                                    List.width('95%');
                                    List.height('200vp');
                                    List.divider({ strokeWidth: 1, color: '#E0E0E0' });
                                }, List);
                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                    ForEach.create();
                                    const forEachItemGenFunction = (_item, index: number) => {
                                        const item = _item;
                                        {
                                            const itemCreation = (elmtId, isInitialRender) => {
                                                ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                                                ListItem.create(deepRenderFunction, true);
                                                if (!isInitialRender) {
                                                    ListItem.pop();
                                                }
                                                ViewStackProcessor.StopGetAccessRecording();
                                            };
                                            const itemCreation2 = (elmtId, isInitialRender) => {
                                                ListItem.create(deepRenderFunction, true);
                                            };
                                            const deepRenderFunction = (elmtId, isInitialRender) => {
                                                itemCreation(elmtId, isInitialRender);
                                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                    Column.create();
                                                    Column.width('95%');
                                                    Column.padding('8vp');
                                                    Column.backgroundColor(index % 2 === 0 ? '#FFFFFF' : '#F5F5F5');
                                                    Column.borderRadius(5);
                                                    Column.onClick(() => {
                                                        // Click to use this history record
                                                        this.inputValue = item.expression;
                                                        this.calValue = item.result;
                                                        this.showHistory = false;
                                                    });
                                                }, Column);
                                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                    Row.create();
                                                    Row.width('100%');
                                                }, Row);
                                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                    Text.create(item.expression);
                                                    Text.fontSize('14vp');
                                                    Text.fontColor('#333333');
                                                    Text.layoutWeight(1);
                                                }, Text);
                                                Text.pop();
                                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                    Text.create('=');
                                                    Text.fontSize('14vp');
                                                    Text.fontColor('#666666');
                                                    Text.margin({ left: '5vp', right: '5vp' });
                                                }, Text);
                                                Text.pop();
                                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                    Text.create(item.result);
                                                    Text.fontSize('14vp');
                                                    Text.fontColor('#4A90E2');
                                                    Text.fontWeight(FontWeight.Bold);
                                                }, Text);
                                                Text.pop();
                                                Row.pop();
                                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                    Text.create(HistoryManager.formatTime(item.timestamp));
                                                    Text.fontSize('12vp');
                                                    Text.fontColor('#999999');
                                                    Text.margin({ top: '3vp' });
                                                }, Text);
                                                Text.pop();
                                                Column.pop();
                                                ListItem.pop();
                                            };
                                            this.observeComponentCreation2(itemCreation2, ListItem);
                                            ListItem.pop();
                                        }
                                    };
                                    this.forEachUpdateFunction(elmtId, this.historyList, forEachItemGenFunction, (item: HistoryItem) => JSON.stringify(item), true, false);
                                }, ForEach);
                                ForEach.pop();
                                List.pop();
                            });
                        }
                    }, If);
                    If.pop();
                    Column.pop();
                });
            }
            // Scientific keys (shown when in scientific mode)
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            // Scientific keys (shown when in scientific mode)
            if (this.isScientificMode) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.width(CommonConstants.FULL_PERCENT);
                        Column.margin({ bottom: '5vp' });
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Row.create();
                        Row.width(CommonConstants.FULL_PERCENT);
                    }, Row);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        ForEach.create();
                        const forEachItemGenFunction = (_item, columnItemIndex?: number) => {
                            const columnItem = _item;
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Column.create();
                                Column.width(CommonConstants.FULL_PERCENT);
                                Column.justifyContent(FlexAlign.Center);
                                Column.layoutWeight(1);
                            }, Column);
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                ForEach.create();
                                const forEachItemGenFunction = (_item, keyItemIndex?: number) => {
                                    const keyItem = _item;
                                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                                        Column.create();
                                        Column.width('60vp');
                                        Column.height('35vp');
                                        Column.borderWidth(1);
                                        Column.borderColor({ "id": 16777222, "type": 10001, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
                                        Column.borderRadius({ "id": 16777229, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
                                        Column.backgroundColor('#E8E8E8');
                                        Column.alignItems(HorizontalAlign.Center);
                                        Column.justifyContent(FlexAlign.Center);
                                        Column.onClick(() => {
                                            this.inputScientificSymbol(keyItem.value);
                                        });
                                    }, Column);
                                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                                        Text.create(keyItem.value);
                                        Text.fontSize('14vp');
                                        Text.fontColor(Color.Black);
                                    }, Text);
                                    Text.pop();
                                    Column.pop();
                                };
                                this.forEachUpdateFunction(elmtId, columnItem, forEachItemGenFunction, (keyItem: PressKeysBean) => JSON.stringify(keyItem), true, false);
                            }, ForEach);
                            ForEach.pop();
                            Column.pop();
                        };
                        this.forEachUpdateFunction(elmtId, keysModel.getScientificKeys(), forEachItemGenFunction, undefined, true, false);
                    }, ForEach);
                    ForEach.pop();
                    Row.pop();
                    Column.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        // Fraction input buttons
                        Column.create();
                        // Fraction input buttons
                        Column.width(CommonConstants.FULL_PERCENT);
                        // Fraction input buttons
                        Column.margin({ bottom: '5vp' });
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Row.create();
                    }, Row);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.width('100%');
                        Column.margin({ bottom: '5vp' });
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('分数输入');
                        Text.fontSize('12vp');
                        Text.fontColor('#666666');
                    }, Text);
                    Text.pop();
                    Column.pop();
                    Row.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Row.create();
                        Row.width('100%');
                        Row.justifyContent(FlexAlign.Center);
                    }, Row);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        // Fraction format button: a/b
                        Column.create();
                        // Fraction format button: a/b
                        Column.width('60vp');
                        // Fraction format button: a/b
                        Column.height('35vp');
                        // Fraction format button: a/b
                        Column.borderWidth(1);
                        // Fraction format button: a/b
                        Column.borderColor({ "id": 16777222, "type": 10001, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
                        // Fraction format button: a/b
                        Column.borderRadius({ "id": 16777229, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
                        // Fraction format button: a/b
                        Column.backgroundColor('#FFE4B5');
                        // Fraction format button: a/b
                        Column.alignItems(HorizontalAlign.Center);
                        // Fraction format button: a/b
                        Column.justifyContent(FlexAlign.Center);
                        // Fraction format button: a/b
                        Column.onClick(() => {
                            this.inputFractionSymbol('/');
                        });
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('a/b');
                        Text.fontSize('14vp');
                        Text.fontColor(Color.Black);
                    }, Text);
                    Text.pop();
                    // Fraction format button: a/b
                    Column.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Blank.create();
                        Blank.width('10vp');
                    }, Blank);
                    Blank.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        // Mixed number format button: a b/c
                        Column.create();
                        // Mixed number format button: a b/c
                        Column.width('60vp');
                        // Mixed number format button: a b/c
                        Column.height('35vp');
                        // Mixed number format button: a b/c
                        Column.borderWidth(1);
                        // Mixed number format button: a b/c
                        Column.borderColor({ "id": 16777222, "type": 10001, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
                        // Mixed number format button: a b/c
                        Column.borderRadius({ "id": 16777229, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
                        // Mixed number format button: a b/c
                        Column.backgroundColor('#FFE4B5');
                        // Mixed number format button: a b/c
                        Column.alignItems(HorizontalAlign.Center);
                        // Mixed number format button: a b/c
                        Column.justifyContent(FlexAlign.Center);
                        // Mixed number format button: a b/c
                        Column.onClick(() => {
                            this.inputFractionSymbol(' ');
                        });
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('a b/c');
                        Text.fontSize('14vp');
                        Text.fontColor(Color.Black);
                    }, Text);
                    Text.pop();
                    // Mixed number format button: a b/c
                    Column.pop();
                    Row.pop();
                    // Fraction input buttons
                    Column.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.layoutWeight(1);
            Column.width(CommonConstants.FULL_PERCENT);
            Column.backgroundColor({ "id": 16777226, "type": 10001, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.height(CommonConstants.FULL_PERCENT);
            Row.alignItems(VerticalAlign.Top);
            Row.margin({
                left: { "id": 16777241, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" },
                right: { "id": 16777242, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" }
            });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = (_item, columnItemIndex?: number) => {
                const columnItem = _item;
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                    Column.layoutWeight(1);
                    Column.margin({
                        top: { "id": 16777243, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" },
                        bottom: { "id": 16777240, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" }
                    });
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    ForEach.create();
                    const forEachItemGenFunction = (_item, keyItemIndex?: number) => {
                        const keyItem = _item;
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Column.create();
                            Column.layoutWeight(((columnItemIndex === (keysModel.getPressKeys().length - 1)) &&
                                (keyItemIndex === (columnItem.length - 1))) ? CommonConstants.TWO : 1);
                            Column.width(CommonConstants.FULL_PERCENT);
                            Column.justifyContent(FlexAlign.Center);
                        }, Column);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Column.create();
                            Column.width({ "id": 16777239, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
                            Column.height(((columnItemIndex === (keysModel.getPressKeys().length - 1)) &&
                                (keyItemIndex === (columnItem.length - 1))) ? { "id": 16777230, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" } : { "id": 16777238, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
                            Column.borderWidth(1);
                            Column.borderColor({ "id": 16777222, "type": 10001, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
                            Column.borderRadius({ "id": 16777229, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
                            Column.backgroundColor(((columnItemIndex === (keysModel.getPressKeys().length - 1)) &&
                                (keyItemIndex === (columnItem.length - 1))) ? { "id": 16777224, "type": 10001, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" } : Color.White);
                            Column.alignItems(HorizontalAlign.Center);
                            Column.justifyContent(FlexAlign.Center);
                            Column.onClick(() => {
                                if (keyItem.flag === 0) {
                                    this.inputSymbol(keyItem.value);
                                }
                                else {
                                    this.inputNumber(keyItem.value);
                                }
                            });
                        }, Column);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            If.create();
                            if (keyItem.flag === 0) {
                                this.ifElseBranchUpdateFunction(0, () => {
                                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                                        Image.create(keyItem.source !== undefined ? keyItem.source : '');
                                        Image.width(keyItem.width);
                                        Image.height(keyItem.height);
                                    }, Image);
                                });
                            }
                            else {
                                this.ifElseBranchUpdateFunction(1, () => {
                                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                                        Text.create(keyItem.value);
                                        Text.fontSize((keyItem.value === CommonConstants.DOTS) ? { "id": 16777232, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" } : { "id": 16777234, "type": 10002, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
                                        Text.width(keyItem.width);
                                        Text.height(keyItem.height);
                                    }, Text);
                                    Text.pop();
                                });
                            }
                        }, If);
                        If.pop();
                        Column.pop();
                        Column.pop();
                    };
                    this.forEachUpdateFunction(elmtId, columnItem, forEachItemGenFunction, (keyItem: PressKeysBean) => JSON.stringify(keyItem), true, false);
                }, ForEach);
                ForEach.pop();
                Column.pop();
            };
            this.forEachUpdateFunction(elmtId, keysModel.getPressKeys(), forEachItemGenFunction, (item: Array<Array<PressKeysBean>>) => JSON.stringify(item), true, false);
        }, ForEach);
        ForEach.pop();
        Row.pop();
        Column.pop();
        Column.pop();
    }
    /**
     * Input Symbols.
     *
     * @param value Input Operators.
     */
    inputSymbol(value: string) {
        if (CheckEmptyUtil.isEmpty(value)) {
            return;
        }
        let len = this.expressions.length;
        switch (value) {
            case Symbol.CLEAN:
                this.expressions = [];
                this.calValue = '';
                this.equationMode = ''; // Exit equation mode
                break;
            case Symbol.DEL:
                this.inputDelete(len);
                break;
            case Symbol.EQU:
                // Check if in equation mode
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
                    // Save to history
                    const expression = this.inputValue;
                    const resultValue = this.calValue;
                    HistoryManager.addHistory(expression, resultValue);
                    this.inputValue = this.calValue;
                    this.calValue = '';
                    this.expressions = [];
                    this.expressions.push(this.inputValue);
                });
                break;
            default:
                this.inputOperators(len, value);
                break;
        }
        this.formatInputValue();
    }
    /**
     * Enter numbers.
     *
     * @param value Enter numbers.
     */
    inputNumber(value: string) {
        if (CheckEmptyUtil.isEmpty(value)) {
            return;
        }
        // In equation mode, just append to input value
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
        // Check if we're in fraction input mode (last element is '/' for fraction)
        if (last === '/' && len >= 2) {
            // We're completing a fraction: numerator/denominator
            // Merge into a single fraction element
            let numerator = secondLast;
            if (numerator && !CalculateUtil.isSymbol(numerator) && !CalculateUtil.isScientificSymbol(numerator)) {
                // Remove the last two elements (numerator and '/')
                this.expressions.pop(); // Remove '/'
                this.expressions.pop(); // Remove numerator
                // Add the complete fraction
                this.expressions.push(numerator + '/' + value);
                this.formatInputValue();
                this.getResult();
                return;
            }
        }
        // Check if last element is a fraction (contains '/') - append to denominator
        if (last && last.indexOf('/') !== -1) {
            // Append to the denominator of the fraction
            this.expressions[len - 1] += value;
            this.formatInputValue();
            this.getResult();
            return;
        }
        // Check if last element is an operator (including scientific operators)
        let isLastOperator = CalculateUtil.isSymbol(last) || CalculateUtil.isScientificSymbol(last);
        if (!last) {
            this.expressions.push(value);
        }
        else if (isLastOperator) {
            // If last is an operator, push new number
            this.expressions.push(value);
        }
        else if (!secondLast) {
            // If no second last, append to last number
            this.expressions[len - 1] += value;
        }
        else {
            // Check if second last is an operator
            let isSecondLastOperator = CalculateUtil.isSymbol(secondLast) || CalculateUtil.isScientificSymbol(secondLast);
            if (isSecondLastOperator) {
                // Append to last number
                this.expressions[len - 1] += value;
            }
            else {
                // Push new number
                this.expressions.push(value);
            }
        }
        this.formatInputValue();
        if (value !== CommonConstants.DOTS) {
            this.getResult();
        }
    }
    /**
     * Verify that you can enter.
     *
     * @param last Value of the last element.
     * @param value Current input value.
     * return Indicates whether to allow input.
     */
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
    /**
     * Delete Key Trigger.
     *
     * @param len Expression Length.
     */
    inputDelete(len: number) {
        if (len === 0) {
            return;
        }
        let last = this.expressions[len - 1];
        let lastLen = last.length;
        if (lastLen === 1) {
            this.expressions.pop();
            len = this.expressions.length;
        }
        else {
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
    /**
     * Triggered when input is added, subtracted, multiplied, and divided.
     *
     * @param len Expression Length.
     * @param value Current Input Value.
     */
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
    /**
     * Get Operator.
     *
     * @param value.
     * @return Operators.
     */
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
    /**
     * Make a deep copy of an expression.
     *
     * @return deep copy expression.
     */
    deepCopy(): Array<string> {
        let copyExpressions: Array<string> = Array.from(this.expressions);
        return copyExpressions;
    }
    /**
     * Obtaining Results.
     *
     * @return Whether the result is incorrect.
     */
    async getResult() {
        let calResult = CalculateUtil.parseExpression(this.deepCopy());
        if (calResult === 'NaN') {
            this.calValue = this.resourceToString({ "id": 16777220, "type": 10003, params: [], "bundleName": "com.example.simplecalculator", "moduleName": "entry" });
            return false;
        }
        // Convert to fraction if in fraction mode
        if (this.isFractionMode) {
            calResult = this.convertToFraction(calResult);
        }
        this.calValue = calResult;
        return true;
    }
    /**
     * Convert decimal result to fraction
     *
     * @param decimalStr Decimal string
     * @return Fraction string or original decimal
     */
    convertToFraction(decimalStr: string): string {
        if (!decimalStr || decimalStr === 'NaN') {
            return decimalStr;
        }
        // Check if already a fraction
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
            // Only return fraction if it's reasonable (denominator not too large)
            if (fraction.denominator <= 1000 && fractionStr !== 'NaN') {
                return fractionStr;
            }
        }
        catch (e) {
            Logger.error('[HomePage] convertToFraction error: ' + JSON.stringify(e));
        }
        return decimalStr;
    }
    /**
     * Update display format when switching between fraction and decimal modes
     */
    updateDisplayFormat() {
        if (!this.calValue || this.calValue === 'NaN') {
            return;
        }
        if (this.isFractionMode) {
            // Convert decimal to fraction
            this.calValue = this.convertToFraction(this.calValue);
        }
        else {
            // Convert fraction to decimal
            if (this.calValue.indexOf('/') !== -1) {
                try {
                    const fraction = FractionUtil.parseFraction(this.calValue);
                    const decimal = FractionUtil.fractionToDecimal(fraction);
                    if (!isNaN(decimal)) {
                        this.calValue = decimal.toString();
                    }
                }
                catch (e) {
                    Logger.error('[HomePage] updateDisplayFormat error: ' + JSON.stringify(e));
                }
            }
        }
    }
    /**
     * Number Formatting.
     *
     * @param value Formatting parameters.
     * @return Thousand percentile data.
     */
    resultFormat(value: string) {
        let reg = (value.indexOf('.') > -1) ? new RegExp("/(\d)(?=(\d{3})+\.)/g") : new RegExp("/(\d)(?=(?:\d{3})+$)/g");
        return value.replace(reg, '$1,');
    }
    /**
     * Convert a resource file to a string.
     *
     * @param resource Resource file.
     * @return Character string converted from the resource file.
     */
    resourceToString(resource: Resource): string {
        if (CheckEmptyUtil.isEmpty(resource)) {
            return '';
        }
        let result = '';
        try {
            const uiContext: UIContext | undefined = AppStorage.get('uiContext');
            let context = uiContext!.getHostContext()!;
            result = context.resourceManager.getStringSync(resource.id);
        }
        catch (error) {
            Logger.error('[CalculateModel] getResourceString fail: ' + JSON.stringify(error));
        }
        return result;
    }
    /**
     * Thousands in the formatting result.
     */
    formatInputValue() {
        let deepExpressions: Array<string> = [];
        this.deepCopy().forEach((item: string, index: number) => {
            deepExpressions[index] = this.resultFormat(item);
        });
        this.inputValue = deepExpressions.join('');
    }
    /**
     * Input scientific symbols.
     *
     * @param value Scientific symbol.
     */
    inputScientificSymbol(value: string) {
        if (CheckEmptyUtil.isEmpty(value)) {
            return;
        }
        // In equation mode, handle comma and minus
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
        // Handle special constants
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
        // Handle equation mode
        if (value === '方程') {
            this.showEquationDialog();
            return;
        }
        // Handle x² (square)
        if (value === 'x²') {
            this.expressions.push('^');
            this.expressions.push('2');
            this.formatInputValue();
            this.getResult();
            return;
        }
        // Handle 1/x (reciprocal)
        if (value === '1/x') {
            this.expressions.unshift('1');
            this.expressions.push('÷');
            this.formatInputValue();
            this.getResult();
            return;
        }
        // Handle parentheses
        if (value === '(' || value === ')') {
            this.expressions.push(value);
            this.formatInputValue();
            return;
        }
        // For unary scientific operators (sin, cos, tan, log, ln, √)
        // These are prefix operators, so they should be added before the operand
        // But in our UI flow, user inputs number first, then clicks operator
        // So we need to apply the operator to the last number in expressions
        const unaryOperators = ['sin', 'cos', 'tan', 'log', 'ln', '√', '!'];
        if (unaryOperators.indexOf(value) !== -1) {
            let len = this.expressions.length;
            if (len > 0) {
                let last = this.expressions[len - 1];
                // If last element is a number, apply the operator
                if (!CalculateUtil.isSymbol(last) && !CalculateUtil.isScientificSymbol(last)) {
                    // For prefix operators like sin, cos, √, we need to insert operator before the number
                    // For postfix operators like !, we add after the number
                    if (value === '!') {
                        // Postfix operator (factorial)
                        this.expressions.push(value);
                    }
                    else {
                        // Prefix operator: insert before the last number
                        this.expressions.splice(len - 1, 0, value);
                    }
                    this.formatInputValue();
                    this.getResult();
                    return;
                }
            }
            // If no number before, just add the operator (user will input number next)
            this.expressions.push(value);
            this.formatInputValue();
            return;
        }
        // For binary operators like ^
        this.expressions.push(value);
        this.formatInputValue();
    }
    /**
     * Show equation solving dialog.
     */
    showEquationDialog() {
        // Toggle equation mode
        if (this.equationMode === '') {
            this.equationMode = 'quadratic';
            this.calValue = '方程模式：输入系数 a,b,c 解 ax²+bx+c=0';
            this.expressions = [];
            this.inputValue = '';
        }
        else {
            // Exit equation mode
            this.equationMode = '';
            this.calValue = '';
            this.expressions = [];
            this.inputValue = '';
        }
    }
    /**
     * Solve equation from input.
     */
    solveEquation() {
        // Get the input string
        let input = this.inputValue.trim();
        // Parse coefficients (separated by comma or space)
        let coefficients: string[];
        if (input.indexOf(',') !== -1) {
            coefficients = input.split(',');
        }
        else {
            coefficients = input.split(/\s+/);
        }
        // Trim each coefficient
        coefficients = coefficients.map(c => c.trim()).filter(c => c !== '');
        if (coefficients.length === 2) {
            // Linear equation: ax + b = 0
            let a = coefficients[0];
            let b = coefficients[1];
            this.calValue = CalculateUtil.solveLinearEquation(a, b);
        }
        else if (coefficients.length === 3) {
            // Quadratic equation: ax² + bx + c = 0
            let a = coefficients[0];
            let b = coefficients[1];
            let c = coefficients[2];
            this.calValue = CalculateUtil.solveQuadraticEquation(a, b, c);
        }
        else {
            this.calValue = '错误：请输入2个系数（一次方程）或3个系数（二次方程）';
        }
    }
    /**
     * Input fraction symbol (for fraction input mode)
     *
     * @param symbol Fraction symbol ('/' or ' ')
     */
    inputFractionSymbol(symbol: string) {
        // Add the symbol to input
        this.inputValue += symbol;
        this.expressions.push(symbol);
        this.formatInputValue();
        // Don't call getResult() here - wait for complete fraction input
        // The calculation will be triggered when user inputs the denominator
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "HomePage";
    }
}
registerNamedRoute(() => new HomePage(undefined, {}), "", { bundleName: "com.example.simplecalculator", moduleName: "entry", pagePath: "pages/HomePage", pageFullPath: "entry/src/main/ets/pages/HomePage", integratedHsp: "false", moduleType: "followWithHap" });
