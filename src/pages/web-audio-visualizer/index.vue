<script setup lang="ts">
// This starter template is using Vue 3 <script setup> SFCs
// Check out https://v3.vuejs.org/api/sfc-script-setup.html#sfc-script-setup
import { onMounted, ref } from 'vue'
import {
  Audio,
  AudioAnalyser,
  AudioListener,
  Camera,
  DataTexture,
  LuminanceFormat,
  Mesh,
  PlaneGeometry,
  RedFormat,
  Scene,
  ShaderMaterial,
  WebGLRenderer,
} from 'three'
import vertexShader from '../../shaders/webaudio-visualizer.vert?raw'
import fragmentShader from '../../shaders/webaudio-visualizer.frag?raw'

const container = ref<HTMLDListElement | null>(null)

const fftSize = 128
const scene = new Scene()
const camera = new Camera()
const renderer = new WebGLRenderer({ antialias: true })
let analyser: AudioAnalyser
let uniforms: { tAudioData: { value: DataTexture } }

renderer.setSize(window.innerWidth, window.innerHeight)
renderer.setClearColor(0x000000)
renderer.setPixelRatio(window.devicePixelRatio)

const file = './music.mp3'
const mediaElement = new window.Audio(file)

const play = () => {
  if (analyser) return mediaElement.play()

  mediaElement.play()
  const listener = new AudioListener()
  const audio = new Audio(listener)
  audio.setMediaElementSource(mediaElement)

  analyser = new AudioAnalyser(audio, fftSize)

  const format = (renderer.capabilities.isWebGL2) ? RedFormat : LuminanceFormat

  uniforms = {
    tAudioData: { value: new DataTexture(analyser.data, fftSize / 2, 1, format) },
  }

  const material = new ShaderMaterial({
    uniforms,
    vertexShader,
    fragmentShader,
  })

  const geometry = new PlaneGeometry(1, 1)

  const mesh = new Mesh(geometry, material)
  scene.add(mesh)
}

const stop = () => {
  mediaElement.pause()
}

onMounted(() => {
  container.value?.appendChild(renderer.domElement)

  function onWindowResize() {
    renderer.setSize(window.innerWidth, window.innerHeight)
  }

  window.addEventListener('resize', onWindowResize)

  function render() {
    analyser?.getFrequencyData()

    if (uniforms) uniforms.tAudioData.value.needsUpdate = true

    renderer.render(scene, camera)
  }

  function animate() {
    requestAnimationFrame(animate)

    render()
  }

  animate()
})

</script>

<template>
  <div>
    <div ref="container" />
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
#controls {
    position: fixed;
    top: 30px;
    left: 50%;
    transform: translateX(-50%);
    z-index: 1;
}
</style>
