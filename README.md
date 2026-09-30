# MySkills

AI Agent Skills 集合，包含 28 个技能包（`.agents/skills/`）。

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
| `.agents/skills/` | 28 个技能包的源目录 |

DSH 还会扫描 `<项目根>/.dsh/skills`（优先级高于 `.agents/skills`）和 `~/.dsh/skills`、`~/.agents/skills`。本仓库统一用 `.agents/skills/`，安装脚本也只写这一处——**别为了"保险"再往别的根目录放一份**，同名技能会由 DSH 裁决，出问题时很难查。

## 技能包列表

### 基础技能包(3 个)

| 技能包 | 用途 |
|--------|------|
| `drawio-skill` | draw.io 可编辑技术图 (v3.4.0) |
| `humanizer` | 去 AI 腔、学术与文案润色 (v3.1.0) |
| `installing-myskills` | 安装或更新整套 MySkills 到当前或指定目录 |

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

> 在 DSH(DeepSeek Harness) 里用这套 skill，先看 [DSH 速成](#dsh-速成3-分钟上手)：触发写法、每个技能照着念的例句、以及几个静默失败坑。

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
 ├─ 想做新功能/大改动 ──────► /grill-with-docs → /to-spec → /to-tickets → /implement
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

每个技能**照着念的原话**见 [DSH 速成 · 照着念](#照着念)。

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

- **敲了命令没反应?** 导演类那 14 个不会自动触发,必须显式敲。DSH 里手势只有 `/名字` 一种写法,`/` 后面必须跟真实存在的 skill 名,打错会被当普通文字(没有补全菜单)。见 [五个坑](#五个坑)。
- **spec 和票存哪了?** 由 setup 阶段的 `docs/agents/issue-tracker.md` 决定;GitHub repo 默认发 GitHub Issues(要装 `gh` CLI)。
- **`grilling` 能删吗?** 不能。它是 `grill-with-docs`、`triage`、`wayfinder`、`improve-codebase-architecture` 的内部引擎。
- **skill 行为不合口味?** 直接改 `.agents/skills/<name>/SKILL.md` —— MIT 许可,随便魔改。
- **要不要再装 Claude Code 插件?** 不要。文件已在本仓库,再装会出现每个 skill 两份。
- **升级怎么办?** 从上游对应 tag 重拉 `skills/engineering/`、`skills/productivity/` 覆盖同名目录(它们自包含,无外部依赖)。

## 使用约定

- 按任务需要加载最匹配的 skill，不设置 always-on skill。
- 只路由到 `.agents/skills/` 中实际存在的 skill。
- 可编辑技术图一律使用 `drawio-skill`（不再保留白板手绘风类 skill）。
- `grill-me` 是手动入口，使用时显式输入 `/grill-me`；`grilling` 是底层原语，可根据“压力测试方案”等语义自动触发。
- `grilling` 也是 `grill-with-docs`、`triage`、`wayfinder`、`improve-codebase-architecture` 的内部依赖，维护或分发时应保留两者。
- mattpocock/skills 的 user-invoked 技能用 `/skill-name` 方式触发；在某个 repo 里做工程工作前，先在该 repo 跑一次 `/setup-matt-pocock-skills`。
- `installing-myskills` 只安装整套 MySkills，不用于安装单个 skill 或其他仓库的 skill。

示例：

```text
/drawio-skill 画一张可编辑的系统架构图。
/grill-me 请压力测试这个方案。在我确认之前不要开始实现。
/installing-myskills 将整套 MySkills 安装到 /path/to/target。
```

## DSH 速成:3 分钟上手

本节只讲 DSH(DeepSeek Harness) 特有的部分——触发怎么写、每个技能照着念什么、哪里会静默失败。技能本身的用途看上面的[技能包列表](#技能包列表)。

### 触发机制

DSH 的 skill 插件会扫描你消息里**任何以空白分隔的 `/名字` 词元**，命中就注入那个 skill 的完整内容。所以：

- `/to-spec` 生效——不需要回车确认，它就是普通文本，混在句子里也行：`帮我 /to-spec 把刚才聊的定稿`
- `/名字` 只能指向真实存在的 user-invocable skill；写成 `$to-spec` 或写错名字，都静默当普通文字处理，**不报错**
- 没有补全菜单，名字得照下表敲
- 同一个 skill 在同一轮里敲多次只注入一次

另外一条路是直接说需求，让 agent 自己挑：`这个 bug 很怪，帮我查` → `diagnosing-bugs` 自动上线。这条路只对**不带 `disable-model-invocation` 的技能**有效，也就是下面第二张表。

### 照着念

下表 `触发` 一列就是你能直接粘进对话的原文。

**导演类:必须自己敲(14 个)**

| 技能 | 触发 | 干什么 |
|---|---|---|
| `setup-matt-pocock-skills` | `/setup-matt-pocock-skills` | **每个 repo 先跑一次**：配 tracker、triage 标签、领域文档位置 |
| `grill-with-docs` | `/grill-with-docs 我想给课程页加批量导入章节` | 疯狂追问 + 顺手沉淀 `CONTEXT.md` / ADR |
| `grill-me` | `/grill-me 我要不要把博客从 Hexo 迁到 Astro` | 只拷问，不落文档，适合不是代码的决策 |
| `to-spec` | `/to-spec` | 不再追问，纯合成：探仓库、画测试接缝、发 spec |
| `to-tickets` | `/to-tickets 142` | 拆成曳光弹竖切片 + 声明阻塞边 |
| `implement` | `/implement ①` | 施工：内部跑 `tdd`，收尾跑 `code-review`，然后 commit |
| `triage` | `/triage` | 用五角色状态机过一遍积压 issue |
| `wayfinder` | `/wayfinder 把整个后端换成事件驱动` | 大到单会话装不下时，拆成决策票地图 |
| `improve-codebase-architecture` | `/improve-codebase-architecture` | 扫"加深模块"机会，出可视化报告 |
| `to-questionnaire` | `/to-questionnaire 问老张要不要统一用 pnpm` | 把决策变成异步问卷发人 |
| `handoff` | `/handoff` | 会话太长时压缩成交接文档 |
| `teach` | `/teach 教我 Rust 的 lifetime` | 跨会话教学 |
| `wait-what` | `/wait-what` | 没看懂上一条，让它换角度重讲 |
| `ask-matt` | `/ask-matt 我该用哪个技能` | 不确定时的路由器 |

**工人类:agent 自己挂载(14 个)**

| 技能 | 触发 | 干什么 |
|---|---|---|
| `grilling` | `/grilling 压测这个方案` | 所有 grill 类的底层引擎（别删） |
| `tdd` | `按 TDD 来` | 红→绿→重构 |
| `diagnosing-bugs` | `这个 bug 反复修不好` | 复现→最小化→单假设→插桩→修→钉回归 |
| `code-review` | `/code-review` 或 `评审一下这个分支` | 标准 + spec 双轴并行评审 |
| `codebase-design` | `这个模块接口怎么设计` | 深模块设计词汇 |
| `domain-modeling` | `把"订单"和"订阅"的术语定下来` | 领域模型与术语 |
| `research` | `查一下 X 的官方说法` | 一手来源调研，落成带引用的 Markdown |
| `prototype` | `先做个原型看看手感` | 一次性原型回答设计问题 |
| `resolving-merge-conflicts` | `帮我解这个冲突` | 按意图逐 hunk 解决 |
| `wizard` | `/wizard 配一下 Stripe 密钥` | 生成交互式 bash 向导，走只有人能做的步骤 |
| `writing-for-agents` | `帮我写个 skill` | 写 skills / `AGENTS.md` 的方法论 |
| `drawio-skill` | `/drawio-skill 画系统架构图` | 可编辑 draw.io 图 |
| `humanizer` | `帮我把这段去 AI 腔` | 去 AI 写作痕迹 |
| `installing-myskills` | `/installing-myskills` | 安装整套 MySkills |

### 五个坑

1. **拼错静默失败**。`/to-specc` 不会报错，DSH 把它当普通文字。DSH 也没有 `/` 补全菜单，名字得照上表敲。
2. **skill 只在"项目根"生效**。DSH 按 `<项目根>/.dsh/skills` → `<项目根>/.agents/skills` → `~/.dsh/skills` → `~/.agents/skills` 的顺序扫描，**项目根取最近的含 `.git` 的祖先目录**。所以 `install.sh` 要装在你真正干活的那个 repo 里；换一个项目根就是另一套目录，装在别处的 skill 不会跟过来。
   - 好消息是**改完不用重启**：新增/改名/删除 skill 目录、或改 frontmatter，下一次调用就生效（本机实测）。只有 `references/`、`scripts/`、`assets/` 这类 bundle 内部资源的改动不触发刷新。
3. **同一套技能别装两遍**。四个根目录都在扫描范围内，两处同名会由 registry 按优先级裁决，排查起来很费劲。
4. **`office-docx` / `office-pptx` / `office-xlsx` 不在本仓库**。它们由 DSH 内置提供，本仓库不含，`install.sh` 也不会装。
5. **`~/.codex/skills/` 里可能还留着一份旧副本**。那是 Codex 的目录，DSH 不扫它，但两边内容不一致时会让人误判"改了没生效"。升级后记得对齐或删掉。

## 维护说明

- **改 skill 只改 `.agents/skills/`**。
- description 优先写 **何时触发**，少写流程摘要；`name` 必须与目录名一致。本仓库的 description 还可能被别家宿主读取，所以别在里面堆多行流程说明。
- 两个调用面字段的含义正好相反，别改错：
  - `disable-model-invocation: true` → 不进模型目录，agent 永远看不到，**只有人敲 `/名字` 能触发**（14 个导演类都是这个）。
  - `user-invocable: false` → 人敲 `/名字` 无效，**只有 agent 能调**。
  - 两个都省略 = 两边都能触发。本仓库不用这种默认态：导演/工人分工靠这两个字段显式区分。
- 那 14 个导演类的字段是刻意加的（来自上游），**不要为了"让 agent 自动调用"而删掉**：它们的价值就在于不抢戏。注意 DSH 里拦住自动调用的是 `disable-model-invocation`，本仓库没有 `user-invocable: false`。
- DSH 只解析 `name`、`description`、`whenToUse`、`metadata` 加上面两个调用面字段，**其余键一律忽略**。所以 `teach`、`handoff` 里的 `argument-hint`、部分 skill 的 `allowed-tools`，以及 `license`，在 DSH 里都不起作用（前两个是 Claude Code 的字段）。改成 `whenToUse` 只是让 DSH 认它，**不会**变出输入提示——DSH 的目录和加载结果都不渲染 `whenToUse`。
- 工具名应按宿主适配，不要写死过时工具名。
- mattpocock/skills 的 25 个技能包是上游 v1.2.3 的原样拷贝；升级时从上游对应 tag 重拉 `skills/engineering/`、`skills/productivity/` 覆盖同名目录即可（它们自包含，无外部依赖）。
