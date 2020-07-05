# bindbc-JSL

D bindings for the JoyShockLibrary

Dynamic bindings are tested and working under Windows. The original library is not yet available under other OSes.

The library can handle controllers made by Sony and Nintendo, with most of their specific capabilities, like reading IMU states.

# Usage

## Loading the library

Unless static bindings are enabled, you'll need to load the library.

Get either the compiled DLL file, or the source from here: https://github.com/JibbSmart/JoyShockLibrary

If your EXE file is in the same directory as the DLL, then use this function call:

```D
  JSLSupport jslStatus = loadJSL();
```

You can specify a full path, including alternative DLL names, like `loadJSL(".\\dlls\\jsl.dll")`.

## Handling the controllers

First is an example for detecting whether a supported controller type is connected or not.

```D
  int type = JslGetControllerType(controllerNum);
  if (type)
  {
    //This assigns the controller to a given player
    JslSetPlayerNumber(controllerNum, playerNum);
    //Rest of your code here
  }
```

Here's the recommended way to read from the controller:

```D
  JOY_SHOCK_STATE controllerState = JslGetSimpleState(controllerNum);
  IMU_STATE imuState = JslGetIMUState(controllerNum);
  //In this example I'll read the up and "south" button using binary logic.
  if (controllerState.buttons == ButtonMasks.Up | ButtonMasks.S)
  {
    //Do something
  }
  //This example reads the left thumbstick and calls a further function if any of the axes leave the deadzone (between +0.1 and -0.1)
  if ((controllerState.stickLX > 0.1 || controllerState.stickLX < -0.1) && ((controllerState.stickLY > 0.1 || controllerState.stickLY < -0.1))
  {
    player.move(controllerState.stickLX, controllerState.stickLY);
  }
  //This example passes the X and Y values from the gyroscope to a function.
  player.aim(imuState.gyroX, imuState.gyroY);
```
There's also individual getters for all values, except for the buttons which are read at once in a 32 bit integer.

You can probably find more info about the library both on this blog (http://gyrowiki.jibbsmart.com/) and the original ligrary if you need.

# Contact and bug reports

If you encounter a bug with the loader, then file it under the `issues`. Please don't bother the developer of bindbc (Mike D Parker) with issues you encounter with this loader. I'll contact him if the error isn't within my own library. Also please chaeck if it's also present in it's original implementation by visiting the original repository.
