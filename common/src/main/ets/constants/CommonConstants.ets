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
 * Common constants for all features.
 */
export class CommonConstants {
  static readonly FULL_PERCENT: string = '100%';
  static readonly OPERATORS: string = '+-×÷';
  static readonly OPERATORS_PRIORITY: string = '×÷';
  static readonly SCIENTIFIC_OPERATORS: string = 'sincostanlogln√^!';
  static readonly ADD: string = '+';
  static readonly MIN: string = '-';
  static readonly MUL: string = '×';
  static readonly DIV: string = '÷';
  static readonly PERCENT_SIGN: string = '%';
  static readonly DOTS: string = '.';
  static readonly TWO: number = 2;
  static readonly TEN: number = 10;
  static readonly ONE_HUNDRED: string = '100';
  static readonly INPUT_LENGTH_MAX: number = 9;
  static readonly INDEX_TWO: number = 2;
  static readonly NUM_MAX_LEN: number = 16;
  static readonly E: string = 'e';
  static readonly ZERO: string = '0';
  static readonly ZERO_DOTS: string = '0.';
  static readonly PI: number = Math.PI;
  static readonly EULER: number = Math.E;
}

/**
 * Symbol value.
 */
export enum Symbol {
  ADD = 'add',
  MIN = 'min',
  MUL = 'mul',
  DIV = 'div',
  CLEAN = 'clean',
  DEL = 'del',
  EQU = 'equ',
  SIN = 'sin',
  COS = 'cos',
  TAN = 'tan',
  LOG = 'log',
  LN = 'ln',
  SQRT = 'sqrt',
  POW = 'pow',
  FACT = 'fact',
  PI = 'pi',
  E = 'e',
  LEFT_PAREN = 'left_paren',
  RIGHT_PAREN = 'right_paren'
}

/**
 * Operator Precedence Enumeration.
 */
export enum Priority {
  HIGHEST = 4,
  HIGH = 3,
  MEDIUM = 2,
  LOW = 1,
  LOWEST = 0
}

/**
 * Enumerated value: addition, subtraction, multiplication, and division.
 */
export enum SymbolicEnumeration {
  ADD = '+',
  MIN = '-',
  MUL = '×',
  DIV = '÷',
  SIN = 'sin',
  COS = 'cos',
  TAN = 'tan',
  LOG = 'log',
  LN = 'ln',
  SQRT = '√',
  POW = '^',
  FACT = '!',
  LEFT_PAREN = '(',
  RIGHT_PAREN = ')'
}
