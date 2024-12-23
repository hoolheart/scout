#ifndef COM_EVENT_DISPATCHER_H
#define COM_EVENT_DISPATCHER_H

#include "com_event.h"

#define EVENT_HANDLER_MAX 4

#define EVENT_DISPATCHER_SUCCESS 0
#define EVENT_HANDLER_FULL -206

typedef void (*event_handler_t)(struct event_s *event);

/**
 * @struct event_dispatcher_s
 * @brief 表示事件分发器的结构体。
 *
 * 该结构体包含用于注册事件处理器和分发事件的函数指针，
 * 它用于管理系统内不同类型事件的处理
 *
 * @var event_dispatcher_s::priv 分发器的私有数据指针
 *
 * @var event_dispatcher_s::register_handler 用于为特定类型注册事件处理器的函数指针
 *
 * @var event_dispatcher_s::dispatch 用于将事件分发到适当处理器的函数指针
 */
struct event_dispatcher_s {
    void *priv;
    int (*register_handler)(struct event_dispatcher_s *dispatcher,
                            uint8_t type, event_handler_t handler);
    void (*dispatch)(struct event_dispatcher_s *dispatcher,
                     struct event_s *event);
};

/**
 * @fn struct event_dispatcher_s *event_dispatcher_get()
 * @brief 获取事件分发器实例。
 *
 * 该函数返回一个指向事件分发器实例的指针，可用于注册处理器和分发事件。
 *
 * @return 指向事件分发器实例的指针。
 */
struct event_dispatcher_s *event_dispatcher_get();

#endif // COM_EVENT_DISPATCHER_H
