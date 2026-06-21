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

export interface HistoryItem {
  expression: string;
  result: string;
  timestamp: number;
}

class HistoryManager {
  private history: Array<HistoryItem> = [];
  private maxHistorySize: number = 100;

  addHistory(expression: string, result: string): void {
    if (!expression || !result) {
      return;
    }
    if (result === 'NaN' || result === '错误') {
      return;
    }
    const item: HistoryItem = {
      expression: expression,
      result: result,
      timestamp: Date.now()
    };
    this.history.unshift(item);
    if (this.history.length > this.maxHistorySize) {
      this.history.pop();
    }
  }

  getHistory(): Array<HistoryItem> {
    return this.history;
  }

  clearHistory(): void {
    this.history = [];
  }

  deleteHistory(index: number): void {
    if (index >= 0 && index < this.history.length) {
      this.history.splice(index, 1);
    }
  }

  getRecentHistory(count: number): Array<HistoryItem> {
    return this.history.slice(0, Math.min(count, this.history.length));
  }

  searchHistory(keyword: string): Array<HistoryItem> {
    if (!keyword) {
      return this.history;
    }
    return this.history.filter(item =>
      item.expression.indexOf(keyword) !== -1 ||
      item.result.indexOf(keyword) !== -1
    );
  }

  formatTime(timestamp: number): string {
    const date = new Date(timestamp);
    const year = date.getFullYear();
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const day = date.getDate().toString().padStart(2, '0');
    const hour = date.getHours().toString().padStart(2, '0');
    const minute = date.getMinutes().toString().padStart(2, '0');
    const second = date.getSeconds().toString().padStart(2, '0');
    return `${year}-${month}-${day} ${hour}:${minute}:${second}`;
  }
}

export default new HistoryManager();
