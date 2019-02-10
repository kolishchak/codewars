module FSM
  FSMError = Class.new(StandardError)

  NOT_APPLICABLE_EVENT = "ERROR".freeze

  def call!(events)
    events.each do |event|
      transition = Transition.new(
          self.transitions,
          state, event
      )

      raise FSMError unless transition.valid?
      @state = transition.to_new_state
    end
    state
  end

  class TransitionBuilder

    def initialize(transitions, state, event)
      @transitions = transitions
      @state = state
      @event = event
    end

    private

    attr_reader :transitions, :state, :event

    def key
      "#{state}:#{event}"
    end
  end

  class Transition < TransitionBuilder
    def to_new_state
      transitions[key]
    end

    def valid?
      transitions.key?(key)
    end
  end
end

class TCP
  include FSM

  DEFAULT_STATE = "CLOSED".freeze

  TRANSITIONS = {
      'CLOSED:APP_PASSIVE_OPEN' => 'LISTEN',
      'CLOSED:APP_ACTIVE_OPEN'  => 'SYN_SENT',
      'LISTEN:RCV_SYN'          => 'SYN_RCVD',
      'LISTEN:APP_SEND'         => 'SYN_SENT',
      'LISTEN:APP_CLOSE'        => 'CLOSED',
      'SYN_RCVD:APP_CLOSE'      => 'FIN_WAIT_1',
      'SYN_RCVD:RCV_ACK'        => 'ESTABLISHED',
      'SYN_SENT:RCV_SYN'        => 'SYN_RCVD',
      'SYN_SENT:RCV_SYN_ACK'    => 'ESTABLISHED',
      'SYN_SENT:APP_CLOSE'      => 'CLOSED',
      'ESTABLISHED:APP_CLOSE'   => 'FIN_WAIT_1',
      'ESTABLISHED:RCV_FIN'     => 'CLOSE_WAIT',
      'FIN_WAIT_1:RCV_FIN'      => 'CLOSING',
      'FIN_WAIT_1:RCV_FIN_ACK'  => 'TIME_WAIT',
      'FIN_WAIT_1:RCV_ACK'      => 'FIN_WAIT_2',
      'CLOSING:RCV_ACK'         => 'TIME_WAIT',
      'FIN_WAIT_2:RCV_FIN'      => 'TIME_WAIT',
      'TIME_WAIT:APP_TIMEOUT'   => 'CLOSED',
      'CLOSE_WAIT:APP_CLOSE'    => 'LAST_ACK',
      'LAST_ACK:RCV_ACK'        => 'CLOSED'
  }.freeze

  attr_accessor :state

  def initialize(state = DEFAULT_STATE)
    @state = state
  end

  def transitions
    TRANSITIONS
  end
end

def traverse_tcp_states(events)
  begin
    tcp = TCP.new
    tcp.call!(events)
  rescue FSM::FSMError
    FSM::NOT_APPLICABLE_EVENT
  end
end

alias traverse_TCP_states traverse_tcp_states