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

import { CommonConstants, Priority, SymbolicEnumeration } from '../constants/CommonConstants';
import CheckEmptyUtil from './CheckEmptyUtil';
import FractionUtil, { Fraction } from './FractionUtil';

class CalculateUtil {
  isSymbol(value: string) {
    if (CheckEmptyUtil.isEmpty(value)) {
      return;
    }
    return (CommonConstants.OPERATORS.indexOf(value) !== -1);
  }

  isScientificSymbol(value: string) {
    if (CheckEmptyUtil.isEmpty(value)) {
      return false;
    }
    return (CommonConstants.SCIENTIFIC_OPERATORS.indexOf(value) !== -1);
  }

  isFunctionOperator(value: string) {
    const functionOps = ['sin', 'cos', 'tan', 'log', 'ln', '√'];
    return functionOps.indexOf(value) !== -1;
  }

  getPriority(value: string): number {
    if (CheckEmptyUtil.isEmpty(value)) {
      return Priority.LOWEST;
    }
    let result = 0;
    switch (value) {
      case SymbolicEnumeration.ADD:
      case SymbolicEnumeration.MIN:
        result = Priority.LOW;
        break;
      case SymbolicEnumeration.MUL:
      case SymbolicEnumeration.DIV:
        result = Priority.MEDIUM;
        break;
      case SymbolicEnumeration.POW:
        result = Priority.HIGH;
        break;
      case SymbolicEnumeration.SIN:
      case SymbolicEnumeration.COS:
      case SymbolicEnumeration.TAN:
      case SymbolicEnumeration.LOG:
      case SymbolicEnumeration.LN:
      case SymbolicEnumeration.SQRT:
      case SymbolicEnumeration.FACT:
        result = Priority.HIGHEST;
        break;
      default:
        result = Priority.LOWEST;
        break;
    }
    return result;
  }

  comparePriority(arg1: string, arg2: string): boolean {
    if (CheckEmptyUtil.isEmpty(arg1) || CheckEmptyUtil.isEmpty(arg2)) {
      return false;
    }
    return (this.getPriority(arg1) <= this.getPriority(arg2));
  }

  parseExpression(expressions: Array<string>): string {
    if (CheckEmptyUtil.isEmpty(expressions)) {
      return 'NaN';
    }
    let len = expressions.length;
    let outputStack: string[] = [];
    let outputQueue: string[] = [];
    expressions.forEach((item: string, index: number) => {
      if (this.isFraction(item)) {
        const decimal = this.parseValue(item);
        expressions[index] = decimal.toString();
      }
      if (item.indexOf(CommonConstants.PERCENT_SIGN) !== -1) {
        expressions[index] = (this.mulOrDiv(item.slice(0, item.length - 1),
          CommonConstants.ONE_HUNDRED, CommonConstants.DIV)).toString();
      }
      if ((index === len - 1) && this.isSymbol(item)) {
        expressions.pop();
      }
    });
    while (expressions.length > 0) {
      let current: string | undefined = expressions.shift();
      if (current !== undefined) {
        if (this.isFunctionOperator(current)) {
          outputStack.push(current);
        } else if (current === '!') {
          outputQueue.push(current);
        } else if (this.isSymbol(current) || current === '^') {
          while (outputStack.length > 0 && this.comparePriority(current, outputStack[outputStack.length - 1])) {
            let popValue: string | undefined = outputStack.pop();
            if (popValue !== undefined) {
              outputQueue.push(popValue);
            }
          }
          outputStack.push(current);
        } else {
          outputQueue.push(current);
          while (outputStack.length > 0 && this.isFunctionOperator(outputStack[outputStack.length - 1])) {
            let popValue: string | undefined = outputStack.pop();
            if (popValue !== undefined) {
              outputQueue.push(popValue);
            }
          }
        }
      }
    }
    while (outputStack.length > 0) {
      let popValue: string | undefined = outputStack.pop();
      if (popValue !== undefined) {
        outputQueue.push(popValue);
      }
    }
    return this.dealQueue(outputQueue);
  }

  dealQueue(queue: Array<string>): string {
    if (CheckEmptyUtil.isEmpty(queue)) {
      return 'NaN';
    }
    let outputStack: string[] = [];
    while (queue.length > 0) {
      let current: string | undefined = queue.shift();
      if (current !== undefined) {
        if (!this.isSymbol(current) && !this.isScientificSymbol(current)) {
          outputStack.push(current);
        } else if (this.isFunctionOperator(current)) {
          let operand: string | undefined = outputStack.pop();
          if (operand !== undefined) {
            let result: number;
            switch (current) {
              case 'sin':
                result = this.sin(operand);
                break;
              case 'cos':
                result = this.cos(operand);
                break;
              case 'tan':
                result = this.tan(operand);
                break;
              case 'log':
                result = this.log(operand);
                break;
              case 'ln':
                result = this.ln(operand);
                break;
              case '√':
                result = this.sqrt(operand);
                break;
              default:
                result = Number.NaN;
                break;
            }
            outputStack.push(this.numberToScientificNotation(result));
          }
        } else if (current === '!') {
          let operand: string | undefined = outputStack.pop();
          if (operand !== undefined) {
            let result = this.factorial(operand);
            outputStack.push(this.numberToScientificNotation(result));
          }
        } else {
          let second: string | undefined = outputStack.pop();
          let first: string | undefined = outputStack.pop();
          if (first !== undefined && second !== undefined) {
            let calResultValue: string = this.calResult(first, second, current)
            outputStack.push(calResultValue);
          }
        }
      }
    }
    if (outputStack.length !== 1) {
      return 'NaN';
    } else {
      let end: string | undefined = outputStack[0];
      if (end === undefined || end === null) {
        return 'NaN';
      }
      if (end.endsWith(CommonConstants.DOTS)) {
        end = end.substring(0, end.length - 1);
      }
      return end;
    }
  }

  calResult(arg1: string, arg2: string, symbol: string): string {
    if (CheckEmptyUtil.isEmpty(arg1) || CheckEmptyUtil.isEmpty(arg2) || CheckEmptyUtil.isEmpty(symbol)) {
      return 'NaN';
    }
    let result = 0;
    switch (symbol) {
      case SymbolicEnumeration.ADD:
        result = this.add(arg1, arg2, CommonConstants.ADD);
        break;
      case SymbolicEnumeration.MIN:
        result = this.add(arg1, arg2, CommonConstants.MIN);
        break;
      case SymbolicEnumeration.MUL:
        result = this.mulOrDiv(arg1, arg2, CommonConstants.MUL);
        break;
      case SymbolicEnumeration.DIV:
        result = this.mulOrDiv(arg1, arg2, CommonConstants.DIV);
        break;
      case SymbolicEnumeration.POW:
        result = this.power(arg1, arg2);
        break;
      default:
        break;
    }
    return this.numberToScientificNotation(result);
  }

  add(arg1: string, arg2: string, symbol: string): number {
    let addFlag = (symbol === CommonConstants.ADD);
    if (this.containScientificNotation(arg1) || this.containScientificNotation(arg2)) {
      if (addFlag) {
        return Number(arg1) + Number(arg2);
      }
      return Number(arg1) - Number(arg2);
    }
    arg1 = (arg1 === CommonConstants.ZERO_DOTS) ? '0' : arg1;
    arg2 = (arg2 === CommonConstants.ZERO_DOTS) ? '0' : arg2;
    let leftArr = arg1.split(CommonConstants.DOTS);
    let rightArr = arg2.split(CommonConstants.DOTS);
    let leftLen = leftArr.length > 1 ? leftArr[1] : '';
    let rightLen = rightArr.length > 1 ? rightArr[1] : '';
    let maxLen = Math.max(leftLen.length, rightLen.length);
    let multiples = Math.pow(CommonConstants.TEN, maxLen);
    if (addFlag) {
      return Number(((Number(arg1) * multiples + Number(arg2) * multiples) / multiples).toFixed(maxLen));
    }
    return Number(((Number(arg1) * multiples - Number(arg2) * multiples) / multiples).toFixed(maxLen));
  }

  mulOrDiv(arg1: string, arg2: string, symbol: string): number {
    let mulFlag = (symbol === CommonConstants.MUL);
    if (this.containScientificNotation(arg1) || this.containScientificNotation(arg2)) {
      if (mulFlag) {
        return Number(arg1) * Number(arg2);
      }
      return Number(arg1) / Number(arg2);
    }
    let leftLen = arg1.split(CommonConstants.DOTS)[1] ? arg1.split(CommonConstants.DOTS)[1].length : 0;
    let rightLen = arg2.split(CommonConstants.DOTS)[1] ? arg2.split(CommonConstants.DOTS)[1].length : 0;
    if (mulFlag) {
      return Number(arg1.replace(CommonConstants.DOTS, '')) *
        Number(arg2.replace(CommonConstants.DOTS, '')) / Math.pow(CommonConstants.TEN, leftLen + rightLen);
    }
    return Number(arg1.replace(CommonConstants.DOTS, '')) /
      (Number(arg2.replace(CommonConstants.DOTS, '')) / Math.pow(CommonConstants.TEN, rightLen - leftLen));
  }

  containScientificNotation(arg: string) {
    return (arg.indexOf(CommonConstants.E) !== -1);
  }

  numberToScientificNotation(result: number) {
    if (result === Number.NEGATIVE_INFINITY || result === Number.POSITIVE_INFINITY) {
      return 'NaN';
    }
    if (Number.isNaN(result)) {
      return 'NaN';
    }
    let resultStr = JSON.stringify(result);
    if (this.containScientificNotation(resultStr)) {
      return resultStr;
    }
    let prefixNumber = (resultStr.indexOf(CommonConstants.MIN) === -1) ? 1 : -1;
    let absResult = Math.abs(result);
    if (resultStr.replace(CommonConstants.DOTS, '').replace(CommonConstants.MIN, '').length <
      CommonConstants.NUM_MAX_LEN) {
      return resultStr;
    }
    let suffix = (Math.floor(Math.log(absResult) / Math.LN10));
    let prefix = (absResult * Math.pow(CommonConstants.TEN, -suffix) * prefixNumber);
    return (prefix + CommonConstants.E + suffix);
  }

  power(base: string, exponent: string): number {
    let baseNum = Number(base);
    let expNum = Number(exponent);
    return Math.pow(baseNum, expNum);
  }

  sin(angle: string): number {
    return Math.sin(Number(angle));
  }

  cos(angle: string): number {
    return Math.cos(Number(angle));
  }

  tan(angle: string): number {
    return Math.tan(Number(angle));
  }

  log(value: string): number {
    let num = Number(value);
    if (num <= 0) {
      return Number.NaN;
    }
    return Math.log10(num);
  }

  ln(value: string): number {
    let num = Number(value);
    if (num <= 0) {
      return Number.NaN;
    }
    return Math.log(num);
  }

  sqrt(value: string): number {
    let num = Number(value);
    if (num < 0) {
      return Number.NaN;
    }
    return Math.sqrt(num);
  }

  factorial(value: string): number {
    let num = Number(value);
    if (num < 0 || !Number.isInteger(num)) {
      return Number.NaN;
    }
    if (num === 0 || num === 1) {
      return 1;
    }
    let result = 1;
    for (let i = 2; i <= num; i++) {
      result *= i;
    }
    return result;
  }

  solveLinearEquation(a: string, b: string): string {
    let aNum = Number(a);
    let bNum = Number(b);
    if (aNum === 0) {
      if (bNum === 0) {
        return '无穷多解';
      }
      return '无解';
    }
    let result = -bNum / aNum;
    return this.numberToScientificNotation(result);
  }

  solveQuadraticEquation(a: string, b: string, c: string): string {
    let aNum = Number(a);
    let bNum = Number(b);
    let cNum = Number(c);
    if (aNum === 0) {
      return this.solveLinearEquation(b, c);
    }
    let discriminant = bNum * bNum - 4 * aNum * cNum;
    if (discriminant < 0) {
      let realPart = -bNum / (2 * aNum);
      let imagPart = Math.sqrt(-discriminant) / (2 * aNum);
      return `x₁ = ${realPart.toFixed(4)} + ${imagPart.toFixed(4)}i, x₂ = ${realPart.toFixed(4)} - ${imagPart.toFixed(4)}i`;
    } else if (discriminant === 0) {
      let root = -bNum / (2 * aNum);
      return `x = ${root.toFixed(4)}`;
    } else {
      let root1 = (-bNum + Math.sqrt(discriminant)) / (2 * aNum);
      let root2 = (-bNum - Math.sqrt(discriminant)) / (2 * aNum);
      return `x₁ = ${root1.toFixed(4)}, x₂ = ${root2.toFixed(4)}`;
    }
  }

  isFraction(value: string): boolean {
    return FractionUtil.isFraction(value);
  }

  parseValue(value: string): number {
    if (this.isFraction(value)) {
      const fraction = FractionUtil.parseFraction(value);
      return FractionUtil.fractionToDecimal(fraction);
    }
    return Number(value);
  }

  numberToFraction(num: number): string {
    const fraction = FractionUtil.decimalToFraction(num);
    if (fraction.denominator <= 100) {
      return FractionUtil.fractionToString(fraction);
    }
    return num.toString();
  }
}

export default new CalculateUtil();
