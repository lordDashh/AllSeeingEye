# Simple implementation for a thread-based timer.
class Timer
  private

  @interval = 0
  @callback = -> {}
  @one_shot = false
  @running = false

  public

  def initialize(interval, one_shot, callback)
    @interval = interval
    @one_shot = one_shot
    @callback = callback
  end

  def start
    @running = true
    Thread.new {
      loop do
      sleep @interval if @running
      @callback.call if @running
      break if @one_shot
      end
    }
  end

  def stop
    @running = false
  end

  def change_interval(new_interval)
    @interval = new_interval
  end
end
