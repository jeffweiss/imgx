defmodule Imgx do

  def header_sequence(<<"screen",_::bitstring>>), do: "\ePtmux;\e\e]1337;"
  def header_sequence(_), do: "\e]1337;"

  def file_data(filename, retrieve_func) do
    name = Base.encode64(filename)
    data =
      filename
      |> retrieve_func.()
      |> Base.encode64
    "File=name=#{name};inline=1:#{data}"
  end
  def footer_sequence(<<"screen",_::bitstring>>), do: "\a\e\\"
  def footer_sequence(_), do: "\a"

  def display_image(filename, retrieve_func \\ &File.read!/1) do
    term = System.get_env("TERM")
    header_sequence(term) <> file_data(filename, retrieve_func) <> footer_sequence(term)
    |> IO.puts
  end

  def retrieve_from_url(url) do
    url
    |> HTTPoison.get!
    |> Map.get(:body)
  end

  def main(args) do
    file_url =
      Imgx.Giphy.random([tag: Enum.join(args, " "), api_key: "dc6zaTOxFJmzC", rating: "g"])
      |> Map.get("data")
      |> Map.get("image_url")

    display_image(file_url, &retrieve_from_url/1)
    IO.puts file_url
  end
end
