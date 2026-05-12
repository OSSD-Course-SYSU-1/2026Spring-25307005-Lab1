/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Logger from '../common/util/Logger';
import CalculateUtil from '../common/util/CalculateUtil';
import CheckEmptyUtil from '../common/util/CheckEmptyUtil';
import keysModel from '../viewmodel/PresskeysViewModel';
import { PressKeysBean } from '../viewmodel/PressKeysItem';
import { CommonConstants, Symbol } from '../common/constants/CommonConstants';

@Entry
@Component
struct HomePage {
  @State inputValue: string = '';
  @State calValue: string = '';
  @State isScientificMode: boolean = false;
  @State equationMode: string = ''; // 'linear' or 'quadratic'
  private expressions: Array<string> = [];

  build() {
    Column() {
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

      // Scientific mode toggle button
      Column() {
        Row() {
          Text(this.isScientificMode ? '标准模式' : '科学模式')
            .fontSize('14vp')
            .fontColor(Color.White)
        }
        .width(CommonConstants.FULL_PERCENT)
        .height('40vp')
        .backgroundColor('#4A90E2')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.isScientificMode = !this.isScientificMode;
        })
      }
      .width(CommonConstants.FULL_PERCENT)
      .margin({ bottom: '5vp' })

      // Scientific keys (shown when in scientific mode)
      if (this.isScientificMode) {
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
                  .width('60vp')
                  .height('35vp')
                  .borderWidth(1)
                  .borderColor($r('app.color.border_color'))
                  .borderRadius($r('app.float.border_radius'))
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
        .margin({ bottom: '5vp' })
      }

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
                    ((columnItemIndex === (keysModel.getPressKeys().length - 1)) &&
                      (keyItemIndex === (columnItem.length - 1))) ?
                      $r('app.float.equals_height') : $r('app.float.key_height')
                  )
                  .borderWidth(1)
                  .borderColor($r('app.color.border_color'))
                  .borderRadius($r('app.float.border_radius'))
                  .backgroundColor(
                    ((columnItemIndex === (keysModel.getPressKeys().length - 1)) &&
                      (keyItemIndex === (columnItem.length - 1))) ?
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
                  ((columnItemIndex === (keysModel.getPressKeys().length - 1)) &&
                    (keyItemIndex === (columnItem.length - 1))) ? CommonConstants.TWO : 1
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
    .height(CommonConstants.FULL_PERCENT)
    .backgroundColor($r('app.color.column_back_color'))
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
        this.equationMode = '';  // Exit equation mode
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
    // Check if last element is an operator (including scientific operators)
    let isLastOperator = CalculateUtil.isSymbol(last) || CalculateUtil.isScientificSymbol(last);

    if (!last) {
      this.expressions.push(value);
    } else if (isLastOperator) {
      // If last is an operator, push new number
      this.expressions.push(value);
    } else if (!secondLast) {
      // If no second last, append to last number
      this.expressions[len - 1] += value;
    } else {
      // Check if second last is an operator
      let isSecondLastOperator = CalculateUtil.isSymbol(secondLast) || CalculateUtil.isScientificSymbol(secondLast);
      if (isSecondLastOperator) {
        // Append to last number
        this.expressions[len - 1] += value;
      } else {
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
      this.calValue = this.resourceToString($r('app.string.error'));
      return false;
    }
    this.calValue = calResult;
    return true;
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
    } catch (error) {
      Logger.error('[CalculateModel] getResourceString fail: ' + JSON.stringify(error))
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
          } else {
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
    } else {
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
    } else {
      coefficients = input.split(/\s+/);
    }

    // Trim each coefficient
    coefficients = coefficients.map(c => c.trim()).filter(c => c !== '');

    if (coefficients.length === 2) {
      // Linear equation: ax + b = 0
      let a = coefficients[0];
      let b = coefficients[1];
      this.calValue = CalculateUtil.solveLinearEquation(a, b);
    } else if (coefficients.length === 3) {
      // Quadratic equation: ax² + bx + c = 0
      let a = coefficients[0];
      let b = coefficients[1];
      let c = coefficients[2];
      this.calValue = CalculateUtil.solveQuadraticEquation(a, b, c);
    } else {
      this.calValue = '错误：请输入2个系数（一次方程）或3个系数（二次方程）';
    }
  }
}