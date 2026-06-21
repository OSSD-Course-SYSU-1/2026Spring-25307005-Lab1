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

export interface Fraction {
  numerator: number;
  denominator: number;
}

class FractionUtil {
  createFraction(numerator: number, denominator: number): Fraction {
    if (denominator === 0) {
      const nanFraction: Fraction = { numerator: NaN, denominator: NaN };
      return nanFraction;
    }
    const result: Fraction = { numerator, denominator };
    return result;
  }

  gcd(a: number, b: number): number {
    a = Math.abs(a);
    b = Math.abs(b);
    while (b !== 0) {
      let temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }

  lcm(a: number, b: number): number {
    return Math.abs(a * b) / this.gcd(a, b);
  }

  simplify(fraction: Fraction): Fraction {
    if (isNaN(fraction.numerator) || isNaN(fraction.denominator)) {
      return fraction;
    }
    if (fraction.numerator === 0) {
      const zeroFraction: Fraction = { numerator: 0, denominator: 1 };
      return zeroFraction;
    }
    const gcdValue = this.gcd(fraction.numerator, fraction.denominator);
    let num = fraction.numerator / gcdValue;
    let den = fraction.denominator / gcdValue;
    if (den < 0) {
      num = -num;
      den = -den;
    }
    const result: Fraction = { numerator: num, denominator: den };
    return result;
  }

  add(f1: Fraction, f2: Fraction): Fraction {
    const commonDenominator = this.lcm(f1.denominator, f2.denominator);
    const numerator1 = f1.numerator * (commonDenominator / f1.denominator);
    const numerator2 = f2.numerator * (commonDenominator / f2.denominator);
    const sumFraction: Fraction = {
      numerator: numerator1 + numerator2,
      denominator: commonDenominator
    };
    return this.simplify(sumFraction);
  }

  subtract(f1: Fraction, f2: Fraction): Fraction {
    const commonDenominator = this.lcm(f1.denominator, f2.denominator);
    const numerator1 = f1.numerator * (commonDenominator / f1.denominator);
    const numerator2 = f2.numerator * (commonDenominator / f2.denominator);
    const diffFraction: Fraction = {
      numerator: numerator1 - numerator2,
      denominator: commonDenominator
    };
    return this.simplify(diffFraction);
  }

  multiply(f1: Fraction, f2: Fraction): Fraction {
    const productFraction: Fraction = {
      numerator: f1.numerator * f2.numerator,
      denominator: f1.denominator * f2.denominator
    };
    return this.simplify(productFraction);
  }

  divide(f1: Fraction, f2: Fraction): Fraction {
    if (f2.numerator === 0) {
      const nanFraction: Fraction = { numerator: NaN, denominator: NaN };
      return nanFraction;
    }
    const quotientFraction: Fraction = {
      numerator: f1.numerator * f2.denominator,
      denominator: f1.denominator * f2.numerator
    };
    return this.simplify(quotientFraction);
  }

  decimalToFraction(decimal: number, tolerance: number = 1e-10): Fraction {
    if (isNaN(decimal)) {
      const nanFraction: Fraction = { numerator: NaN, denominator: NaN };
      return nanFraction;
    }
    if (decimal === 0) {
      const zeroFraction: Fraction = { numerator: 0, denominator: 1 };
      return zeroFraction;
    }
    const isNegative = decimal < 0;
    decimal = Math.abs(decimal);
    if (Math.abs(decimal - Math.round(decimal)) < tolerance) {
      const intFraction: Fraction = {
        numerator: isNegative ? -Math.round(decimal) : Math.round(decimal),
        denominator: 1
      };
      return intFraction;
    }
    let h1 = 1, h2 = 0;
    let k1 = 0, k2 = 1;
    let b = decimal;
    for (let i = 0; i < 100; i++) {
      let a = Math.floor(b);
      let aux = h1;
      h1 = a * h1 + h2;
      h2 = aux;
      aux = k1;
      k1 = a * k1 + k2;
      k2 = aux;
      if (Math.abs(decimal - h1 / k1) < tolerance) {
        break;
      }
      b = 1 / (b - a);
    }
    const resultFraction: Fraction = {
      numerator: isNegative ? -h1 : h1,
      denominator: k1
    };
    return this.simplify(resultFraction);
  }

  fractionToDecimal(fraction: Fraction): number {
    if (isNaN(fraction.numerator) || isNaN(fraction.denominator) || fraction.denominator === 0) {
      return NaN;
    }
    return fraction.numerator / fraction.denominator;
  }

  parseFraction(str: string): Fraction {
    str = str.trim();
    if (str.indexOf('/') !== -1) {
      const parts = str.split('/');
      if (parts.length === 2) {
        const numerator = parseInt(parts[0].trim());
        const denominator = parseInt(parts[1].trim());
        if (!isNaN(numerator) && !isNaN(denominator)) {
          const parsedFraction: Fraction = { numerator, denominator };
          return this.simplify(parsedFraction);
        }
      }
    }
    const decimal = parseFloat(str);
    if (!isNaN(decimal)) {
      return this.decimalToFraction(decimal);
    }
    const nanFraction: Fraction = { numerator: NaN, denominator: NaN };
    return nanFraction;
  }

  fractionToString(fraction: Fraction): string {
    const simplified = this.simplify(fraction);
    if (isNaN(simplified.numerator) || isNaN(simplified.denominator)) {
      return 'NaN';
    }
    if (simplified.denominator === 1) {
      return simplified.numerator.toString();
    }
    return `${simplified.numerator}/${simplified.denominator}`;
  }

  toMixedNumber(fraction: Fraction): string {
    const simplified = this.simplify(fraction);
    if (isNaN(simplified.numerator) || isNaN(simplified.denominator)) {
      return 'NaN';
    }
    if (simplified.denominator === 1) {
      return simplified.numerator.toString();
    }
    const whole = Math.trunc(simplified.numerator / simplified.denominator);
    const remainder = Math.abs(simplified.numerator % simplified.denominator);
    if (whole === 0) {
      return `${simplified.numerator}/${simplified.denominator}`;
    }
    if (remainder === 0) {
      return whole.toString();
    }
    const sign = simplified.numerator < 0 ? '-' : '';
    return `${sign}${Math.abs(whole)} ${remainder}/${simplified.denominator}`;
  }

  isFraction(str: string): boolean {
    const fractionPattern = /^-?\d+\/\d+$/;
    return fractionPattern.test(str.trim());
  }

  power(fraction: Fraction, exponent: number): Fraction {
    if (!Number.isInteger(exponent)) {
      const decimal = this.fractionToDecimal(fraction);
      const result = Math.pow(decimal, exponent);
      return this.decimalToFraction(result);
    }
    if (exponent === 0) {
      const unitFraction: Fraction = { numerator: 1, denominator: 1 };
      return unitFraction;
    }
    if (exponent < 0) {
      const reciprocalFraction: Fraction = {
        numerator: fraction.denominator,
        denominator: fraction.numerator
      };
      const reciprocal = this.simplify(reciprocalFraction);
      return this.power(reciprocal, -exponent);
    }
    let result: Fraction = { numerator: 1, denominator: 1 };
    for (let i = 0; i < exponent; i++) {
      result = this.multiply(result, fraction);
    }
    return result;
  }
}

export default new FractionUtil();
