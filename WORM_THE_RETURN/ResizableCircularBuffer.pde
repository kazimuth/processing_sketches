import java.util.Arrays;

// thanks, google bard!
public class ResizableCircularBuffer<T> {

    private T[] buffer;
    private int head;
    private int tail;
    private int size;

    // Invariants:
    // - 0 <= head < buffer.length
    // - 0 <= tail < buffer.length
    // - size >= 0
    // - size <= buffer.length
    // - If size > 0, then elements [head, tail) in the buffer contain valid data.
    // - If size == buffer.length, then tail == head + 1 modulo buffer.length.

    public ResizableCircularBuffer(int initialCapacity) {
        buffer = (T[]) new Object[initialCapacity];
        checkInvariants();
    }

    public void add(T element) {
        if (element == null) {
          throw new IllegalArgumentException("ResizableCircularBuffer will not store nulls");
        }
        checkInvariants();
        ensureCapacity(size + 1);
        buffer[tail] = element;
        tail = (tail + 1) % buffer.length;
        size++;
        checkInvariants();
    }

    public T remove() {
        checkInvariants();
        if (isEmpty()) {
            throw new IllegalStateException("Buffer is empty");
        }
        T element = buffer[head];
        buffer[head] = null; // Help garbage collection
        head = (head + 1) % buffer.length;
        size--;
        checkInvariants();
        return element;
    }

    public T peek() {
        checkInvariants();
        if (isEmpty()) {
            throw new IllegalStateException("Buffer is empty");
        }
        return buffer[head];
    }
    
    public T get(int index) {
      // checkInvariants();
      return buffer[(head + index) % buffer.length];
    }

    public boolean isEmpty() {
        return size == 0;
    }

    public int size() {
        return size;
    }

    private void ensureCapacity(int capacity) {
        if (capacity > buffer.length) {
            int newCapacity = Math.max(capacity, buffer.length * 2);
            buffer = Arrays.copyOf(buffer, newCapacity);
        }
    }

    private void checkInvariants() {
        if (head < 0 || head >= buffer.length) {
            throw new IllegalStateException("Invariant violated: head out of bounds");
        }
        if (tail < 0 || tail >= buffer.length) {
            throw new IllegalStateException("Invariant violated: tail out of bounds");
        }
        if (size < 0) {
            throw new IllegalStateException("Invariant violated: size is negative");
        }
        if (size > buffer.length) {
            throw new IllegalStateException("Invariant violated: size exceeds capacity");
        }
        /*if (size > 0) {
            // Ensure elements from head to tail contain valid data
            for (int i = head; i < tail; i++) {
                if (buffer[i] == null) {
                    throw new IllegalStateException("Invariant violated: null element in buffer");
                }
            }
        }*/
        if (size == buffer.length) {
            if (tail != (head + 1) % buffer.length) {
                throw new IllegalStateException("Invariant violated: tail not adjacent to head when full");
            }
        }
    }
}
