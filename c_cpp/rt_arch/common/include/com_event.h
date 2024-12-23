#ifndef COM_EVENT_H
#define COM_EVENT_H

#ifndef uint8_t
typedef unsigned char uint8_t;
#endif // uint8_t

#define EVENT_TYPE_MAX 0x7F

/**
 * @struct event_s
 * @brief 事件结构体，包含事件类型和事件数据指针
 *
 * 该结构体用于表示一个事件，包括事件的类型以及指向事件数据的指针。
 * 事件类型用于区分不同的事件，事件数据指针则指向具体的事件数据。
 */
struct event_s {
    uint8_t type; /**< 事件类型 */
    void *data;   /**< 指向事件数据的指针 */
};

#endif // COM_EVENT_H
