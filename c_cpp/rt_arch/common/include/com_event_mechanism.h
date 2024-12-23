/**
 * @file com_event_mechanism.h
 * @brief 事件机制头文件，包含事件处理、队列、路由和分发的相关定义。
 */

#ifndef COM_EVENT_MECHANISM_H
#define COM_EVENT_MECHANISM_H

#include "com_event.h"
#include "com_event_queue.h"
#include "com_event_router.h"
#include "com_event_dispatcher.h"

/**
 * @brief 初始化并运行事件机制。
 */
void initial_and_run_event_mechanism();

/**
 * @brief 将事件推入事件队列。
 * @param event 指向要推入的事件结构体的指针。
 * @return 返回操作结果，成功返回0，失败返回非0值。
 */
int push_event(struct event_s *event);

/**
 * @brief 注册事件处理器。
 * @param event_type 事件类型。
 * @param handler 处理事件的函数指针。
 */
void register_event_handler(uint8_t event_type, event_handler_t handler);

#endif // COM_EVENT_MECHANISM_H
