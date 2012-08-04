package com.jack.llk.control.factors
{

	public class FramerateFactors
	{
		/**
		 * 当手机切换到游戏以外的界面时, 比如按HOME键.
		 */
		public static const FPS_DEACTIVATE:int=60;

		/**
		 * 游戏停留在 关卡选择界面 或者 等待界面.
		 */
		public static const FPS_IDLE:int=10;

		/**
		 * 游戏正常进行阶段(连连看),需要提高framerate使游戏运行流畅.
		 */
		public static const FPS_PLAYING:int=60;

		/**
		 * 游戏暂停阶段(此暂停由切换出游戏界面触发)
		 */
		public static const FPS_PAUSE_BY_DEACTIVATE:int=5;

		/**
		 * 游戏暂停阶段(此暂停由用户主动点击游戏暂停按钮触发，只可能发生在 STATUS_PLAYING 状态下)
		 */
		public static const FPS_PAUSE_BY_USER:int=10;
	}
}
