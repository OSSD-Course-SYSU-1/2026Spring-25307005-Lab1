/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

export enum GameState {
  PLAYING,
  WON,
  LOST
}

export interface CellState {
  isMine: boolean;
  isRevealed: boolean;
  isFlagged: boolean;
  adjacentMines: number;
}

export class MinesweeperGame {
  private rows: number;
  private cols: number;
  public mineCount: number;
  private board: boolean[][]; // true = mine, false = empty
  private revealed: boolean[][];
  private flagged: boolean[][];
  private gameState: GameState = GameState.PLAYING;
  private firstClick: boolean = true;

  constructor(rows: number, cols: number, mineCount: number) {
    this.rows = rows;
    this.cols = cols;
    this.mineCount = mineCount;
    this.board = [];
    this.revealed = [];
    this.flagged = [];

    // 初始化空板
    for (let i = 0; i < rows; i++) {
      this.board[i] = [];
      this.revealed[i] = [];
      this.flagged[i] = [];
      for (let j = 0; j < cols; j++) {
        this.board[i][j] = false;
        this.revealed[i][j] = false;
        this.flagged[i][j] = false;
      }
    }
  }

  private placeMines(excludeRow: number, excludeCol: number): void {
    let placed = 0;
    while (placed < this.mineCount) {
      const row = Math.floor(Math.random() * this.rows);
      const col = Math.floor(Math.random() * this.cols);

      // 不在第一次点击的位置及其周围放置地雷
      const isExcluded = Math.abs(row - excludeRow) <= 1 && Math.abs(col - excludeCol) <= 1;

      if (!this.board[row][col] && !isExcluded) {
        this.board[row][col] = true;
        placed++;
      }
    }
  }

  private countAdjacentMines(row: number, col: number): number {
    let count = 0;
    for (let i = -1; i <= 1; i++) {
      for (let j = -1; j <= 1; j++) {
        const newRow = row + i;
        const newCol = col + j;
        if (newRow >= 0 && newRow < this.rows &&
            newCol >= 0 && newCol < this.cols &&
            this.board[newRow][newCol]) {
          count++;
        }
      }
    }
    return count;
  }

  reveal(row: number, col: number): GameState {
    if (this.gameState !== GameState.PLAYING) {
      return this.gameState;
    }

    if (row < 0 || row >= this.rows || col < 0 || col >= this.cols) {
      return this.gameState;
    }

    if (this.revealed[row][col] || this.flagged[row][col]) {
      return this.gameState;
    }

    // 第一次点击时放置地雷
    if (this.firstClick) {
      this.placeMines(row, col);
      this.firstClick = false;
    }

    this.revealed[row][col] = true;

    // 踩到地雷
    if (this.board[row][col]) {
      this.gameState = GameState.LOST;
      this.revealAllMines();
      return this.gameState;
    }

    // 如果周围没有地雷，自动展开
    if (this.countAdjacentMines(row, col) === 0) {
      for (let i = -1; i <= 1; i++) {
        for (let j = -1; j <= 1; j++) {
          this.reveal(row + i, col + j);
        }
      }
    }

    // 检查是否获胜
    if (this.checkWin()) {
      this.gameState = GameState.WON;
    }

    return this.gameState;
  }

  private revealAllMines(): void {
    for (let i = 0; i < this.rows; i++) {
      for (let j = 0; j < this.cols; j++) {
        if (this.board[i][j]) {
          this.revealed[i][j] = true;
        }
      }
    }
  }

  private checkWin(): boolean {
    for (let i = 0; i < this.rows; i++) {
      for (let j = 0; j < this.cols; j++) {
        // 如果有非地雷格子未揭开，则未获胜
        if (!this.board[i][j] && !this.revealed[i][j]) {
          return false;
        }
      }
    }
    return true;
  }

  toggleFlag(row: number, col: number): void {
    if (this.gameState !== GameState.PLAYING) {
      return;
    }

    if (row < 0 || row >= this.rows || col < 0 || col >= this.cols) {
      return;
    }

    if (this.revealed[row][col]) {
      return;
    }

    this.flagged[row][col] = !this.flagged[row][col];
  }

  getFlagCount(): number {
    let count = 0;
    for (let i = 0; i < this.rows; i++) {
      for (let j = 0; j < this.cols; j++) {
        if (this.flagged[i][j]) {
          count++;
        }
      }
    }
    return count;
  }

  getDisplayBoard(): CellState[][] {
    const display: CellState[][] = [];
    for (let i = 0; i < this.rows; i++) {
      display[i] = [];
      for (let j = 0; j < this.cols; j++) {
        display[i][j] = {
          isMine: this.board[i][j],
          isRevealed: this.revealed[i][j],
          isFlagged: this.flagged[i][j],
          adjacentMines: this.countAdjacentMines(i, j)
        };
      }
    }
    return display;
  }
}
