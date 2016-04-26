defmodule Imgx do

  def header_sequence(<<"screen",_::bitstring>>), do: "\ePtmux;\e\e]1337;"
  def header_sequence(_), do: "\e]1337;"

  def file_data(filename) do
    name = Base.encode64(filename)
    data =
      filename
      |> File.read!
      |> Base.encode64
    "File=name=#{name};inline=1:#{data}"
  end
  def footer_sequence(<<"screen",_::bitstring>>), do: "\a\e\\"
  def footer_sequence(_), do: "\a"

  def display_image(filename) do
    term = System.get_env("TERM")
    header_sequence(term) <> file_data(filename) <> footer_sequence(term)
    |> IO.puts
  end

  def main(args) do
    for file <- args do
      display_image(file)
    end
  end
end
