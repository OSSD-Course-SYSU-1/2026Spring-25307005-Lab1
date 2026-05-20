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
/**
 * Fraction structure
 */
export interface Fraction {
    numerator: number; // Numerator
    denominator: number; // Denominator
}
/**
 * Fraction Utility Class
 * Used for fraction calculations and conversions
 */
class FractionUtil {
    /**
     * Create a fraction
     *
     * @param numerator Numerator
     * @param denominator Denominator
     * @return Fraction object
     */
    createFraction(numerator: number, denominator: number): Fraction {
        if (denominator === 0) {
            const nanFraction: Fraction = { numerator: NaN, denominator: NaN };
            return nanFraction;
        }
        const result: Fraction = { numerator, denominator };
        return result;
    }
    /**
     * Calculate greatest common divisor (GCD)
     *
     * @param a Number 1
     * @param b Number 2
     * @return GCD
     */
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
    /**
     * Calculate least common multiple (LCM)
     *
     * @param a Number 1
     * @param b Number 2
     * @return LCM
     */
    lcm(a: number, b: number): number {
        return Math.abs(a * b) / this.gcd(a, b);
    }
    /**
     * Simplify fraction
     *
     * @param fraction Fraction to simplify
     * @return Simplified fraction
     */
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
        // Ensure denominator is positive
        if (den < 0) {
            num = -num;
            den = -den;
        }
        const result: Fraction = { numerator: num, denominator: den };
        return result;
    }
    /**
     * Add two fractions
     *
     * @param f1 Fraction 1
     * @param f2 Fraction 2
     * @return Sum fraction
     */
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
    /**
     * Subtract two fractions
     *
     * @param f1 Fraction 1
     * @param f2 Fraction 2
     * @return Difference fraction
     */
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
    /**
     * Multiply two fractions
     *
     * @param f1 Fraction 1
     * @param f2 Fraction 2
     * @return Product fraction
     */
    multiply(f1: Fraction, f2: Fraction): Fraction {
        const productFraction: Fraction = {
            numerator: f1.numerator * f2.numerator,
            denominator: f1.denominator * f2.denominator
        };
        return this.simplify(productFraction);
    }
    /**
     * Divide two fractions
     *
     * @param f1 Fraction 1
     * @param f2 Fraction 2
     * @return Quotient fraction
     */
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
    /**
     * Convert decimal to fraction
     *
     * @param decimal Decimal number
     * @param tolerance Tolerance for conversion (default 1e-10)
     * @return Fraction
     */
    decimalToFraction(decimal: number, tolerance: number = 1e-10): Fraction {
        if (isNaN(decimal)) {
            const nanFraction: Fraction = { numerator: NaN, denominator: NaN };
            return nanFraction;
        }
        if (decimal === 0) {
            const zeroFraction: Fraction = { numerator: 0, denominator: 1 };
            return zeroFraction;
        }
        // Handle negative numbers
        const isNegative = decimal < 0;
        decimal = Math.abs(decimal);
        // Check if it's an integer
        if (Math.abs(decimal - Math.round(decimal)) < tolerance) {
            const intFraction: Fraction = {
                numerator: isNegative ? -Math.round(decimal) : Math.round(decimal),
                denominator: 1
            };
            return intFraction;
        }
        // Use continued fraction algorithm
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
    /**
     * Convert fraction to decimal
     *
     * @param fraction Fraction
     * @return Decimal number
     */
    fractionToDecimal(fraction: Fraction): number {
        if (isNaN(fraction.numerator) || isNaN(fraction.denominator) || fraction.denominator === 0) {
            return NaN;
        }
        return fraction.numerator / fraction.denominator;
    }
    /**
     * Parse fraction string (e.g., "3/4", "-5/6")
     *
     * @param str Fraction string
     * @return Fraction object
     */
    parseFraction(str: string): Fraction {
        str = str.trim();
        // Check if it's a fraction format
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
        // Try to parse as decimal
        const decimal = parseFloat(str);
        if (!isNaN(decimal)) {
            return this.decimalToFraction(decimal);
        }
        const nanFraction: Fraction = { numerator: NaN, denominator: NaN };
        return nanFraction;
    }
    /**
     * Convert fraction to string
     *
     * @param fraction Fraction
     * @return String representation
     */
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
    /**
     * Convert fraction to mixed number string (e.g., "1 1/2")
     *
     * @param fraction Fraction
     * @return Mixed number string
     */
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
    /**
     * Check if a string is a fraction format
     *
     * @param str String to check
     * @return Whether it's a fraction
     */
    isFraction(str: string): boolean {
        const fractionPattern = /^-?\d+\/\d+$/;
        return fractionPattern.test(str.trim());
    }
    /**
     * Power operation for fractions
     *
     * @param fraction Base fraction
     * @param exponent Exponent (integer)
     * @return Result fraction
     */
    power(fraction: Fraction, exponent: number): Fraction {
        if (!Number.isInteger(exponent)) {
            // For non-integer exponents, convert to decimal and back
            const decimal = this.fractionToDecimal(fraction);
            const result = Math.pow(decimal, exponent);
            return this.decimalToFraction(result);
        }
        if (exponent === 0) {
            const unitFraction: Fraction = { numerator: 1, denominator: 1 };
            return unitFraction;
        }
        if (exponent < 0) {
            // Negative exponent: reciprocal
            const reciprocalFraction: Fraction = {
                numerator: fraction.denominator,
                denominator: fraction.numerator
            };
            const reciprocal = this.simplify(reciprocalFraction);
            return this.power(reciprocal, -exponent);
        }
        // Positive exponent
        let result: Fraction = { numerator: 1, denominator: 1 };
        for (let i = 0; i < exponent; i++) {
            result = this.multiply(result, fraction);
        }
        return result;
    }
}
export default new FractionUtil();
