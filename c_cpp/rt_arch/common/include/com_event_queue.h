#ifndef COM_EVENT_QUEUE_H
#define COM_EVENT_QUEUE_H

#include "com_event.h"

#define EVENT_QUEUE_SIZE 100

#define EVENT_QUEUE_SUCCESS 0
#define EVENT_QUEUE_FULL -201
#define EVENT_QUEUE_EMPTY -202
#define EVENT_QUEUE_TIMEOUT -203
#define EVENT_QUEUE_INVALID -204
#define EVENT_INVALID -205

/**
 * @struct event_queue_s
 * @brief 表示事件队列结构。
 *
 * 该结构定义了事件队列的接口，用于管理事件的添加（push）和检索（pop），以及清空队列。
 *
 * @var void* event_queue_s::priv
 *   指向私有数据的指针，由事件队列实现内部使用。
 *
 * @var int (*event_queue_s::push)(struct event_queue_s *queue, struct event_s
 * *event) 用于将事件推入队列的函数指针。
 *
 * @var int (*event_queue_s::pop)(struct event_queue_s *queue, struct event_s
 * *event, int timeout_ms) 用于从队列中弹出事件的函数指针，带有可选的超时时间。
 *
 * @var void (*event_queue_s::clear)(struct event_queue_s *queue)
 *   用于清空队列中所有事件的函数指针。
 */
struct event_queue_s {
    void *priv;
    int (*push)(struct event_queue_s *queue, struct event_s *event);
    int (*pop)(struct event_queue_s *queue, struct event_s *event,
               int timeout_ms);
    void (*clear)(struct event_queue_s *queue);
};

/**
 * @brief 枚举可用的事件队列类型。
 *
 * 该枚举定义了系统中可以使用的不同类型的事件队列，每种类型都有特定的优先级。
 */
enum event_queue_type {
    EVENT_QUEUE_NORMAL = 0,
    EVENT_QUEUE_IMPORTANT,
    EVENT_QUEUE_CRITICAL,
    EVENT_QUEUE_TYPE_END
};

/**
 * @brief 初始化事件队列系统。
 *
 * 该函数为事件队列正确运行设置必要的结构和资源。
 */
void event_queue_init();

/**
 * @brief 获取指定类型的事件队列指针。
 *
 * @param type 要检索的事件队列类型。
 * @return struct event_queue_s*
 * 返回请求的事件队列指针，如果类型无效则返回NULL。
 */
struct event_queue_s *event_queue_get(enum event_queue_type type);

#endif // COM_EVENT_QUEUE_H
