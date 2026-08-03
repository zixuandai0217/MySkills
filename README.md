# MySkills

AI Agent Skills 集合，包含 8 个技能包（`.agents/skills/`）。

当前目录下 skill 数量以 `.agents/skills/` 为准（安装脚本会打印实际数量）。

## 一键安装

在任何目录下运行以下命令，即可将 skills 下载到当前目录：

```bash
curl -fsSL https://raw.githubusercontent.com/zixuandai0217/MySkills/main/install.sh | bash
```

## 安装到指定目录

```bash
curl -fsSL https://raw.githubusercontent.com/zixuandai0217/MySkills/main/install.sh | bash -s -- /path/to/target
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
| `.agents/skills/` | 8 个技能包的源目录 |

## 技能包列表

| 技能包 | 用途 |
|--------|------|
| `docx` | Word 文档处理 |
| `drawio-skill` | draw.io 可编辑技术图 |
| `frontend-design` | 生产级前端界面实现 |
| `humanizer` | 去 AI 腔、学术与文案润色 |
| `pdf` | PDF 文档处理 |
| `pptx` | PowerPoint 演示文稿处理 |
| `skill-creator` | 创建和更新 skill |
| `xlsx` | Excel 表格处理 |

## 使用约定

- 按任务需要加载最匹配的 skill，不设置 always-on skill。
- 只路由到 `.agents/skills/` 中实际存在的 skill。

## 维护说明

- **改 skill 只改 `.agents/skills/`**。
- description 优先写 **何时触发**，少写流程摘要；`name` 必须与目录名一致。
- 工具名应按宿主适配，不要写死过时工具名。
