<script setup lang="ts">
// This starter template is using Vue 3 <script setup> SFCs
// Check out https://v3.vuejs.org/api/sfc-script-setup.html#sfc-script-setup
import { onMounted, ref } from 'vue'

const audio = ref<HTMLAudioElement | null>(null)
const canvas = ref<HTMLCanvasElement | null>(null)
let c: AudioContext

const onLoadAudio = () => {
  if (audio.value && canvas.value) {
    if (c) return
    const context = c = new AudioContext()
    const analyser = context.createAnalyser()
    analyser.fftSize = 512
    const source = context.createMediaElementSource(audio.value)

    source.connect(analyser)
    analyser.connect(context.destination)

    const bufferLength = analyser.frequencyBinCount
    const dataArray = new Uint8Array(bufferLength)

    canvas.value.width = window.innerWidth
    canvas.value.height = window.innerHeight

    const ctx = canvas.value.getContext('2d')
    const WIDTH = canvas.value.width
    const HEIGHT = canvas.value.height

    const barWidth = WIDTH / bufferLength * 1.5
    let barHeight

    function renderFrame() {
      requestAnimationFrame(renderFrame)

      analyser.getByteFrequencyData(dataArray)

      ctx?.clearRect(0, 0, WIDTH, HEIGHT)

      for (let i = 0, x = 0; i < bufferLength; i++) {
        barHeight = dataArray[i]

        const r = barHeight + 25 * (i / bufferLength)
        const g = 250 * (i / bufferLength)
        const b = 50

        ctx!.fillStyle = `rgb(${r},${g},${b})`
        ctx?.fillRect(x, HEIGHT - barHeight, barWidth, barHeight)

        x += barWidth + 2
      }
    }

    renderFrame()
  }
}

const play = () => {
  audio.value?.play()
  onLoadAudio()
}

const stop = () => {
  audio.value?.pause()
}

onMounted(() => {

})
</script>

<template>
  <div>
    <canvas id="canvas" ref="canvas" />
    <audio
      id="audio"
      ref="audio"
      controls
      src="//m8.music.126.net/21180815163607/04976f67866d4b4d11575ab418904467/ymusic/515a/5508/520b/f0cf47930abbbb0562c9ea61707c4c0b.mp3?infoId=92001"
      crossorigin="anonymous"
    />
    <div id="controls">
      <button class="text-sm btn px-5 py-2 mr-5" @click="play">
        播放
      </button>
      <button class="text-sm btn px-5 py-2" @click="stop">
        暂停
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
