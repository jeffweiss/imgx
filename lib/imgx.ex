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
    {options, args, _unknowns} = OptionParser.parse(args, strict: [rating: :string, file: :string], aliases: [f: :file, r: :rating])
    options
    |> Keyword.get(:file)
    |> case do
      nil ->
        rating = Keyword.get(options, :rating, "g")
        file_url =
          Imgx.Giphy.random([tag: Enum.join(args, " "), api_key: "dc6zaTOxFJmzC", rating: rating])
          |> Map.get("data")
          |> Map.get("image_url")

        display_image(file_url, &retrieve_from_url/1)
        IO.puts file_url
      file ->
        display_image(file, &File.read!/1)
    end
  end
end
