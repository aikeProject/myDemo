<script setup lang="ts">
// This starter template is using Vue 3 <script setup> SFCs
// Check out https://v3.vuejs.org/api/sfc-script-setup.html#sfc-script-setup
import useAudio from './useAudio'
import useRequestAnimationFrame from '~/composables/useRequestAnimationFrame'

const { onAudio, analyser, dataArray, bufferLength } = useAudio(2 ** 10)
const { loop, unLoop } = useRequestAnimationFrame()

const music = [
  '凯丽-夏天的风.mp3',
  '徐佳莹 - 喜欢你.mp3',
  '王贰浪 - 把回忆拼好给你.mp3',
  '许嵩,金莎 - 半城烟沙 (合唱版).mp3',
  'DJ阿福 - 草蜢-草蜢 - 半点心 (DJ_Afu Version Mix)（DJ阿福 (DJ-Afu) remix）.mp3',
]

const audio = ref<HTMLAudioElement>()
const canvas = ref<HTMLCanvasElement | null>(null)
const isPlay = ref(false)
const index = ref(0)

const onLoadAudio = () => {
  if (audio.value && canvas.value) {
    onAudio(audio.value)
    canvas.value.width = window.innerWidth
    canvas.value.height = window.innerHeight

    const ctx = canvas.value.getContext('2d')
    const WIDTH = canvas.value.width
    const HEIGHT = canvas.value.height

    const _bufferLength = bufferLength.value
    const _dataArray = dataArray.value

    const barWidth = WIDTH / _bufferLength * 1.5
    let barHeight

    loop(() => {
      analyser.value?.getByteFrequencyData(_dataArray)

      ctx?.clearRect(0, 0, WIDTH, HEIGHT)

      for (let i = 0, x = 0; i < _bufferLength; i++) {
        barHeight = _dataArray[i]

        const r = barHeight + 25 * (i / _bufferLength)
        const g = 250 * (i / _bufferLength)
        const b = 50

        ctx!.fillStyle = `rgb(${r},${g},${b})`
        ctx?.fillRect(x, HEIGHT - barHeight, barWidth, barHeight)

        x += barWidth + 2
      }
    })
  }
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
</script>

<template>
  <div>
    <canvas id="canvas" ref="canvas" />
    <audio
      ref="audio"
      :src="music[0]"
      crossorigin="anonymous"
      @ended="ended"
    />
    <div id="controls">
      <button class="text-sm btn px-5 py-2 mr-5" @click="playOrStop">
        {{ isPlay ? '暂停' : '播放' }}
      </button>
      <button class="text-sm btn px-5 py-2" @click="nextMusic">
        下一曲
      </button>
    </div>
  </div>
</template>

<style scoped>
#canvas {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: #121212;
}
#audio {
    display: none;
}
#controls {
    position: fixed;
    top: 30px;
    left: 50%;
    transform: translateX(-50%);
    z-index: 1;
}
</style>
