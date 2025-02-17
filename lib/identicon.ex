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
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
  end

  @doc """
  Build a list where each row is mirrored.
  """
  def build_grid(%Identicon.Image{hex: hex} = image) do
    # Pattern match to get hex and pass it through pipeline
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard) # chunk/2 deprecated; Need this form to work properly
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index # Take list, create a new tuple with the elements index

    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Build the pixel map that will be used to help color certain squares on the image.
  """
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """
  Filter out the tuples that have an odd code/number.
  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({code, _index}) ->
      # Calculate if the remainder is divisible by two
      rem(code, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Hash the given input using MD5 and convert it to a list.
  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex} # Struct
  end

  @doc """
  Grab the first three values of the hex from the Image struct to use as r, g, b values for the color
  """
  # def pick_color(image) do
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    # Pattern match
    # We are looking for an Image, that has a hex prop, that is a list
    # Only want the first 3, acknowledge the rest but don't use

    %Identicon.Image{image | color: {r, g, b}} # Create new struct and add color prop to it
  end

  @doc """
  Take the first two elements from a list and append them to the end in reverse order.

  Helper function
  """
  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first] # Join lists (++)
  end
end
