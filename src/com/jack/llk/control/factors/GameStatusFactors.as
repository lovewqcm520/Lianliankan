package com.jack.llk.control.factors
{
	public class GameStatusFactors
	{
		/**
		 * 当手机切换到游戏以外的界面时, 比如按HOME键.
		 */
		public static const STATUS_DEACTIVATE:int = 1;
		
		/**
		 * 游戏停留在 关卡选择界面 或者 等待界面.
		 */
		public static const STATUS_IDLE:int = 2;
		
		/**
		 * 游戏正常进行阶段(连连看),需要提高framerate使游戏运行流畅.
		 */
		public static const STATUS_PLAYING:int = 3;
		
		/**
		 * 游戏暂停阶段(此暂停由切换出游戏界面触发)
		 */
		public static const STATUS_PAUSE_BY_DEACTIVATE:int = 4;
		
		/**
		 * 游戏暂停阶段(此暂停由用户主动点击游戏暂停按钮触发，只可能发生在 STATUS_PLAYING 状态下)
		 */
		public static const STATUS_PAUSE_BY_USER:int = 5;
		
		/**
		 * 游戏警告阶段(玩家剩余时间不多时,会有警报)
		 */
		public static const STATUS_WARNING:int = 6;
		
		/**
		 * 游戏结束(针对当前章节)
		 */
		public static const STATUS_OVER:int = 7;
		
		/**
		 * 游戏开始(针对当前章节)
		 */
		public static const STATUS_START:int = 8;
	}
}