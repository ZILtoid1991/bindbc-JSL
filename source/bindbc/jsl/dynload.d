module bindbc.jsl.dynload;
version(BindJSL_Static) {

} else {
	import bindbc.loader;
	import bindbc.jsl.joyshocklibrary;
	/**
	 * Used as a return value by the loader.
	 * Currently doesn't support version checking.
	 */
	enum JSLSupport {
		noLibrary,
		badLibrary,
		loadedV1_1,
	}
	private {
		SharedLib lib;
		JSLSupport loadedVersion;
	}
	/**
	 * Unloads the JSL library.
	 */
	void unloadJLS() {
		if(lib != invalidHandle) {
			lib.unload();
		}
	}
	/**
	 * Returns the currently loaded version of the library, or an error code if the loading failed.
	 */
	JSLSupport loadedJSLVersion() {
		return loadedVersion;
	}
	/**
	 * Loads the library.
	 */
	JSLSupport loadJSL() {
		version(Windows) {
			const(char)[] filename = "JoyShockLibrary.dll";
		} else static assert(0, "At the current moment, JoyShockLibrary is Windows only!");
		return loadJSL(filename.ptr);
	}
	/**
	 * Loads the library from the given path.
	 */
	JSLSupport loadJSL(const(char)* libName) {
		lib = load(libName);
		if (lib == invalidHandle) return JSLSupport.noLibrary;
		auto errCnt = errorCount();
		lib.bindSymbol(cast(void**)&JslGetSimpleState, "JslGetSimpleState");
		lib.bindSymbol(cast(void**)&JslGetIMUState, "JslGetIMUState");
		lib.bindSymbol(cast(void**)&JslGetButtons, "JslGetButtons");
		lib.bindSymbol(cast(void**)&JslGetLeftX, "JslGetLeftX");
		lib.bindSymbol(cast(void**)&JslGetLeftY, "JslGetLeftY");
		lib.bindSymbol(cast(void**)&JslGetRightX, "JslGetRightX");
		lib.bindSymbol(cast(void**)&JslGetRightY, "JslGetRightY");
		lib.bindSymbol(cast(void**)&JslGetLeftTrigger, "JslGetLeftTrigger");
		lib.bindSymbol(cast(void**)&JslGetRightTrigger, "JslGetRightTrigger");
		lib.bindSymbol(cast(void**)&JslGetGyroX, "JslGetGyroX");
		lib.bindSymbol(cast(void**)&JslGetGyroY, "JslGetGyroY");
		lib.bindSymbol(cast(void**)&JslGetGyroZ, "JslGetGyroZ");
		lib.bindSymbol(cast(void**)&JslGetAccelX, "JslGetAccelX");
		lib.bindSymbol(cast(void**)&JslGetAccelY, "JslGetAccelY");
		lib.bindSymbol(cast(void**)&JslGetAccelZ, "JslGetAccelZ");
		lib.bindSymbol(cast(void**)&JslGetStickStep, "JslGetStickStep");
		lib.bindSymbol(cast(void**)&JslGetTriggerStep, "JslGetTriggerStep");
		lib.bindSymbol(cast(void**)&JslGetPollRate, "JslGetPollRate");
		lib.bindSymbol(cast(void**)&JslResetContinuousCalibration, "JslResetContinuousCalibration");
		lib.bindSymbol(cast(void**)&JslStartContinuousCalibration, "JslStartContinuousCalibration");
		lib.bindSymbol(cast(void**)&JslPauseContinuousCalibration, "JslPauseContinuousCalibration");
		lib.bindSymbol(cast(void**)&JslGetCalibrationOffset, "JslGetCalibrationOffset");
		lib.bindSymbol(cast(void**)&JslSetCalibrationOffset, "JslSetCalibrationOffset");
		lib.bindSymbol(cast(void**)&JslSetCallback, "JslSetCallback");
		lib.bindSymbol(cast(void**)&JslGetControllerType, "JslGetControllerType");
		lib.bindSymbol(cast(void**)&JslGetControllerSplitType, "JslGetControllerSplitType");
		lib.bindSymbol(cast(void**)&JslGetControllerColour, "JslGetControllerColour");
		lib.bindSymbol(cast(void**)&JslSetLightColour, "JslSetLightColour");
		lib.bindSymbol(cast(void**)&JslSetRumble, "JslSetRumble");
		lib.bindSymbol(cast(void**)&JslSetPlayerNumber, "JslSetPlayerNumber");
		if(errCnt != errorCount()) loadedVersion = JSLSupport.badLibrary;
		else loadedVersion = JSLSupport.loadedV1_1;
		return loadedVersion;
	}
}