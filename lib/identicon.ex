defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  An Identicon is
  * 5x5 grid
  * 250px tall and wide
  * Each square is 50x50px
  * Random squares are colored
  * One random color used throughout
  * Vertically symmetrical
  * Each itdenticon should be based on a string input i.e. "billy" will always result
    in the same identicon
  """

  def main(input) do
    input
    |> hash_input
  end

  @doc """
  Hash the given input using MD5 and convert it to a list.
  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list
    %Identicon.Image{hex: hex}
  end
end
