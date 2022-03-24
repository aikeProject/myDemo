<script setup lang="ts">
import vertexShaderSource from './vertexShader.vert?raw'
import fragmentShaderSource from './fragmentShader.frag?raw'

const canvas = ref<HTMLCanvasElement>()

onMounted(() => {
  const gl = canvas.value?.getContext('webgl')

  if (gl) {
    // 创建顶点着色器对象
    const vertexShader = gl.createShader(gl.VERTEX_SHADER)
    if (!vertexShader) return
    // 将源码分配给顶点着色器对象
    gl.shaderSource(vertexShader, vertexShaderSource)
    // 编译顶点着色器程序
    gl.compileShader(vertexShader)

    // 创建片元着色器程序
    const fragmentShader = gl.createShader(gl.FRAGMENT_SHADER)
    if (!fragmentShader) return
    // 将源码分配给片元着色器对象
    gl.shaderSource(fragmentShader, fragmentShaderSource)
    // 编译片元着色器
    gl.compileShader(fragmentShader)

    // 创建着色器程序
    const program = gl.createProgram()
    if (!program) return
    // 将顶点着色器挂载在着色器程序上。
    gl.attachShader(program, vertexShader)
    // 将片元着色器挂载在着色器程序上。
    gl.attachShader(program, fragmentShader)
    // 链接着色器程序
    gl.linkProgram(program)

    // 使用刚创建好的着色器程序。
    gl.useProgram(program)

    // 设置清空画布颜色为黑色。
    gl.clearColor(0.0, 0.0, 0.0, 1.0)

    // 用上一步设置的清空画布颜色清空画布。
    gl.clear(gl.COLOR_BUFFER_BIT)

    // 绘制点。
    gl.drawArrays(gl.POINTS, 0, 1)
  }
})
</script>

<template>
  <div>
    <canvas ref="canvas" width="500" height="500" style="width: 500px; height: 500px;" />
  </div>
</template>

<style>
</style>
