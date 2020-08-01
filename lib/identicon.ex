defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Identicon.hello()
      :world

  """

  def main(input) do
  input |>
  hash_input |>
  pick_color |>
  make_grid |>
  make_pixelmap |>
  draw_img |>
  save_img(input)
  end

  def hash_input(input) do
    seed =:crypto.hash(:md5, input) |>
    :binary.bin_to_list
    %Identicon.Image{seed: seed}
  end

  def pick_color(%Identicon.Image{seed: [r,g,b| _tail ]} = image) do
    %Identicon.Image{image | color: {r,g,b} }
  end

  def make_grid(%Identicon.Image{seed: list} = image) do
    grid=list |>
      Enum.map(&rem(&1,2)) |>
      Enum.chunk(3) |>  # Dar tamaño libre
      Enum.map(&extend_row/1) |>
      List.flatten |>
      Enum.with_index |>
      Enum.filter( fn{val,_} -> val == 1 end) |>
      Enum.map( fn {_,idx} -> idx end )
      %Identicon.Image{image | grid: grid}

  end

  def extend_row(row) do
    center = get_center(row)
    row_added = row |>
                Enum.slice(0..center) |>
                Enum.reverse()


    row ++ row_added

  end

  def get_center(row) do
    row |>
      length |>
      Kernel.+(1) |>
      Kernel./(2) |>
      floor() |>
      Kernel.-(1)
  end

  def make_pixelmap(%Identicon.Image{grid: grid} = image) do
    pixelmap= grid |>
      Enum.map(&get_limits/1)

    %Identicon.Image{image | pixelmap: pixelmap}
  end

  def get_limits(idx) do
    j= idx |> div(5) |> Kernel.*(50)
    i= idx |> rem(5) |> floor |> Kernel.*(50)
    {{i,j},{i+50,j+50}}
  end

  def draw_img(%Identicon.Image{color: color, pixelmap: pixelmap}) do
    img= :egd.create(250,250)
    fill = :egd.color(color)
    Enum.each( pixelmap, fn({start,stop}) ->
      :egd.filledRectangle(img,start,stop,fill)
     end )
     :egd.render(img)
  end

  def save_img(image,filename) do
    File.write("img/#{filename}.png",image)
    IO.puts("Se creo el archivo #{filename}.png")
  end
end
