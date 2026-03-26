---
title: fGoogleSheet Claude Code Plugin
description: fGoogleSheet REST API를 활용하는 Claude Code 플러그인 사용 가이드 (한국어)
date: 2026-03-26
---

# 새 위치

fGoogleSheet Claude Code 플러그인은 통합 플러그인 레포지토리에서 관리됩니다:

* **레포지토리**: [Finfra/f-claude-plugins](https://github.com/Finfra/f-claude-plugins)
* **경로**: `fGoogleSheet/`

# 설치 방법

```
/plugin marketplace add Finfra/f-claude-plugins
/plugin install fgooglesheet@f-claude-plugins
```

# 수동 설치

```bash
git clone https://github.com/Finfra/f-claude-plugins.git
cp -r f-claude-plugins/fGoogleSheet/plugin.json .claude-plugin/plugin.json
cp -r f-claude-plugins/fGoogleSheet/skills .claude/skills
```
