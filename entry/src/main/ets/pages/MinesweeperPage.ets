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

import { MinesweeperGame, CellState, GameState } from '../model/MinesweeperModel';

@Builder
export function MinesweeperPageBuilder() {
  MinesweeperPage()
}

@Component
export struct MinesweeperPage {
  @State game: MinesweeperGame = new MinesweeperGame(9, 9, 10);
  @State cells: CellState[][] = [];
  @State gameState: GameState = GameState.PLAYING;
  @State mineCount: number = 10;
  @State flagCount: number = 0;
  @State elapsedTime: number = 0;
  @State difficulty: number = 0; // 0: 简单, 1: 中等, 2: 困难
  private timer: number = -1;

  aboutToAppear(): void {
    this.initGame();
  }

  aboutToDisappear(): void {
    if (this.timer !== -1) {
      clearInterval(this.timer);
    }
  }

  initGame(): void {
    if (this.timer !== -1) {
      clearInterval(this.timer);
    }
    this.elapsedTime = 0;
    this.game = new MinesweeperGame(
      this.difficulty === 0 ? 9 : (this.difficulty === 1 ? 16 : 16),
      this.difficulty === 0 ? 9 : (this.difficulty === 1 ? 16 : 30),
      this.difficulty === 0 ? 10 : (this.difficulty === 1 ? 40 : 99)
    );
    this.mineCount = this.game.mineCount;
    this.cells = this.game.getDisplayBoard();
    this.gameState = GameState.PLAYING;
    this.flagCount = 0;
  }

  startTimer(): void {
    if (this.timer === -1) {
      this.timer = setInterval(() => {
        this.elapsedTime++;
      }, 1000);
    }
  }

  handleCellClick(row: number, col: number): void {
    if (this.gameState !== GameState.PLAYING) {
      return;
    }
    this.startTimer();
    const result = this.game.reveal(row, col);
    this.cells = this.game.getDisplayBoard();
    this.gameState = result;
  }

  handleCellLongPress(row: number, col: number): void {
    if (this.gameState !== GameState.PLAYING) {
      return;
    }
    this.startTimer();
    this.game.toggleFlag(row, col);
    this.cells = this.game.getDisplayBoard();
    this.flagCount = this.game.getFlagCount();
  }

  getCellColor(value: number): string {
    const colors: string[] = [
      '#0000FF', // 1 - 蓝色
      '#008000', // 2 - 绿色
      '#FF0000', // 3 - 红色
      '#000080', // 4 - 深蓝
      '#800000', // 5 - 深红
      '#008080', // 6 - 青色
      '#000000', // 7 - 黑色
      '#808080'  // 8 - 灰色
    ];
    return colors[value - 1] || '#000000';
  }

  @Builder
  cellBuilder(row: number, col: number) {
    Stack() {
      if (this.cells[row][col].isRevealed) {
        if (this.cells[row][col].isMine) {
          // 地雷
          Text('💣')
            .fontSize(this.difficulty === 0 ? 20 : 14)
        } else if (this.cells[row][col].adjacentMines > 0) {
          // 数字
          Text(`${this.cells[row][col].adjacentMines}`)
            .fontSize(this.difficulty === 0 ? 18 : 12)
            .fontColor(this.getCellColor(this.cells[row][col].adjacentMines))
            .fontWeight(FontWeight.Bold)
        }
      } else if (this.cells[row][col].isFlagged) {
        // 旗帜
        Text('🚩')
          .fontSize(this.difficulty === 0 ? 20 : 14)
      }
    }
    .width(this.difficulty === 0 ? 36 : (this.difficulty === 1 ? 24 : 20))
    .height(this.difficulty === 0 ? 36 : (this.difficulty === 1 ? 24 : 20))
    .backgroundColor(this.cells[row][col].isRevealed ?
      (this.cells[row][col].isMine ? '#FF6B6B' : '#E8E8E8') : '#C0C0C0')
    .border({
      width: 2,
      color: this.cells[row][col].isRevealed ? '#A0A0A0' : '#FFFFFF',
      style: BorderStyle.Solid
    })
    .alignContent(Alignment.Center)
    .onClick(() => this.handleCellClick(row, col))
    .gesture(
      LongPressGesture({ repeat: false })
        .onAction(() => this.handleCellLongPress(row, col))
    )
  }

  build() {
    NavDestination() {
      Column() {
        // 顶部信息栏
        Row() {
          // 地雷计数
          Row({ space: 4 }) {
            Text('💣')
              .fontSize(20)
            Text(`${this.mineCount - this.flagCount}`)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
          }
          .width('30%')
          .justifyContent(FlexAlign.Start)

          // 游戏状态/重置按钮
          Button() {
            Text(this.gameState === GameState.WON ? '😎' :
                 this.gameState === GameState.LOST ? '😵' : '🙂')
              .fontSize(24)
          }
          .width(50)
          .height(40)
          .backgroundColor('#FFD700')
          .onClick(() => this.initGame())

          // 计时器
          Row({ space: 4 }) {
            Text('⏱️')
              .fontSize(20)
            Text(`${this.elapsedTime}`)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
          }
          .width('30%')
          .justifyContent(FlexAlign.End)
        }
        .width('100%')
        .height(50)
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ left: 16, right: 16 })
        .backgroundColor('#F0F0F0')

        // 难度选择
        Row() {
          Button('简单')
            .fontSize(14)
            .backgroundColor(this.difficulty === 0 ? '#4CAF50' : '#E0E0E0')
            .fontColor(this.difficulty === 0 ? '#FFFFFF' : '#000000')
            .onClick(() => {
              this.difficulty = 0;
              this.initGame();
            })
          Button('中等')
            .fontSize(14)
            .backgroundColor(this.difficulty === 1 ? '#FF9800' : '#E0E0E0')
            .fontColor(this.difficulty === 1 ? '#FFFFFF' : '#000000')
            .onClick(() => {
              this.difficulty = 1;
              this.initGame();
            })
          Button('困难')
            .fontSize(14)
            .backgroundColor(this.difficulty === 2 ? '#F44336' : '#E0E0E0')
            .fontColor(this.difficulty === 2 ? '#FFFFFF' : '#000000')
            .onClick(() => {
              this.difficulty = 2;
              this.initGame();
            })
        }
        .width('100%')
        .height(50)
        .justifyContent(FlexAlign.SpaceEvenly)
        .backgroundColor('#F8F8F8')

        // 游戏区域
        Column() {
          ForEach(this.cells, (row: CellState[], rowIndex: number) => {
            Row() {
              ForEach(row, (cell: CellState, colIndex: number) => {
                this.cellBuilder(rowIndex, colIndex)
              }, (cell: CellState, colIndex: number) => `${rowIndex}-${colIndex}`)
            }
          }, (row: CellState[], rowIndex: number) => `${rowIndex}`)
        }
        .padding(8)
        .backgroundColor('#C0C0C0')

        // 游戏结果提示
        if (this.gameState !== GameState.PLAYING) {
          Column() {
            Text(this.gameState === GameState.WON ? '🎉 恭喜你赢了！' : '💥 游戏结束！')
              .fontSize(24)
              .fontColor(this.gameState === GameState.WON ? '#4CAF50' : '#F44336')
              .fontWeight(FontWeight.Bold)
            Text(`用时: ${this.elapsedTime} 秒`)
              .fontSize(16)
              .margin({ top: 8 })
            Button('再来一局')
              .margin({ top: 16 })
              .backgroundColor('#2196F3')
              .onClick(() => this.initGame())
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(8)
          .margin({ top: 16 })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')
    }
    .title('扫雷')
    .systemTransition(NavigationSystemTransitionType.SLIDE_RIGHT)
  }
}
