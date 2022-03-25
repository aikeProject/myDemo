<script setup lang="ts">
const list = [
  {
    to: '/audio-canvas',
    title: 'audio-canvas',
    desc: '使用canvas实现音频可视化',
  },
  {
    to: '/web-audio-visualizer',
    title: 'web-audio-visualizer',
    desc: '使用three.js实现音频可视化',
  },
  {
    to: '/webgl/lesson1',
    title: '从一个点开始',
    desc: '编写第一个 WebGL 程序',
  },
  {
    to: '/webgl/lesson1-1',
    title: '动态绘制点',
    desc: '编写 WebGL 程序',
  },
  {
    to: '/webgl/lesson2',
    title: '三角形',
    desc: '绘制基本三角形',
  },
]
</script>

<template>
  <div class="p-2">
    <n-grid :x-gap="8" :y-gap="8" cols="1 s:3 m:4 l:5 xl:6 2xl:7" responsive="screen">
      <n-grid-item v-for="item in list" :key="item.title">
        <router-link :to="item.to">
          <n-card :title="item.title" :hoverable="true">
            <n-ellipsis :line-clamp="2">
              {{ item.desc }}
            </n-ellipsis>
          </n-card>
        </router-link>
      </n-grid-item>
    </n-grid>
  </div>
</template>

<style>
</style>
