# FinOptimizationAppStore

**FinOptimizationAppStore** 是一个面向金融优化应用的集中式管理/展示平台（或应用商店原型）。旨在帮助用户快速发现、部署和使用各类金融领域的优化工具，包括资产配置、风险平价、投资组合回测等。

## ✨ 主要特性

- 📊 **金融优化算法集合** – 提供均值-方差优化、Black-Litterman 模型、风险预算、CVaR 优化等。
- 🧩 **模块化应用商店** – 每个优化工具作为独立“应用”展示，支持动态加载。
- 📈 **可视化对比** – 一键绘制有效前沿、权重构成、风险贡献图。
- ⚙️ **参数配置界面** – 通过 Web 表单或 YAML/JSON 文件自定义优化约束。
- 🚀 **REST API 支持** – 所有优化引擎均可通过 API 调用，便于集成到已有系统。
- 📦 **Docker 一键启动** – 简化部署流程。

## 🛠 技术栈

| 组件          | 技术选型                      |
|---------------|-------------------------------|
| 后端框架      | FastAPI / Python 3.10+        |
| 优化计算库    | SciPy, CVXPY, PyPortfolioOpt |
| 前端展示      | React + Ant Design / Vue 3    |
| 数据持久化    | SQLite + Redis (缓存)         |
| 部署          | Docker + Nginx                |

## 📥 安装与运行

### 1. 克隆仓库
```bash
git clone https://github.com/yourusername/FinOptimizationAppStore.git
cd FinOptimizationAppStore
```

### 2. 使用 Docker（推荐）
```bash
docker-compose up -d
```
访问 `http://localhost:3000` 进入前端界面，API 文档位于 `http://localhost:8000/docs`

### 3. 本地开发运行
**后端**
```bash
cd backend
pip install -r requirements.txt
uvicorn main:app --reload --port 8000
```

**前端**（若包含）
```bash
cd frontend
npm install
npm start
```

## 📚 使用示例

### 通过 Web 界面
1. 在“应用商店”中选择一个优化器（例如“最小 CVaR 优化”）
2. 上传或输入资产历史收益率数据（CSV 格式）
3. 设置约束（无卖空、行业上限等）
4. 运行优化，查看结果权重饼图及绩效指标

### 通过 API 调用
```python
import requests

response = requests.post(
    "http://localhost:8000/optimize/mean_variance",
    json={
        "returns": [0.12, 0.15, 0.08],
        "cov_matrix": [[0.1, 0.02, 0.01], [0.02, 0.2, 0.03], [0.01, 0.03, 0.15]],
        "risk_aversion": 2.5
    }
)
print(response.json()["weights"])
```

## 🗂 目录结构
```
FinOptimizationAppStore/
├── backend/                 # FastAPI 后端
│   ├── optimizers/          # 各优化算法实现
│   ├── models/              # 数据模型
│   ├── routes/              # API 路由
│   └── requirements.txt
├── frontend/                # React/Vue 前端
│   ├── src/
│   └── public/
├── docker-compose.yml
├── README.md
└── LICENSE
```

## 🤝 贡献指南

欢迎提交 Issue 或 Pull Request。请确保：
- 新优化算法附带单元测试（`tests/` 目录）
- 更新 API 文档字符串
- 遵守 PEP 8 代码风格

## 📄 许可证

[MIT](LICENSE)
