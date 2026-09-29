# MySkills

AI Agent Skills 集合，包含 29 个技能包（`.agents/skills/`）。

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
| `.agents/skills/` | 29 个技能包的源目录 |

## 技能包列表

### 基础技能包(4 个)

| 技能包 | 用途 |
|--------|------|
| `drawio-skill` | draw.io 可编辑技术图 |
| `humanizer` | 去 AI 腔、学术与文案润色 |
| `installing-myskills` | 安装或更新整套 MySkills 到当前或指定目录 |
| `skill-creator` | 创建和更新 skill |

### mattpocock/skills 技能包(25 个,v1.2.3)

来自 [mattpocock/skills](https://github.com/mattpocock/skills) v1.2.3,采用 MIT License。

**Engineering(user-invoked,编排入口):**

| 技能包 | 用途 |
|--------|------|
| `ask-matt` | 不确定用哪个 skill 时的路由器 |
| `setup-matt-pocock-skills` | 每个 repo 先跑一次:配置 issue tracker、triage 标签、领域文档布局 |
| `grill-with-docs` | 拷问式访谈 + 沉淀领域语言(维护 `CONTEXT.md` 与 ADR) |
| `to-spec` | 把当前对话合成为 spec 并发布到 issue tracker |
| `to-tickets` | 把 plan/spec 拆成带阻塞关系的 tracer-bullet 票 |
| `implement` | 按 spec/票施工,驱动 `/tdd`,收尾跑 `/code-review` |
| `triage` | 用五角色状态机过 issue |
| `wayfinder` | 规划超出单会话容量的大工程,拆成决策票地图逐个解决 |
| `improve-codebase-architecture` | 扫码找"加深模块"机会,产出可视化 HTML 报告 |

**Engineering(model-invoked,agent 自动或手动调用):**

| 技能包 | 用途 |
|--------|------|
| `tdd` | 测试驱动开发,红绿重构循环 |
| `diagnosing-bugs` | 疑难 bug / 性能回归的纪律化诊断循环 |
| `code-review` | 标准 + spec 双轴并行评审 |
| `codebase-design` | 深模块设计词汇与分工 |
| `domain-modeling` | 维护领域模型、挑战术语、压力测试 |
| `prototype` | 一次性原型回答设计问题 |
| `research` | 高信任一手来源调研并落成带引用的 Markdown |
| `resolving-merge-conflicts` | 按意图逐 hunk 解决 merge/rebase 冲突 |
| `wizard` | 为只有人能完成的步骤生成交互式 bash 向导 |

**Productivity:**

| 技能包 | 用途 |
|--------|------|
| `grill-me` | 手动入口:对方案/设计做逆向拷问 |
| `grilling` | 所有 grill 类 skill 的底层通用访谈原语 |
| `handoff` | 会话压缩成交接文档 |
| `teach` | 跨会话技能教学 |
| `to-questionnaire` | 把决策变成异步问卷 |
| `wait-what` | 没看懂消息时让 agent 换角度重讲 |
| `writing-for-agents` | 给 agent 写文档(skills / AGENTS.md / CLAUDE.md)的方法论 |

`drawio-skill` 的部分内容来自 [Agents365-ai](https://github.com/Agents365-ai) 相关许可文件。

## 使用教程

### 全景地图:25 个 mattpocock skill 的分工

```
        你敲命令(user-invoked,14 个"导演")
        ┌──────────────────────────────────────────────────┐
        │ /grill-with-docs /grill-me   ← 把你问明白       │
        │ /to-spec /to-tickets /implement ← 定稿→拆→建    │
        │ /triage /wayfinder /improve-codebase-architecture│
        │ /to-questionnaire /handoff /teach /ask-matt      │
        │ /setup-matt-pocock-skills /wait-what             │
        └──────────────────┬───────────────────────────────┘
                           │ 内部调用
                           ▼
        agent 自动挂载(model-invoked,11 个"工人")
        ┌──────────────────────────────────────────────────┐
        │ /grilling /tdd /diagnosing-bugs /code-review     │
        │ /domain-modeling /codebase-design /research      │
        │ /prototype /resolving-merge-conflicts            │
        │ /wizard /writing-for-agents                      │
        └──────────────────────────────────────────────────┘
```

**一句话记住**:你敲的都是"导演",agent 自动挂载的都是"工人"。你只说"帮我 debug 这个报错",`/diagnosing-bugs` 自己就上线了。

### 第一次使用:5 分钟初始化

在你要干活的**项目仓库**里(不是 MySkills 仓库),敲:

```
/setup-matt-pocock-skills
```

它问三个问题,都带推荐答案,基本一路"好":

```
问题 1:issue tracker 放哪? ──► 推荐:GitHub(检测到 git remote 就会提议)
问题 2:triage 标签用默认五件套? ──► needs-triage → ready-for-agent → …
问题 3:领域文档放哪? ──► 根目录 CONTEXT.md + docs/adr/
```

**每个 repo 只跑一次**。之后所有工程 skill 都知道"issue 发到哪、标签叫什么、术语看哪份"。

### 主干工作流:做一件事的完整闭环

```
 你:"想给课程页加一个批量导入章节的功能"
   ▼
 ① /grill-with-docs ── 疯狂追问(每组带推荐答案),直到所有
 │                      分支都有着落;顺手沉淀 CONTEXT.md / ADR
   ▼
 ② /to-spec ────────── 不再追问,纯合成:探仓库、画测试接缝、
 │                      发 spec 到 tracker,打 ready-for-agent
   ▼
 ③ /to-tickets ─────── 拆成"曳光弹"竖切片:每张票贯穿
 │                      schema→API→UI→测试,单独可演示,
 │                      并声明阻塞边(谁完工谁才能开工)
   ▼
 ④ /implement ──────── 在约定接缝跑 /tdd(红→绿→重构),
                        收尾 /code-review 双轴评审,然后 commit
```

`/code-review` 在内部长这样(两路并行子代理,互不污染):

```
                 ┌── 轴 1「标准」:符合仓库编码规范吗?
一个 diff(基准)┤   + Fowler 坏味道基线
                 └── 轴 2「spec」:忠实实现了当初的 issue/spec 吗?
```

小改动可以只走 `grill → implement`;管线是自助餐,不是流水线监狱。

### 场景速查:我现在该敲什么?

```
 你现在的处境?
 │
 ├─ 想做新功能/大改动 ──────► grill-with-docs → to-spec → to-tickets → implement
 ├─ 有个 bug 反复修不好 ────► 直接描述现象(自动进 diagnosing-bugs)
 ├─ issue 一堆不知从哪下手 ► /triage
 ├─ 工程大到单会话装不下 ──► /wayfinder
 ├─ 总觉得代码在变烂 ──────► /improve-codebase-architecture(每隔几天一次)
 ├─ 不是代码:方案/决策 ───► /grill-me → /to-questionnaire
 ├─ 会话太长要换房间 ──────► /handoff
 ├─ 看不懂对方的话 ────────► /wait-what
 ├─ 只能人干的配置活 ──────► /wizard
 └─ 不知道用哪个 ───────────► /ask-matt
```

### 实战剧本

**剧本 A:加一个新功能(完整管线)**

```
 你: /grill-with-docs 我想给支付模块加退款单导出
 AI: Q1 退款单和已有 refund 记录什么关系? ➡ 推荐:同一实体的导出视图
     Q2 导出格式? ➡ 推荐:CSV,复用现有 exporter 接缝
 你: (逐条回答/纠偏)
 你: /to-spec        → AI 发 spec #142 到 GitHub Issues
 你: /to-tickets 142 → AI 给出 ①schema ②CSV生成器(阻塞①) ③admin路由(阻塞②)
 你: /implement ①    → AI TDD 循环 → 全量测试 → 双轴评审 → commit
```

**剧本 B:修一个诡异 bug(自动循环)**

你只需要描述现象,agent 会走这个纪律循环,不会瞎猜:

```
复现(让测试变红) → 最小化(缩到最小可复现样本)
       → 假设(一次一个) → 插桩验证(证据说话)
       → 修 → 回归测试(把这个坑钉死,不再复发)
```

**剧本 C:不是代码的事**

```
 你: /grill-me 我要不要把个人博客从 Hexo 迁到 Astro
 AI: (追问迁移成本、内容量、主题生态、你为什么想迁…)
 你: /to-questionnaire 把这个问题发给老张,他周三前填完
 AI: (生成 Markdown 问卷:背景、选项、要他回答什么)
 你: (会话太长?) /handoff 一键交接给新会话
```

### 节奏建议

| 频率 | 动作 |
|---|---|
| **每次改东西之前** | grill 类 skill — 全仓库最值钱的习惯 |
| **每个 repo 第一次** | `/setup-matt-pocock-skills` |
| **每天写码时** | `to-spec → to-tickets → implement` 管线 |
| **每隔几天** | `/improve-codebase-architecture` 扫"加深模块"的机会 |
| **issue 积压时** | `/triage` |

### 常见问题

- **敲了命令没反应?** user-invoked 的 14 个 skill 不会自动触发,必须显式敲;确认宿主前缀(`/` 或 `$`);新会话才会重扫 `.agents/skills/`。
- **spec 和票存哪了?** 由 setup 阶段的 `docs/agents/issue-tracker.md` 决定;GitHub repo 默认发 GitHub Issues(要装 `gh` CLI)。
- **`grilling` 能删吗?** 不能。它是 `grill-with-docs`、`triage`、`wayfinder`、`improve-codebase-architecture` 的内部引擎。
- **skill 行为不合口味?** 直接改 `.agents/skills/<name>/SKILL.md` —— MIT 许可,随便魔改。
- **要不要再装 Claude Code 插件?** 不要。文件已在本仓库,再装会出现每个 skill 两份。
- **升级怎么办?** 从上游对应 tag 重拉 `skills/engineering/`、`skills/productivity/` 覆盖同名目录(它们自包含,无外部依赖)。

## 使用约定

- 按任务需要加载最匹配的 skill，不设置 always-on skill。
- 只路由到 `.agents/skills/` 中实际存在的 skill。
- 可编辑技术图一律使用 `drawio-skill`（不再保留白板手绘风类 skill）。
- `grill-me` 是手动入口，使用时显式输入 `$grill-me`；`grilling` 是底层原语，可根据"压力测试方案"等语义自动触发。
- `grilling` 也是 `grill-with-docs`、`triage`、`wayfinder`、`improve-codebase-architecture` 的内部依赖，维护或分发时应保留两者。
- mattpocock/skills 的 user-invoked 技能用 `/skill-name` 方式触发；在某个 repo 里做工程工作前，先在该 repo 跑一次 `/setup-matt-pocock-skills`。
- `installing-myskills` 只安装整套 MySkills，不用于安装单个 skill 或其他仓库的 skill。

示例：

```text
$drawio-skill 画一张可编辑的系统架构图。
$grill-me 请压力测试这个方案。在我确认之前不要开始实现。
$installing-myskills 将整套 MySkills 安装到 /path/to/target。
```

## 维护说明

- **改 skill 只改 `.agents/skills/`**。
- description 优先写 **何时触发**，少写流程摘要；`name` 必须与目录名一致。
- 工具名应按宿主适配，不要写死过时工具名。
- mattpocock/skills 的 25 个技能包是上游 v1.2.3 的原样拷贝；升级时从上游对应 tag 重拉 `skills/engineering/`、`skills/productivity/` 覆盖同名目录即可（它们自包含，无外部依赖）。
