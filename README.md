# MySkills

AI Agent Skills 集合，包含 12 个技能包（`.agents/skills/`）。

当前目录下 skill 数量以 `.agents/skills/` 为准（安装脚本会打印实际数量）。

## 一键安装

在任何目录下运行以下命令，即可将 skills 下载到当前目录：

```bash
curl -fsSL https://raw.githubusercontent.com/zixuandai0217/MySkills/main/install.sh | bash
```

## 安装到指定目录

```bash
curl -fsSL https://raw.githubusercontent.com/zixuandai0217/MySkills/main/install.sh | bash -s -- "/path/to/target"
```

### 安装选项

| 环境变量 | 默认 | 说明 |
|---------|------|------|
| `BACKUP` | `1` | 覆盖前备份已有 `.agents` |

示例：

```bash
# 覆盖已有 .agents 时不创建备份
BACKUP=0 bash install.sh /path/to/project
```

## 工作原理

安装脚本通过 **一次 HTTP 请求** 下载整个仓库的 tarball 归档，本地解压后提取所需文件。无需调用 GitHub API，不受速率限制，通常 10 秒内即可完成安装。

- 仅需 `curl`（或 `wget`）+ `tar`，无其他依赖
- 内置失败重试（最多 3 次）
- 自动清理临时文件
- 安装脚本直接复制 `.agents/skills/`，并动态统计实际 skill 数量

## 安装内容

| 文件 | 说明 |
|------|------|
| `.agents/skills/` | 12 个技能包的源目录 |

## 技能包列表

| 技能包 | 用途 |
|--------|------|
| `docx` | Word 文档处理 |
| `drawio-skill` | draw.io 可编辑技术图 |
| `excalidraw-skill` | Excalidraw 白板、手绘风与轻量架构草图 |
| `frontend-design` | 生产级前端界面实现 |
| `grill-me` | 手动启动方案或设计压力测试 |
| `grilling` | 逐项追问计划、决策或想法中的关键分支 |
| `humanizer` | 去 AI 腔、学术与文案润色 |
| `installing-myskills` | 安装或更新整套 MySkills 到当前或指定目录 |
| `pdf` | PDF 文档处理 |
| `pptx` | PowerPoint 演示文稿处理 |
| `skill-creator` | 创建和更新 skill |
| `xlsx` | Excel 表格处理 |

`excalidraw-skill` 来自 [Agents365-ai/excalidraw-skill](https://github.com/Agents365-ai/excalidraw-skill) `v1.3.0`，采用 MIT License。

`grill-me` 和 `grilling` 来自 [mattpocock/skills](https://github.com/mattpocock/skills)，采用 MIT License。

## 使用约定

- 按任务需要加载最匹配的 skill，不设置 always-on skill。
- 只路由到 `.agents/skills/` 中实际存在的 skill。
- `excalidraw-skill` 用于可编辑 `.excalidraw`、白板、手绘风和轻量草图；精确 UML、品牌图标或高保真技术图使用 `drawio-skill`。
- `grill-me` 是手动入口，使用时显式输入 `$grill-me`。
- `grilling` 是实际执行追问的 skill，也可能根据"压力测试方案"等语义自动触发。
- `grill-me` 依赖 `grilling`，维护或分发时应保留两者。
- `installing-myskills` 只安装整套 MySkills，不用于安装单个 skill 或其他仓库的 skill。

示例：

```text
$excalidraw-skill 画一张可编辑的手绘风系统架构草图。
$grill-me 请压力测试这个方案。在我确认之前不要开始实现。
$installing-myskills 将整套 MySkills 安装到 /path/to/target。
```

## 维护说明

- **改 skill 只改 `.agents/skills/`**。
- description 优先写 **何时触发**，少写流程摘要；`name` 必须与目录名一致。
- 工具名应按宿主适配，不要写死过时工具名。
