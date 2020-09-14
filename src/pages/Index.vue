<template xmlns:v-slot="http://www.w3.org/1999/XSL/Transform">
  <q-page class="flex flex-center column">
    <div class="row text-white">
      请输入要下载的好看视频地址，只支持单个下载
    </div>
    <div class="row" style="width: 100%; padding: 10px">
      <q-input standout square v-model="url" :dense=true bg-color="orange"
               style="width: 100%"></q-input>
    </div>
    <div class="row">
      <q-btn style="background: #FF0080; color: white; width: 200px"
             :loading="loading"
             @click="download"
             :percentage="percentage" label="点击下载">
        <template v-slot:loading>
          <q-spinner-gears class="on-left" />
          下载中({{percentage}}%)...
        </template>
      </q-btn>
    </div>
    <q-dialog v-model="alert" persistent transition-show="flip-down" transition-hide="flip-up">
      <q-card :class="alertClass" class="bg-primary">
        <q-card-section>
          <div class="text-h6">{{messageType}}</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          {{message}}
        </q-card-section>

        <q-card-actions align="right">
          <q-btn flat label="OK" color="primary" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </q-page>
</template>

<script>
import { ipcRenderer } from 'electron'

export default {
  name: 'PageIndex',
  data () {
    return {
      url: '',
      loading: false,
      percentage: 0,
      alert: false,
      alertClass: '',
      messageType: '错误',
      message: ''
    }
  },
  methods: {
    download () {
      const url = this.delSpaces(this.url)
      if (!url) {
        return this.showAlert({ message: '下载地址不能为空' })
      }
      ipcRenderer.send('downloadFile', url)
      this.loading = true
      this.percentage = 0
      this.url = url
    },

    showAlert ({ message, messageType = '错误', alertClass = 'bg-white text-pink' }) {
      this.message = message
      this.messageType = messageType
      this.alert = true
      this.alertClass = alertClass
    },
    delSpaces (s) {
      return s && s.replace('\\r', '').replace('\\n', '').replace('\t', '').trim()
    }
  },
  async mounted () {
    ipcRenderer.on('downloading', (event, { percentage }) => {
      this.loading = true
      console.log(percentage)
      this.percentage = percentage
    })
    ipcRenderer.on('downloadComplete', (event, filePath) => {
      this.loading = false
      this.showAlert({ message: `下载到:${filePath}`, messageType: '成功', alertClass: 'bg-white text-green' })
    })
    ipcRenderer.on('downloadFail', (event, error) => {
      this.loading = false
      console.log(error)
      this.showAlert({ message: '下载失败' })
    })
  }
}
</script>
