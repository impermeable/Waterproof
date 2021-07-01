'use strict';

/* global __static */

import {app, BrowserWindow, ipcMain, protocol, dialog} from 'electron';
import installExtension, {VUEJS_DEVTOOLS} from 'electron-devtools-installer';

import {execFile} from 'child_process';
import path from 'path';
import {
  createProtocol,
} from 'vue-cli-plugin-electron-builder/lib';

import { autoUpdater } from "electron-updater"

// declare const __static: string;
const isDevelopment = process.env.NODE_ENV !== 'production';

// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
let win;
let wrapper;
let running = true;

// Scheme must be registered before the app is ready
protocol.registerSchemesAsPrivileged([
  {scheme: 'app', privileges: {secure: true, standard: true}},
]);

/**
 * Creates Waterproof's main window.
 */
function createWindow() {
  // Create the browser window.

  let relPath;
  if (process.env.NODE_ENV === 'production') {
    relPath = '../../';
  } else {
    relPath = '../';
  }
  const basePath = path.join(__dirname, relPath);

  let wrapperExecutable = '';
  if (process.platform === 'win32') {
    wrapperExecutable = 'win/wpwrapper.exe';
  } else if (process.platform === 'darwin') {
    wrapperExecutable = 'mac/wpwrapper_mac.mac';
  } else {
    wrapperExecutable = 'lin/wpwrapper_ubuntu.ubuntu';
  }

  const wrapperPath = path.join(basePath, 'wrapper/' + wrapperExecutable);

  wrapper = execFile(wrapperPath, {cwd: app.getPath('home')},
      (error) => {
        if (running && error && error.signal !== 'SIGTERM') {
          console.log('Could not start wrapper');
          console.log(error);
        }
      });

  win = new BrowserWindow({
    width: 800,
    height: 600,
    minHeight: 500,
    minWidth: 500,
    title: 'Waterproof',
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false,
      enableRemoteModule: true,
    },
    icon: path.join(__static, 'icon.png'),
  });

  // Remove OS top bar
  // win.setMenu(null);
  win.setMenuBarVisibility(false);

  if (process.env.WEBPACK_DEV_SERVER_URL) {
    // Load the url of the dev server if in development mode
    win.loadURL(process.env.WEBPACK_DEV_SERVER_URL);
    if (!process.env.IS_TEST) {
      installExtension(VUEJS_DEVTOOLS)
          .then((name) => console.log(`Added Extension:  ${name}`))
          .catch((err) => console.log('An error occurred: ', err));
      win.webContents.openDevTools();
    }
  } else {
    createProtocol('app');
    // Load the index.html when not in development

    if (process.argv.length > 1) {
      // TODO check on different platforms
      win.loadURL('app://./index.html?location=' + encodeURIComponent(process.argv[1]));
    } else {
      win.loadURL('app://./index.html');
    }

    /*  When not in development, check for updates  */
    const log = require("electron-log");
    log.transports.file.level = "info";
    autoUpdater.logger = log;

    /*  Note: the official documentation of Vue Electron Builder (which is used to build Waterproof) 
          recommends placing the updating code here  */
    autoUpdater.on('update-available', (info) => {

      const feedback = dialog.showMessageBox(win, {
        type: 'question',
        buttons: ['Remind me later', 'Yes, please'],
        /*  Option 1 ('Yes, please') is the default option */
        defaultId: 1,
        title: 'Update available',
        message: 'A new version of Waterproof is available. Would you like to update?',
        detail: 'If you agree, the update will be applied the next time you start Waterproof.'
      });
      feedback.then(
        function(ret) {
          if (ret.response == 1) {  /*  user has accepted the update  */
            autoUpdater.downloadUpdate();
          }
        }
      );
    });

    /*  Check for available updates, but only download after the user confirms this */
    autoUpdater.autoDownload = false;
    autoUpdater.checkForUpdates();
  }

  win.on('closed', () => {
    win = null;
  });

  win.on('close', function(e) {
    if (running) {
      win.webContents.send('closing-application');
      e.preventDefault();
    } else {
      wrapper.kill('SIGTERM');
    }
  });

  ipcMain.on('confirmClosing', () => {
    running = false;
    app.quit();
  });
}

// Quit when all windows are closed.
app.on('window-all-closed', () => {
  // On macOS it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('activate', () => {
  // On macOS it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  if (win === null) {
    createWindow();
  }
});

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.on('ready', async () => {
  createWindow();
});

// Exit cleanly on request from parent process in development mode.
if (isDevelopment) {
  if (process.platform === 'win32') {
    process.on('message', (data) => {
      if (data === 'graceful-exit') {
        app.quit();
      }
    });
  } else {
    process.on('SIGTERM', () => {
      app.quit();
    });
  }
}
