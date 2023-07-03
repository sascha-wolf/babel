defprotocol Babel.Chainable do
  @type t :: t(any)
  @type t(output) :: t(any, output)
  @type t(_input, _output) :: any

  @spec chain(left :: t, right :: t) :: t
  def chain(left, right)
end
