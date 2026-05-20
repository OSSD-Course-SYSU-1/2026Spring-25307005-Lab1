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
  /**
   * Determines whether it is an operator.
   *
   * @param value The symbol.
   * @return Is Operator.
   */
  isSymbol(value: string) {
    if (CheckEmptyUtil.isEmpty(value)) {
      return ;
    }
    return (CommonConstants.OPERATORS.indexOf(value) !== -1);
  }

  /**
   * Determines whether it is a scientific operator.
   *
   * @param value The symbol.
   * @return Is Scientific Operator.
   */
  isScientificSymbol(value: string) {
    if (CheckEmptyUtil.isEmpty(value)) {
      return false;
    }
    return (CommonConstants.SCIENTIFIC_OPERATORS.indexOf(value) !== -1);
  }

  /**
   * Determines whether it is a function operator (sin, cos, tan, log, ln, sqrt).
   *
   * @param value The symbol.
   * @return Is Function Operator.
   */
  isFunctionOperator(value: string) {
    const functionOps = ['sin', 'cos', 'tan', 'log', 'ln', '√'];
    return functionOps.indexOf(value) !== -1;
  }

  /**
   * Get Operator Precedence.
   *
   * @param value The symbol.
   * @return Priority.
   */
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

  /**
   * Determine the priority of addition, subtraction, multiplication, and division.
   *
   * @param arg1 Parameter 1.
   * @param arg2 Parameter 2.
   * @return Compare Priority Results.
   */
  comparePriority(arg1: string, arg2: string): boolean {
    if (CheckEmptyUtil.isEmpty(arg1) || CheckEmptyUtil.isEmpty(arg2)) {
      return false;
    }
    return (this.getPriority(arg1) <= this.getPriority(arg2));
  }

  /**
   * Expression Processing.
   *
   * @param expressions Expressions.
   */
  parseExpression(expressions: Array<string>): string {
    if (CheckEmptyUtil.isEmpty(expressions)) {
      return 'NaN';
    }
    let len = expressions.length;
    let outputStack: string[] = [];
    let outputQueue: string[] = [];
    
    // Pre-process: convert fractions to decimals and handle %
    expressions.forEach((item: string, index: number) => {
      // Handle fractions
      if (this.isFraction(item)) {
        const decimal = this.parseValue(item);
        expressions[index] = decimal.toString();
      }
      
      // Handle % in the expression
      if (item.indexOf(CommonConstants.PERCENT_SIGN) !== -1) {
        expressions[index] = (this.mulOrDiv(item.slice(0, item.length - 1),
          CommonConstants.ONE_HUNDRED, CommonConstants.DIV)).toString();
      }
      
      // Whether the last digit is an operator.
      if ((index === len - 1) && this.isSymbol(item)) {
        expressions.pop();
      }
    });
    
    while (expressions.length > 0) {
      let current: string | undefined = expressions.shift();
      if (current !== undefined) {
        // Check if it's a unary operator (prefix operators like sin, cos, √)
        if (this.isFunctionOperator(current)) {
          // For unary prefix operators, push to stack with special handling
          outputStack.push(current);
        } else if (current === '!') {
          // Factorial is a postfix unary operator, add directly to queue
          outputQueue.push(current);
        } else if (this.isSymbol(current) || current === '^') {
          // Processing binary operators.
          while (outputStack.length > 0 && this.comparePriority(current, outputStack[outputStack.length - 1])) {
            let popValue: string | undefined = outputStack.pop();
            if (popValue !== undefined) {
              outputQueue.push(popValue);
            }
          }
          outputStack.push(current);
        } else {
          // Processing the numbers.
          outputQueue.push(current);
          // After adding a number, check if there are unary operators in the stack
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

  /**
   * Processing expressions in queues.
   *
   * @param queue Expression Queue.
   * @return The end result.
   */
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
          // Handle unary scientific functions (sin, cos, tan, log, ln, sqrt)
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
          // Handle factorial
          let operand: string | undefined = outputStack.pop();
          if (operand !== undefined) {
            let result = this.factorial(operand);
            outputStack.push(this.numberToScientificNotation(result));
          }
        } else {
          // Handle binary operators
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

  /**
   * Calculation result.
   *
   * @param arg1 Number 1.
   * @param arg2 Number 2.
   * @param symbol Operators.
   * @return Calculation result.
   */
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

  /**
   * Addition and subtraction operation.
   *
   * @param arg1 Number 1.
   * @param arg2 Number 2.
   * @param symbol Operators.
   * @return Addition and subtraction results.
   */
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

  /**
   * multiplication and division operation.
   *
   * @param arg1 Number 1.
   * @param arg2 Number 2.
   * @param symbol Operators.
   * @return Multiply and divide result.
   */
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

  /**
   * Whether the operand contains scientific notation
   *
   * @param arg Number.
   * @return Whether scientific notation is included
   */
  containScientificNotation(arg: string) {
    return (arg.indexOf(CommonConstants.E) !== -1);
  }

  /**
   * Results converted to scientific notation.
   *
   * @param result Digital Results.
   */
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

  /**
   * Power operation (exponentiation).
   *
   * @param base Base number.
   * @param exponent Exponent.
   * @return Power result.
   */
  power(base: string, exponent: string): number {
    let baseNum = Number(base);
    let expNum = Number(exponent);
    return Math.pow(baseNum, expNum);
  }

  /**
   * Sine function.
   *
   * @param angle Angle in radians.
   * @return Sine value.
   */
  sin(angle: string): number {
    return Math.sin(Number(angle));
  }

  /**
   * Cosine function.
   *
   * @param angle Angle in radians.
   * @return Cosine value.
   */
  cos(angle: string): number {
    return Math.cos(Number(angle));
  }

  /**
   * Tangent function.
   *
   * @param angle Angle in radians.
   * @return Tangent value.
   */
  tan(angle: string): number {
    return Math.tan(Number(angle));
  }

  /**
   * Logarithm (base 10).
   *
   * @param value Input value.
   * @return Logarithm result.
   */
  log(value: string): number {
    let num = Number(value);
    if (num <= 0) {
      return Number.NaN;
    }
    return Math.log10(num);
  }

  /**
   * Natural logarithm (base e).
   *
   * @param value Input value.
   * @return Natural logarithm result.
   */
  ln(value: string): number {
    let num = Number(value);
    if (num <= 0) {
      return Number.NaN;
    }
    return Math.log(num);
  }

  /**
   * Square root.
   *
   * @param value Input value.
   * @return Square root result.
   */
  sqrt(value: string): number {
    let num = Number(value);
    if (num < 0) {
      return Number.NaN;
    }
    return Math.sqrt(num);
  }

  /**
   * Factorial.
   *
   * @param value Input value (must be non-negative integer).
   * @return Factorial result.
   */
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

  /**
   * Solve simple linear equation (ax + b = 0).
   *
   * @param a Coefficient of x.
   * @param b Constant term.
   * @return Solution x = -b/a.
   */
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

  /**
   * Solve quadratic equation (ax² + bx + c = 0).
   *
   * @param a Coefficient of x².
   * @param b Coefficient of x.
   * @param c Constant term.
   * @return Solutions as string.
   */
  solveQuadraticEquation(a: string, b: string, c: string): string {
    let aNum = Number(a);
    let bNum = Number(b);
    let cNum = Number(c);

    if (aNum === 0) {
      // Linear equation
      return this.solveLinearEquation(b, c);
    }

    let discriminant = bNum * bNum - 4 * aNum * cNum;

    if (discriminant < 0) {
      // Complex roots
      let realPart = -bNum / (2 * aNum);
      let imagPart = Math.sqrt(-discriminant) / (2 * aNum);
      return `x₁ = ${realPart.toFixed(4)} + ${imagPart.toFixed(4)}i, x₂ = ${realPart.toFixed(4)} - ${imagPart.toFixed(4)}i`;
    } else if (discriminant === 0) {
      // One real root
      let root = -bNum / (2 * aNum);
      return `x = ${root.toFixed(4)}`;
    } else {
      // Two real roots
      let root1 = (-bNum + Math.sqrt(discriminant)) / (2 * aNum);
      let root2 = (-bNum - Math.sqrt(discriminant)) / (2 * aNum);
      return `x₁ = ${root1.toFixed(4)}, x₂ = ${root2.toFixed(4)}`;
    }
  }

  /**
   * Check if a string is a fraction format (e.g., "3/4", "-5/6")
   *
   * @param value String to check
   * @return Whether it's a fraction
   */
  isFraction(value: string): boolean {
    return FractionUtil.isFraction(value);
  }

  /**
   * Parse a value that might be a fraction or decimal
   *
   * @param value Value string
   * @return Numeric value
   */
  parseValue(value: string): number {
    if (this.isFraction(value)) {
      const fraction = FractionUtil.parseFraction(value);
      return FractionUtil.fractionToDecimal(fraction);
    }
    return Number(value);
  }

  /**
   * Convert a number to fraction string if it's a simple fraction
   *
   * @param num Number to convert
   * @return Fraction string or decimal string
   */
  numberToFraction(num: number): string {
    const fraction = FractionUtil.decimalToFraction(num);
    // Only return fraction if denominator is reasonable
    if (fraction.denominator <= 100) {
      return FractionUtil.fractionToString(fraction);
    }
    return num.toString();
  }
}

export default new CalculateUtil();