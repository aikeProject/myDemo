<script setup lang="ts">
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-expect-error
import echarts from 'echarts/lib/echarts'
import useAudio from '~/composables/useAudio'
import useRequestAnimationFrame from '~/composables/useRequestAnimationFrame'
import { generateWaveData } from '~/pages/audio-sunburst/utils'
import 'echarts/lib/chart/sunburst'

const { onAudio, analyser, dataArray } = useAudio(2 ** 5)
const { loop, unLoop } = useRequestAnimationFrame()

const audio = ref<HTMLAudioElement>()
const main = ref<HTMLDivElement>()
const width = ref(`${window.innerWidth}px`)
const height = ref(`${window.innerHeight}px`)
const isPlay = ref(false)
const index = ref(0)

let myChart: any
const music = [
  '凯丽-夏天的风.mp3',
  '徐佳莹 - 喜欢你.mp3',
  '王贰浪 - 把回忆拼好给你.mp3',
  '许嵩,金莎 - 半城烟沙 (合唱版).mp3',
  'DJ阿福 - 草蜢-草蜢 - 半点心 (DJ_Afu Version Mix)（DJ阿福 (DJ-Afu) remix）.mp3',
]
const bgColor = '#2E2733'
const colors = ['#FFAE57', '#FF7853', '#EA5151', '#CC3F57', '#9A2555']
// const value = 1
const data: DataSource[] = [
  {
    children: [{
      children: [],
    }],
  },
  {
    children: [{
      children: [],
    }],
  },
]
for (let i = 0; i < 8; i++) {
  data[0].children[0].children.push({
    name: '-',
    // value: 1,
    children: [{
      name: '',
      value: 1,
      children: [],
    }],
  })
  data[1].children[0].children.push({
    name: '-',
    // value: 1,
    children: [{
      name: '',
      value: 1,
      children: [],
    }],
  })
}

const option = (seriesData: DataSource[]) => ({
  backgroundColor: bgColor,
  color: colors,
  // nodeClick: false,
  series: [{
    type: 'sunburst',
    center: ['50%', '50%'],
    data: seriesData,
    nodeClick: undefined,
    // label: {
    //   rotate: 0,
    // },
    // animation: false,
    // animationDuration: 0,
    // animationDurationUpdate: 0,
    // animationDurationUpdate: 100,
    // animationEasingUpdate: 'linear',
    sort(a: any, b: any) {
      if (a.depth === 1)
        return b.getValue() - a.getValue()
      else
        return a.dataIndex - b.dataIndex
    },
    itemStyle: {
      borderColor: bgColor,
      borderWidth: 2,
    },
    levels: [{}, {
      r0: 0,
      r: 40,
    }, {
      r0: 40,
      r: 105,
    }, {
      r0: 115,
      r: 140,
      itemStyle: {
        shadowBlur: 2,
        shadowColor: colors[2],
        color: 'transparent',
      },
      label: {
        rotate: 'tangential',
        fontSize: 10,
        color: colors[0],
      },
    }, {
      r0: 140,
      r: 145,
      itemStyle: {
        shadowBlur: 80,
        shadowColor: colors[0],
        color: colors[0],
      },
      label: {
        position: 'outside',
        textShadowBlur: 5,
        textShadowColor: '#333',
        backgroundColor: colors[0],
      },
    }],
  }],
})

const debouncedAnimate = useThrottleFn(() => {
  const _dataArray = dataArray.value
  analyser.value?.getByteFrequencyData(_dataArray)
  const _data = generateWaveData(data, _dataArray)
  myChart.setOption(option(_data))
}, 50)

const onLoadAudio = () => {
  if (!audio.value) return
  onAudio(audio.value)

  loop(debouncedAnimate)
}

const nextMusic = () => {
  if (index.value >= music.length - 1)
    index.value = 0
  else
    index.value += 1

  if (audio.value) {
    audio.value.src = music[index.value]
    audio.value.play()
  }
  onLoadAudio()
}

const playOrStop = () => {
  if (isPlay.value) {
    isPlay.value = false
    audio.value?.pause()
    unLoop()
  }
  else {
    isPlay.value = true
    audio.value?.play()
    onLoadAudio()
  }
}

const ended = () => {
  nextMusic()
}

onMounted(() => {
  if (!main.value) return
  myChart = echarts.init(main.value)
  myChart.setOption(option(data))
})
</script>

<template>
  <div>
    <div ref="main" :style="{ width, height }" />
    <div id="controls">
      <n-space>
        <n-button type="primary" :dashed="true" @click="playOrStop">{{ isPlay ? '暂停' : '播放' }}</n-button>
        <n-button type="primary" :dashed="true" @click="nextMusic">下一曲</n-button>
      </n-space>
    </div>
    <audio
      ref="audio"
      style="display: none"
      :src="music[0]"
      crossorigin="anonymous"
      @ended="ended"
    />
  </div>
</template>

<style scoped>
#controls {
  position: fixed;
  top: 30px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 1;
}
</style>
