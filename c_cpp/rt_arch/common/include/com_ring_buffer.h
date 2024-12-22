#ifndef COM_RING_BUFFER_H
#define COM_RING_BUFFER_H

/** 可生成的环形缓冲区数量 */
#define RING_BUFFER_COUNT 10

/** 成功状态码 */
#define RING_BUFFER_SUCCESS 0
/** 环形缓冲区一般失败状态码 */
#define RING_BUFFER_FAILURE -100
/** 环形缓冲区无效状态码 */
#define RING_BUFFER_UNAVAILABLE -101
/** `push` 中满的状态码 */
#define RING_BUFFER_FULL -102
/** `pop` 中空的状态码 */
#define RING_BUFFER_EMPTY -103
/** `try_pop` 中超时的状态码 */
#define RING_BUFFER_TIMEOUT -104

/*
 * ring_buffer_s 是一个定义环形缓冲区接口的结构体。
 *
 * 该结构体定义了一个环形缓冲区的接口，环形缓冲区是一个固定大小的缓冲区，
 * 其两端被视为相连，允许以循环方式添加和移除数据。它适用于管理数据流，
 * 当新数据到达时，最旧的数据会被丢弃。
 *
 * ring_buffer 结构体包含指向以下操作的函数指针：
 * - size: 返回缓冲区中当前元素的数量。
 * - push: 向缓冲区添加一个元素，返回成功、无效或队列满。
 * - pop: 从缓冲区移除一个元素，返回成功、无效、队列空（timeout=0）或超时。
 * - clear: 清除缓冲区中的所有元素。
 */
struct ring_buffer_s {
    void *priv;
    int (*size)(struct ring_buffer_s *rb);
    int (*push)(struct ring_buffer_s *rb, void *data);
    int (*pop)(struct ring_buffer_s *rb, void *data, int timeout_ms);
    void (*clear)(struct ring_buffer_s *rb);
};

/**
 * @brief 尝试创建一个环形缓冲区。
 *
 * @param[in] buffer 由调用者提供的实际缓冲内存指针。
 * @param[in] item_size 每个项目的大小。
 * @param[in] item_count 缓冲区中最大项目数量。
 * @return 生成的环形缓冲区，如果失败则返回 NULL。
 */
struct ring_buffer_s *ring_buffer_create(char *buffer, int item_size,
                                         int item_count);

#endif // COM_RING_BUFFER_H
