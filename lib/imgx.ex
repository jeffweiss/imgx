defmodule Imgx do

  def header_sequence(), do: <<27, 93, 49, 51, 51, 55, 59>>
  def file_data(filename) do
    name = Base.encode64(filename)
    data =
      filename
      |> File.read!
      |> Base.encode64
    "File=name=#{name};inline=1:#{data}"
  end
  def footer_sequence(), do: "\a"

  def display_image(filename) do
    header_sequence <> file_data(filename) <> footer_sequence
  end

  def main(_) do
    display_image("he-man.jpg")
    |> IO.puts
  end
end
