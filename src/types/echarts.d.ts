import type {
  // 系列类型的定义后缀都为 SeriesOption
  SunburstSeriesOption,
} from 'echarts/charts'
import type * as echarts from 'echarts/core'

declare global {
  // 通过 ComposeOption 来组合出一个只有必须组件和图表的 Option 类型
  type ECOption = echarts.ComposeOption<SunburstSeriesOption>
}
