module bindbc.jsl.joyshocklibrary;

/**
 * API difference: I decided to use an enumerator instead of individually defined values.
 *
 * Stores the values associated with types of possible controller types.
 */
enum JoyShockTypes {
	JoyCon_Left     =   1,
	JoyCon_Right    =   2,
	ProController   =   3,
	DualShock4      =   4
}
/**
 * API difference: I decided to use an enumerator instead of individually defined values.
 *
 * Stores the values associated with types of potential JoyCon splits.
 */
enum JoyConSplitType {
	Left            =   1,
	Right           =   2,
	Full            =   3
}
/**
 * API difference: I decided to use an enumerator instead of individually defined values.
 *
 * Stores the values associated with button events. For the right-hand-side buttons, south-east-west-north system 
 * is used to avoid ambiguity between Microsoft and Nintendo systems. (Offsets)
 */
enum ButtonOffsets {
	Up = 0,
	Down = 1,
	Left = 2,
	Right = 3,
	Plus = 4,
	Options = 4,
	Minus = 5,
	Share = 5,
	LClick = 6,
	RClick = 7,
	L = 8,
	R = 9,
	ZL = 10,
	ZR = 11,
	S = 12,
	E = 13,
	W = 14,
	N = 15,
	Home = 16,
	PS = 16,
	Capture = 17,
	TouchpadClick = 17,
	SL = 18,
	SR = 19,
}
/**
 * API difference: I decided to use an enumerator instead of individually defined values.
 *
 * Stores the values associated with button events. For the right-hand-side buttons, south-east-west-north system 
 * is used to avoid ambiguity between Microsoft and Nintendo systems. (Bitmasks)
 */
enum ButtonMasks {
	Up = 1 << ButtonOffsets.Up,
	Down = 1 << ButtonOffsets.Down,
	Left = 1 << ButtonOffsets.Left,
	Right = 1 << ButtonOffsets.Right,
	Plus = 1 << ButtonOffsets.Plus,
	Options = 1 << ButtonOffsets.Options,
	Minus = 1 << ButtonOffsets.Minus,
	Share = 1 << ButtonOffsets.Share,
	LClick = 1 << ButtonOffsets.LClick,
	RClick = 1 << ButtonOffsets.RClick,
	L = 1 << ButtonOffsets.L,
	R = 1 << ButtonOffsets.R,
	ZL = 1 << ButtonOffsets.ZL,
	ZR = 1 << ButtonOffsets.ZR,
	S = 1 << ButtonOffsets.S,
	E = 1 << ButtonOffsets.E,
	W = 1 << ButtonOffsets.W,
	N = 1 << ButtonOffsets.N,
	Home = 1 << ButtonOffsets.Home,
	PS = 1 << ButtonOffsets.PS,
	Capture = 1 << ButtonOffsets.Capture,
	TouchpadClick = 1 << ButtonOffsets.TouchpadClick,
	SL = 1 << ButtonOffsets.SL,
	SR = 1 << ButtonOffsets.SR,
}

struct JOY_SHOCK_STATE {
	int buttons;
	float lTrigger;
	float rTrigger;
	float stickLX;
	float stickLY;
	float stickRX;
	float stickRY;
}

struct IMU_STATE {
	float accelX;
	float accelY;
	float accelZ;
	float gyroX;
	float gyroY;
	float gyroZ;
}
version(JSLV2_0) {
	struct MOTION_STATE {
		float quatW;
		float quatX;
		float quatY;
		float quatZ;
		float accelX;
		float accelY;
		float accelZ;
		float gravX;
		float gravY;
		float gravZ;
	}

	struct TOUCH_STATE {
		int t0Id;
		int t1Id;
		bool t0Down;
		bool t1Down;
		float t0X;
		float t0Y;
		float t1X;
		float t1Y;
	}
}

version(BindJSL_Static) {
extern(C) @nogc nothrow:
	// These are the best way to get all the buttons/triggers/sticks, gyro/accelerometer (IMU), orientation/acceleration/gravity (Motion), or touchpad
	JOY_SHOCK_STATE JslGetSimpleState(int deviceId);
	IMU_STATE JslGetIMUState(int deviceId);
	int JslGetButtons(int deviceId);
	version(JSLV2_0) {
		MOTION_STATE JslGetMotionState(int deviceId);
		TOUCH_STATE JslGetTouchState(int deviceId);
	}
	// get thumbsticks
	float JslGetLeftX(int deviceId);
	float JslGetLeftY(int deviceId);
	float JslGetRightX(int deviceId);
	float JslGetRightY(int deviceId);

	// get triggers. Switch controllers don't have analogue triggers, but will report 0.0 or 1.0 so they can be used in the same way as others
	float JslGetLeftTrigger(int deviceId);
	float JslGetRightTrigger(int deviceId);

	// get gyro
	float JslGetGyroX(int deviceId);
	float JslGetGyroY(int deviceId);
	float JslGetGyroZ(int deviceId);

	// get accelerometor
	float JslGetAccelX(int deviceId);
	float JslGetAccelY(int deviceId);
	float JslGetAccelZ(int deviceId);

	// analog parameters have different resolutions depending on device
	float JslGetStickStep(int deviceId);
	float JslGetTriggerStep(int deviceId);
	float JslGetPollRate(int deviceId);

	// calibration
	void JslResetContinuousCalibration(int deviceId);
	void JslStartContinuousCalibration(int deviceId);
	void JslPauseContinuousCalibration(int deviceId);
	void JslGetCalibrationOffset(int deviceId, ref float xOffset, ref float yOffset, ref float zOffset);
	void JslSetCalibrationOffset(int deviceId, float xOffset, float yOffset, float zOffset);

	/// this function will get called for each input event from each controller
	void JslSetCallback(void function(int, JOY_SHOCK_STATE, JOY_SHOCK_STATE, IMU_STATE, IMU_STATE, float) callback);

	/// what kind of controller is this?
	int JslGetControllerType(int deviceId);
	/// is this a left, right, or full controller?
	int JslGetControllerSplitType(int deviceId);
	/// what colour is the controller (not all controllers support this; those that don't will report white)
	int JslGetControllerColour(int deviceId);
	/// set controller light colour (not all controllers have a light whose colour can be set, but that just means nothing will be done when this is called -- no harm)
	void JslSetLightColour(int deviceId, int colour);
	/// set controller rumble
	void JslSetRumble(int deviceId, int smallRumble, int bigRumble);
	/// set controller player number indicator (not all controllers have a number indicator which can be set, but that just means nothing will be done when this is called -- no harm)
	void JslSetPlayerNumber(int deviceId, int number);
} else {
	extern(C) @nogc nothrow {
		alias pJslGetSimpleState = JOY_SHOCK_STATE function(int deviceId);
		alias pJslGetIMUState = IMU_STATE function(int deviceId);
		alias pJslGetButtons = int function(int deviceId);
		alias pJslGetLeftX = float function(int deviceId);
		alias pJslGetLeftY = float function(int deviceId);
		alias pJslGetRightX = float function(int deviceId);
		alias pJslGetRightY = float function(int deviceId);
		alias pJslGetLeftTrigger = float function(int deviceId);
		alias pJslGetRightTrigger = float function(int deviceId);
		alias pJslGetGyroX = float function(int deviceId);
		alias pJslGetGyroY = float function(int deviceId);
		alias pJslGetGyroZ = float function(int deviceId);
		alias pJslGetAccelX = float function(int deviceId);
		alias pJslGetAccelY = float function(int deviceId);
		alias pJslGetAccelZ = float function(int deviceId);
		alias pJslGetStickStep = float function(int deviceId);
		alias pJslGetTriggerStep = float function(int deviceId);
		alias pJslGetPollRate = float function(int deviceId);
		alias pJslResetContinuousCalibration = void function(int deviceId);
		alias pJslStartContinuousCalibration = void function(int deviceId);
		alias pJslPauseContinuousCalibration = void function(int deviceId);
		alias pJslGetCalibrationOffset = void function(int deviceId, ref float xOffset, ref float yOffset, ref float zOffset);
		alias pJslSetCalibrationOffset = void function(int deviceId, float xOffset, float yOffset, float zOffset);
		alias pJslSetCallback = void function(void function(int, JOY_SHOCK_STATE, JOY_SHOCK_STATE, IMU_STATE, IMU_STATE, float) callback);
		alias pJslGetControllerType = int function(int deviceId);
		alias pJslGetControllerSplitType = int function(int deviceId);
		alias pJslGetControllerColour = int function(int deviceId);
		alias pJslSetLightColour = void function(int deviceId, int colour);
		alias pJslSetRumble = void function(int deviceId, int smallRumble, int bigRumble);
		alias pJslSetPlayerNumber = void function(int deviceId, int number);
		version(JSLV2_0) {
			alias pJslGetMotionState = MOTION_STATE function(int deviceId);
			alias pJslGetTouchState = TOUCH_STATE function(int deviceId);
		}
	}
	__gshared {
		pJslGetSimpleState JslGetSimpleState;
		pJslGetIMUState JslGetIMUState;
		pJslGetButtons JslGetButtons;
		pJslGetLeftX JslGetLeftX;
		pJslGetLeftY JslGetLeftY;
		pJslGetRightX JslGetRightX;
		pJslGetRightY JslGetRightY;
		pJslGetLeftTrigger JslGetLeftTrigger;
		pJslGetRightTrigger JslGetRightTrigger;
		pJslGetGyroX JslGetGyroX;
		pJslGetGyroY JslGetGyroY;
		pJslGetGyroZ JslGetGyroZ;
		pJslGetAccelX JslGetAccelX;
		pJslGetAccelY JslGetAccelY;
		pJslGetAccelZ JslGetAccelZ;
		pJslGetStickStep JslGetStickStep;
		pJslGetTriggerStep JslGetTriggerStep;
		pJslGetPollRate JslGetPollRate;
		pJslResetContinuousCalibration JslResetContinuousCalibration;
		pJslStartContinuousCalibration JslStartContinuousCalibration;
		pJslPauseContinuousCalibration JslPauseContinuousCalibration;
		pJslGetCalibrationOffset JslGetCalibrationOffset;
		pJslSetCalibrationOffset JslSetCalibrationOffset;
		/// this function will get called for each input event from each controller
		pJslSetCallback JslSetCallback;
		/// what kind of controller is this?
		pJslGetControllerType JslGetControllerType;
		/// is this a left, right, or full controller?
		pJslGetControllerSplitType JslGetControllerSplitType;
		/// what colour is the controller (not all controllers support this; those that don't will report white)
		pJslGetControllerColour JslGetControllerColour;
		/// set controller light colour (not all controllers have a light whose colour can be set, but that just means nothing will be done when this is called -- no harm)
		pJslSetLightColour JslSetLightColour;
		/// set controller rumble
		pJslSetRumble JslSetRumble;
		/// set controller player number indicator (not all controllers have a number indicator which can be set, but that just means nothing will be done when this is called -- no harm)
		pJslSetPlayerNumber JslSetPlayerNumber;
		version(JSLV2_0) {
			pJslGetMotionState JslGetMotionState;
			pJslGetTouchState JslGetTouchState;
		}
	}
}