<script setup lang="ts">
import vertexShaderSource from './shader/vertexShader.vert?raw'
import fragmentShaderSource from './shader/fragmentShader.frag?raw'
import { createProgram, createShader } from '~/utils/webgl-helper'

const canvas = ref<HTMLCanvasElement>()
const width = ref(window.innerWidth)
const height = ref(window.innerHeight)

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

  const positions = [1, 0, 0, 1, 0, 0]
  const a_Position = gl.getAttribLocation(program, 'a_Position')
  const buffer = gl.createBuffer()
  // 获取片元着色器中的变量u_Color的位置。
  const u_Color = gl.getUniformLocation(program, 'u_Color')
  // 向片元着色器传递颜色信息
  gl.uniform4f(u_Color, 256, 0, 0, 1)

  // 绑定缓冲区
  gl.bindBuffer(gl.ARRAY_BUFFER, buffer)
  // 写入数据
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(positions), gl.STATIC_DRAW)
  // 启用a_Position
  gl.enableVertexAttribArray(a_Position)
  // 每次取两个数据
  const size = 2
  // 每个数据的类型是32位浮点型
  const type = gl.FLOAT
  // 不需要归一化数据
  const normalize = false
  // 每次迭代运行需要移动数据数 * 每个数据所占内存 到下一个数据开始点。
  const stride = 0
  // 从缓冲起始位置开始读取
  const offset = 0
  // 将 a_Position 变量获取数据的缓冲区指向当前绑定的 buffer。
  gl.vertexAttribPointer(
    a_Position, size, type, normalize, stride, offset)
  // 设置清空画布颜色为黑色。
  gl.clearColor(0.0, 0.0, 0.0, 1.0)
  // 用上一步设置的清空画布颜色清空画布。
  gl.clear(gl.COLOR_BUFFER_BIT)
  // 绘制图元设置为三角形
  const primitiveType = gl.TRIANGLES
  // 因为我们要绘制三个点，所以执行三次顶点绘制操作。
  const count = 3
  gl.drawArrays(primitiveType, 0, count)
})
</script>

<template>
  <div>
    <canvas ref="canvas" :width="width" :height="height" />
  </div>
</template>

<style>
</style>
