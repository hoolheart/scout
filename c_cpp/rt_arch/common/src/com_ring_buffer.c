#include "com_ring_buffer.h"

#ifndef NULL
#define NULL ((void *)0)
#endif

/** Private data of ring buffer */
struct ring_buffer_priv_s {
    char *buffer;   /**< buffer pointer */
    int item_size;  /**< size of each item */
    int item_count; /**< maximum count of items in buffer */
    int head;       /**< head position for pop */
    int tail;       /**< tail position for push */
    int used;       /**< used count */
    // TODO: locking items
};

/** Used count of prepared ring buffers */
int g_ring_buffer_used = 0;
/** Prepared private data in ring buffers */
struct ring_buffer_priv_s g_ring_buffer_privates[RING_BUFFER_COUNT] = {0};
/** Prepared ring buffers */
struct ring_buffer_s g_ring_buffers[RING_BUFFER_COUNT] = {0};

/**
 * @brief Locks the ring buffer to prevent concurrent access.
 *
 * This function is intended to provide mutual exclusion to the ring buffer,
 * ensuring that no other thread can modify the buffer while it is being
 * accessed. The actual locking mechanism should be implemented in place of the
 * TODO comment.
 *
 * @param rb Pointer to the ring buffer structure to be locked.
 */
void ring_buffer_lock(struct ring_buffer_s *rb) {
    // TODO: lock
}

/**
 * @brief Unlocks the ring buffer, allowing other threads to access it.
 *
 * This function is responsible for unlocking the ring buffer after it has been
 * locked by a thread. Unlocking the buffer ensures that other threads can
 * safely perform read/write operations on the buffer.
 *
 * @param rb Pointer to the ring buffer structure to be unlocked.
 */
void ring_buffer_unlock(struct ring_buffer_s *rb) {
    // TODO: unlock
}

/**
 * @brief Notifies about changes in the ring buffer state.
 *
 * This function is intended to be called whenever there is a change in the
 * state of the ring buffer, such as when new data is added or when data is
 * consumed. The exact mechanism of notification is left to the implementation,
 * which might involve signaling another thread, updating a flag, or any other
 * suitable action.
 *
 * @param rb Pointer to the ring buffer structure.
 */
void ring_buffer_notify(struct ring_buffer_s *rb) {
    // TODO: notify
}

/**
 * @brief Attempts to require the ring buffer to be ready within a specified
 * timeout period.
 *
 * This function checks if the ring buffer is ready for use and waits up to the
 * specified timeout period if it is not immediately available. If the ring
 * buffer becomes ready within the timeout, it returns success; otherwise, it
 * may return an appropriate error code.
 *
 * @param rb Pointer to the ring buffer structure.
 * @param timeout_ms Maximum time to wait for the ring buffer to be ready, in
 * milliseconds.
 * @return RING_BUFFER_SUCCESS if the ring buffer is ready, otherwise an error
 * code.
 */
int ring_buffer_require(struct ring_buffer_s *rb, int timeout_ms) {
    // TODO: try_require
    return RING_BUFFER_SUCCESS;
}

/**
 * @brief Get the size of the used portion of the ring buffer.
 *
 * This function returns the number of elements currently used in the ring
 * buffer. If the provided ring buffer pointer is NULL, it returns 0.
 *
 * @param rb Pointer to the ring buffer structure.
 * @return Number of elements used in the ring buffer.
 */
int ring_buffer_size(struct ring_buffer_s *rb) {
    if (NULL == rb) {
        return 0;
    }
    struct ring_buffer_priv_s *priv = (struct ring_buffer_priv_s *)rb->priv;
    return priv->used;
}

/**
 * @brief Pushes data into the ring buffer.
 *
 * This function attempts to add data to the ring buffer. If the buffer is full,
 * it returns RING_BUFFER_FULL. Otherwise, it copies the data into the buffer,
 * updates the tail index, increments the used count, and notifies any waiting
 * threads that the buffer has new data.
 *
 * @param rb Pointer to the ring buffer structure.
 * @param data Pointer to the data to be pushed into the buffer.
 * @return int Returns RING_BUFFER_SUCCESS on success, RING_BUFFER_UNAVAILABLE
 * if the ring buffer pointer is NULL, or RING_BUFFER_FULL if the buffer is
 * full.
 */
int ring_buffer_push(struct ring_buffer_s *rb, void *data) {
    struct ring_buffer_priv_s *priv = NULL;
    int tail = 0;
    if (NULL == rb) {
        return RING_BUFFER_UNAVAILABLE;
    }
    ring_buffer_lock(rb);
    priv = (struct ring_buffer_priv_s *)rb->priv;
    if (priv->used >= priv->item_count) {
        ring_buffer_unlock(rb);
        return RING_BUFFER_FULL;
    }
    tail = priv->tail;
    memcpy(priv->buffer + tail * priv->item_size, data, priv->item_size);
    priv->tail = (tail + 1) % priv->item_count;
    priv->used++;
    ring_buffer_unlock(rb);
    ring_buffer_notify(rb);
    return RING_BUFFER_SUCCESS;
}

/**
 * @brief Pops an item from the ring buffer.
 *
 * This function attempts to pop an item from the ring buffer. If successful, it
 * copies the item to the provided data pointer, updates the head index,
 * decrements the used count, and returns success. If the buffer is empty or a
 * timeout occurs, it returns the appropriate error code.
 *
 * @param rb Pointer to the ring buffer structure.
 * @param data Pointer to where the popped item should be copied.
 * @param timeout_ms Maximum time to wait for an item to be available (in
 * milliseconds).
 * @return RING_BUFFER_SUCCESS on success, RING_BUFFER_EMPTY if the buffer is
 * empty, or other error codes on failure.
 */
int ring_buffer_pop(struct ring_buffer_s *rb, void *data, int timeout_ms) {
    struct ring_buffer_priv_s *priv = NULL;
    int head = 0;
    int ret = ring_buffer_require(rb, timeout_ms);

    if (ret != RING_BUFFER_SUCCESS) {
        return ret;
    }

    ring_buffer_lock(rb);
    priv = (struct ring_buffer_priv_s *)rb->priv;
    if (priv->used <= 0) {
        ring_buffer_unlock(rb);
        return RING_BUFFER_EMPTY;
    }
    head = priv->head;
    memcpy(data, priv->buffer + head * priv->item_size, priv->item_size);
    priv->head = (head + 1) % priv->item_count;
    priv->used--;
    ring_buffer_unlock(rb);
    return RING_BUFFER_SUCCESS;
}

/**
 * @brief Clears the contents of the ring buffer.
 *
 * This function locks the ring buffer, resets the head, tail, and used
 * pointers, effectively clearing all data from the buffer, and then unlocks it.
 *
 * @param rb Pointer to the ring buffer structure.
 * @return void
 */
void ring_buffer_clear(struct ring_buffer_s *rb) {
    struct ring_buffer_priv_s *priv = NULL;
    if (NULL == rb) {
        return;
    }
    ring_buffer_lock(rb);
    priv = (struct ring_buffer_priv_s *)rb->priv;
    priv->head = 0;
    priv->tail = 0;
    priv->used = 0;
    ring_buffer_unlock(rb);
}

/**
 * @brief Creates a new ring buffer instance.
 *
 * This function initializes a new ring buffer with the provided buffer, item
 * size, and item count. It also sets up the necessary pointers and function
 * pointers for the ring buffer operations.
 *
 * @param buffer Pointer to the underlying buffer that will be used by the ring
 * buffer.
 * @param item_size Size of each item that will be stored in the ring buffer.
 * @param item_count Maximum number of items that can be stored in the ring
 * buffer.
 * @return Pointer to the newly created ring buffer structure, or NULL if
 * creation failed.
 */
struct ring_buffer_s *ring_buffer_create(char *buffer, int item_size,
                                         int item_count) {
    struct ring_buffer_s *rb = NULL;
    struct ring_buffer_priv_s *priv = NULL;
    int i = 0;

    if ((NULL == buffer) || (item_size <= 0) || (item_count <= 0)) {
        return NULL;
    }

    // TODO: lock all ring buffers
    if (g_ring_buffer_used >= RING_BUFFER_COUNT) {
        // TODO: unlock all ring buffers
        return NULL;
    }
    i = g_ring_buffer_used++;
    // TODO: unlock all ring buffers

    rb = &g_ring_buffers[i];
    priv = &g_ring_buffer_privates[i];
    priv->buffer = buffer;
    priv->item_size = item_size;
    priv->item_count = item_count;
    priv->head = 0;
    priv->tail = 0;
    priv->used = 0;
    // TODO: prepare buffer locking
    rb->priv = priv;
    rb->size = ring_buffer_size;
    rb->push = ring_buffer_push;
    rb->pop = ring_buffer_pop;
    rb->clear = ring_buffer_clear;
    return rb;
}
