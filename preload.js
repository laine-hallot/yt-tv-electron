const { contextBridge, ipcRenderer } = require("electron");

contextBridge.exposeInMainWorld("electron", {
  save: () => ipcRenderer.invoke("save-config"),
  loadConfig: () => ipcRenderer.invoke("load-config"),
});
