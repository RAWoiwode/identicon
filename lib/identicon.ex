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
    |> pick_color
  end

  @doc """
  Hash the given input using MD5 and convert it to a list.
  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex} # Struct
  end

  def pick_color(image) do
    # Pattern match
    # We are looking for an Image, that has a hex prop, that is a list
    %Identicon.Image{hex: [r, g, b | _tail]} = image # Only want the first 3, acknowledge the rest but don't use
    [r, g, b]
  end
end
