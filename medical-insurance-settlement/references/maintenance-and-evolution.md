# 持续维护与演进

## 用途

本文件用于规定：以后每次使用本 skill 完成医保需求分析、代码阅读、代码修改、问题排查、规则对照时，如何把新知识写回 skill，并如何定期瘦身，避免内容膨胀。

## 总原则

这个 skill 不是一次性文档，而是持续演进的医保知识库。

每次使用后都要问两件事：

1. 我是否获得了新的医保知识？
2. 现有 skill 是否变得更臃肿、更重复、更难读了？

如果任一答案为“是”，就应更新 skill。

## 一、知识回写规则

### 哪些场景必须回写

- 需求分析发现了新规则
- 需求变更引入了新分支或新例外
- 阅读代码找到了真正的生效逻辑
- 修改代码时理清了原本模糊的规则
- 排查 bug 时发现了隐藏优先级、隐藏配置依赖
- 联调、测试、对账时发现了文档与实现不一致

### 哪些知识值得写回

- 参保类型与结算路径的对应关系
- 接口号、接口顺序、接口入参出参意义
- 上传字段和业务概念的映射关系
- 存储过程、数据库表、配置项来源
- 普通比例、特殊比例、病人特批比例之间的优先级
- 减负、高价药、限用、组套、双凭证、干保等特殊逻辑
- 冲正、撤销、改账、补传、重试、对账逻辑
- 应急切换规则
- 文档没有讲清、但代码已经确认的真实规则

### 写回时的可信度标记

如有必要，应在表述中明确标记来源：

- `文档明确`：来自需求文档、接口文档、制度说明
- `代码确认`：已从代码、SQL、配置调用关系中验证
- `推断`：根据现象、示例、上下文推断
- `未解决`：重要但还未确认

示例：
- `代码确认：五期上传金额在某服务中组装。`
- `文档明确：儿保住院结算为先本地计算，再上传。`
- `未解决：某院区人工关节组套一套/两套判断可能存在本地化差异。`

## 二、文件更新分工

### 更新 `core-concepts.md`

适用于：
- 核心金额概念更清晰了
- 通用公式更准确了
- 易混术语需要重新梳理

### 更新 `settlement-modes.md`

适用于：
- 新发现某类患者走不同路径
- 发现新的分流条件
- 发现新的容灾切换逻辑

### 更新 `upload-and-sync.md`

适用于：
- 新发现接口顺序
- 新确认上传时机
- 新发现前置机、FTP、Excel、DBF、轮询同步机制
- 新确认冲正、对账、补传流程

### 更新 `configurations-and-special-rules.md`

适用于：
- 新找到某类配置表、配置界面、配置来源
- 新确认某类特殊比例优先级
- 新发现特殊标志和特殊结算规则

### 更新 `examples-and-mapping.md`

适用于：
- 有更好的算例
- 字段映射更清晰了
- 新增高价值测试案例

### 更新 `SKILL.md`

适用于：
- skill 的使用范围发生变化
- 工作流需要调整
- 回写规则或瘦身规则需要加强

## 三、定期瘦身规则

### 瘦身触发条件

当出现以下任一情况时，应进行瘦身：

- 同一个概念在多个文件里重复展开
- 同一个规则写了多个近似版本
- 某个文件只是在不断追加，没有总结
- 某些历史补充已经能合并成更高层级规则
- 示例太多，但信息增量很低
- 某些内容只适用于单个项目，却污染了通用知识结构

### 瘦身动作

1. 合并重复规则。
2. 删除重复举例，只保留最代表性的一个。
3. 把同类零散条目整理成总规则 + 特例。
4. 把分散在多个文件中的同主题内容集中到最合适的位置。
5. 对长段堆砌内容做总结，抽象出稳定规律。
6. 对局部适用规则打标，避免被误解为通用规则。
7. 对过时、错误、已被新规则覆盖的内容做替换或收缩。

### 瘦身目标

瘦身后应满足：

- 同一知识点只保留一个主表达
- 结构比之前更清楚
- 术语口径更统一
- 新增内容不会明显拉低可读性
- 后续 agent 更容易快速定位高价值知识

## 四、最低维护清单

每次完成一个较实质性的任务后，至少检查：

1. 是否发现了新的业务规则？
2. 是否找到了新的代码入口、表、存储过程、字段、接口？
3. 是否发现了文档与代码不一致？
4. 是否出现了明显重复内容？
5. 是否可以把多个零散结论合并为更高层次的总结？

只要有一项成立，就应该更新或瘦身 skill。

## 五、当前已知缺口

这一段应长期维护，而不是每次重写。

- 生产环境中的最终计算规则可能仍依赖本地存储过程与医院个性化配置。
- 某些医保类型的精确分流条件可能因部署医院而异。
- 业务术语与代码变量、数据库字段之间的映射仍不完整。
- 混合结算路径的真实权威来源，可能更多在代码与 SQL，而不是文档。

## 六、后续优先补齐方向

后续优先沉淀这些内容：

1. 本地计算核心存储过程名称
2. 费别比例、特殊比例、病人特批比例对应的数据表
3. 国家医保上传组装代码入口
4. 上海五期上传组装代码入口
5. 双凭证汇总与封顶逻辑
6. 干保二次结算的实现入口
7. 对账、冲正、撤销、补传的实现路径
## 项目沉淀：`onelink-micro-insurance-sh-ybqpsq` 代码入口与维护关注点

以下内容为代码确认，适用于项目 `D:\ideaproject\onelink-micro-insurance-sh-ybqpsq`。

### 一、门诊主入口定位

- Web 统一入口：`onelink-micro-insurance-service/src/main/java/com/zoe/optimus/service/insur/web/InsuranceManageController.java`
- 控制器统一接口：`/api/insur/insurManager/insurInterface`
- 分发表：`InsurInterfaceFactoryService`
- 真实类与方法由 `InsurConfigDict` 动态决定，不是 controller 里写死某个上海类。

结论：
- 分析上海门诊接口时，先看 `insuranceMessage.insurCatalog + interfaceId + outpInpCode`。
- 然后再到 `InsurInterfaceFactoryService` / `InsurManageService.getInsurClassAndMethodCache(...)` 确认落到哪一个 `ShangHai*` 服务类。

### 二、当前项目中应优先关注的门诊类

原上海医保：
- `onelink-micro-insurance-service/src/main/java/com/zoe/optimus/service/insur/service/wonders/shangHai/ShangHaiInsuranceOutpService.java`
- `onelink-micro-insurance-service/src/main/java/com/zoe/optimus/service/insur/service/wonders/shangHai/ShangHaiInsurancePublicService.java`

国家医保上海：
- `onelink-micro-insurance-service/src/main/java/com/zoe/optimus/service/insur/service/nationalInsurance/shangHai/ShangHaiNationalInsuranceOutpService.java`
- `onelink-micro-insurance-service/src/main/java/com/zoe/optimus/service/insur/service/nationalInsurance/shangHai/ShangHaiNaitonalInsurancePublicService.java`

FCYY 独立版：
- `onelink-micro-insurance-service/src/main/java/com/zoe/optimus/service/insur/service/wonders/shangHaiFCYY/ShangHaiInsuranceOutpServiceFCYY.java`
- `onelink-micro-insurance-service/src/main/java/com/zoe/optimus/service/insur/service/nationalInsurance/shangHaiNationalFCYY/ShangHaiNationalInsuranceOutpServiceFCYY.java`

公共 DAO：
- `ShanghaiCommonDao`
- `ShanghaiInsuranceCommonDao`

### 三、这套项目里真实生效的维护关注点

- 原上海医保门诊预结算依赖费用缓存表 `CHA_OUTP_CHARGE_DETAIL_CACHE`，缓存不全时会回落主表 `CHA_OUTP_CHARGE_DETAIL`。
- 原上海医保门诊和 FCYY 版都会过滤数量小于 0 的退费明细，分析预结算差异时不要直接把前端传入 items 当最终上传集合。
- 国家医保上海门诊在预结算成功后，会额外往旧上海医保门诊结算主表写兼容数据；看到两套表同时有记录时，不要误判为重复结算。
- 国家医保 FCYY 的 `chargeDetailUploadV2` 有“明细重复则先撤销再重传”的补偿逻辑，这属于代码确认的真实行为。
- 国家医保 FCYY 存在 `rxyFlag=1` 的“自费转医保”分支，分析费用上传遗漏、结算金额不一致时必须先判断是否进入了该分支。
- FCYY 门诊流程普遍多一层 `outpApptRecordId` 预约状态校验，排查预挂号/预结算报错时要先排除预约状态问题。
- FCYY 国家医保的一码付逻辑与 `cardType=3`、`stasFlag`、自付金额是否大于 0 强相关，结算结果返回里可能追加支付凭证字段。

### 四、后续再分析上海门诊时的建议顺序

1. 先确认是原上海医保、国家医保，还是 FCYY 独立版。
2. 再确认是预挂号、挂号确认、预结算、结算确认中的哪一步。
3. 再看是否命中了病种上传、电子凭证、自费转医保、一码付、药品封顶这些本地特例。
4. 最后才看金额计算和落库表，避免一开始就在错误分支里追代码。
