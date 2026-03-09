## feature/parent-D 工作说明

1. 本分支完成了什么  
- **家长端主页（Parent Home）**：新增 `ParentHomePage`，展示当前 mock 绑定状态、待审批数量，并提供“活动审批”“安全功能”两个入口。  
- **活动审批流程闭环（仅基于 mock）**：  
  - 儿童端在 `ActivityPage` 点击“加入活动”会创建一条活动加入审批请求（pending），并在活动卡片上展示审批状态文案。  
  - 家长在 `ApprovalListPage` 中可以对待审批请求进行“同意/拒绝”操作，更新内存中的审批状态。  
  - 返回活动页后，根据同一活动 ID 读取审批状态，展示“已同意/已拒绝”等状态。  
- **安全功能演示页**：新增 `SafetyPage`，包含“定位共享”开关（仅演示，不做真实定位/权限）、紧急联系人信息展示和若干安全提示卡片。  
- **路由与导航接入**：在 `main.dart` 中增加 `/parent`、`/approval-list`、`/safety` 路由；在已有底部导航页面中增加“家长”入口，形成：首页 / 聊天 / 活动 / 家长 / 我的 的五栏导航结构。  

2. 新增了哪些文件  
- `lib/models/approval_request.dart`：审批请求模型，含 `ApprovalRequestType`、`ApprovalStatus` 枚举和 `ApprovalRequest` 实体。  
- `lib/models/mock_parent_data.dart`：家长端 mock 仓库，仅在内存中维护：  
  - `isBound`（当前是否 mock 绑定家长，默认 true）  
  - `locationSharingEnabled`（定位共享开关，仅演示）  
  - `approvalRequests`（活动加入审批请求列表）  
  - 方法：`createActivityRequest` / `approveRequest` / `rejectRequest` / `getStatusByActivityId` / `pendingCount`。  
- `lib/pages/parent_home_page.dart`：家长主页，展示绑定状态、待审批数量以及“活动审批”“安全功能”入口。  
- `lib/pages/approval_list_page.dart`：活动审批列表页，区分“待审批”和“已处理”两段列表，支持同步更新 mock 数据。  
- `lib/pages/safety_page.dart`：安全功能 demo 页，包含定位共享开关、紧急联系人展示和安全提示卡片。  

3. 修改了哪些已有文件  
- `lib/main.dart`  
  - 新增导入：`ParentHomePage` / `ApprovalListPage` / `SafetyPage`。  
  - 在 `routes` 中增加：`/parent`、`/approval-list`、`/safety` 三个路由，保留原有路由不变。  
- `lib/pages/home_page.dart`  
  - 保持原有好友推荐及列表逻辑不变，仅调整底部导航：  
    - 从 3 个 Tab 扩展为 5 个 Tab：`首页 / 聊天 / 活动 / 家长 / 我的`。  
    - `currentIndex` 设为 0。  
    - `onTap` 中新增 `/chat` 和 `/parent` 的跳转。  
- `lib/pages/activity_page.dart`  
  - 将 `ActivityPage` 由 `StatelessWidget` 改为 `StatefulWidget`，但仍然使用本地假活动列表 `_activities`，未引入后端数据。  
  - 新增引入 `mock_parent_data.dart` 与 `approval_request.dart`，将“加入活动”按钮接入 mock 审批流：  
    - 首次点击某活动的“加入活动”时，通过 `MockParentData.createActivityRequest` 创建 pending 请求，并弹出 SnackBar：“已发送家长确认”。  
    - 使用 `MockParentData.getStatusByActivityId` 读取当前活动的审批状态，在活动标题下方展示状态文案（待审批 / 已同意 / 已拒绝 / 尚未发起审批），颜色分别为橙/绿/红/灰。  
    - 按钮文案与可用状态随审批状态变化：  
      - 未申请且有名额：按钮为“加入活动”，可点击。  
      - pending：按钮为“等待审批”，禁用。  
      - approved：按钮为“已同意”，禁用。  
      - rejected：按钮为“已拒绝”，禁用（不做重新申请逻辑）。  
      - 无名额时统一显示“名额已满”，禁用。  
  - 调整底部导航为 5 个 Tab，并设置 `currentIndex = 2`，点击“家长”跳转 `/parent`。  
- `lib/pages/profile_page.dart`  
  - 将“家长设置”项的 `onTap` 改为 `Navigator.pushNamed(context, '/parent')`，实现最小接入。  
  - 对当前用户场景的 `BottomNavigationBar`：  
    - 从 3 个 Tab 扩展为 5 个 Tab（首页 / 聊天 / 活动 / 家长 / 我的），`currentIndex = 4`。  
    - 在 `onTap` 中新增 `/chat`、`/parent` 的跳转。  
  - 其它 UI 与交互保持不变，避免影响现有流程。  

4. 目前哪些仍然是 mock / demo  
- **所有家长相关数据均为内存 mock**：  
  - `MockParentData.isBound` 仅用于在家长主页展示“当前 mock 状态：已绑定”，没有真实绑定逻辑。  
  - `MockParentData.locationSharingEnabled` 仅驱动安全页上的开关文案，不做真实定位、不做权限请求。  
  - `MockParentData.approvalRequests` 仅在运行期内存存在，不做持久化，不与后端交互。  
- **活动数据仍为前端假数据**：`ActivityPage` 中 `_activities` 未改为仓库/后端数据，只是在 UI 层引用 `MockParentData` 获取审批状态。  
- **审批范围仅限活动**：  
  - `ApprovalRequestType` 目前只在结构上支持扩展；本分支实际只创建 `type == activity` 的请求。  
  - 未实现聊天/好友相关的审批逻辑。  
- **未实现完整绑定流程**：  
  - 未新增配对码、扫码等主绑定流程页面。  
  - 仅通过 `isBound = true` 的 mock 状态模拟“已经完成绑定”的前置条件，方便演示审批闭环。  

5. 后续和 feature/parent-H 合并时，建议如何对接  
- **绑定流程接入建议**  
  - 由 parent-H 分支实现真实的家长绑定流程与状态管理（含配对码 / 账号体系 / 登录鉴权等）。  
  - 可以将 `MockParentData.isBound` 替换为真实的绑定状态读取接口，家长主页的“当前绑定状态（Mock）”文案可根据真实数据调整为“已绑定 XXX 家长账号”等。  
  - 如需持久化定位开关和安全配置，可在 parent-H 中将 `MockParentData.locationSharingEnabled` 的角色升级为真实设置的默认值或临时占位，在后端/本地存储接入完成前保留该静态字段作为 fallback。  
- **审批数据模型与真实后端的映射**  
  - `ApprovalRequest` 已包含：`id` / `type` / `targetId` / `targetTitle` / `childName` / `status` / `createdAt`，基本可以映射到后端的审批实体。  
  - parent-H 可以：  
    - 复用 `ApprovalStatus` 与 `ApprovalRequestType` 的定义，保持前后端状态枚举一致。  
    - 用真实接口替换 `MockParentData` 中的内存列表操作（创建请求、状态更新、按 activityId 查询状态），在接口层维持同名方法，以减少对 UI 页面的改动。  
    - 考虑将 `MockParentData` 重构为接口 + 实现的形式：本分支当前实现可作为“本地 demo 实现”，parent-H 提供“远程实现”。  
- **页面与路由衔接**  
  - `/parent`、`/approval-list`、`/safety` 三个路由已在 `main.dart` 注册，且底部导航和“家长设置”入口都指向 `/parent`。  
  - 若 parent-H 需要拆分“家长登录/绑定向导页”和“家长首页”，建议：  
    - 保留 `/parent` 作为家长端主入口路由。  
    - 在 `/parent` 内部根据绑定/登录状态决定展示哪一套 UI：  
      - 未绑定：展示 H 分支实现的绑定流程页。  
      - 已绑定：展示本分支的家长主页（或其演进版本）。  
  - `ApprovalListPage` 与 `SafetyPage` 均为轻 UI 页，后续如需接真实数据，可直接在页面中调用新的仓库/接口层，无需改路由。  
- **合并策略与冲突控制**  
  - 本分支尽量只改动与 parent-D 强相关的文件，未触碰登录 / 兴趣选择 / 聊天逻辑，有利于降低与 parent-H 的冲突面。  
  - 建议在合并前：  
    - 以 `ApprovalRequest` 与 `MockParentData` 为基础，与 H 分支约定统一的“家长审批领域模型”。  
    - 由 H 分支在完成真实实现后，再统一替换 `MockParentData` 的内部逻辑，保持对 UI 层方法签名不变。  
    - 合并测试时重点回归以下路径：  
      - 儿童端：活动页“加入活动” → 生成审批请求。  
      - 家长端：查看审批列表 → 同意/拒绝 → 返回活动页查看状态。  
      - 家长端：安全页开关与提示展示是否正常。  

