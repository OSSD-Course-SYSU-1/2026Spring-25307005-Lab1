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
 * History record item
 */
export interface HistoryItem {
  expression: string;  // Original expression
  result: string;      // Calculation result
  timestamp: number;   // Time stamp
}

/**
 * History Manager
 * Used to manage calculation history records
 */
class HistoryManager {
  private history: Array<HistoryItem> = [];
  private maxHistorySize: number = 100; // Maximum history records

  /**
   * Add a history record
   *
   * @param expression Calculation expression
   * @param result Calculation result
   */
  addHistory(expression: string, result: string): void {
    if (!expression || !result) {
      return;
    }

    // Don't add if result is error
    if (result === 'NaN' || result === '错误') {
      return;
    }

    const item: HistoryItem = {
      expression: expression,
      result: result,
      timestamp: Date.now()
    };

    this.history.unshift(item); // Add to the beginning

    // Limit history size
    if (this.history.length > this.maxHistorySize) {
      this.history.pop();
    }
  }

  /**
   * Get all history records
   *
   * @return History records array
   */
  getHistory(): Array<HistoryItem> {
    return this.history;
  }

  /**
   * Clear all history records
   */
  clearHistory(): void {
    this.history = [];
  }

  /**
   * Delete a specific history record
   *
   * @param index Index of the record to delete
   */
  deleteHistory(index: number): void {
    if (index >= 0 && index < this.history.length) {
      this.history.splice(index, 1);
    }
  }

  /**
   * Get recent N history records
   *
   * @param count Number of records to get
   * @return Recent history records
   */
  getRecentHistory(count: number): Array<HistoryItem> {
    return this.history.slice(0, Math.min(count, this.history.length));
  }

  /**
   * Search history records by expression
   *
   * @param keyword Search keyword
   * @return Matching history records
   */
  searchHistory(keyword: string): Array<HistoryItem> {
    if (!keyword) {
      return this.history;
    }

    return this.history.filter(item => 
      item.expression.indexOf(keyword) !== -1 || 
      item.result.indexOf(keyword) !== -1
    );
  }

  /**
   * Format timestamp to readable string
   *
   * @param timestamp Timestamp
   * @return Formatted time string
   */
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
