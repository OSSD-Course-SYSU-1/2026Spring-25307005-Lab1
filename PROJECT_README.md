# IntentsKitGameRevisit 工程说明文档

## 项目概述

这是一个 **HarmonyOS 游戏推荐应用**，使用 ArkTS 开发。应用展示游戏列表，支持意图推荐功能，并包含可玩的扫雷小游戏。

---

## 目录结构

```
IntentsKitGameRevisit-master/
│
├── .arts/                          # Arts 配置目录
│   └── settings.json
│
├── .hvigor/                        # Hvigor 构建缓存
│   └── cache/
│
├── .idea/                          # IDE 配置目录
│
├── AppScope/                       # 应用全局作用域
│   └── app.json5                   # 应用配置
│
├── entry/                          # 主入口模块
│   └── src/main/
│       │
│       ├── ets/                    # ArkTS 源代码
│       │   │
│       │   ├── common/             # 公共模块
│       │   │   ├── constants/
│       │   │   │   └── CommonConstants.ets    # 全局常量定义
│       │   │   └── utils/
│       │   │       ├── FileReader.ets         # JSON文件读取工具
│       │   │       └── Logger.ets             # 日志工具
│       │   │
│       │   ├── entryability/       # 应用入口
│       │   │   └── EntryAbility.ets           # 主Ability，处理启动和意图
│       │   │
│       │   ├── entrybackupability/ # 备份恢复Ability
│       │   │   └── EntryBackupAbility.ets
│       │   │
│       │   ├── insightintents/     # 意图配置
│       │   │   └── InsightIntents.ets
│       │   │
│       │   ├── model/              # 数据模型层
│       │   │   ├── DataModel.ets              # 游戏信息接口定义
│       │   │   └── MinesweeperModel.ets       # 扫雷游戏逻辑模型 ⭐新增
│       │   │
│       │   └── pages/              # 页面组件
│       │       ├── Index.ets                  # 首页 - 游戏列表
│       │       ├── PlayPage.ets               # 游戏详情页
│       │       └── MinesweeperPage.ets        # 扫雷游戏页面 ⭐新增
│       │
│       ├── resources/              # 资源文件
│       │   │
│       │   ├── base/               # 基础资源（默认）
│       │   │   ├── element/
│       │   │   │   └── string.json            # 字符串资源
│       │   │   ├── media/
│       │   │   │   ├── background.png         # 背景图
│       │   │   │   ├── foreground.png         # 前景图
│       │   │   │   ├── startIcon.png          # 启动图标
│       │   │   │   ├── game1.PNG              # 游戏1缩略图
│       │   │   │   ├── game1_detail.png       # 游戏1详情图
│       │   │   │   ├── game2.PNG              # 游戏2缩略图
│       │   │   │   ├── game2_detail.png       # 游戏2详情图
│       │   │   │   ├── minesweeper.png        # 扫雷缩略图 ⭐新增
│       │   │   │   └── minesweeper_detail.png # 扫雷详情图 ⭐新增
│       │   │   └── profile/
│       │   │       └── main_pages.json        # 页面路由配置
│       │   │
│       │   ├── en_US/              # 英文资源
│       │   │   └── element/string.json
│       │   │
│       │   ├── zh_CN/              # 中文资源
│       │   │   └── element/string.json
│       │   │
│       │   ├── dark/               # 暗色主题资源
│       │   │   └── element/string.json
│       │   │
│       │   └── rawfile/            # 原始资源文件
│       │       ├── game.json                  # 游戏列表配置 ⭐已更新
│       │       ├── shareIntent.json           # 意图分享配置(中文)
│       │       └── shareIntent_en.json        # 意图分享配置(英文)
│       │
│       └── module.json5            # 模块配置文件
│
├── hvigor/                         # Hvigor 构建脚本
│   └── hvigor-config.json5
│
├── oh_modules/                     # OpenHarmony 依赖包
│
├── screenshots/                    # 应用截图
│   └── device/
│       ├── 1.png, 1_en.png         # 首页截图
│       ├── 2.png, 2_en.png         # 详情页截图
│       └── 3.png, 3_en.png         # 意图分享截图
│
├── .gitignore                      # Git 忽略配置
├── build-profile.json5             # 构建配置
├── code-linter.json5               # 代码检查配置
├── hvigorfile.ts                   # Hvigor 入口文件
├── oh-package.json5                # 包依赖配置
├── oh-package-lock.json5           # 依赖锁定文件
├── LICENSE                         # Apache 2.0 许可证
├── README.md                       # 项目说明(中文)
└── README.en.md                    # 项目说明(英文)
```

**⭐ 标记为本次新增/修改的内容**

---

## 模块功能介绍

### 1. 页面模块 (pages/)

| 文件 | 功能描述 |
|------|----------|
| `Index.ets` | 应用首页，展示游戏卡片列表，处理导航路由 |
| `PlayPage.ets` | 游戏详情页，显示游戏海报和意图分享状态 |
| `MinesweeperPage.ets` | 扫雷游戏页面，完整的可交互游戏界面 |

### 2. 数据模型 (model/)

| 文件 | 功能描述 |
|------|----------|
| `DataModel.ets` | 定义 `IGameInfo` 接口，包含游戏ID、名称、描述、图片等属性 |
| `MinesweeperModel.ets` | 扫雷游戏核心逻辑：地雷生成、格子揭开、胜负判定 |

### 3. 公共模块 (common/)

| 文件 | 功能描述 |
|------|----------|
| `CommonConstants.ets` | 全局常量：事件名、文件名、路径名、分享状态枚举 |
| `FileReader.ets` | 异步读取 rawfile 中的 JSON 配置文件 |
| `Logger.ets` | 统一日志输出工具 |

### 4. 入口模块 (entryability/)

| 文件 | 功能描述 |
|------|----------|
| `EntryAbility.ets` | 应用生命周期管理，处理冷启动和意图执行事件 |
| `EntryBackupAbility.ets` | 数据备份恢复功能 |

---

## 核心功能

### 1. 游戏列表展示
- 从 `game.json` 读取游戏配置
- 卡片式布局展示游戏缩略图、名称、描述
- 点击卡片跳转到对应游戏页面

### 2. 意图推荐 (InsightIntent)
- 支持 InsightIntent 意图分享功能
- 根据系统语言加载中/英文意图配置
- 显示分享状态：sharing / succeeded / failed

### 3. 扫雷游戏 ⭐新增

#### 游戏概述
扫雷是一款经典的单人益智游戏，目标是在不触雷的情况下，揭开所有非地雷的格子。

#### 三种难度模式
| 难度 | 网格大小 | 地雷数量 |
|------|----------|----------|
| 简单 | 9 × 9 | 10个 |
| 中等 | 16 × 16 | 40个 |
| 困难 | 16 × 30 | 99个 |

#### 游戏操作
- **点击格子**：揭开该格子
- **长按格子**：放置/取消旗帜标记（标记可疑地雷）

#### 游戏机制
- **首次点击安全**：第一次点击永远不会踩到地雷
- **自动展开**：揭开空白格子时，自动展开周围的安全区域
- **数字提示**：已揭开的格子显示周围8格内的地雷数量（1-8）
- **颜色区分**：不同数字用不同颜色显示，便于识别

#### 状态显示
- **地雷计数器**：显示剩余未标记的地雷数（总地雷数 - 已标记旗帜数）
- **计时器**：记录游戏用时（秒）
- **表情按钮**：显示游戏状态，点击可重新开始
  - 🙂 游戏进行中
  - 😎 游戏胜利
  - 😵 游戏失败

#### 游戏结果
- **胜利条件**：揭开所有非地雷格子
- **失败条件**：点击到地雷格子
- **结果提示**：显示胜负信息和用时，可快速重新开始

### 4. 国际化支持
- 支持中文/英文切换
- 资源文件按语言目录分离

---

## 配置文件说明

| 文件 | 说明 |
|------|------|
| `game.json` | 游戏列表配置，定义每个游戏的ID、名称、图片等 |
| `shareIntent.json` | 意图分享配置，定义可分享的意图实体 |
| `module.json5` | 模块配置，定义Ability、权限等 |

### game.json 配置示例
```json
{
  "id": "12949691",
  "displayName": "app.string.game_card_title_minesweeper",
  "fileName": "minesweeper.png",
  "description": "app.string.game_card_desc_minesweeper",
  "thumbnail": "app.media.minesweeper",
  "gamePoster": "app.media.minesweeper_detail"
}
```

---

## 技术栈

| 技术 | 说明 |
|------|------|
| 开发语言 | ArkTS (TypeScript 扩展) |
| UI框架 | ArkUI 声明式UI |
| 构建工具 | Hvigor |
| 目标平台 | HarmonyOS |

---

## 新增文件清单

本次开发新增以下文件：

1. **`entry/src/main/ets/pages/MinesweeperPage.ets`** - 扫雷游戏页面组件
2. **`entry/src/main/ets/model/MinesweeperModel.ets`** - 扫雷游戏逻辑模型
3. **`entry/src/main/resources/base/media/minesweeper.png`** - 扫雷游戏缩略图
4. **`entry/src/main/resources/base/media/minesweeper_detail.png`** - 扫雷游戏详情图

修改以下文件：

1. **`entry/src/main/resources/rawfile/game.json`** - 添加扫雷游戏配置
2. **`entry/src/main/resources/base/element/string.json`** - 添加扫雷字符串资源
3. **`entry/src/main/resources/zh_CN/element/string.json`** - 添加中文字符串
4. **`entry/src/main/resources/en_US/element/string.json`** - 添加英文字符串
5. **`entry/src/main/ets/pages/Index.ets`** - 注册扫雷页面路由

---

## 使用说明

1. 打开应用，首页显示游戏列表
2. 点击"扫雷"卡片进入游戏
3. 选择难度后开始游戏
4. 点击格子揭开，长按标记旗帜
5. 揭开所有非地雷格子即可获胜
