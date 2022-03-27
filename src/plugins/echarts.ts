import * as echarts from 'echarts/core'
import { SunburstChart } from 'echarts/charts'
import { CanvasRenderer } from 'echarts/renderers'

// 注册必须的组件
echarts.use([
  SunburstChart,
  CanvasRenderer,
])

export default echarts
