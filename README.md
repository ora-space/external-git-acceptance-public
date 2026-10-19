# external-git-acceptance-public

外部 Git 线（circus#181、运行 circus#186）真实对端验收专用的**公开**测试仓库，与私有仓库
`ora-space/external-git-acceptance` 配套。

- **本仓库是公开的**，只放构造内容，不放任何真实数据、凭据或业务代码。
- 讨论和验收记录在 `ora-space/circus` 的 issue 里，不在本仓库开 issue。
- 仓库状态可以用 `scripts/reset-fixture.sh` 复位到 `fixture/*-baseline`。

## 对端用途

| 能力 | 方式 | 验证点 |
| --- | --- | --- |
| 公开仓库首次同步 | Binding 不带凭据，匿名同步默认分支 | `succeeded`；快照 ref 与跟踪 ref 指向 `main`；**没有任何凭据兑换记录** |
| publish 拒绝 | 用读写 token 直接推送受保护分支 `publish-protected` | 平台明确拒绝，发布 `rejected` |

## 分支与基线

| 分支 | 基线 tag | 说明 |
| --- | --- | --- |
| `main` | `fixture/main-baseline` | 默认分支，2 个提交的构造历史；匿名同步与快进发布的目标 |
| `publish-protected` | `fixture/publish-protected-baseline` | 受保护分支，直接推送被平台拒绝 |

## 保护规则

`publish-protected`：

- Require a pull request before merging；
- Include administrators（`enforce_admins`）；
- 禁止 force push 与删除分支。

因此这个分支只会被拒绝写入，内容固定，复位脚本不需要也不应该改它。
`main` 不设保护：匿名只读，读写 token 可以快进发布。

## 复位

在**新一次验收开始前**运行：

```bash
scripts/reset-fixture.sh
```

脚本只把 `main` 强制复位到 `fixture/main-baseline`；`publish-protected` 因受保护不可写，无需复位。
公开仓库的匿名同步不需要凭据；复位需要对该仓库有写权限的凭据（例如 `gh auth setup-git`，
或设置 `REPO_URL` / 用 `GH_TOKEN` 提供凭据）。

> 复位会改写 `main` 的历史；复位后请为验收新建 Project/Binding，不要在旧快照上继续。

## token

本仓库的匿名读取不需要 token。读写 token 作用于配套的私有仓库与本仓库，只用于受保护分支的拒绝场景；
只读 token 只作用于私有仓库。
token 明文不进入本仓库、issue、PR 或日志；交付和存放方式见 circus#241 与运行 circus#186。
