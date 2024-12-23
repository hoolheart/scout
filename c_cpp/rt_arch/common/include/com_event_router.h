#ifndef COM_EVENT_ROUTER_H
#define COM_EVENT_ROUTER_H

#include "com_event.h"
#include "com_event_queue.h"

/**
 * @struct event_router_s
 * @brief 代表事件路由器的结构体。
 *
 * 该结构体包含函数指针和一个私有指针，用于管理事件路由。
 * route函数负责根据事件类型和队列类型处理事件，
 * 而push函数用于将事件添加到路由器。
 */
struct event_router_s {
    void *priv; ///< 指向私有数据的指针。
    /**
     * @brief 路由事件的函数。
     * @param router 指向事件路由器的指针。
     * @param event_type 事件类型。
     * @param queue_type 事件队列类型。
     */
    void (*route)(struct event_router_s *router, uint8_t event_type,
                  enum event_queue_type queue_type);
    /**
     * @brief 将事件推送到路由器的函数。
     * @param router 指向事件路由器的指针。
     * @param event 指向要推送的事件的指针。
     * @return int 返回一个整数，表示成功或失败。
     */
    int (*push)(struct event_router_s *router, struct event_s *event);
};

/**
 * @brief 获取事件路由器实例的函数。
 * @return struct event_router_s* 指向事件路由器实例的指针。
 */
struct event_router_s *event_router_get();

#endif // COM_EVENT_ROUTER_H
