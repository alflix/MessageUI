### View：
- 气泡 Bubble
- 头像 Avatar
- 昵称 cellTopLabel
- 时间 messageTopLabel
- 内容 MessageContainner
- 发送失败/语音未读 accessoryView

### 内容

#### 通用：
- 文字+高亮检测（可选）
- 图片
- 视频+时长（可选）
- 语音：播放按钮+时长+进度条（可选）
- 位置：地图+标题（可选）+副标题（可选）

#### 需要自定义：
- 公告
- app 内链接
- 名片
- 红包/转账

Protocol:
配置图片，url，时长

Delegate：
定义字体，尺寸

DataSource：


为什么用 Frame？
用 AutoLayout 无法适用左右2边的不同布局，或可用，但每次 Render 都需要刷新，性能差



