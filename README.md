# sync-release-files
sync-release-files

<!-- 
org-release-sync/
├── .github/
│   └── workflows/
│       ├── sync-helm.yaml       # Helm 专属同步工作流
│       ├── sync-kubectl.yaml    # Kubectl 专属同步工作流
│       └── sync-go.yaml         # Go 专属同步工作流
├── common/                      # 公共函数库目录
│   └── commonlibs.sh            # 公共逻辑提取（依赖安装、日志输出、重试机制等）
└── scripts/                     # 各仓库专属同步脚本目录
    ├── sync-helm.sh             # Helm 专属脚本（含专属函数，source 公共库）
    ├── sync-kubectl.sh          # Kubectl 专属脚本
    └── sync-go.sh               # Go 专属脚本
-->
