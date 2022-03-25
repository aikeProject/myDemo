<script setup lang="ts">
import vertexShaderSource from './shader/vertexShader.vert?raw'
import fragmentShaderSource from './shader/fragmentShader.frag?raw'
import { createProgram, createShader } from '~/utils/webgl-helper'

const canvas = ref<HTMLCanvasElement>()

onMounted(() => {
  const gl = canvas.value?.getContext('webgl')
  if (!gl) return

  // 创建顶点着色器对象
  const vertexShader = createShader(gl, gl.VERTEX_SHADER, vertexShaderSource)
  // 创建片元着色器程序
  const fragmentShader = createShader(gl, gl.FRAGMENT_SHADER, fragmentShaderSource)
  // 创建着色器程序
  const { program } = createProgram(gl, vertexShader, fragmentShader)

  // 使用刚创建好的着色器程序
  gl.useProgram(program)
  // 设置清空画布颜色为黑色。
  gl.clearColor(0.0, 0.0, 0.0, 1.0)
  // 用上一步设置的清空画布颜色清空画布。
  gl.clear(gl.COLOR_BUFFER_BIT)
  // 绘制点。
  gl.drawArrays(gl.POINTS, 0, 1)
})
</script>

<template>
  <div>
    <canvas ref="canvas" width="500" height="500" />
  </div>
</template>

<style>
</style>
