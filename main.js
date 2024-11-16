const { app, BrowserWindow, ipcMain, Menu, session } = require('electron');
const { resolve } = require('path');
const { cwd } = require('process');

const USER_AGENT =
  'Mozilla/5.0 (PlayStation; PlayStation 5/6.50) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Safari/605.1.15';

const isMac = process.platform === 'darwin';

const createWindow = () => {
  const win = new BrowserWindow({
    autoHideMenuBar: true,
    webPreferences: {
      devTools: true,
      preload: resolve(cwd(), './preload.js'),
    },
  });
  const menu = Menu.buildFromTemplate([
    {
      label: 'File',
      submenu: [isMac ? { role: 'close' } : { role: 'quit' }],
    },
    {
      label: 'Controller',
      submenu: [{ label: 'Configure' }],
    },
  ]);
  Menu.setApplicationMenu(menu);
  return win;
};

app
  .whenReady()
  .then(async () => {
    const win = createWindow();

    session.defaultSession.webRequest.onBeforeSendHeaders(
      (details, callback) => {
        details.requestHeaders['User-Agent'] = USER_AGENT;
        callback({
          cancel: false,
          requestHeaders: details.requestHeaders,
        });
      }
    );

    const extension = await session.defaultSession.loadExtension(
      resolve(cwd(), './gamepad-to-keyboard-mapper')
    );

    ipcMain.handle('load-config', () => {
      return { controllerMap: [] };
    });

    win.webContents.session.on(
      'select-hid-device',
      (event, details, callback) => {
        // Add events to handle devices being added or removed before the callback on
        // `select-hid-device` is called.
        win.webContents.session.on('hid-device-added', (event, device) => {
          console.log('hid-device-added FIRED WITH', device);
          // Optionally update details.deviceList
        });

        win.webContents.session.on('hid-device-removed', (event, device) => {
          console.log('hid-device-removed FIRED WITH', device);
          // Optionally update details.deviceList
        });

        event.preventDefault();
        if (details.deviceList && details.deviceList.length > 0) {
          callback(details.deviceList[0].deviceId);
        }
      }
    );

    win.webContents.session.setPermissionCheckHandler(
      (webContents, permission, requestingOrigin, details) => {
        if (permission === 'hid' && details.securityOrigin === 'file:///') {
          return true;
        }
      }
    );

    win.webContents.session.setDevicePermissionHandler((details) => {
      if (details.deviceType === 'hid' && details.origin === 'file://') {
        return true;
      }
    });

    console.log(extension);
    await win.loadURL('https://youtube.com/tv', { userAgent: USER_AGENT });
    /* await win.loadFile(extension.path + "/popup.html", {
      userAgent: USER_AGENT,
    }); */
    /* await win.loadURL('http://localhost:3000/', {
      userAgent: USER_AGENT,
    });
 */
    if (process.env.NODE_ENV === 'development') {
      win.webContents.openDevTools();
    }
  })
  .catch((error) => console.log(error));
